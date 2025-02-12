extension String {
    func matches(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}
