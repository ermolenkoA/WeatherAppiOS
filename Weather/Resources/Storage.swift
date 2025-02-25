import UIKit

final class Storage {

    static let weatherData = "weather"
    static let savedCities = "savedCities"

    static let maxCities = 3

    static func saveWeatherModel(_ model: WeatherModel) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: weatherData)
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }

    static func getLastCities() -> [City] {
        guard let data = UserDefaults.standard.data(forKey: Storage.savedCities),
              let cities = try? JSONDecoder().decode([City].self, from: data) else {
            return []
        }
        return cities
    }

    static func saveCity(_ city: City) {
        var savedCities = getLastCities()
        savedCities.removeAll { $0 == city }
        savedCities.insert(city, at: 0)
        if savedCities.count > maxCities {
            savedCities.removeLast()
        }

        if let encoded = try? JSONEncoder().encode(savedCities) {
            UserDefaults.standard.set(encoded, forKey: Storage.savedCities)
        }
    }

    static func loadWeatherModel() -> WeatherModel? {
        if let data = UserDefaults.standard.data(forKey: weatherData) {
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

}
