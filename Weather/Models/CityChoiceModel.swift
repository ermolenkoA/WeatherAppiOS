import UIKit

final class CityChoiceModel {
    weak var presenter: CityChoicePresenter?

    let searchQueue = OperationQueue()

    private let mockCities: [City] = [
        City(
            nameEN: "Minsk",
             nameRU: "Минск",
             addInfoEN: "Capital of Belarus",
             addInfoRU: "Столица Беларуси",
             latitude: 53.9006,
             longitude: 27.5590
            ),
        City(nameEN: "Moscow",
             nameRU: "Москва",
             addInfoEN: "Capital of Russia",
             addInfoRU: "Столица России",
             latitude: 55.7558,
             longitude: 37.6173
            ),
        City(nameEN: "Saint Petersburg",
             nameRU: "Санкт-Петербург",
             addInfoEN: "Cultural capital of Russia",
             addInfoRU: "Культурная столица России",
             latitude: 59.9311,
             longitude: 30.3609
            ),
        City(nameEN: "Prague",
             nameRU: "Прага",
             addInfoEN: "Capital of Czech Republic",
             addInfoRU: "Столица Чехии",
             latitude: 50.0755,
             longitude: 14.4378
            ),
        City(nameEN: "Berlin",
             nameRU: "Берлин",
             addInfoEN: "Capital of Germany",
             addInfoRU: "Столица Германии",
             latitude: 52.5200,
             longitude: 13.4050
             ),
        City(nameEN: "London",
             nameRU: "Лондон",
             addInfoEN: "Capital of UK",
             addInfoRU: "Столица Великобритании",
             latitude: 51.5074,
             longitude: -0.1278
            ),
        City(nameEN: "Paris",
             nameRU: "Париж",
             addInfoEN: "Capital of France",
             addInfoRU: "Столица Франции",
             latitude: 48.8566,
             longitude: 2.3522
            ),
        City(nameEN: "Rome",
             nameRU: "Рим",
             addInfoEN: "Capital of Italy",
             addInfoRU: "Столица Италии",
             latitude: 41.9028,
             longitude: 12.4964
            ),
        City(nameEN: "Madrid",
             nameRU: "Мадрид",
             addInfoEN: "Capital of Spain",
             addInfoRU: "Столица Испании",
             latitude: 40.4168,
             longitude: -3.7038
            ),
        City(nameEN: "Warsaw",
             nameRU: "Варшава",
             addInfoEN: "Capital of Poland",
             addInfoRU: "Столица Польши",
             latitude: 52.2298,
             longitude: 21.0122
            ),
        City(nameEN: "Amsterdam",
             nameRU: "Амстердам",
             addInfoEN: "Capital of Netherlands",
             addInfoRU: "Столица Нидерландов",
             latitude: 52.3676,
             longitude: 4.9041
            ),
        City(nameEN: "Stockholm",
             nameRU: "Стокгольм",
             addInfoEN: "Capital of Sweden",
             addInfoRU: "Столица Швеции",
             latitude: 59.3293,
             longitude: 18.0686
            ),
        City(nameEN: "Copenhagen",
             nameRU: "Копенгаген",
             addInfoEN: "Capital of Denmark",
             addInfoRU: "Столица Дании",
             latitude: 55.6761,
             longitude: 12.5683
            ),
        City(nameEN: "Vienna",
             nameRU: "Вена",
             addInfoEN: "Capital of Austria",
             addInfoRU: "Столица Австрии",
             latitude: 48.2082,
             longitude: 16.3738
            ),
        City(nameEN: "Budapest",
             nameRU: "Будапешт",
             addInfoEN: "Capital of Hungary",
             addInfoRU: "Столица Венгрии",
             latitude: 47.4979,
             longitude: 19.0402
            ),
        City(nameEN: "Barcelona",
             nameRU: "Барселона",
             addInfoEN: "City in Spain",
             addInfoRU: "Город в Испании",
             latitude: 41.3874,
             longitude: 2.1686
            ),
        City(nameEN: "Lisbon",
             nameRU: "Лиссабон",
             addInfoEN: "Capital of Portugal",
             addInfoRU: "Столица Португалии",
             latitude: 38.7169,
             longitude: -9.1399
            ),
        City(nameEN: "Dublin",
             nameRU: "Дублин",
             addInfoEN: "Capital of Ireland",
             addInfoRU: "Столица Ирландии",
             latitude: 53.3498,
             longitude: -6.2603
            ),
        City(nameEN: "New York",
             nameRU: "Нью-Йорк",
             addInfoEN: "Largest city in USA",
             addInfoRU: "Крупнейший город США",
             latitude: 40.7128,
             longitude: -74.0060
            ),
        City(nameEN: "Tokyo",
             nameRU: "Токио",
             addInfoEN: "Capital of Japan",
             addInfoRU: "Столица Японии",
             latitude: 35.6895,
             longitude: 139.6917
            )
    ]

    func getCities(with start: String, count: Int, completion: @escaping (APIError?, [City]) -> Void) {
        searchQueue.cancelAllOperations()

        let operation = BlockOperation()

        operation.addExecutionBlock { [weak self] in
            Thread.sleep(forTimeInterval: 0.5)
            if operation.isCancelled { return }
            Thread.sleep(forTimeInterval: 0.5)
            guard let filteredCities = self?.getMockedData(start, count), !operation.isCancelled else { return }
            completion(nil, filteredCities)
        }
        
        searchQueue.addOperation(operation)
    }

    func getMockedData(_ start: String, _ count: Int) -> [City] {
        Array(self.mockCities
            .filter { $0.nameEN.starts(with: start) || $0.nameRU.starts(with: start) }
            .sorted { $0.name < $1.name }
            .prefix(count))
    }
}
