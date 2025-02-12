import UIKit
import SnapKit
import RswiftResources

final class WeatherView: UIImageView {
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
        temperatureLabel.text = R.string.localizable.temperatureC(data.tempC)
        dayTemperatureLabel.text = R.string.localizable.temperatureC(data.tempMax)
            + "/"
            + R.string.localizable.temperatureC(data.tempMin)
        descriptionLabel.text = data.info.description()
        weatherImageView.image = data.info.mainIcon()
        image = data.info.background()
    }

    private func setupView() {
        addSubview(weatherImageView)
        addSubview(cityLabel)
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        addSubview(dayTemperatureLabel)
        addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        dayTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalInset = 25
        let verticalInset = 20
        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalInset)
            make.leading.equalToSuperview().inset(horizontalInset)
            make.trailing.equalToSuperview().offset(horizontalInset)
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
