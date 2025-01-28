import UIKit
import SnapKit
import RswiftResources

final class DayWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "DayWeatherCollectionViewCell"

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 16)
        label.textColor = R.color.gray200()
        return label
    }()

    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var dayTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 16)
        label.textColor = R.color.gray100()
        return label
    }()

    private lazy var nightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 16)
        label.textColor = R.color.gray400()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(dayTemperatureLabel)
        contentView.addSubview(nightTemperatureLabel)

        dayLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(12)
            make.width.equalToSuperview()
            make.height.equalTo(weatherImageView.snp.width).multipliedBy(0.8)
        }

        dayTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }

        nightTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dayTemperatureLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(with data: DayWeather) {
        dayLabel.text = data.day
        weatherImageView.image = data.info.icon()
        dayTemperatureLabel.text = R.string.localizable.temperatureC(data.maxTemp)
        nightTemperatureLabel.text = R.string.localizable.temperatureC(data.minTemp)
    }
}
