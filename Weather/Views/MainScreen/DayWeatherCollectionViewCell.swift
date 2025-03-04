import UIKit
import SnapKit
import RswiftResources

final class DayWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "DayWeatherCollectionViewCell"
    
    enum Constants {
        static let dayLabelHeight: CGFloat = 30
        static let weatherImageViewHeight: CGFloat = 55
        static let dayTemperatureLabelHeight: CGFloat = 20
        static let nightTemperatureLabelHeight: CGFloat = 20
        static let totalSpace: CGFloat = 10
        static let totalHeight: CGFloat = 130
    }

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
        label.font = R.font.nunitoBold(size: 14)
        label.textColor = R.color.gray100()
        return label
    }()

    private lazy var nightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 14)
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

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        dayTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        nightTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false

        dayLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.dayLabelHeight)
        }

        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.weatherImageViewHeight)
        }

        dayTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.dayTemperatureLabelHeight)
        }

        nightTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(dayTemperatureLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(Constants.nightTemperatureLabelHeight)
        }
    }

    func configure(with data: DayWeather) {
        dayLabel.text = ForecastDate.weekdayShortName(data.weekday)
        weatherImageView.image = data.info.icon()
        dayTemperatureLabel.text = data.maxTemp.getTemp()
        nightTemperatureLabel.text = data.minTemp.getTemp()
    }
}
