import UIKit

final class Storage {

    static let weatherData = "weather"

    static func saveWeatherModel(_ model: WeatherModel) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: weatherData)
        } catch {
            print("Ошибка при сохранении данных: \(error)")
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
