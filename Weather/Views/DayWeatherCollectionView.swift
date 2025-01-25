import UIKit
import SnapKit
import RswiftResources

final class DayWeatherCollectionView: UICollectionView {
    private var rowCount: Int
    private var columnCount: Int
    private var data: [DayWeather]

    init(rowCount: Int = 1, columnCount: Int = 10) {
        self.rowCount = rowCount
        self.columnCount = columnCount

        // Инициализация данных
        self.data = (0..<columnCount).map { index in
            DayWeather(
                day: "Mon",
                icon: R.image.weatherFewCloudsMomentNightIcon()!,
                maxTemp: 32,
                minTemp: 29
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
            DayWeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: DayWeatherCollectionViewCell.identifier)
    }

}

// MARK: - UICollectionViewDataSource

extension DayWeatherCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DayWeatherCollectionViewCell.identifier,
                for: indexPath
            ) as? DayWeatherCollectionViewCell else { return UICollectionViewCell() }

        let cellData = data[indexPath.item]
        cell.configure(with: cellData)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DayWeatherCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(
                width: frame.width / 6,
                height: frame.height - 20)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            return .zero
    }
}
