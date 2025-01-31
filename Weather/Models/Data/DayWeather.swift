import UIKit

struct DayWeather: Codable {
    let weekday: Int
    let info: Weather
    let maxTemp: Int
    let minTemp: Int
}
