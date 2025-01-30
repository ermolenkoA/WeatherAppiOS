import UIKit

final class MainScreenPresenter {

    private weak var view: MainScreenViewController?
    private var model: MainScreenModel?
    private weak var coordinator: AppCoordinator?
    let lat = 54.221440
    let lon = 28.501430

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
        model?.getData(lon: self.lon, lat: self.lat) { [weak self, view] error, data in
            guard let data else { return }
            guard let self, let view else { return }
            DispatchQueue.main.async {
                view.setWeatherData(data)
                Storage.saveWeatherModel(data)
                view.refreshControl.endRefreshing()
                view.activityIndicatorView.stopAnimating()
            }
        }
    }
}
