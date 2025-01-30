import UIKit

final class MainScreenModel {

    weak var presenter: MainScreenPresenter?

    func getData(
        lon: Double,
        lat: Double,
        completion: @escaping (APIError?, WeatherModel?) -> Void
    ) {
        let request = API.createRequest(lat: lat, lon: lon)
        
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] data, response, error in
            if let error {
                completion(.network, nil)
                return
            }

            if let data, let JSONObject = try? JSONSerialization.jsonObject(
                with: data, options: [] ) as? [String: Any] {
                let model = self?.parseWeatherModel(JSONObject)
                completion(model == nil ? .dataParse : nil, model)
            } else {
                completion(.noData, nil)
            }
        }.resume()
    }

    private func parseWeatherModel(_ data: [String: Any]) -> WeatherModel? {
        guard let info = data[API.DataKeys.Info.name] as? [String: Any],
              let fact = data[API.DataKeys.Fact.name] as? [String: Any],
              let forecasts = data[API.DataKeys.Forecasts.name] as? [[String: Any]],
              let temp = fact[API.DataKeys.Fact.temp] as? Int,
              let condition = fact[API.DataKeys.Fact.condition] as? String,
              let date = parseDate(info),
              let partOfDay = getSunTimes(date, forecasts[0])?.getCurrentPartOfDay(),
              let weather = Weather(condition, partOfDay) else {
            return nil
        }
        let properties = parseProperties(fact)
        let hourWeather = parseHourWeather(forecasts, date)
        let dayWeather = parseDayWeather(forecasts)
        guard !properties.isEmpty && !hourWeather.isEmpty && !dayWeather.isEmpty else {
            return nil
        }
        return WeatherModel(
            info: weather,
            city: "Борисов",
            date: ForecastDate(date: date),
            tempC: temp,
            tempMin: dayWeather.first!.minTemp,
            tempMax: dayWeather.first!.maxTemp,
            properties: properties,
            hourWeather: hourWeather,
            dailyweather: dayWeather
        )
    }

    private func parseDayWeather(_ days: [[String: Any]]) -> [DayWeather] {
        var dayWeathers = [DayWeather]()
        for day in days {
            guard let parts = day[API.DataKeys.Forecasts.Parts.name] as? [String: Any],
                  let date = day[API.DataKeys.Forecasts.date] as? String,
                  let weekDay = Date.getDayOfWeek(from: date),
                  let dayShort = parts[API.DataKeys.Forecasts.Parts.DayShort.name] as? [String: Any],
                  let condition = dayShort[API.DataKeys.Forecasts.Parts.DayShort.condition] as? String,
                  let maxTemp = dayShort[API.DataKeys.Forecasts.Parts.DayShort.temp] as? Int,
                  let nightShort = parts[API.DataKeys.Forecasts.Parts.NightShort.name] as? [String: Any],
                  let minTemp = nightShort[API.DataKeys.Forecasts.Parts.NightShort.temp] as? Int,
                  let weather = Weather(condition, .day) else { return [] }
            dayWeathers.append(DayWeather(
                weekday: weekDay,
                info: weather,
                maxTemp: maxTemp,
                minTemp: minTemp
            ))
        }
        return dayWeathers
    }

    private func parseHourWeather(_ days: [[String: Any]], _ currentDate: Date) -> [HourWeather] {
        var hourWeathers = [HourWeather]()
        var dayCounter = 0
        var condition: (Int, SunTimes) -> Bool = { hour, sunTimes  in
            dayCounter == 0
            ? hour >= sunTimes.startForecastHour
            : hour <= sunTimes.endForecastHour
        }
        
        for _ in 0...1 {
            guard days.count > dayCounter,
                  let hours = days[dayCounter][API.DataKeys.Forecasts.Hours.name] as? [[String: Any]],
                  let sunTimes = getSunTimes(currentDate, days[dayCounter])
            else {
                return []
            }

            for hour in hours {
                guard let hourString = hour[API.DataKeys.Forecasts.Hours.hour] as? String,
                      let hourValue = Int(hourString) else {
                    return []
                }
                if condition(hourValue, sunTimes) {
                    let partOfDay = sunTimes.getPartOfDay(hourValue)
                    guard let temp = hour[API.DataKeys.Forecasts.Hours.temp] as? Int,
                          let condition = hour[API.DataKeys.Forecasts.Hours.condition] as? String,
                          let weather = Weather(condition, partOfDay)
                    else { return [] }
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

    private func getSunTimes(_ date: Date, _ dayInfo: [String: Any]) -> SunTimes? {
        guard let sunrise = dayInfo[API.DataKeys.Forecasts.sunrise] as? String,
              let sunset = dayInfo[API.DataKeys.Forecasts.setEnd] as? String else {
            return nil
        }
        return SunTimes(currentDate: date, sunrise: sunrise, sunset: sunset)
    }

    private func parseProperties(_ data: [String: Any]) -> [Property] {
        guard let feelsLike = data[API.DataKeys.Fact.feelsLike] as? Int,
              let precProb = data[API.DataKeys.Fact.precProb] as? Int,
              let windSpeed = data[API.DataKeys.Fact.windSpeed] as? Double,
              let humidity = data[API.DataKeys.Fact.humidity] as? Int,
              let uvIndex = data[API.DataKeys.Fact.uvIndex] as? Int else {
            return []
        }
        return [
            Property(info: .avgTemp, value: feelsLike),
            Property(info: .probability, value: precProb),
            Property(info: .velocity, value: Int(round(windSpeed * 3.6))),
            Property(info: .humidity, value: humidity),
            Property(info: .indexUV, value: uvIndex)
        ]
    }

    private func parseDate(_ data: [String: Any]) -> Date? {
        guard let tzinfo = data[API.DataKeys.Info.TZInfo.name] as? [String: Any],
              let offset = tzinfo[API.DataKeys.Info.TZInfo.offset] as? Int else {
            return nil
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
            city: "Minsk",
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
