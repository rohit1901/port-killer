import SwiftUI
import Core

@main
struct PortKillerApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 18
                $0.size.width = 18 / ratio
                return $0
            }(NSImage(named: "MenuBarIcon")!)

            Image(nsImage: image)
        }
        .menuBarExtraStyle(.window)
    }
}

class AppState: ObservableObject {
    // Shared state if needed
}
