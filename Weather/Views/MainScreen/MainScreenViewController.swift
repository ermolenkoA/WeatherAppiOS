import UIKit
import RswiftResources
import SnapKit

final class MainScreenViewController: UIViewController {

    var presenter: MainScreenPresenter?
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        control.tintColor = .white
        return control
    }()

    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.backgroundColor = R.color.gray900()
        activityIndicator.style = .large
        activityIndicator.color = .white
        return activityIndicator
    }()

    private lazy var weatherScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = R.color.gray900()
        scrollView.refreshControl = refreshControl
        return scrollView
    }()

    private lazy var weatherContentView: UIView = {
        let contentView = UIView()
        return contentView
    }()

    private lazy var weatherBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.gray800()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()

    private lazy var hourWeatherCollectionView: HourWeatherCollectionView = {
        let collectionView = HourWeatherCollectionView(rowCount: 1, columnCount: 10)
        collectionView.backgroundColor = R.color.gray800()
        collectionView.layer.cornerRadius = 15
        collectionView.layer.masksToBounds = true
        collectionView.clipsToBounds = true
        return collectionView
    }()

    private lazy var propertiesWeatherTableView: PropertiesWeatherTableView = {
        let tableView = PropertiesWeatherTableView()
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.allowsSelection = false
        tableView.separatorColor = R.color.gray500()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return tableView
    }()

    private lazy var dayWeatherCollectionView: DayWeatherCollectionView = {
        let collectionView = DayWeatherCollectionView(rowCount: 1, columnCount: 10)
        collectionView.backgroundColor = R.color.gray800()
        collectionView.layer.cornerRadius = 15
        collectionView.layer.masksToBounds = true
        collectionView.clipsToBounds = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.gray900()
        makeConstraints()
        presenter?.prepareView()
    }
    
    func setWeatherData(_ data: WeatherModel) {
        weatherView.setData(data)
        hourWeatherCollectionView.setData(data: data.hourWeather)
        propertiesWeatherTableView.setData(data: data.properties)
        dayWeatherCollectionView.setData(data: data.dailyweather)
    }

    @objc private func refreshData() {
        presenter?.updateMainScreen()
    }
    
    private func makeConstraints() {
        view.addSubview(weatherScrollView)
        weatherScrollView.addSubview(weatherContentView)
        weatherContentView.addSubview(weatherBackgroundView)
        weatherBackgroundView.addSubview(weatherView)
        weatherContentView.addSubview(hourWeatherCollectionView)
        weatherContentView.addSubview(propertiesWeatherTableView)
        weatherContentView.addSubview(dayWeatherCollectionView)
        view.addSubview(activityIndicatorView)

        weatherScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        weatherContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() 
        }

        weatherBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(weatherContentView.safeAreaLayoutGuide.snp.top).inset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.91)
            make.height.equalTo(weatherView.snp.width).multipliedBy(0.9)
        }

        weatherView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        hourWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(weatherBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(140)
        }

        propertiesWeatherTableView.snp.makeConstraints { make in
            make.top.equalTo(hourWeatherCollectionView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }

        dayWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(propertiesWeatherTableView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(160)
            make.bottom.equalToSuperview()
        }

        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
