import UIKit
import SnapKit
import RswiftResources

final class PropertiesWeatherTableView: UITableView {

    private var data: [Property]

    init() {
        
        self.data = []

        super.init(frame: .zero, style: .plain)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.dataSource = self
        self.delegate = self
        self.register(PropertiesWeatherTableCell.self, forCellReuseIdentifier: PropertiesWeatherTableCell.identifier)
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 50
        self.backgroundColor = R.color.gray800()
    }

    func setData(data: [Property]) {
        self.data = data
        self.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PropertiesWeatherTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: PropertiesWeatherTableCell.identifier,
                for: indexPath
            ) as? PropertiesWeatherTableCell else { return UITableViewCell() }

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

extension PropertiesWeatherTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // Высота строки
    }
}
