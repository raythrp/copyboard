import AppKit
import Combine

class ClipboardMonitor: ObservableObject {
    static let shared = ClipboardMonitor()
    
    @Published var clipboardHistory: [String] = []
    private var lastCopiedItem: String?  // Store last copied item
    
    private var timer: Timer?
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        
        guard let copiedText = pasteboard.string(forType: .string) else { return }
        
        // Prevent duplicate entry if it's the same as the last copied item
        if copiedText != lastCopiedItem && !clipboardHistory.contains(copiedText) {
            DispatchQueue.main.async {
                self.clipboardHistory.insert(copiedText, at: 0)
                self.lastCopiedItem = copiedText  // Store this to avoid duplicates
            }
        }
    }
}
