struct ApplicationAppearance {
    static func setupAppearance() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBarBackground"), forBarMetrics: .Default)
    }
}
