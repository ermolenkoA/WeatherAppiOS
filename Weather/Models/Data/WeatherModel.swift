import UIKit

struct WeatherModel {
    let background: UIImage
    let icon: UIImage
    let city: String
    let tempC: Int
    let tempMin: Int
    let tempMax: Int
    let description: String
    let properties: [Property]
    let hourWeather: [HourWeather]
    let dailyweather: [DayWeather]
}
