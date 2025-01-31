import UIKit

struct WeatherAPI {
    struct DataKeys {

        struct Info {
            static let name = "info"
            struct TZInfo {
                static let name = "tzinfo"
                static let offset = "offset"
            }
        }

        struct Fact {
            static let name = "fact"
            static let temp = "temp"
            static let condition = "condition"
            static let humidity = "humidity"
            static let feelsLike = "feels_like"
            static let uvIndex = "uv_index"
            static let windSpeed = "wind_speed"
            static let precProb = "prec_prob"
        }

        struct Forecasts {
            static let name = "forecasts"
            static let date = "date"
            static let sunrise = "sunrise"
            static let setEnd = "set_end"
            struct Parts {
                static let name = "parts"
                struct DayShort {
                    static let name = "day_short"
                    static let condition = "condition"
                    static let temp = "temp"
                }
                struct NightShort {
                    static let name = "night_short"
                    static let temp = "temp"
                }
            }

            struct Hours {
                static let name = "hours"
                static let hour = "hour"
                static let condition = "condition"
                static let temp = "temp"

            }
        }
    }

    static let token = ""

    static private var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weather.yandex.ru"
        components.path = "/v2/forecast"

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }

    static func createRequest(lat: Double, lon: Double) -> URLRequest {
        let url = getForecastURL(lat: lat, lon: lon)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.addValue(WeatherAPI.token, forHTTPHeaderField: "X-Yandex-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    static private func getForecastURL(lat: Double, lon: Double) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon))
        ]

        guard let url = components.url else {
            preconditionFailure("Invalid URL with query parameters")
        }

        return url
    }

}
