import UIKit
import SnapKit
import RswiftResources

final class PropertiesWeatherTableView: UITableView {

    private let rowCount = 5 
    private var data: [PropertiesWeather]

    init() {
        
        self.data = (0..<rowCount).map { index in
            PropertiesWeather(
                iconImage: R.image.typeCloudRainLight(),
                propertyText: "Property \(index + 1)",
                valueText: "\(32 + index)"
            )
        }

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
}

// MARK: - UITableViewDataSource

extension PropertiesWeatherTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertiesWeatherTableCell.identifier, for: indexPath) as? PropertiesWeatherTableCell else {
            return UITableViewCell()
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
