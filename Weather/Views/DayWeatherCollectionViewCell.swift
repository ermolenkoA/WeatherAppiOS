import UIKit
import SnapKit
import RswiftResources

final class DayWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "DayWeatherCollectionViewCell"

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 14)
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
        label.textColor = R.color.gray100()
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
            make.top.equalTo(dayLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(weatherImageView.snp.width)
        }

        dayTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        nightTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dayTemperatureLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(with data: DayWeather) {
        dayLabel.text = data.day
        weatherImageView.image = data.imageWeather
        dayTemperatureLabel.text = data.dayTemperature
        nightTemperatureLabel.text = data.nightTemperature
    }
}
