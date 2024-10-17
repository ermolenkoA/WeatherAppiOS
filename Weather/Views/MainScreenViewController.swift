import UIKit
import RswiftResources

final class MainScreenViewController: UIViewController {

    var presenter: MainScreenPresenter?
    let greetingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetingLabel)
        greetingLabel.numberOfLines = 0

        // Устанавливаем автолейаут (constraints)
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Получаем случайное имя
        let randomName = ["Анна", "Иван", "Мария", "Дмитрий"].randomElement()!
        // Используем R.swift для локализации
        
        var hours = Calendar.current.component(.hour, from: Date())
        let minutes = Calendar.current.component(.minute, from: Date())

        hours = hours % 12
        hours = hours == 0 ? 12 : hours

        let helloText = R.string.localizable.greeting(randomName)
        let hoursText = R.string.localizable.hours(value: hours)
        let minutesText = R.string.localizable.minutes(value: minutes)

        greetingLabel.text = helloText + "\n" + hoursText + " " + minutesText
        greetingLabel.textColor = R.color.red()
    }

}
