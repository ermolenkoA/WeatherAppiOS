import UIKit
import RswiftResources
import SnapKit

final class CityChoiceViewController: UIViewController {

    var presenter: CityChoicePresenter?

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
                value: R.color.blue()!,
                range: rangeOfLastWord
            )
        }

        label.attributedText = attributedText
        return label
    }()

    lazy var inputLocation: UITextField = {
        let textInput = UITextField()
        textInput.backgroundColor = R.color.gray600()
        textInput.layer.cornerRadius = 15
        textInput.textColor = R.color.gray300()
        textInput.font = R.font.nunitoRegular(size: 20)
        textInput.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.enterCity(),
            attributes: [NSAttributedString.Key.foregroundColor: R.color.gray300()!]
        )

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textInput.leftView = leftPaddingView
        textInput.leftViewMode = .always
        return textInput
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
        config.baseBackgroundColor = R.color.blue()
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
        return button
    }()

    lazy var savedCitiesTableView: SavedCitiesTableView = {
        let tableView = SavedCitiesTableView()
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.allowsSelection = false
        tableView.separatorColor = R.color.gray500()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()

    private func setData() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.gray900()
        makeConstraints()
    }

    private func makeConstraints() {
        view.addSubview(headerLabel)
        view.addSubview(inputLocation)
        view.addSubview(showForecastButton)
        view.addSubview(savedCitiesTableView)

        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        inputLocation.translatesAutoresizingMaskIntoConstraints = false
        showForecastButton.translatesAutoresizingMaskIntoConstraints = false
        savedCitiesTableView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(230)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
        }

        inputLocation.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(headerLabel)
            make.height.equalTo(50)
        }

        showForecastButton.snp.makeConstraints { make in
            make.top.equalTo(inputLocation.snp.bottom).offset(180)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(40)
        }

        savedCitiesTableView.snp.makeConstraints { make in
            make.top.equalTo(showForecastButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(150)
        }
    }
}
