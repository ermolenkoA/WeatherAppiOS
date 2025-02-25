import UIKit

final class CityChoiceModel {
    weak var presenter: CityChoicePresenter?

    let searchQueue = OperationQueue()

    func getCities(with start: String, count: Int, completion: @escaping (FileError?, [City]) -> Void) {
        searchQueue.cancelAllOperations()

        let operation = BlockOperation()

        operation.addExecutionBlock { [weak self] in
            Thread.sleep(forTimeInterval: 0.7)
            if operation.isCancelled { return }
            do {
                guard let cities = try self?.loadCities(start, count, operation),
                      !operation.isCancelled else { return }
                completion(nil, cities)
            } catch let e {
                completion(e, [])
            }
        }

        searchQueue.addOperation(operation)
    }

    private func loadCities(_ start: String, _ count: Int, _ operation: BlockOperation? = nil) throws -> [City] {
        var resultCities: [City] = []
        let start = start.lowercased()

        let resourcePaths = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
        let cityFiles = resourcePaths.filter { $0.matches(regex: "^.+_cities\\.json$") }

        if cityFiles.isEmpty {
            throw FileError.fileNotFound
        }

        for filePath in cityFiles {
            if let operation = operation, operation.isCancelled {
                return []
            }

            let url = URL(fileURLWithPath: filePath)

            guard let data = try? Data(contentsOf: url) else {
                throw FileError.accessDenied
            }

            guard let cities = try? JSONDecoder().decode([City].self, from: data) else {
                throw FileError.invalidFormat
            }

            resultCities.append(contentsOf: cities.filter {
                $0.nameEN.lowercased().starts(with: start)
                || $0.nameRU.lowercased().starts(with: start)
            })

            if resultCities.count >= count {
                return Array(resultCities
                    .sorted { $0.name < $1.name }
                    .prefix(count))
            }
        }

        return Array(resultCities
            .sorted { $0.name < $1.name }
        )
    }
}
