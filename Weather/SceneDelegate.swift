import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Создаем окно
        window = UIWindow(windowScene: windowScene)
        
        let initialViewController = ViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
}
