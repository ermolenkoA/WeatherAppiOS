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

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
