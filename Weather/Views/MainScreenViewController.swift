import UIKit
import RswiftResources
import SnapKit

final class MainScreenViewController: UIViewController {

    var presenter: MainScreenPresenter?

    private lazy var weatherScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
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
        view.image = R.image.weatherClearMomentNight()
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
        tableView.separatorColor = R.color.gray400()
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
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
        layoutWeatherView()
        setWeatherData()
    }
    
    func setWeatherData() {
        weatherView.cityLabel.text = "ntvbrefweffewff"
        weatherView.dateLabel.text = "efhnwekjvgnwfewfwe"
        weatherView.temperatureLabel.text = "28"
        weatherView.dayTemperatureLabel.text = "28/32"
        weatherView.descriptionLabel.text = "ekfjnwkef"
        weatherView.weatherImageView.image = R.image.weatherClearMomentNightIcon()

    }

    private func layoutWeatherView() {
        view.addSubview(weatherScrollView)
        weatherScrollView.addSubview(weatherContentView)
        weatherContentView.addSubview(weatherBackgroundView)
        weatherBackgroundView.addSubview(weatherView)
        weatherContentView.addSubview(hourWeatherCollectionView)
        weatherContentView.addSubview(propertiesWeatherTableView)
        weatherContentView.addSubview(dayWeatherCollectionView)

        weatherScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            make.top.equalTo(weatherBackgroundView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }

        propertiesWeatherTableView.snp.makeConstraints { make in
            make.top.equalTo(hourWeatherCollectionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }

        dayWeatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(propertiesWeatherTableView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(130)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
