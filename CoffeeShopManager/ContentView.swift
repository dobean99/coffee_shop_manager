import SwiftUI

struct ContentView: View {
    @AppStorage("settings.darkMode") private var isDarkMode = false

    var body: some View {
        RootTabView()
            .environment(\.font, .system(.body, design: .default))
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
