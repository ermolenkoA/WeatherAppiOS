import UIKit
import SnapKit
import RswiftResources

final class HourWeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "HourWeatherCollectionViewCell"

    enum Constants {
        static let timeLabelHeight: CGFloat = 30
        static let weatherImageViewHeight: CGFloat = 55
        static let temperatureLabelHeight: CGFloat = 30
        static let totalHeight: CGFloat = 110
    }

    private lazy var timeLabel: UILabel = {
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

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 14)
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
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(temperatureLabel)

        timeLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.timeLabelHeight)
        }

        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.width.height.equalTo(Constants.weatherImageViewHeight)
            make.centerX.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(Constants.temperatureLabelHeight)
        }
    }

    func configure(with data: HourWeather) {
        timeLabel.text = data.time.getTime()
        weatherImageView.image = data.info.icon()
        temperatureLabel.text = data.temp.getTemp()
    }
}
