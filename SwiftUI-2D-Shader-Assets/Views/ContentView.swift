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
            
            Text(currentShader)
                .font(.title)
                .bold()
            
            if currentIndex < sampleColorEffectShaders.count {
                Text("Color Effect")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            } else  if currentIndex < sampleColorEffectShaders.count + sampleLayerEffectShaders.count {
                Text("Layer Effect")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            } else {
                Text("Distort Effect")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        
        if #available(iOS 17.0, *) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .gray.opacity(0.8)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                TimelineView(.animation) { context in
                    if currentIndex < sampleColorEffectShaders.count {
                        Image("sampleCard")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 224,
                                   height: 314)
                            .colorEffect(
                                sampleShaders[currentIndex].1(previewDate)
                            )
                    } else if currentIndex < sampleColorEffectShaders.count + sampleLayerEffectShaders.count {
                        Image("sampleCard")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 224,
                                   height: 314)
                            .layerEffect(
                                sampleShaders[currentIndex].1(previewDate),
                                maxSampleOffset: .init(width: 10, height: 10)
                            )
                    } else {
                        
                    }
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
