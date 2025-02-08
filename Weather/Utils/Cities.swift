import UIKit

struct City: Codable {
    let nameEN: String
    let nameRU: String
    private let addInfoEN: String
    private let addInfoRU: String
    let latitude: Double
    let longitude: Double

    var name: String {
        (Locale.current.languageCode ?? "en") == "ru" ? nameRU : nameEN
    }

    var addInfo: String {
        (Locale.current.languageCode ?? "en") == "ru" ? addInfoRU : addInfoEN
    }

    init(
        nameEN: String, nameRU: String,
        addInfoEN: String, addInfoRU: String,
        latitude: Double, longitude: Double
    ) {
        self.nameEN = nameEN
        self.nameRU = nameRU
        self.addInfoEN = addInfoEN
        self.addInfoRU = addInfoRU
        self.latitude = latitude
        self.longitude = longitude
    }
}
