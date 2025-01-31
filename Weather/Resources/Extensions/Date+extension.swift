import UIKit
import RswiftResources

extension Date {

    static let weekDays = [
        R.string.localizable.sun(),
        R.string.localizable.mon(),
        R.string.localizable.tue(),
        R.string.localizable.wed(),
        R.string.localizable.thu(),
        R.string.localizable.fri(),
        R.string.localizable.sat()
    ]
    static let months = [
        R.string.localizable.jan(),
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]

    func getHours() -> Int {
        let utcTimeZone = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar.current
        calendar.timeZone = utcTimeZone
        return calendar.component(.hour, from: self)
    }

    static func getDayOfWeek(from dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        let calendar = Calendar.current

        return calendar.component(.weekday, from: date)
    }
}
