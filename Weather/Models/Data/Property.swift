import UIKit

struct Property: Codable {
    let info: PropertyInfo
    private let _value: Int
    var value: String {
        return switch info {
        case .avgTemp:
            _value.getTemp()
        case .probability:
            R.string.localizable.percent(_value)
        case .velocity:
            R.string.localizable.speed(_value)
        case .humidity:
            R.string.localizable.percent(_value)
        case .indexUV:
            String(_value)
        }
    }

    init(info: PropertyInfo, value: Int) {
        self.info = info
        self._value = value
    }

}
