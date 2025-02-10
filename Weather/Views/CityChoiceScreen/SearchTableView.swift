import UIKit
import SnapKit

final class SearchTableView: UITableView {

    private var data: [City]

    private var dataCount: Int {
        dataFound ? data.count : 1
    }

    weak var searchDelegate: SearchTableViewDelegate?

    var dataFound: Bool = true

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = R.color.gray900()
        activityIndicator.style = .medium
        activityIndicator.color = .white
        return activityIndicator
    }()

    init() {
        data = []
        super.init(frame: .zero, style: .plain)
        setupTableView()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        data = []
        super.init(coder: coder)
        setupTableView()
        makeConstraints()
    }

    func setData(data: [City]) {
        self.data = data
        reloadData()
    }

    func startSearching() {
        activityIndicatorView.startAnimating()
    }

    func endsearching() {
        activityIndicatorView.stopAnimating()
    }

    func clearData() {
        data.removeAll()
        dataFound = true
        activityIndicatorView.stopAnimating()
        reloadData()
    }

    private func setupTableView() {
        dataSource = self
        delegate = self
        register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        backgroundColor = .clear
        allowsSelection = false
    }

    private func makeConstraints() {
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        activityIndicatorView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(0.3)
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
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

        if !dataFound {
            cell.configureEmpty()
            cell.isAnimationEnabled = false
        } else {
            let cellData = data[indexPath.row]
            cell.configure(with: cellData)
            cell.isAnimationEnabled = true
            cell.delegate = searchDelegate
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
