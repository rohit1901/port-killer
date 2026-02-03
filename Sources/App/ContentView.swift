import SwiftUI
import Core

struct ContentView: View {
    @State private var ports: [PortInfo] = []
    @State private var searchText = ""
    @State private var hoveredPortId: UUID?
    
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
            // Header Search
            VStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(10)
            
            // List Content
            ScrollView {
                LazyVStack(spacing: 0) {
                    if filteredPorts.isEmpty {
                        Text("No active ports found")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                    } else {
                        ForEach(filteredPorts) { port in
                            PortRow(port: port, isHovered: hoveredPortId == port.id) {
                                killProcess(port)
                            }
                            .onHover { isHovered in
                                if isHovered {
                                    hoveredPortId = port.id
                                } else if hoveredPortId == port.id {
                                    hoveredPortId = nil
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Footer
            HStack {
                Button("Refresh") {
                    refreshPorts()
                }
                
                Spacer()
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(10)
        }
        .frame(width: 280, height: 350)
        .background(.ultraThinMaterial)
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

struct PortRow: View {
    let port: PortInfo
    let isHovered: Bool
    let onKill: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(port.command)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack(spacing: 4) {
                    Text("PID \(port.pid)")
                    Text("•")
                    Text("TCP")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(":\(port.port.formatted(.number.grouping(.never)))")
                .font(.body.monospaced())
                .foregroundColor(.secondary)
            
            if isHovered {
                Button(action: onKill) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isHovered ? Color.secondary.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
    }
}
