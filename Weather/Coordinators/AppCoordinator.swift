import UIKit

final class AppCoordinator {
    private var window: UIWindow?

    init(window: UIWindow? = nil) {
        self.window = window
    }

    func showMainScreen() {
        let view = MainScreenViewController()
        let model = MainScreenModel()
        let presenter = MainScreenPresenter(view, model, self)
        view.presenter = presenter
        model.presenter = presenter
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
}
