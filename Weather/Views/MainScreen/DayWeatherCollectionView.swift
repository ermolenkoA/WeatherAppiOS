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
        self.data = []

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero

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

    func setData(data: [DayWeather]) {
        self.data = data
        self.reloadData()
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
                height: frame.height - 10)
    }

    func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            return .init(top: 0, left: 1, bottom: 0, right: 1)
    }
}
