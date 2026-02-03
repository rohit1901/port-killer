import ArgumentParser
import Core
import Foundation

@main
struct PortKillerCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "port-killer",
        abstract: "A tool to kill processes on ports.",
        subcommands: [List.self, Kill.self],
        defaultSubcommand: List.self)
    
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "List all open ports.")
        
        func run() {
            let ports = PortManager.shared.getOpenPorts()
            print(String(format: "%-10@ %-10@ %-10@", "COMMAND", "PID", "PORT"))
            for p in ports {
                print(String(format: "%-10@ %-10d %-10d", p.command, p.pid, p.port))
            }
        }
    }
    
    struct Kill: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Kill process on a port.")
        
        @Argument(help: "The port number to free up.")
        var port: Int
        
        func run() {
            let ports = PortManager.shared.getOpenPorts()
            if let target = ports.first(where: { $0.port == port }) {
                do {
                    try PortManager.shared.killProcess(pid: target.pid)
                    print("Successfully killed process \(target.command) (PID: \(target.pid)) on port \(port).")
                } catch {
                    print("Failed to kill process: \(error)")
                }
            } else {
                print("No process found on port \(port).")
            }
        }
    }
}
