import UIKit

final class MainScreenModel {

    weak var presenter: MainScreenPresenter?

    func getData(
        _ city: City,
        completion: @escaping (APIError?, WeatherModel?) -> Void
    ) {
        let request = WeatherAPI.createRequest(lat: city.latitude, lon: city.longitude)

        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                completion(.network, nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode == 403 {
                    completion(.badAPIKey, nil)
                    return
                }
            }

            if let data, let JSONObject = try? JSONSerialization.jsonObject(
                with: data, options: [] ) as? [String: Any] {
                do {
                    let model = try self?.parseWeatherModel(JSONObject, city)
                    completion(nil, model)
                } catch let error as APIError {
                    completion(error, nil)
                    return
                } catch {
                    let wrappedError = APIError.dataParse(what: "Unexpected error: \(error.localizedDescription)")
                    completion(wrappedError, nil)
                }
            } else {
                completion(.noData, nil)
            }
        }.resume()
    }

    private func parseWeatherModel(_ data: [String: Any], _ city: City) throws -> WeatherModel {
        guard let info = data[WeatherAPI.DataKeys.Info.name] as? [String: Any],
              let fact = data[WeatherAPI.DataKeys.Fact.name] as? [String: Any],
              let forecasts = data[WeatherAPI.DataKeys.Forecasts.name] as? [[String: Any]],
              let temp = fact[WeatherAPI.DataKeys.Fact.temp] as? Int,
              let condition = fact[WeatherAPI.DataKeys.Fact.condition] as? String,
              let date = try parseDate(info),
              let partOfDay = try getSunTimes(date, forecasts[0])?.getCurrentPartOfDay(),
              let weather = Weather(condition, partOfDay) else {
            throw APIError.dataParse(what: "Error while parsing WeatherModel")
        }
        let properties = try parseProperties(fact)
        let hourWeather = try parseHourWeather(forecasts, date)
        let dayWeather = try parseDayWeather(forecasts)
        let tempMin = dayWeather.first!.minTemp
        let tempMax = dayWeather.first!.maxTemp

        return WeatherModel(
            info: weather,
            city: city,
            date: ForecastDate(date: date),
            tempC: temp,
            tempMin: min(tempMin, tempMax),
            tempMax: max(tempMin, tempMax),
            properties: properties,
            hourWeather: hourWeather,
            dailyweather: dayWeather
        )
    }

    private func parseDayWeather(_ days: [[String: Any]]) throws -> [DayWeather] {
        var dayWeathers = [DayWeather]()
        for day in days {
            guard let parts = day[WeatherAPI.DataKeys.Forecasts.Parts.name] as? [String: Any],
                  let date = day[WeatherAPI.DataKeys.Forecasts.date] as? String,
                  let weekDay = Date.getDayOfWeek(from: date),
                  let dayShort = parts[WeatherAPI.DataKeys.Forecasts.Parts.DayShort.name] as? [String: Any],
                  let condition = dayShort[WeatherAPI.DataKeys.Forecasts.Parts.DayShort.condition] as? String,
                  let maxTemp = dayShort[WeatherAPI.DataKeys.Forecasts.Parts.DayShort.temp] as? Int,
                  let nightShort = parts[WeatherAPI.DataKeys.Forecasts.Parts.NightShort.name] as? [String: Any],
                  let minTemp = nightShort[WeatherAPI.DataKeys.Forecasts.Parts.NightShort.temp] as? Int,
                  let weather = Weather(condition, .day)
            else {
                throw APIError.dataParse(what: "Error while parsing DayWeather")
            }
            dayWeathers.append(DayWeather(
                weekday: weekDay,
                info: weather,
                maxTemp: maxTemp,
                minTemp: minTemp
            ))
        }
        return dayWeathers
    }

    private func parseHourWeather(_ days: [[String: Any]], _ currentDate: Date) throws -> [HourWeather] {
        var hourWeathers = [HourWeather]()
        var dayCounter = 0
        let condition: (Int, SunTimes) -> Bool = { hour, sunTimes  in
            dayCounter == 0
            ? hour >= sunTimes.startForecastHour
            : hour <= sunTimes.endForecastHour
        }
        
        for _ in 0...1 {
            guard days.count > dayCounter,
                  let hours = days[dayCounter][WeatherAPI.DataKeys.Forecasts.Hours.name] as? [[String: Any]],
                  let sunTimes = try getSunTimes(currentDate, days[dayCounter])
            else {
                throw APIError.dataParse(what: "Error while parsing HourWeather: getting of hours and sunTimes")
            }

            for hour in hours {
                guard let hourString = hour[WeatherAPI.DataKeys.Forecasts.Hours.hour] as? String,
                      let hourValue = Int(hourString) else {
                    throw APIError.dataParse(what: "Error while parsing hourValue from HourWeather")
                }
                if condition(hourValue, sunTimes) {
                    let partOfDay = sunTimes.getPartOfDay(hourValue)
                    guard let temp = hour[WeatherAPI.DataKeys.Forecasts.Hours.temp] as? Int,
                          let condition = hour[WeatherAPI.DataKeys.Forecasts.Hours.condition] as? String,
                          let weather = Weather(condition, partOfDay)
                    else { throw APIError.dataParse(
                        what: "Error while parsing HourWeather: getting of temp, condition and weather"
                    ) }
                    hourWeathers.append(HourWeather(time: hourValue, info: weather, temp: temp))
                    if hourWeathers.count == SunTimes.hourForecastCount {
                        return hourWeathers
                    }
                }
            }
            dayCounter += 1
        }
        return hourWeathers
    }

    private func getSunTimes(_ date: Date, _ dayInfo: [String: Any]) throws -> SunTimes? {
        guard let sunrise = dayInfo[WeatherAPI.DataKeys.Forecasts.sunrise] as? String,
              let sunset = dayInfo[WeatherAPI.DataKeys.Forecasts.setEnd] as? String else {
            throw APIError.dataParse(what: "Error while parsing SunTimes: sunrise and sunset")
        }
        return SunTimes(currentDate: date, sunrise: sunrise, sunset: sunset)
    }

    private func parseProperties(_ data: [String: Any]) throws -> [Property] {
        guard let feelsLike = data[WeatherAPI.DataKeys.Fact.feelsLike] as? Int,
              let precProb = data[WeatherAPI.DataKeys.Fact.precProb] as? Int,
              let windSpeed = data[WeatherAPI.DataKeys.Fact.windSpeed] as? Double,
              let humidity = data[WeatherAPI.DataKeys.Fact.humidity] as? Int,
              let uvIndex = data[WeatherAPI.DataKeys.Fact.uvIndex] as? Int else {
            throw APIError.dataParse(what: "Error while parsing Properties")
        }
        return [
            Property(info: .avgTemp, value: feelsLike),
            Property(info: .probability, value: precProb),
            Property(info: .velocity, value: Int(round(windSpeed * 3.6))),
            Property(info: .humidity, value: humidity),
            Property(info: .indexUV, value: uvIndex)
        ]
    }

    private func parseDate(_ data: [String: Any]) throws -> Date? {
        guard let tzinfo = data[WeatherAPI.DataKeys.Info.TZInfo.name] as? [String: Any],
              let offset = tzinfo[WeatherAPI.DataKeys.Info.TZInfo.offset] as? Int else {
            throw APIError.dataParse(what: "Error while parsing Date: tzindo and offset")
        }
        let currentDate = Date()
        let dateInTimeZone = Calendar.current.date(byAdding: .second, value: offset, to: currentDate)
        return dateInTimeZone
    }

    private func mockData() async -> WeatherModel {
        try? await Task.sleep(nanoseconds: 6 * 1_000_000_000)
        var data: WeatherModel
        let properties = [
            Property(info: .avgTemp, value: Int.random(in: -10...15)),
            Property(info: .probability, value: Int.random(in: 0...100)),
            Property(info: .velocity, value: Int.random(in: 0...70)),
            Property(info: .humidity, value: Int.random(in: 0...100)),
            Property(info: .indexUV, value: Int.random(in: 0...11))
        ]
        let createHourWeather = {
            HourWeather(
                time: 14,
                info: .clear(.day),
                temp: Int.random(in: -30...40)
            )
        }

        let createDailyWeather = {
            DayWeather(
                weekday: 4,
                info: .clear(.day),
                maxTemp: Int.random(in: -30...40),
                minTemp: Int.random(in: -30...40)
            )
        }

        var hourWeather = [HourWeather]()
        var dailyweather = [DayWeather]()

        for _ in 0...11 {
            hourWeather.append(createHourWeather())
            dailyweather.append(createDailyWeather())
        }
        
        data = WeatherModel(
            info: .clear(.day),
            city: City(
                nameEN: "Borisov",
                nameRU: "Борисов",
                addInfoEN: "Belarus, Minsk Region",
                addInfoRU: "Беларусь, Минская область",
                latitude: 54.2240665,
                longitude: 28.5117849
            ),
            date: ForecastDate(date: Date()),
            tempC: Int.random(in: -30...40),
            tempMin: Int.random(in: -30...40),
            tempMax: Int.random(in: -30...40),
            properties: properties,
            hourWeather: hourWeather,
            dailyweather: dailyweather
        )
        return data
    }
}
