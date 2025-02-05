import UIKit

final class AppCoordinator {
    private var window: UIWindow?

    init(window: UIWindow? = nil) {
        self.window = window
    }

    func showMainScreen() {
        let view = CityChoiceViewController()
        let model = CityChoiceModel()
        let presenter = CityChoicePresenter()
        view.presenter = presenter
        model.presenter = presenter
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
}
