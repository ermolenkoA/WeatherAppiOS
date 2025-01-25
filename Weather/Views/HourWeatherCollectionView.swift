import UIKit
import SnapKit
import RswiftResources

final class HourWeatherCollectionView: UICollectionView {
    private var rowCount: Int
    private var columnCount: Int
    private var data: [HourWeather]

    init(rowCount: Int = 1, columnCount: Int = 10) {
        self.rowCount = rowCount
        self.columnCount = columnCount

        // Инициализация данных
        self.data = (0..<columnCount).map { index in
            HourWeather(
                time: index + 12,
                icon: R.image.weatherFewCloudsMomentNightIcon()!,
                temp: 32
            )
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        super.init(frame: .zero, collectionViewLayout: layout)
        self.contentInset = .zero
        self.showsHorizontalScrollIndicator = false

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        self.dataSource = self
        self.delegate = self
        self.register(
            HourWeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: HourWeatherCollectionViewCell.identifier)
    }

}

// MARK: - UICollectionViewDataSource

extension HourWeatherCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HourWeatherCollectionViewCell.identifier,
                for: indexPath
            ) as? HourWeatherCollectionViewCell else { return UICollectionViewCell() }

        let cellData = data[indexPath.item]
        cell.configure(with: cellData)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HourWeatherCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(
                width: frame.width / 6,
                height: frame.height - 10)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            return .zero
    }
}
