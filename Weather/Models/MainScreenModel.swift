import UIKit

final class MainScreenModel {

    weak var presenter: MainScreenPresenter?

    func getData(long: Int, lat: Int) async -> WeatherModel {
        try? await Task.sleep(nanoseconds: 6 * 1_000_000_000)
        return mockData()
    }

    private func mockData() -> WeatherModel {
        var data: WeatherModel
        let properties = [
            Property(type: .avgTemp, value: Int.random(in: -10...15)),
            Property(type: .probability, value: Int.random(in: 0...100)),
            Property(type: .velocity, value: Int.random(in: 0...70)),
            Property(type: .humidity, value: Int.random(in: 0...100)),
            Property(type: .indexUV, value: Int.random(in: 0...11))
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
                day: "Thu",
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
            date: "tuesday 15 april 2025",
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
