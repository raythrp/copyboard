//
//  VisualEffectBlurView.swift
//  CopyBoard
//
//  Created by Rayhan Athar on 19/02/25.
//

import SwiftUI

struct VisualEffectBlurView: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .sidebar // Change to .hudWindow, .menu, etc., for different styles
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
