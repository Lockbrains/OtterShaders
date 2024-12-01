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
        ZStack {
            VStack {
                Image("background")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.2)
                
                Spacer()
                HStack(alignment: .bottom) {
                    Button {
                        currentIndex = max(currentIndex - 1, 0)
                        currentShader = sampleShaders[currentIndex].0
                    } label: {
                        Image("prev")
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8.0) {
                        Text(currentShader)
                            .font(Font.custom("Grandstander-Black", size: 24))
                            .foregroundStyle(.colorTheme)
                            .bold()
                        
                        if currentIndex < sampleColorEffectShaders.count {
                            Text("Color Effect")
                                .font(Font.custom("Glory-Medium", size: 16))
                                .foregroundStyle(.secondary)
                        } else  if currentIndex < sampleColorEffectShaders.count + sampleLayerEffectShaders.count {
                            Text("Layer Effect")
                                .font(Font.custom("Glory-Medium", size: 16))
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Distort Effect")
                                .font(Font.custom("Glory-Medium", size: 16))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    
                    Spacer()
                    Button {
                        currentIndex = min(currentIndex + 1, sampleShaders.count - 1)
                        currentShader = sampleShaders[currentIndex].0
                    } label: {
                        Image("next")
                    }
                }
                .padding()
                .background(.white)
                Spacer()
                    .frame(height: 70)
            }
            
            VStack(spacing: 8.0) {
                if #available(iOS 17.0, *) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Material.thinMaterial)
                            .frame(width: 300, height: 450)
                            .shadow(radius: 4.0)
                        
                        TimelineView(.animation) { context in
                            if currentIndex < sampleColorEffectShaders.count {
                                Image("example")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 224,
                                           height: 314)
                                    .colorEffect(
                                        sampleShaders[currentIndex].1(previewDate)
                                    )
                            } else if currentIndex < sampleColorEffectShaders.count + sampleLayerEffectShaders.count {
                                Image("example")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 224,
                                           height: 314)
                                    .layerEffect(
                                        sampleShaders[currentIndex].1(previewDate),
                                        maxSampleOffset: .init(width: 10, height: 10)
                                    )
                            } else {
                                Image("example")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 224,
                                           height: 314)
                                    .distortionEffect(
                                        sampleShaders[currentIndex].1(previewDate),
                                        maxSampleOffset: .init(width: 10, height: 10)
                                    )
                            }
                        }
                        
                        VStack {
                            Spacer()
                                .frame(height: 200)
                            Image("exampleLabel")
                                .shadow(radius: 2.0, x:0, y: 2)
                            
                            Spacer()
                            
                        }
                        .padding()
                    }
                    
                } else {
                    Text("This feature is not available on this platform.")
                }
                
                
                
                
            }
        }
        
        
        
        
    }
}

#Preview {
    ContentView()
}
