import UIKit
import SnapKit
import RswiftResources

protocol WeatherViewDelegate: AnyObject {
    func loupePressed()
    func settingsDotPressed()
}

final class WeatherView: UIImageView {

    var isLoupeHidden: Bool {
        get {
            iconLoupe.isHidden
        }
        set {
            iconLoupe.isHidden = newValue
        }
    }

    var isSettingsHidden: Bool {
        get {
            settingsDots.isHidden
        }
        set {
            settingsDots.isHidden = newValue
        }
    }

    weak var delegate: WeatherViewDelegate?

    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.nunitoBold(size: 22)
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.nunitoRegular(size: 18)
        return label
    }()

    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.nunitoExtraBold(size: 45)
        return label
    }()

    lazy var dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.nunitoBold(size: 18)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.nunitoRegular(size: 18)
        return label
    }()

    lazy var weatherImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()

    lazy var iconLoupe: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true

        let tapDownGesture = UILongPressGestureRecognizer(target: self, action: #selector(loupePressed(_:)))
        tapDownGesture.minimumPressDuration = 0
        imageView.addGestureRecognizer(tapDownGesture)
        return imageView
    }()

    lazy var settingsDots: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "ellipsis.circle"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true

        let tapDownGesture = UILongPressGestureRecognizer(target: self, action: #selector(settingsDotsPressed(_:)))
        tapDownGesture.minimumPressDuration = 0
        imageView.addGestureRecognizer(tapDownGesture)
        return imageView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    func setData(_ data: WeatherModel) {
        cityLabel.text = data.city.name
        dateLabel.text = data.date.fullForecastDate
        temperatureLabel.text = data.tempC.getTemp()
        dayTemperatureLabel.text = data.tempMax.getTemp()
            + "/"
            + data.tempMin.getTemp()
        descriptionLabel.text = data.info.description()
        weatherImageView.image = data.info.mainIcon()
        image = data.info.background()
    }

    @objc private func loupePressed(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.1) {
                self.iconLoupe.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        case .ended, .cancelled, .failed:
            let touchPoint = gesture.location(in: self.iconLoupe)
            UIView.animate(withDuration: 0.1, animations: {
                self.iconLoupe.transform = .identity
            }) { _ in
                if self.iconLoupe.bounds.contains(touchPoint) {
                    self.delegate?.loupePressed()
                }
            }
        default:
            break
        }
    }

    @objc private func settingsDotsPressed(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.1) {
                self.settingsDots.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        case .ended, .cancelled, .failed:
            let touchPoint = gesture.location(in: self.settingsDots)
            UIView.animate(withDuration: 0.1, animations: {
                self.settingsDots.transform = .identity
            }) { _ in
                if self.settingsDots.bounds.contains(touchPoint) {
                    self.delegate?.settingsDotPressed()
                }
            }
        default:
            break
        }
    }

    private func setupView() {
        addSubview(weatherImageView)
        addSubview(cityLabel)
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        addSubview(dayTemperatureLabel)
        addSubview(descriptionLabel)
        addSubview(iconLoupe)
        addSubview(settingsDots)
    }

    private func setupConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        iconLoupe.translatesAutoresizingMaskIntoConstraints = false
        settingsDots.translatesAutoresizingMaskIntoConstraints = false

        let horizontalInset = 25
        let verticalInset = 20
        iconLoupe.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalInset)
            make.width.height.equalTo(27)
            make.trailing.equalToSuperview().inset(horizontalInset)
        }
        settingsDots.snp.makeConstraints { make in
            make.top.equalTo(iconLoupe.snp.bottom).offset(verticalInset)
            make.width.height.equalTo(27)
            make.trailing.equalToSuperview().inset(horizontalInset)
        }
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalInset)
            make.leading.equalToSuperview().inset(horizontalInset)
            make.trailing.equalTo(iconLoupe.snp.leading).offset(-10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.leading.equalToSuperview().inset(horizontalInset)
            make.trailing.equalToSuperview().offset(horizontalInset)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(horizontalInset)
            make.leading.equalToSuperview().offset(horizontalInset)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        dayTemperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.leading.equalToSuperview().offset(horizontalInset)
            make.width.equalTo(descriptionLabel)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalTo(dayTemperatureLabel.snp.top)
            make.leading.equalToSuperview().offset(horizontalInset)
            make.width.equalTo(descriptionLabel)
        }
        weatherImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalTo(weatherImageView.snp.width)
        }
    }
}
