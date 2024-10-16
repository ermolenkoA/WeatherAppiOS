import UIKit

final class MainScreenViewController: UIViewController {

    var presenter: MainScreenPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }

}
