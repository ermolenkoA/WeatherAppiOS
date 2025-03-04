import UIKit

final class CityChoicePresenter {

    private weak var view: CityChoiceViewController?
    private var model: CityChoiceModel?
    private weak var coordinator: AppCoordinator?

    private var isKeyboardVisible = false
    private var maxCities = 50
    private var lastTextFieldText: String?

    private var savedCity: City?
    private var ignoreKeyboardEvents = false

    init(
        _ view: CityChoiceViewController?,
        _ model: CityChoiceModel?,
        _ coordinator: AppCoordinator?
    ) {
        self.view = view
        self.model = model
        self.coordinator = coordinator
        addObserver()
        view?.searchCitiesTableView.searchDelegate = self
        view?.savedCitiesTableView.citySelectionDelegate = self

        if let view = view {
            coordinator?.manageSettingsButton(vc: view)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible && !ignoreKeyboardEvents, let view else { return }
        isKeyboardVisible = true
        view.inputLocation.transform = CGAffineTransform(
            translationX: 0,
            y: view.topInset
        )
        UIView.animate(withDuration: 1) {
            view.searchCitiesTableView.layer.opacity = 1
            view.headerLabel.layer.opacity = 0
            view.savedCitiesTableView.layer.opacity = 0
        }
        view.showForecastButton.isHidden = true
        view.savedCitiesTableView.layer.opacity = 0
        view.textFieldHeightConstraint?.update(
            offset: CityChoiceViewController.Constants.textFieldTopHeight
        )
        view.inputLocation.text = lastTextFieldText
        view.inputLocation.layer.cornerRadius =
        CityChoiceViewController.Constants.textFieldTopHeight * 0.3
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let view, isKeyboardVisible && !ignoreKeyboardEvents else { return }
        isKeyboardVisible = false
        lastTextFieldText = view.inputLocation.text
        view.inputLocation.text = savedCity?.name
        view.inputLocation.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3) {
            view.searchCitiesTableView.layer.opacity = 0
            view.headerLabel.layer.opacity = 1
            view.savedCitiesTableView.layer.opacity = 1
        }
        view.showForecastButton.isHidden = savedCity == nil
        view.textFieldHeightConstraint?.update(
            offset: CityChoiceViewController.Constants.textFieldHeight
        )
        view.inputLocation.layer.cornerRadius = CityChoiceViewController.Constants.textFieldHeight * 0.3

    }

    func textChanged(_ newText: String) {
        guard !newText.isEmpty else {
            textFieldClear()
            return
        }
        savedCity = nil
        view?.startSearching()
        model?.getCities(with: newText, count: maxCities, completion: { [weak self] error, cities in
            if let error {
                switch error {
                case .fileNotFound:
                    Logger.log(level: .error, instance: self, message: "JSON file not found")
                case .invalidFormat:
                    Logger.log(level: .error, instance: self, message: "Format in JSON file is invalid")
                case .accessDenied:
                    Logger.log(level: .error, instance: self, message: "Access to JSON file is denied")
                }
            }
            DispatchQueue.main.async {
                self?.view?.dataFound = !cities.isEmpty
                self?.view?.endSearching()
                self?.view?.setSearchCities(cities)
            }
        })
    }

    func textFieldClear() {
        savedCity = nil
        model?.searchQueue.cancelAllOperations()
        view?.clearSearchTableView()
    }

    func showForecast() {
        guard let savedCity else { return }
        coordinator?.pushMainScreen(city: savedCity)
    }

    func loadLastCities() {
        view?.savedCitiesTableView.setData(data: Storage.getLastCities())
    }

    func showSettings() {
        guard let coordinator, let view else { return }
        ignoreKeyboardEvents = true
        coordinator.showSettings(from: view) {
            self.ignoreKeyboardEvents = false
        }
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

extension CityChoicePresenter: SearchTableViewDelegate {
    func select(city: City) {
        savedCity = city
        view?.view.endEditing(true)
    }
}

extension CityChoicePresenter: SavedCitiesTableViewDelegate {
    func updateTableHeight(with height: CGFloat) {
        view?.savedCitiesTableViewHeightConstraint?.update(offset: height)
    }
    
    func didSelectCity(_ city: City) {
        coordinator?.pushMainScreen(city: city)
    }
}
