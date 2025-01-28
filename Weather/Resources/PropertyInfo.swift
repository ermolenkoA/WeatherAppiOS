import UIKit

enum PropertyInfo: String, Codable {
    case avgTemp, probability, velocity, humidity, indexUV

    func icon() -> UIImage? {
        switch self {
        case .avgTemp:
            return R.image.typeThermometerSimpleLight()
        case .probability:
            return R.image.typeCloudRainLight()
        case .velocity:
            return R.image.typeWindLight()
        case .humidity:
            return R.image.typeDropLight()
        case .indexUV:
            return R.image.typeSunDimLight()
        }
    }

    func name() -> String {
        switch self {
        case .avgTemp:
            return R.string.localizable.temperature()
        case .probability:
            return R.string.localizable.probability()
        case .velocity:
            return R.string.localizable.windVelocity()
        case .humidity:
            return R.string.localizable.humidity()
        case .indexUV:
            return R.string.localizable.indexUV()
        }
    }
}
