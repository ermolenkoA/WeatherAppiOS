import UIKit
import RswiftResources

final class AppCoordinator {
    var isFirstScreen: Bool { navC.viewControllers.count == 1 }

    private var window: UIWindow?
    private var navC = SwipeNavigationController()

    init(window: UIWindow? = nil) {
        self.window = window
    }

    func start() {
        if let weather = Storage.loadWeatherModel() {
            pushScreen(createMainScreen(for: weather))
        } else {
            pushScreen(createCityChoiceScreen())
        }
        makeNavCRoot()
        window?.makeKeyAndVisible()
    }

    func updateNavBar() {
        if navC.viewControllers.count == 1 {
            navC.setNavigationBarHidden(true, animated: true)
        } else if navC.isNavigationBarHidden {
            navC.setNavigationBarHidden(false, animated: true)
        }
    }

    func pushMainScreen(city: City) {
        pushScreen(createMainScreen(for: city))
    }

    func createNavC(root: UIViewController) {
        navC = SwipeNavigationController(rootViewController: root)
        makeNavCRoot()
    }

    func managePlusButton(vc: MainScreenViewController) {
        if navC.viewControllers.count > 1 {
            createPlusButton(for: vc)
        }
    }

    private func pushScreen(_ vc: UIViewController) {
        navC.isNavigationBarHidden = false
        if !navC.viewControllers.isEmpty {
            createBackButton(for: vc)
        }

        navC.pushViewController(vc, animated: true)
    }

    private func createBackButton(for vc: UIViewController) {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = R.color.gray100()

        let leftSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpacer.width = 16

        vc.navigationItem.leftBarButtonItems = [leftSpacer, backButton]
    }

    private func createPlusButton(for vc: MainScreenViewController) {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(plusButtonTapped))
        plusButton.tintColor = R.color.gray100()
        
        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpacer.width = 16

        vc.navigationItem.rightBarButtonItems = [plusButton, rightSpacer]
    }

    @objc private func backButtonTapped() {
        navC.popViewController(animated: true)
        updateNavBar()
    }

    @objc private func plusButtonTapped() {
        guard let vc = navC.viewControllers.last as? MainScreenViewController else { return }
        createNavC(root: vc)
        if let weather = vc.presenter?.getLastWeater() {
            Storage.saveWeatherModel(weather)
        }
    }

    private func createMainScreen(for city: City) -> MainScreenViewController {
        let view = MainScreenViewController()
        let model = MainScreenModel()
        let presenter = MainScreenPresenter(view, model, self, city)
        view.presenter = presenter
        model.presenter = presenter
        return view
    }

    private func createMainScreen(for weather: WeatherModel) -> MainScreenViewController {
        let view = MainScreenViewController()
        let model = MainScreenModel()
        let presenter = MainScreenPresenter(view, model, self, weather)
        view.presenter = presenter
        model.presenter = presenter
        return view
    }

    private func createCityChoiceScreen() -> CityChoiceViewController {
        let view = CityChoiceViewController()
        let model = CityChoiceModel()
        let presenter = CityChoicePresenter(view, model, self)
        view.presenter = presenter
        model.presenter = presenter
        return view
    }

    private func makeNavCRoot() {
        window?.rootViewController = navC
        updateNavBar()
    }
}
