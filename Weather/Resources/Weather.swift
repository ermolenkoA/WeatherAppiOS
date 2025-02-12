import UIKit
import RswiftResources

enum Weather: Codable {
    case clear(PartOfDay)
    case partlyCloudy(PartOfDay)
    case cloudy(PartOfDay)
    case overcast(PartOfDay)
    case lightRain(PartOfDay)
    case rain(PartOfDay)
    case heavyRain(PartOfDay)
    case showers(PartOfDay)
    case wetSnow(PartOfDay)
    case lightSnow(PartOfDay)
    case snow(PartOfDay)
    case snowShowers(PartOfDay)
    case hail(PartOfDay)
    case thunderstorm(PartOfDay)
    case thunderstormWithRain(PartOfDay)
    case thunderstormWithHail(PartOfDay)

    enum PartOfDay: String, Codable {
        case day
        case night
    }

    func icon() -> UIImage? {
        switch self {
        case .clear(let partOfDay):
            return partOfDay == .day
            ? R.image.clearDayIcon()
            : R.image.clearNightIcon()
        case .partlyCloudy(let partOfDay):
            return partOfDay == .day
            ? R.image.fewCloudsDayIcon()
            : R.image.fewCloudsNightIcon()
        case .cloudy(let partOfDay):
            return partOfDay == .day
            ? R.image.cloudyDayIcon()
            : R.image.cloudyNightIcon()
        case .overcast(let partOfDay):
            return partOfDay == .day
            ? R.image.fewCloudsDayIcon()
            : R.image.fewCloudsNightIcon()
        case .lightRain(let partOfDay):
            return partOfDay == .day
            ? R.image.lightRainDayIcon()
            : R.image.lightRainNightIcon()
        case .rain(let partOfDay):
            return partOfDay == .day
            ? R.image.rainDayIcon()
            : R.image.rainNightIcon()
        case .heavyRain(let partOfDay):
            return partOfDay == .day
            ? R.image.heavyRainDayIcon()
            : R.image.heavyRainNightIcon()
        case .showers(let partOfDay):
            return partOfDay == .day
            ? R.image.heavyRainDayIcon()
            : R.image.heavyRainNightIcon()
        case .wetSnow(let partOfDay):
            return partOfDay == .day
            ? R.image.wetSnowDayIcon()
            : R.image.wetSnowNightIcon()
        case .lightSnow(let partOfDay):
            return partOfDay == .day
            ? R.image.lightSnowDayIcon()
            : R.image.lightSnowNightIcon()
        case .snow(let partOfDay):
            return partOfDay == .day
            ? R.image.snowIcon()
            : R.image.snowIcon()
        case .snowShowers(let partOfDay):
            return partOfDay == .day
            ? R.image.snowShowersDayIcon()
            : R.image.snowShowersNightIcon()
        case .hail(let partOfDay):
            return partOfDay == .day
            ? R.image.hailDayIcon()
            : R.image.hailNightIcon()
        case .thunderstorm(let partOfDay):
            return partOfDay == .day
            ? R.image.stormDayIcon()
            : R.image.stormNightIcon()
        case .thunderstormWithRain(let partOfDay):
            return partOfDay == .day
            ? R.image.stormDayIcon()
            : R.image.stormNightIcon()
        case .thunderstormWithHail(let partOfDay):
            return partOfDay == .day
            ? R.image.stormDayIcon()
            : R.image.stormNightIcon()
        }
    }

    func mainIcon() -> UIImage? {
        switch self {
        case .clear(let partOfDay):
            return partOfDay == .day
            ? R.image.clearDay()
            : R.image.clearNight()
        case .partlyCloudy(let partOfDay):
            return partOfDay == .day
            ? R.image.fewCloudsDay()
            : R.image.fewCloudsNight()
        case .cloudy(let partOfDay):
            return partOfDay == .day
            ? R.image.cloudyDay()
            : R.image.cloudyNight()
        case .overcast(let partOfDay):
            return partOfDay == .day
            ? R.image.fewCloudsDay()
            : R.image.fewCloudsNight()
        case .lightRain(let partOfDay):
            return partOfDay == .day
            ? R.image.lightRainDay()
            : R.image.lightRainNight()
        case .rain(let partOfDay):
            return partOfDay == .day
            ? R.image.rainDay()
            : R.image.rainNight()
        case .heavyRain(let partOfDay):
            return partOfDay == .day
            ? R.image.heavyRainDay()
            : R.image.heavyRainNight()
        case .showers(let partOfDay):
            return partOfDay == .day
            ? R.image.heavyRainDay()
            : R.image.heavyRainNight()
        case .wetSnow(let partOfDay):
            return partOfDay == .day
            ? R.image.wetSnowDay()
            : R.image.wetSnowNight()
        case .lightSnow(let partOfDay):
            return partOfDay == .day
            ? R.image.lightSnowDay()
            : R.image.lightSnowNight()
        case .snow(let partOfDay):
            return partOfDay == .day
            ? R.image.snow()
            : R.image.snow()
        case .snowShowers(let partOfDay):
            return partOfDay == .day
            ? R.image.snowShowersDay()
            : R.image.snowShowersNight()
        case .hail(let partOfDay):
            return partOfDay == .day
            ? R.image.hailDay()
            : R.image.hailNight()
        case .thunderstorm(let partOfDay):
            return partOfDay == .day
            ? R.image.stormDay()
            : R.image.stormNight()
        case .thunderstormWithRain(let partOfDay):
            return partOfDay == .day
            ? R.image.stormDay()
            : R.image.stormNight()
        case .thunderstormWithHail(let partOfDay):
            return partOfDay == .day
            ? R.image.stormDay()
            : R.image.stormNight()
        }
    }

