import Foundation

extension Int {
    func getTemp() -> String {
        Storage.isFahrenheit()
        ? R.string.localizable.temperatureF(self.toFahrenheit())
        : R.string.localizable.temperatureC(self)
    }

    func getTime() -> String {
        Storage.isAMPMFormat() ? self.toAMPM() : String(format: "%02d", self)
    }

    func toFahrenheit() -> Int {
        return Int(Double(self) * 9.0 / 5.0 + 32.0)
    }

    func toAMPM() -> String {
        let hour = self % 24
        let period = hour < 12 ? "AM" : "PM"
        let hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return "\(hour12)\(period)"
    }
}
