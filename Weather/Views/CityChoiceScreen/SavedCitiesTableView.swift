import UIKit

protocol SavedCitiesTableViewDelegate: AnyObject {
    func didSelectCity(_ city: City)
    func updateTableHeight(with height: CGFloat)
}

final class SavedCitiesTableView: UITableView {
    enum Constants {
        static let maxCities = 3
        static let rowHeight: CGFloat = 55
    }

    private var data: [City]
    weak var citySelectionDelegate: SavedCitiesTableViewDelegate?

    init() {
        data = []
        super.init(frame: .zero, style: .plain)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        data = []
        super.init(coder: coder)
        setupTableView()
    }

    override func reloadData() {
        super.reloadData()
        citySelectionDelegate?.updateTableHeight(
            with: Constants.rowHeight * CGFloat(min(data.count, Constants.maxCities))
        )
    }

    private func setupTableView() {
        dataSource = self
        delegate = self
        register(SavedCitiesTableViewCell.self, forCellReuseIdentifier: SavedCitiesTableViewCell.identifier)
        backgroundColor = R.color.gray600()
    }

    func setData(data: [City]) {
        self.data = data
        reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SavedCitiesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: SavedCitiesTableViewCell.identifier,
                for: indexPath
            ) as? SavedCitiesTableViewCell else { return UITableViewCell() }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: frame.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }

        let cellData = data[indexPath.row]
        cell.configure(with: cellData)
        cell.citySelectionDelegate = citySelectionDelegate
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SavedCitiesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
