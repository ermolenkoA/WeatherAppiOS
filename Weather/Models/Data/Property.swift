import UIKit

struct Property {
    let icon: UIImage
    let name: String
    let value: String

    static func createAvgTemp(value: Int) -> Property {
        Property(
            icon: R.image.typeThermometerSimpleLight()!,
            name: R.string.localizable.temperature(),
            value: R.string.localizable.temperatureC(value)
        )
    }

    static func createProbability(value: Int) -> Property {
        Property(
            icon: R.image.typeCloudRainLight()!,
            name: R.string.localizable.probability(),
            value: R.string.localizable.percent(value)
        )
    }

    static func createVelocity(value: Int) -> Property {
        Property(
            icon: R.image.typeWindLight()!,
            name: R.string.localizable.windVelocity(),
            value: R.string.localizable.speed(value)
        )
    }

    static func createHumidity(value: Int) -> Property {
        Property(
            icon: R.image.typeDropLight()!,
            name: R.string.localizable.humidity(),
            value: R.string.localizable.percent(value)
        )
    }

    static func createIndexUV(value: Int) -> Property {
        Property(
            icon: R.image.typeSunDimLight()!,
            name: R.string.localizable.indexUV(),
            value: String(value)
        )
    }

}
