import UIKit

final class SwipeNavigationController: UINavigationController,
                                       UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        enableSwipeBackGesture()
    }

    private func enableSwipeBackGesture() {
        guard let interactivePopGesture = interactivePopGestureRecognizer,
              let gestureView = interactivePopGesture.view else { return }

        let panGesture = UIPanGestureRecognizer(
            target: interactivePopGesture.delegate,
            action: Selector(("handleNavigationTransition:"))
        )
        panGesture.delegate = self
        gestureView.addGestureRecognizer(panGesture)

        interactivePopGesture.isEnabled = false
    }

    @discardableResult
    override func popViewController(animated: Bool) -> UIViewController? {
        setNavigationBarHidden(viewControllers.count == 2, animated: true)
        return super.popViewController(animated: animated)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        setNavigationBarHidden(viewControllers.isEmpty, animated: true)
        super.pushViewController(viewController, animated: animated)
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
