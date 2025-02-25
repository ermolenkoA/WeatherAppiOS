import UIKit

struct ForecastDate: Codable {
    let weekday: Int
    let month: Int
    let day: Int

    static var weekdaysShort: [String] { [
        R.string.localizable.sun(),
        R.string.localizable.mon(),
        R.string.localizable.tue(),
        R.string.localizable.wed(),
        R.string.localizable.thu(),
        R.string.localizable.fri(),
        R.string.localizable.sat()
    ] }

    static var weekdays: [String] { [
        R.string.localizable.sunday(),
        R.string.localizable.monday(),
        R.string.localizable.tuesday(),
        R.string.localizable.wednesday(),
        R.string.localizable.thursday(),
        R.string.localizable.friday(),
        R.string.localizable.saturday()
    ] }

    static var months: [String] { [
        R.string.localizable.jan(),
        R.string.localizable.feb(),
        R.string.localizable.mar(),
        R.string.localizable.apr(),
        R.string.localizable.may(),
        R.string.localizable.june(),
        R.string.localizable.july(),
        R.string.localizable.aug(),
        R.string.localizable.sep(),
        R.string.localizable.oct(),
        R.string.localizable.nov(),
        R.string.localizable.dec()
    ] }

    init(date: Date) {
        let utcTimeZone = TimeZone(abbreviation: "UTC")!
        var calendar = Calendar.current
        calendar.timeZone = utcTimeZone
        self.weekday = calendar.component(.weekday, from: date)
        self.month = calendar.component(.month, from: date)
        self.day = calendar.component(.day, from: date)
    }

    var fullForecastDate: String {
        let currentLanguage = Locale.current.languageCode ?? "en"
        if currentLanguage == "ru" {
            return "\(weekdayName()), \(day) \(monthName())"
        }
        return "\(weekdayName()), \(monthName()) \(day)"
    }

    static func weekdayShortName(_ day: Int) -> String {
        guard 1...7 ~= day else { return "" }
        return ForecastDate.weekdaysShort[day - 1]
    }

    private func weekdayName() -> String {
        ForecastDate.weekdays[weekday - 1]
    }

    private func monthName() -> String {
        ForecastDate.months[month - 1]
    }
}
