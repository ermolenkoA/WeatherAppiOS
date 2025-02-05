import UIKit

final class SavedCitiesTableViewCell: UITableViewCell {
    static let identifier = "SavedCitiesTableViewCell"

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.nunitoBold(size: 16)
        label.textColor = R.color.gray100()
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        contentView.addSubview(cityLabel)
        contentView.addSubview(iconImageView)

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(7)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(iconImageView.snp.height)
        }

        cityLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(7)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalToSuperview().offset(-16)
        }
    }

    func configure(with data: SavedCities) {
        cityLabel.text = data.city
        iconImageView.image = R.image.clearDayIcon()
    }
}
 
