import UIKit

final class MainScreenPresenter {

    private weak var view: MainScreenViewController?
    private var model: MainScreenModel?
    private weak var coordinator: AppCoordinator?
    private var long = 2
    private var lat = 3

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
        Task { [weak self] in
            let data = await self!.model!.getData(long: self!.long, lat: self!.lat)
            guard let self, let view else { return }
            await view.setWeatherData(data)
            Storage.saveWeatherModel(data)
            await view.refreshControl.endRefreshing()
            await view.activityIndicatorView.stopAnimating()
        }
    }
}
