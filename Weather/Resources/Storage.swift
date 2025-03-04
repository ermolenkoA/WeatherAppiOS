import UIKit
import Security

final class Storage {

    typealias AppSettings = (isAMPMFormat: Bool, isFahrenheit: Bool, apiKey: String)

    enum Constants {
        enum Keys {
            static let weatherData = "weather"
            static let savedCities = "savedCities"
            static let isAMPMFormat = "isAMPMFormat"
            static let isFahrenheit = "isFahrenheit"
        }
        static let maxCities = 3
        static let apiKeyService = "usya.Weather.weatherAPI"
    }

    static func saveWeatherModel(_ model: WeatherModel) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: Constants.Keys.weatherData)
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }

    static func getLastCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: Constants.Keys.savedCities),
              let cities = try? JSONDecoder().decode([City].self, from: data) else {
            return []
        }
        return cities
    }

    static func saveCity(_ city: City) {
        var savedCities = getLastCities()
        savedCities.removeAll { $0 == city }
        savedCities.insert(city, at: 0)
        if savedCities.count > Constants.maxCities {
            savedCities.removeLast()
        }

        if let encoded = try? JSONEncoder().encode(savedCities) {
            UserDefaults.standard.set(encoded, forKey: Constants.Keys.savedCities)
        }
    }

    static func loadWeatherModel() -> WeatherModel? {
        if let data = UserDefaults.standard.data(forKey: Constants.Keys.weatherData) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(WeatherModel.self, from: data)
                return model
            } catch {
                print("Ошибка при восстановлении данных: \(error)")
                return nil
            }
        }
        return nil
    }

    static func getSettings() -> AppSettings {
        let isAMPMFormat = isAMPMFormat()
        let isFahrenheit = isFahrenheit()
        let apiKey = getApiKey()
        return (isAMPMFormat, isFahrenheit, apiKey)
    }

    static func isAMPMFormat() -> Bool {
        UserDefaults.standard.bool(forKey: Constants.Keys.isAMPMFormat)
    }

    static func isFahrenheit() -> Bool {
        UserDefaults.standard.bool(forKey: Constants.Keys.isFahrenheit)
    }

    static func saveSettings(_ settings: AppSettings) {
        UserDefaults.standard.setValue(settings.isAMPMFormat, forKey: Constants.Keys.isAMPMFormat)
        UserDefaults.standard.setValue(settings.isFahrenheit, forKey: Constants.Keys.isFahrenheit)
        saveApiKey(settings.apiKey)
    }

    static func saveApiKey(_ apiKey: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.apiKeyService,
            kSecValueData as String: apiKey.data(using: .utf8)!
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func getApiKey() -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.apiKeyService,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8) ?? ""
        }

        return ""
    }
}
