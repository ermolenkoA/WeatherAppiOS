import UIKit

final class SavedCitiesTableViewCell: UITableViewCell {
    static let identifier = "SavedCitiesTableViewCell"

    weak var citySelectionDelegate: SavedCitiesTableViewDelegate?
    private var selectedCity: City?

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
        addTapAnimation()
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
        selectedCity = data
        cityLabel.text = data.name
    }

    private func addTapAnimation() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.minimumPressDuration = 0
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            animateScale(transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7)
        case .ended, .cancelled, .failed:
            let touchPoint = gesture.location(in: self)
            animateScale(transform: .identity, alpha: 1) { _ in
                if self.bounds.contains(touchPoint) {
                    if let selectedCity = self.selectedCity {
                        self.citySelectionDelegate?.didSelectCity(selectedCity)
                    }
                }
            }
        case .changed:
            let touchPoint = gesture.location(in: self)
            if !bounds.contains(touchPoint) {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        default:
            break
        }
    }

    private func animateScale(
        transform: CGAffineTransform,
        alpha: CGFloat,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = transform
            self.alpha = alpha
        }, completion: completion)
    }
}
 
