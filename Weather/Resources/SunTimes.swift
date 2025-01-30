import UIKit

struct SunTimes {

    static let hourForecastCount = 12

    var startForecastHour: Int { _startForecastHour }
    var endForecastHour: Int { _endForecastHour }

    private var _startForecastHour: Int = 0
    private var _endForecastHour: Int = 0
    private var sunriseHour: Int = -1
    private var sunsetHour: Int = -1

    init?(currentDate: Date, sunrise: String, sunset: String) {
        setStartForecastHour(currentDate)
        setSunrise(sunrise)
        setSunset(sunset)
        guard sunsetHour != -1 && sunriseHour != -1 else { return nil }
    }

    private init() {}

    func getPartOfDay(_ currentHour: Int) -> Weather.PartOfDay {
        currentHour >= sunriseHour && currentHour < sunsetHour ? .day : .night
    }

    func getCurrentPartOfDay() -> Weather.PartOfDay {
        getPartOfDay(_startForecastHour)
    }

    private mutating func setSunrise(_ hm: String) {
        let components = hm.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else { return }
        sunriseHour = hour
        sunsetHour += minute > 30 ? 1 : 0
    }

    private mutating func setSunset(_ hm: String) {
        let components = hm.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else { return }
        sunsetHour = hour
        sunsetHour += minute > 30 ? 1 : 0
    }

    private mutating func setStartForecastHour(_ date: Date) {
        _startForecastHour = date.getHours()
        _endForecastHour = (_startForecastHour + SunTimes.hourForecastCount) % 24
    }

}

