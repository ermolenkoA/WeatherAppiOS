import UIKit
import SnapKit
import RswiftResources

final class HourWeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "HourWeatherCollectionViewCell"

    private lazy var timeLabel: UILabel = {
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

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.nunitoBold(size: 15)
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
        }

        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(weatherImageView.snp.width)
            make.center.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(with data: HourWeather) {
        timeLabel.text = String(format: "%02d", data.time)
        weatherImageView.image = data.info.icon()
        temperatureLabel.text = R.string.localizable.temperatureC(data.temp)
    }
}
