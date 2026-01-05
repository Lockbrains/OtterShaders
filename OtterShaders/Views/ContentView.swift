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
    @State private var showInstructions = false
    
    
    let previewDate = Date()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, .colorTheme.opacity(0.5)]),
                                           startPoint: .bottom,
                                           endPoint: .top)
                                .edgesIgnoringSafeArea(.all)
                                .offset(y: -100)
            
            VStack {
                
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
            }
            
            VStack(spacing: 8.0) {
                if #available(iOS 17.0, *) {
                    ZStack {
                        Image("background")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 400, height: 480)
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
                                .frame(height: 550)
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
            
            // 右上角帮助按钮
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showInstructions = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 24))
                            .foregroundStyle(.colorTheme)
                            .padding()
                    }
                }
                .padding(.trailing)
                .padding(.top, 8)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showInstructions) {
            InstructionsView()
        }
    }
}

struct InstructionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Instructions")
                        .font(Font.custom("Grandstander-Black", size: 32))
                        .foregroundStyle(.colorTheme)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InstructionSection(
                            title: "Shader Effect Types",
                            content: """
                            • Color Effect: Effects that only change colors
                            • Layer Effect: Effects that require background information (blur, outline, etc.)
                            • Distort Effect: Effects that change shape/vertex manipulations
                            """
                        )
                        
                        InstructionSection(
                            title: "How to Browse",
                            content: """
                            • Use the left and right arrow buttons to browse different Shader effects
                            • The top displays the current effect name and type
                            """
                        )
                        
                        InstructionSection(
                            title: "System Requirements",
                            content: """
                            • Requires iOS 17.0 or later
                            • Effects may not display on lower versions
                            """
                        )
                        
                        InstructionSection(
                            title: "Getting the Code",
                            content: """
                            • Shader code is located in the Shaders folder
                            • You can use these Shaders directly in your project
                            • You can also use the generators in the ShaderToView folder
                            """
                        )
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.colorTheme)
                }
            }
        }
    }
}

struct InstructionSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.custom("Grandstander-Black", size: 20))
                .foregroundStyle(.colorTheme)
            
            Text(content)
                .font(Font.custom("Glory-Regular", size: 16))
                .foregroundStyle(.primary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
