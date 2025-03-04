import UIKit

protocol SearchTableViewDelegate: AnyObject {
    func select(city: City)
}

final class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"

    weak var delegate: SearchTableViewDelegate?
    var isAnimationEnabled = true
    private var city: City?

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.nunitoSemiBold(size: 18)
        label.textColor = R.color.gray200()
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = R.font.nunitoSemiBold(size: 16)
        label.textColor = R.color.gray400()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .clear
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(descriptionLabel)

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        cityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(7)
        }
    }

    func configure(with data: City) {
        city = data
        cityLabel.text = data.name
        descriptionLabel.text = data.addInfo
    }

    func configureEmpty() {
        city = .none
        cityLabel.text = R.string.localizable.notFound()
        descriptionLabel.text = nil
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        guard isAnimationEnabled else { return }
        animateScale(transform: CGAffineTransform(scaleX: 0.95, y: 0.95), alpha: 0.7) {
            self.animateScale(transform: .identity, alpha: 1.0) {
                if let city = self.city {
                    self.delegate?.select(city: city)
                }
            }
        }
    }

    private func animateScale(transform: CGAffineTransform, alpha: CGFloat, completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.6,
            options: .allowUserInteraction,
            animations: {
                self.transform = transform
                self.alpha = alpha
            },
            completion: { _ in completion?() }
        )
    }
}
