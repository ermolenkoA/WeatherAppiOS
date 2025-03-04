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

    func pushMainScreen(city: City) {
        pushScreen(createMainScreen(for: city))
    }

    func pushCityChoiceScreen() {
        pushScreen(createCityChoiceScreen())
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

    func manageSettingsButton(vc: CityChoiceViewController) {
        createSettingsButton(for: vc)
    }

    func showSettings(from vc: UIViewController, completion: (() -> Void)? = nil) {
        vc.navigationController?.view.isUserInteractionEnabled = false 

        let settingsVC = SettingsViewController {
            vc.navigationController?.view.isUserInteractionEnabled = true
            completion?()
        }

        settingsVC.modalPresentationStyle = .overFullScreen
        settingsVC.modalTransitionStyle = .crossDissolve

        vc.present(settingsVC, animated: true)
    }

    func popAndShowSettings() {
        popViewController()
        guard let view = navC.viewControllers.last else { return }
        if let view = view as? CityChoiceViewController {
            view.showSettings()
        } else {
            showSettings(from: view)
        }
    }

    func popViewController() {
        navC.popViewController(animated: true)
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

    private func createSettingsButton(for vc: CityChoiceViewController) {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(settingsButtonTapped))
        plusButton.tintColor = R.color.gray100()

        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpacer.width = 16

        vc.navigationItem.rightBarButtonItems = [plusButton, rightSpacer]
    }

    @objc private func backButtonTapped() {
        navC.popViewController(animated: true)
    }

    @objc private func plusButtonTapped() {
        guard let vc = navC.viewControllers.last as? MainScreenViewController else { return }
        createNavC(root: vc)
        vc.showButton()
        if let weather = vc.presenter?.getLastWeater(),
           let city = vc.presenter?.getCity() {
            Storage.saveWeatherModel(weather)
            Storage.saveCity(city)
        }
    }

    @objc private func settingsButtonTapped() {
        (navC.viewControllers.last as? CityChoiceViewController)?.showSettings()
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
    }
}
