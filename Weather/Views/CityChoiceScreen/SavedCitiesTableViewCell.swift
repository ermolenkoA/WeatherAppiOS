import UIKit

final class SavedCitiesTableViewCell: UITableViewCell {
    static let identifier = "SavedCitiesTableViewCell"

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.nunitoSemiBold(size: 18)
        label.textColor = R.color.gray100()
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.historyTime()
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
            make.leading.equalToSuperview().offset(12)
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalTo(iconImageView.snp.height)
        }

        cityLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
            make.height.equalToSuperview().offset(-16)
        }
    }

    func configure(with data: City) {
        cityLabel.text = data.name
    }
}
 
