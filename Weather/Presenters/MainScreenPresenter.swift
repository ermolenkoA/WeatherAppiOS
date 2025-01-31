import UIKit

final class MainScreenPresenter {

    private weak var view: MainScreenViewController?
    private var model: MainScreenModel?
    private weak var coordinator: AppCoordinator?
    let city = City(
        nameEN: "Borisov",
        nameRU: "Борисов",
        addInfoEN: "Belarus, Minsk Region",
        addInfoRU: "Беларусь, Минская область",
        latitude: 34.055863,
        longitude: -118.246139
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

            if let error {
                switch error {
                case .network:
                    Logger.log(level: .error, instance: self, message: "Network error occurred")
                case .noData:
                    Logger.log(level: .error, instance: self, message: "No data received")
                case .dataParse(what: let what):
                    Logger.log(level: .error, instance: self, message: "Data parsing: \(what)")
                }
            }

            guard let data else {
                Logger.log(level: .error, instance: self, message: "Unexpected error: data = nil")
                return
            }
            guard let self, let view else {
                Logger.log(level: .error, instance: self, message: "Unexpected error: self = nil")
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
}
