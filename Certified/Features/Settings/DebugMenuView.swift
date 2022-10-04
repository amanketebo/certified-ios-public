import SwiftUI

struct DebugMenuView: View {

    @State var isFaceSwapPrototypeEnabled: Bool

    let featureFlagsManager: FeatureFlagsManager

    var body: some View {
        NavigationView {
            List {
                Section("Flags") {
                    Toggle("Face Swap Prototype", isOn: $isFaceSwapPrototypeEnabled)
                }
            }
            .navigationTitle("Debug Menu")
        }
        .onChange(of: isFaceSwapPrototypeEnabled) { newValue in
            featureFlagsManager.updateFaceSwapPrototypeEnabled(newValue)
        }
    }

    init(featureFlagsManager: FeatureFlagsManager) {
        self.featureFlagsManager = featureFlagsManager
        self.isFaceSwapPrototypeEnabled = featureFlagsManager.isFaceSwapPrototypeEnabled
    }
}
