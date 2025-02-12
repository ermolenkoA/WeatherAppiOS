import UIKit

final class SavedCitiesTableView: UITableView {
    private var data: [City]

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
        if data.count <= 3 && !data.isEmpty {
            isScrollEnabled = false
            contentInset = UIEdgeInsets(top: CGFloat((3 - data.count) * 50), left: 0, bottom: 0, right: 0)
        } else {
            isScrollEnabled = true
            contentInset = .zero
        }
    }

    private func setupTableView() {
        dataSource = self
        delegate = self
        register(SavedCitiesTableViewCell.self, forCellReuseIdentifier: SavedCitiesTableViewCell.identifier)
        backgroundColor = .clear
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
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SavedCitiesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
