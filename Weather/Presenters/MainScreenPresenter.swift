import UIKit
import RswiftResources

final class MainScreenPresenter {

    private weak var view: MainScreenViewController?
    private var model: MainScreenModel?
    private weak var coordinator: AppCoordinator?
    let city = City(
        nameEN: "Borisov",
        nameRU: "Борисов",
        addInfoEN: "Belarus, Minsk Region",
        addInfoRU: "Беларусь, Минская область",
        latitude: 54.2322075,
        longitude: 28.5146671
    )

    init(_ view: MainScreenViewController? = nil,
         _ model: MainScreenModel? = nil,
         _ coordinator: AppCoordinator? = nil) {
        self.view = view
        self.model = model
        self.coordinator = coordinator
    }

    func prepareView() {
        if let data = Storage.loadWeatherModel() {
            view?.setWeatherData(data)
        } else {
            view?.activityIndicatorView.startAnimating()
            updateMainScreen()
        }
    }

    func updateMainScreen() {
        model?.getData(city) { [weak self, view] error, data in

            guard let view else {
                Logger.log(level: .error, instance: self, message: "Unexpected error: view = nil")
                return
            }

            if let error {
                var message: String = ""
                switch error {
                case .network:
                    message = "Network error occurred"
                    Logger.log(level: .error, instance: self, message: message)
                case .noData:
                    message = "No data received"
                    Logger.log(level: .error, instance: self, message: message)
                case .dataParse(what: let what):
                    message = what
                    Logger.log(level: .error, instance: self, message: message)
                case .badAPIKey:
                    message = R.string.localizable.apiKeyError()
                    Logger.log(level: .error, instance: self, message: message)
                }
                self?.showError(message)
                return
            }

            guard let data else {
                let error = "Unexpected error: data = nil"
                Logger.log(level: .error, instance: self, message: error)
                self?.showError(error)
                return
            }

            DispatchQueue.main.async {
                view.setWeatherData(data)
                Storage.saveWeatherModel(data)
                view.refreshControl.endRefreshing()
                view.activityIndicatorView.stopAnimating()
            }
        }
    }

    func showError(_ message: String) {
        let alertController = UIAlertController(
            title: R.string.localizable.error(),
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(.init(
            title: "OK",
            style: .default) { [weak self] _ in
                self?.view?.refreshControl.endRefreshing()
            }
        )
        DispatchQueue.main.async { [weak self] in
            self?.view?.present(alertController, animated: true)
        }
    }
}
