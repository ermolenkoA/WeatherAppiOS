import UIKit

final class AppCoordinator {
    private var window: UIWindow?

    init(window: UIWindow? = nil) {
        self.window = window
    }

    func start() {
        showCityChoiceScreen()
    }

    func showMainScreen(for city: City) {
        let view = MainScreenViewController()
        let model = MainScreenModel()
        let presenter = MainScreenPresenter(view, model, self, city)
        view.presenter = presenter
        model.presenter = presenter
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }

    func showCityChoiceScreen() {
        let view = CityChoiceViewController()
        let model = CityChoiceModel()
        let presenter = CityChoicePresenter(view, model, self)
        view.presenter = presenter
        model.presenter = presenter
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
}
