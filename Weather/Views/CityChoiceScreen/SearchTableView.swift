import UIKit

class SearchTableView: UITableView {

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

    private func setupTableView() {
        dataSource = self
        delegate = self
        register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        backgroundColor = .clear
    }

    func setData(data: [City]) {
        self.data = data
        reloadData()
    }
}

// MARK: - UITableViewDataSource

extension SearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: SearchTableViewCell.identifier,
                for: indexPath
            ) as? SearchTableViewCell else { return UITableViewCell() }

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

extension SearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // Высота строки
    }
}
