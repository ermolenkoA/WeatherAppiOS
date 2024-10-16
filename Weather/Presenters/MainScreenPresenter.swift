import UIKit

final class MainScreenPresenter {

    private weak var view: MainScreenViewController?
    private var model: MainScreenModel?
    private weak var coordinator: AppCoordinator?

    init(_ view: MainScreenViewController? = nil,
         _ model: MainScreenModel? = nil,
         _ coordinator: AppCoordinator? = nil) {
        self.view = view
        self.model = model
        self.coordinator = coordinator
    }

}
