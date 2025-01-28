import UIKit

struct Property: Codable {
    let info: PropertyInfo
    let value: String

    init(type: PropertyInfo, value: Int) {
        switch type {
        case .avgTemp:
            self.value = R.string.localizable.temperatureC(value)
        case .probability:
            self.value = R.string.localizable.percent(value)
        case .velocity:
            self.value = R.string.localizable.speed(value)
        case .humidity:
            self.value = R.string.localizable.percent(value)
        case .indexUV:
            self.value = String(value)
        }
        info = type
    }

}
