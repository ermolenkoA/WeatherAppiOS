import UIKit
import SnapKit
import RswiftResources

final class PropertiesWeatherTableCell: UITableViewCell {

    static let identifier = "PropertiesWeatherTableCell"
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var propertyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.nunitoRegular(size: 16)
        label.textColor = R.color.gray100()
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = R.font.nunitoRegular(size: 20)
        label.textColor = R.color.gray200()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(weatherImageView)
        contentView.addSubview(propertyLabel)
        contentView.addSubview(valueLabel)

        weatherImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(7)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(weatherImageView.snp.height)

        }

        propertyLabel.snp.makeConstraints { make in
            make.leading.equalTo(weatherImageView.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalToSuperview().offset(-16)
        }

        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(propertyLabel.snp.trailing).offset(7)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview() 
            make.height.equalToSuperview().offset(-16)
        }
    }

    func configure(with data: PropertiesWeather) {
        weatherImageView.image = data.iconImage
        propertyLabel.text = data.propertyText
        valueLabel.text = data.valueText

    }
}
