import SwiftUI

struct RootSafeAreaInsetsKey: EnvironmentKey {

    static var defaultValue: EdgeInsets {
        EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

extension EnvironmentValues {

    var rootSafeAreaInsets: EdgeInsets {
        get { self[RootSafeAreaInsetsKey.self] }
        set { self[RootSafeAreaInsetsKey.self] = newValue }
    }
}
