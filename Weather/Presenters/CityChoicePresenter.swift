import UIKit

final class CityChoicePresenter {
    
    private weak var view: CityChoiceViewController?
    private var model: CityChoiceModel?
    private weak var coordinator: AppCoordinator?

    private var isKeyboardVisible = false
    private var maxCities = 50

    init(
        _ view: CityChoiceViewController?,
        _ model: CityChoiceModel?,
        _ coordinator: AppCoordinator?
    ) {
        self.view = view
        self.model = model
        self.coordinator = coordinator

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible, let view else { return }
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
        view.textFieldHeightConstraint?.update(
            offset: CityChoiceViewController.Constants.textFieldTopHeight
        )
        view.inputLocation.layer.cornerRadius =
        CityChoiceViewController.Constants.textFieldTopHeight * 0.3
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let view, isKeyboardVisible else { return }
        isKeyboardVisible = false
        view.inputLocation.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3) {
            view.searchCitiesTableView.layer.opacity = 0
            view.headerLabel.layer.opacity = 1
            view.savedCitiesTableView.layer.opacity = 1
        }
        view.textFieldHeightConstraint?.update(
            offset: CityChoiceViewController.Constants.textFieldHeight
        )
        view.inputLocation.layer.cornerRadius = CityChoiceViewController.Constants.textFieldHeight * 0.3

    }

    func textChanged(_ newText: String) {
        guard let newCities = model?.getCities(with: newText, count: maxCities) else {
            return
        }
        view?.setSearchCities(newCities)
    }
}
