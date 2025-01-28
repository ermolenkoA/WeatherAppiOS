import UIKit

struct DayWeather: Codable {
    let day: String
    let info: Weather
    let maxTemp: Int
    let minTemp: Int
}