    func background() -> UIImage {
        switch self {
        case .clear(let partOfDay):
            return partOfDay == .day ?
            R.image.weatherClearMomentDay()!
            : R.image.weatherClearMomentNight()!
        case .partlyCloudy(let partOfDay):
            return partOfDay == .day ?
            R.image.weatherFewCloudsMomentDay()!
            : R.image.weatherFewCloudsMomentNight()!
        case .cloudy(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherFewCloudsMomentDay()!
            : R.image.weatherFewCloudsMomentNight()!
        case .overcast(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherCloudyMomentDay()!
            : R.image.weatherCloudyMomentNight()!
        case .lightRain(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .rain(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .heavyRain(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .showers(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .wetSnow(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .lightSnow(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .snow(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .snowShowers(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .hail(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherRainMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .thunderstorm(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherStormMomentDay()!
            : R.image.weatherStormMomentNight()!
        case .thunderstormWithRain(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherStormMomentDay()!
            : R.image.weatherRainMomentNight()!
        case .thunderstormWithHail(let partOfDay):
            return partOfDay == .day
            ? R.image.weatherStormMomentDay()!
            : R.image.weatherRainMomentNight()!
        }
    }

    func description() -> String {
        switch self {
        case .clear:
            return R.string.localizable.clear()
        case .partlyCloudy:
            return R.string.localizable.partlyCloudy()
        case .cloudy:
            return R.string.localizable.cloudy()
        case .overcast:
            return R.string.localizable.overcast()
        case .lightRain:
            return R.string.localizable.lightRain()
        case .rain:
            return R.string.localizable.rain()
        case .heavyRain:
            return R.string.localizable.heavyRain()
        case .showers:
            return R.string.localizable.showers()
        case .wetSnow:
            return R.string.localizable.wetSnow()
        case .lightSnow:
            return R.string.localizable.lightSnow()
        case .snow:
            return R.string.localizable.snow()
        case .snowShowers:
            return R.string.localizable.snowShowers()
        case .hail:
            return R.string.localizable.hail()
        case .thunderstorm:
            return R.string.localizable.thunderstorm()
        case .thunderstormWithRain:
            return R.string.localizable.thunderstormWithRain()
        case .thunderstormWithHail:
            return R.string.localizable.thunderstormWithHail()
        }
    }
}

extension Weather {
    struct Conditions {
        static let clear = "clear"
        static let partlyCloudy = "partly-cloudy"
        static let cloudy = "cloudy"
        static let overcast = "overcast"
        static let lightRain = "light-rain"
        static let rain = "rain"
        static let heavyRain = "heavy-rain"
        static let showers = "showers"
        static let wetSnow = "wet-snow"
        static let lightSnow = "light-snow"
        static let snow = "snow"
        static let snowShowers = "snow-showers"
        static let hail = "hail"
        static let thunderstorm = "thunderstorm"
        static let thunderstormWithRain = "thunderstorm-with-rain"
        static let thunderstormWithHail = "thunderstorm-with-hail"
    }

    init?(_ condition: String, _ partOfDay: PartOfDay) {
        switch condition {
        case Conditions.clear:
            self = .clear(partOfDay)
        case Conditions.cloudy:
            self = .cloudy(partOfDay)
        case Conditions.partlyCloudy:
            self = .partlyCloudy(partOfDay)
        case Conditions.overcast:
            self = .overcast(partOfDay)
        case Conditions.hail:
            self = .hail(partOfDay)
        case Conditions.heavyRain:
            self = .heavyRain(partOfDay)
        case Conditions.lightRain:
            self = .lightRain(partOfDay)
        case Conditions.rain:
            self = .rain(partOfDay)
        case Conditions.lightSnow:
            self = .lightSnow(partOfDay)
        case Conditions.showers:
            self = .showers(partOfDay)
        case Conditions.snow:
            self = .snow(partOfDay)
        case Conditions.snowShowers:
            self = .snowShowers(partOfDay)
        case Conditions.wetSnow:
            self = .wetSnow(partOfDay)
        case Conditions.thunderstorm:
            self = .thunderstorm(partOfDay)
        case Conditions.thunderstormWithHail:
            self = .thunderstormWithHail(partOfDay)
        case Conditions.thunderstormWithRain:
            self = .thunderstormWithRain(partOfDay)
        default:
            return nil
        }
    }
}
