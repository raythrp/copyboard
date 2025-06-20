import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        
        // Monitor global mouse events
//        NSEvent.addGlobalMonitorForEvents(matching: .rightMouseUp) { [weak self] event in
//            self?.showMenu()
//        }
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "clipboard", accessibilityDescription: "Clipboard History")
            button.target = self
            button.action = #selector(leftClickHandler) // Handles left-click
            button.sendAction(on: [.leftMouseUp]) // Capture only left click
        }
        
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: ClipboardHistoryView())
        popover.behavior = .transient
    }
    
    @objc func leftClickHandler(_ sender: Any?) {
        togglePopover(sender)
    }

    func showMenu() {
//        guard let button = statusItem.button else { return }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem.menu = menu
        statusItem.button?.performClick(nil) // Simulate a menu click
        
        // Reset menu after showing to avoid interference with left click
        DispatchQueue.main.async {
            self.statusItem.menu = nil
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            let buttonFrame = button.window?.frame ?? .zero
            let screenFrame = NSScreen.main?.visibleFrame ?? .zero
            let popoverWidth = popover.contentSize.width
            let popoverHeight = popover.contentSize.height

            // Default position
            var popoverX = buttonFrame.midX - (popoverWidth / 2) - 13
            var popoverY = buttonFrame.minY - popoverHeight - 215

            // Ensure the popover does not go off-screen horizontally
            if popoverX < screenFrame.minX {
                popoverX = screenFrame.minX + 10
            }
            if popoverX + popoverWidth > screenFrame.maxX {
                popoverX = screenFrame.maxX - popoverWidth - 10
            }

            // Ensure the popover does not go off-screen vertically
            if popoverY < screenFrame.minY {
                popoverY = buttonFrame.maxY // Show below instead
            }

            // Show popover
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.setFrameOrigin(NSPoint(x: popoverX, y: popoverY))
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        statusItem.menu = menu // Ensure right-click works
    }
    
    func menuDidClose(_ menu: NSMenu) {
        statusItem.menu = nil // Reset menu to allow left-click popover
    }
}
