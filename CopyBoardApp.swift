//
//  CopyBoardApp.swift
//  CopyBoard
//
//  Created by Rayhan Athar on 19/02/25.
//

import SwiftUI

@main
struct CopyBoardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
