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
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                TextField("Search...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(Color(NSColor.controlBackgroundColor))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(NSColor.separatorColor)),
                alignment: .bottom
            )
            
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
                Button(action: refreshPorts) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                .buttonStyle(LinkButtonStyle())
                .font(.caption)
                
                Spacer()
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Label("Quit", systemImage: "power")
                }
                .buttonStyle(LinkButtonStyle())
                .font(.caption)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(NSColor.windowBackgroundColor))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(NSColor.separatorColor)),
                alignment: .top
            )
        }
        .frame(width: 280, height: 350)
        .background(Color(NSColor.textBackgroundColor))
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
        HStack(spacing: 10) {
            // Process Info
            VStack(alignment: .leading, spacing: 2) {
                Text(port.command)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack(spacing: 4) {
                    Text("PID \(port.pid)")
                    Text("•")
                    Text("TCP") // Assuming TCP based on lsof command
                }
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Port Number
            Text(":\(port.port.formatted(.number.grouping(.never)))")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(4)
            
            // Kill Action
            Button(action: onKill) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isHovered ? .red : .secondary)
                    .frame(width: 20, height: 20)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .opacity(isHovered ? 1 : 0.5)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isHovered ? Color(NSColor.selectedControlColor).opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
    }
}

struct LinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .secondary : .primary)
    }
}
