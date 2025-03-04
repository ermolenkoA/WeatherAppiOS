import UIKit
import RswiftResources
import SnapKit

final class CityChoiceViewController: UIViewController {

    enum Constants {
        static let textFieldHeight: CGFloat = 50
        static let textFieldTopHeight: CGFloat = 40
        static let textFieldCenter: CGFloat = 15
    }

    var presenter: CityChoicePresenter?

    var isKeyboardVisible = false
    var textFieldHeightConstraint: Constraint?
    var savedCitiesTableViewHeightConstraint: Constraint?

    var topInset: CGFloat {
        -(inputLocation.frame.origin.y - view.safeAreaInsets.top)
    }
    var dataFound: Bool {
        get {
            searchCitiesTableView.dataFound
        }
        set {
            searchCitiesTableView.dataFound = newValue
        }
    }

    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.nunitoBold(size: 22)
        label.textAlignment = .center

        let fullText = R.string.localizable.header()

        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .foregroundColor: R.color.gray200()!
            ]
        )

        let words = fullText.components(separatedBy: " ")
        if let lastWord = words.last {
            let fullNSString = fullText as NSString
            let rangeOfLastWord = fullNSString.range(of: lastWord, options: .backwards)

            attributedText.addAttribute(
                .foregroundColor,
                value: R.color.blue100()!,
                range: rangeOfLastWord
            )
        }

        label.attributedText = attributedText
        return label
    }()

    lazy var inputLocation: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = R.color.gray600()
        textField.layer.cornerRadius = Constants.textFieldHeight * 0.3
        textField.textColor = R.color.gray100()
        textField.font = R.font.nunitoRegular(size: 20)
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.enterCity(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.gray400()!]
        )

        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.returnKeyType = .go

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    lazy var showForecastButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = R.string.localizable.showForecast()
        if let originalImage = R.image.cloud() {
            let biggerImage = originalImage.resized(to: CGSize(width: 26, height: 26))
            config.image = biggerImage
        }
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseBackgroundColor = R.color.blue100()
        config.baseForegroundColor = R.color.gray100()
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = R.font.nunitoRegular(size: 20)
            return outgoing
        }

        let button = UIButton()
        button.configuration = config
        button.isHidden = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    lazy var savedCitiesTableView: SavedCitiesTableView = {
        let tableView = SavedCitiesTableView()
        tableView.allowsSelection = false
        tableView.separatorColor = R.color.gray400()
        tableView.layer.cornerRadius = 15
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()

    lazy var searchCitiesTableView: SearchTableView = {
        let tableView = SearchTableView()
        tableView.allowsSelection = false
        tableView.separatorColor = R.color.gray500()
        tableView.layer.opacity = 0
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.gray900()
        makeConstraints()
        inputLocation.delegate = self
        setupTapGesture()
        presenter?.loadLastCities()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func showSettings() {
        presenter?.showSettings()
    }

    func setSearchCities(_ cities: [City]) {
        searchCitiesTableView.setData(data: cities)
    }

    func startSearching() {
        searchCitiesTableView.clearData()
        searchCitiesTableView.startSearching()
    }

    func endSearching() {
        searchCitiesTableView.endsearching()
    }

    func clearSearchTableView() {
        searchCitiesTableView.clearData()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        searchCitiesTableView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func buttonTapped() {
        presenter?.showForecast()
    }

    private func makeConstraints() {
        view.addSubview(headerLabel)
        view.addSubview(inputLocation)
        view.addSubview(showForecastButton)
        view.addSubview(savedCitiesTableView)
        view.addSubview(searchCitiesTableView)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLocation.translatesAutoresizingMaskIntoConstraints = false
        showForecastButton.translatesAutoresizingMaskIntoConstraints = false
        savedCitiesTableView.translatesAutoresizingMaskIntoConstraints = false
        searchCitiesTableView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-(Constants.textFieldHeight * 1.5))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        inputLocation.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(headerLabel)
            textFieldHeightConstraint =
            make.height.equalTo(Constants.textFieldHeight).constraint
        }

        showForecastButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }

        savedCitiesTableView.snp.makeConstraints { make in
            make.bottom.equalTo(showForecastButton.snp.top).offset(-15)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(165)
            savedCitiesTableViewHeightConstraint =
            make.height.equalTo(0).constraint
        }

        searchCitiesTableView.snp.makeConstraints { make in
            make.width.equalTo(inputLocation)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(Constants.textFieldTopHeight)
            make.centerX.equalToSuperview()
            make.height.equalTo(250)
        }
    }
}

extension CityChoiceViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
              newText.matches(regex: "^[A-Za-zА-Яа-яЁё\\- ]*$") else {
            return false
        }

        presenter?.textChanged(newText)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            self.presenter?.textFieldClear()
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
