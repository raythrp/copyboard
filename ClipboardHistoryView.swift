//
//  ClipboardHistoryView.swift
//  CopyBoard
//
//  Created by Rayhan Athar on 19/02/25.
//

import SwiftUI

struct ClipboardHistoryView: View {
    @ObservedObject var monitor = ClipboardMonitor.shared
    @State private var hoveredButton: String? = nil  // Track hovered button
    
    var body: some View {
        ZStack {
            VisualEffectBlurView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                List {
                    ForEach(monitor.clipboardHistory.reversed(), id: \.self) { item in
                        VStack(alignment: .leading) {
                            Text(item)
                                .foregroundColor(.white)
                            
                            HStack {
                                Spacer()
                                Button("Paste") {
                                    pasteToActiveApp(item)
                                }
                                .buttonStyle(BorderedButtonStyle())
                                .foregroundColor(hoveredButton == item ? .blue : .white)
                                .onHover { hovering in
                                    hoveredButton = hovering ? item : nil
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1)) // Slightly brighter background
                        .cornerRadius(10) // Rounded corners
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1) // Subtle border
                        )
                        .listRowSeparator(.hidden) // Hide default List separator
                        .padding(.vertical, 4) // Add spacing between items
                    }
                }
                .frame(width: 350, height: 450)
                .background(Color.clear) // Won't work alone
                .scrollContentBackground(.hidden) // ✅ Hides background on macOS 13+
                
                
                HStack {
                    Spacer()
                    Button("Clear History") {
                        monitor.clipboardHistory.removeAll()
                    }
                    .padding()
                    .foregroundColor(hoveredButton == "clear" ? .blue : .white) // Hover effect
                    .onHover { hovering in
                        hoveredButton = hovering ? "clear" : nil
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .background(Color.clear) // Ensures transparency
    }
    
    private func pasteToActiveApp(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        
        // Simulates Command + V for pasting text
        let source = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: source!, virtualKey: 0x09, keyDown: true) // V is 0x09
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        
        keyDown?.flags = .maskCommand
        keyUp?.flags = .maskCommand
        
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }
}

#Preview {
    ClipboardHistoryView()
}
