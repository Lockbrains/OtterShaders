//
//  ContentView.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentShader: String = sampleShaders[0].0
    @State private var currentIndex: Int = 0
    
    
    let previewDate = Date()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    currentIndex = max(currentIndex - 1, 0)
                    currentShader = sampleShaders[currentIndex].0
                } label: {
                    Text("Prev")
                }
                
                Spacer()
                Button {
                    currentIndex = min(currentIndex + 1, sampleShaders.count - 1)
                    currentShader = sampleShaders[currentIndex].0
                } label: {
                    Text("Next")
                }
            }
            .padding()
            Text("Shader Assets")
                .font(.largeTitle)
                .bold()
            Text(currentShader)
                .font(.title)
                .foregroundStyle(.secondary)
        }
        
        if #available(iOS 17.0, *) {
            ZStack {
                Color(Color.gray)
                    .edgesIgnoringSafeArea(.all)
                
                TimelineView(.animation) { context in
                    Image("example")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 224,
                               height: 314)
                        .colorEffect(
                            sampleShaders[currentIndex].1(previewDate)
                        )
                        .layerEffect(sampleGaussianBlur(previewDate),
                                     maxSampleOffset: .init(width: 3, height: 3))
                }
            }
            
        } else {
            Text("This feature is not available on this platform.")
        }
    }
}

#Preview {
    ContentView()
}
