import UIKit
import RswiftResources

final class MainScreenPresenter {

    private weak var view: MainScreenViewController?
    private var model: MainScreenModel?
    private weak var coordinator: AppCoordinator?

    private let city: City
    private var lastWeather: WeatherModel?

    init(_ view: MainScreenViewController? = nil,
         _ model: MainScreenModel? = nil,
         _ coordinator: AppCoordinator? = nil,
         _ city: City
        ) {
        self.view = view
        self.model = model
        self.coordinator = coordinator
        self.city = city
    }

    convenience init(_ view: MainScreenViewController? = nil,
                     _ model: MainScreenModel? = nil,
                     _ coordinator: AppCoordinator? = nil,
                     _ weather: WeatherModel
                    ) {
        self.init(view, model, coordinator, weather.city)
        lastWeather = weather
        view?.showButton()
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
                view.refreshControl.endRefreshing()
                view.activityIndicatorView.stopAnimating()
                self?.coordinator?.managePlusButton(vc: view)
                if self?.coordinator?.isFirstScreen == true {
                    Storage.saveWeatherModel(data)
                }
                self?.lastWeather = data
            }
        }
    }

    func getLastWeater() -> WeatherModel? {
        lastWeather
    }

    func getCity() -> City {
        city
    }

    func prepareView() {
        if let lastWeather {
            view?.setWeatherData(lastWeather)
        } else {
            view?.activityIndicatorView.startAnimating()
            updateMainScreen()
        }
    }

    private func showError(_ message: String) {
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

extension MainScreenPresenter: WeatherViewDelegate {
    func loupePressed() {
        coordinator?.pushCityChoiceScreen()
    }
}
