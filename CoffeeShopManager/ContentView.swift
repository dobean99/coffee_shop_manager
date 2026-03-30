import SwiftUI

struct ContentView: View {
    var body: some View {
        RootTabView()
            .environment(\.font, .system(.body, design: .default))
    }
}

#Preview {
    ContentView()
}
