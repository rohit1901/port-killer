import SwiftUI
import Core

struct ContentView: View {
    @State private var ports: [PortInfo] = []
    @State private var searchText = ""
    
    var filteredPorts: [PortInfo] {
        if searchText.isEmpty {
            return ports
        } else {
            return ports.filter { 
                $0.command.localizedCaseInsensitiveContains(searchText) || 
                String($0.port).contains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Search port or process...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(8)
            
            List(filteredPorts) { port in
                HStack {
                    VStack(alignment: .leading) {
                        Text(port.command)
                            .font(.headline)
                        Text("PID: \(port.pid)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(":\(port.port)")
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                    
                    Button(action: {
                        killProcess(port)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
            
            HStack {
                Button("Refresh") {
                    refreshPorts()
                }
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(8)
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 300, height: 400)
        .onAppear {
            refreshPorts()
        }
    }
    
    func refreshPorts() {
        ports = PortManager.shared.getOpenPorts()
    }
    
    func killProcess(_ port: PortInfo) {
        try? PortManager.shared.killProcess(pid: port.pid)
        refreshPorts()
    }
}
