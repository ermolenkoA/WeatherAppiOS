import UIKit

enum APIError: Error {
    case network, noData, dataParse(what: String), badAPIKey
}
