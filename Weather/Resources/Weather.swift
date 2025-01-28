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
            return partOfDay == .day ? R.image.weatherClearMomentDayIcon() : R.image.weatherClearMomentNightIcon()
        case .partlyCloudy(let partOfDay):
            return partOfDay == .day ?
            R.image.weatherFewCloudsMomentDayIcon() :
            R.image.weatherFewCloudsMomentNightIcon()
        case .cloudy(let partOfDay):
            return partOfDay == .day ? R.image.weatherFewCloudsMomentDayIcon() : R.image.weatherFewCloudsMomentNightIcon()
        case .overcast(let partOfDay):
            return partOfDay == .day ? R.image.weatherCloudyMomentDayIcon() : R.image.weatherCloudyMomentNightIcon()
        case .lightRain(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        case .rain(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        case .heavyRain(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        case .showers(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        case .wetSnow(let partOfDay):
            return partOfDay == .day ? R.image.weatherFreezingRain() : R.image.weatherFreezingRain()
        case .lightSnow(let partOfDay):
            return partOfDay == .day ? R.image.weatherSnow() : R.image.weatherSnow()
        case .snow(let partOfDay):
            return partOfDay == .day ? R.image.weatherSnow() : R.image.weatherSnow()
        case .snowShowers(let partOfDay):
            return partOfDay == .day ? R.image.weatherSnow() : R.image.weatherSnow()
        case .hail(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        case .thunderstorm(let partOfDay):
            return partOfDay == .day ? R.image.weatherStormMomentDayIcon() : R.image.weatherStormMomentNightIcon()
        case .thunderstormWithRain(let partOfDay):
            return partOfDay == .day ? R.image.weatherStormMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        case .thunderstormWithHail(let partOfDay):
            return partOfDay == .day ? R.image.weatherStormMomentDayIcon() : R.image.weatherRainMomentNightIcon()
        }
    }

    func background() -> UIImage {
        switch self {
        case .clear(let partOfDay):
            return partOfDay == .day ? R.image.weatherClearMomentDay()! : R.image.weatherClearMomentNight()!
        case .partlyCloudy(let partOfDay):
            return partOfDay == .day ? R.image.weatherFewCloudsMomentDay()! : R.image.weatherFewCloudsMomentNight()!
        case .cloudy(let partOfDay):
            return partOfDay == .day ? R.image.weatherFewCloudsMomentDay()! : R.image.weatherFewCloudsMomentNight()!
        case .overcast(let partOfDay):
            return partOfDay == .day ? R.image.weatherCloudyMomentDay()! : R.image.weatherCloudyMomentNight()!
        case .lightRain(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .rain(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .heavyRain(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .showers(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .wetSnow(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .lightSnow(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .snow(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .snowShowers(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .hail(let partOfDay):
            return partOfDay == .day ? R.image.weatherRainMomentDay()! : R.image.weatherRainMomentNight()!
        case .thunderstorm(let partOfDay):
            return partOfDay == .day ? R.image.weatherStormMomentDay()! : R.image.weatherStormMomentNight()!
        case .thunderstormWithRain(let partOfDay):
            return partOfDay == .day ? R.image.weatherStormMomentDay()! : R.image.weatherRainMomentNight()!
        case .thunderstormWithHail(let partOfDay):
            return partOfDay == .day ? R.image.weatherStormMomentDay()! : R.image.weatherRainMomentNight()!
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
