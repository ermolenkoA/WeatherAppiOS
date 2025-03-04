import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    private static let eyeImages: (normal: UIImage?, slash: UIImage?) =
        (UIImage(systemName: "eye")?.resized(to: CGSize(width: 25, height: 20)),
         UIImage(systemName: "eye.slash")?.resized(to: CGSize(width: 25, height: 20)))

    private static let clearButton: UIImage? =
    (UIImage(systemName: "xmark.circle.fill")?.resized(to: CGSize(width: 20, height: 20)))

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.gray700()
        view.layer.cornerRadius = 12
        return view
    }()

    private let apiKeyTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = R.color.gray600()
        textField.textColor = R.color.gray100()
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.enterApiKey(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.gray200()!]
        )
        textField.font = R.font.nunitoRegular(size: 16)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .never
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.keyboardType = .namePhonePad

        return textField
    }()

    private let toggleAPIKeyButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = R.color.gray200()
        button.setImage(eyeImages.slash, for: .normal)
        return button
    }()

    private lazy var clearTextFieldButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = R.color.gray400()
        button.setImage(SettingsViewController.clearButton, for: .normal)
        button.isHidden = true
        return button
    }()

    private lazy var timeFormatSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["24H", "AM/PM"])
        segmentedControl.selectedSegmentTintColor = .darkGray
        return segmentedControl
    }()

    private lazy var temperatureSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["°C", "°F"])
        segmentedControl.selectedSegmentTintColor = .darkGray
        return segmentedControl
    }()

    private let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = R.string.localizable.saveSettings()
        config.baseBackgroundColor = R.color.blue100()
        config.baseForegroundColor = R.color.gray100()
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = R.font.nunitoRegular(size: 16)
            return outgoing
        }

        let button = UIButton()
        button.configuration = config
        return button
    }()

    private let completion: (() -> Void)?

    // MARK: - Жизненный цикл

    init(_ completion: (() -> Void)? = nil) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSettings()
        addTargets()
        setupTextField()
        setupDismiss()
        apiKeyTextField.inputAccessoryView = createToolbar()
    }

    // MARK: - Настройка интерфейса
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(contentView)

        let stackView = createStackView()
        contentView.addSubview(stackView)
        contentView.addSubview(saveButton)

        saveButton.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(25)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).inset(-20)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func addTargets() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSettings))
        backgroundView.addGestureRecognizer(tapGesture)

        toggleAPIKeyButton.addTarget(self, action: #selector(toggleAPIKeyVisibility), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        clearTextFieldButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
    }

    private func setupDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func toggleAPIKeyVisibility() {
        apiKeyTextField.isSecureTextEntry.toggle()
        toggleAPIKeyButton.setImage(
            apiKeyTextField.isSecureTextEntry
            ? SettingsViewController.eyeImages.slash
            : SettingsViewController.eyeImages.normal,
            for: .normal
        )
    }

    @objc private func clearTextField() {
        apiKeyTextField.text = ""
        clearTextFieldButton.isHidden = true
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = R.font.nunitoSemiBold(size: 16)
        label.textColor = R.color.gray100()
        return label
    }

    private func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            createLabel(text: R.string.localizable.apiKey()),
            apiKeyTextField,
            createLabel(text: R.string.localizable.timeFormat()),
            timeFormatSegmentedControl,
            createLabel(text: R.string.localizable.temperatureSettings()),
            temperatureSegmentedControl
        ])

        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }

    // MARK: - Загрузка и сохранение настроек
    private func loadSettings() {
        let settings = Storage.getSettings()
        apiKeyTextField.text = settings.apiKey
        timeFormatSegmentedControl.selectedSegmentIndex = settings.isAMPMFormat ? 1 : 0
        temperatureSegmentedControl.selectedSegmentIndex = settings.isFahrenheit ? 1 : 0
    }

    private func setupTextField() {
        let rightStackView = UIStackView(arrangedSubviews: [clearTextFieldButton, toggleAPIKeyButton])
        rightStackView.axis = .horizontal
        rightStackView.spacing = 8

        apiKeyTextField.rightView = rightStackView
        apiKeyTextField.rightViewMode = .always
        apiKeyTextField.delegate = self
    }

    @objc private func saveSettings() {
        let settings: Storage.AppSettings = (
            isAMPMFormat: timeFormatSegmentedControl.selectedSegmentIndex == 1,
            isFahrenheit: temperatureSegmentedControl.selectedSegmentIndex == 1,
            apiKey: apiKeyTextField.text ?? ""
        )

        Storage.saveSettings(settings)

        dismissSettings()
    }

    @objc private func dismissSettings() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.contentView.alpha = 0
        }) { _ in
            self.dismiss(animated: false, completion: self.completion)
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        clearTextFieldButton.isHidden = apiKeyTextField.text?.isEmpty ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        clearTextFieldButton.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidChangeSelection(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let hexString = (textField.text as NSString?)?
            .replacingCharacters(in: range, with: string)
            .replacingOccurrences(of: "-", with: ""),
              hexString.matches(regex: "^[0-9a-fA-F]{0,32}$") else {
            return false
        }

        // Автоформатирование: вставляем тире согласно схеме 8-4-4-4-12
        var formattedString = ""
        let sections = [8, 4, 4, 4, 12]
        var index = hexString.startIndex

        for section in sections {
            if index == hexString.endIndex { break }
            let endIndex = hexString
                .index(index, offsetBy: section, limitedBy: hexString.endIndex)
            ?? hexString.endIndex
            formattedString += hexString[index..<endIndex]
            if endIndex != hexString.endIndex {
                formattedString += "-"
            }
            index = endIndex
        }
        textField.text = formattedString
        return false
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let pasteButton = UIBarButtonItem(
            title: R.string.localizable.paste(),
            style: .plain,
            target: self,
            action: #selector(pasteHexValue)
        )
        pasteButton.tintColor = .white

        toolbar.items = [flexibleSpace, pasteButton]
        return toolbar
    }

    @objc private func pasteHexValue() {
        if let clipboardText = UIPasteboard.general.string {
            let hexString = clipboardText.replacingOccurrences(of: "-", with: "")

            let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
            if hexString.rangeOfCharacter(from: allowedCharacters.inverted) == nil && hexString.count <= 32 {
                var formattedString = ""
                let sections = [8, 4, 4, 4, 12]
                var index = hexString.startIndex

                for section in sections {
                    if index == hexString.endIndex { break }
                    let endIndex = hexString.index(
                        index,
                        offsetBy: section,
                        limitedBy: hexString.endIndex) ?? hexString.endIndex
                    formattedString += hexString[index..<endIndex]
                    if endIndex != hexString.endIndex {
                        formattedString += "-"
                    }
                    index = endIndex
                }

                apiKeyTextField.text = formattedString
            }
        }
    }

}
