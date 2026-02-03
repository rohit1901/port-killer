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
                if let image = Bundle.module.image(forResource: "port-killer") ?? NSImage(named: "port-killer") {
                    let ratio = image.size.height / image.size.width
                    image.size.height = 18
                    image.size.width = 18 / ratio
                    return image
                }
                return NSImage(systemSymbolName: "circle.grid.cross", accessibilityDescription: nil)!
            }()

            Image(nsImage: image)
        }
        .menuBarExtraStyle(.window)
    }
}

class AppState: ObservableObject {
    // Shared state if needed
}
