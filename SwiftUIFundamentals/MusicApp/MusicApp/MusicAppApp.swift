//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Adam Ahrens on 4/4/22.
//

import SwiftUI

@main
struct MusicAppApp: App {
  let repository = MusicRepository()
  
  var body: some Scene {
    WindowGroup {
        MusicView()
        .environmentObject(repository)
    }
  }
}
