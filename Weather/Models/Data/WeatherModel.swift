import UIKit

struct WeatherModel: Codable {
    let info: Weather
    let city: String
    let date: ForecastDate
    let tempC: Int
    let tempMin: Int
    let tempMax: Int
    let properties: [Property]
    let hourWeather: [HourWeather]
    let dailyweather: [DayWeather]
}
