//
//  SwiftUI_2D_Shader_AssetsApp.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI

@main
struct SwiftUI_2D_Shader_AssetsApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var showWelcome = true
    
    var body: some View {
        if showWelcome {
            WelcomeView {
                showWelcome = false
            }
        } else {
            ContentView()
        }
    }
}
