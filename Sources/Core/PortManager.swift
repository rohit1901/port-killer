import Foundation

public struct PortInfo: Identifiable, Equatable {
    public let id = UUID()
    public let port: Int
    public let pid: Int
    public let command: String
    
    public init(port: Int, pid: Int, command: String) {
        self.port = port
        self.pid = pid
        self.command = command
    }
}

public class PortManager {
    public static let shared = PortManager()
    
    public init() {}
    
    public func getOpenPorts() -> [PortInfo] {
        // Run lsof -iTCP -sTCP:LISTEN -P -n
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["lsof", "-iTCP", "-sTCP:LISTEN", "-P", "-n"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                return parseLsofOutput(output)
            }
        } catch {
            print("Error running lsof: \(error)")
        }
        return []
    }
    
    private func parseLsofOutput(_ output: String) -> [PortInfo] {
        var ports: [PortInfo] = []
        let lines = output.components(separatedBy: .newlines)
        
        // Skip header
        for line in lines.dropFirst() {
            let parts = line.split(separator: " ", omittingEmptySubsequences: true)
            if parts.count >= 9 {
                // Example: COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
                // python3 12345 user 3u IPv4 0t0 TCP *:8000 (LISTEN)
                
                let command = String(parts[0])
                if let pid = Int(parts[1]) {
                    // Search for port in the last few parts
                    // NAME column: *:8089 (LISTEN) -> ["*:8089", "(LISTEN)"]
                    // or *:80 -> ["*:80"]
                    
                    var port: Int? = nil
                    
                    // Iterate backwards from the end
                    for part in parts.reversed() {
                        if part == "(LISTEN)" || part == "(ESTABLISHED)" { continue }
                        
                        // Check for address:port
                        if let lastColonIndex = part.lastIndex(of: ":") {
                            let portSubstring = part[part.index(after: lastColonIndex)...]
                            if let p = Int(portSubstring) {
                                port = p
                                break
                            }
                        }
                    }
                    
                    if let port = port {
                        ports.append(PortInfo(port: port, pid: pid, command: command))
                    }
                }
            }
        }
        return ports
    }
    
    public func killProcess(pid: Int) throws {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["kill", "-9", "\(pid)"]
        try task.run()
        task.waitUntilExit()
    }
}
