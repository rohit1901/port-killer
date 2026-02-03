# Port Killer

![Port Killer Logo](Sources/App/Resources/port-killer.png)

A native macOS port termination tool. Quickly identify and kill processes running on specific ports.

## Features

- **Menu Bar App**: Lives in your menu bar for quick access to list and kill ports.
- **CLI Tool**: Terminal interface for scripting and quick management.
- **Native Swift**: Built with Swift and SwiftUI for optimal performance on macOS.

## Installation & Building

### Prerequisites
- macOS 13.0+
- Xcode Command Line Tools (`xcode-select --install`)
- Swift 5.9+

### Build the App Bundle

To create the standalone `PortKiller.app` (including the custom icon):

```bash
make bundle
```

The app will be created in the root directory: `PortKiller.app`. Drag it to your `/Applications` folder.

> **Note:** If you receive an "Application is damaged" error, the build script attempts to fix this automatically. If it persists, run:
> ```bash
> xattr -cr PortKiller.app
> ```

## Usage

### Menu Bar App
Simply launch `PortKiller.app`. A new icon (custom Port Killer logo) will appear in your menu bar. Click it to see active ports and terminate them.

### CLI

You can run the CLI tool using `swift run`:

**List active ports:**
```bash
swift run port-killer list
```

**Kill a process on a specific port:**
```bash
swift run port-killer kill <port_number>
```

## Development

- **Core Logic**: `Sources/Core`
- **CLI**: `Sources/CLI`
- **App**: `Sources/App`

Pull requests are welcome!
