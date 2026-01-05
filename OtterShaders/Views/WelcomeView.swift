//
//  WelcomeView.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI

struct WelcomeView: View {
    let onEnter: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .colorTheme.opacity(0.5)]),
                           startPoint: .bottom,
                           endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("Otter Shaders")
                    .font(Font.custom("Grandstander-Black", size: 48))
                    .foregroundStyle(.colorTheme)
                
                Text("2D Shader Effects for SwiftUI")
                    .font(Font.custom("Grandstander-Black", size: 24))
                    .foregroundStyle(.colorTheme.opacity(0.8))
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        onEnter()
                    }
                } label: {
                    Text("Get Started")
                        .font(Font.custom("Grandstander-Black", size: 20))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(.colorTheme)
                        .cornerRadius(12)
                }
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    WelcomeView {
        // Preview placeholder
    }
}

