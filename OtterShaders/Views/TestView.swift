//
//  TestView.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/18/24.
//

//
//  ContentView.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI

struct TestView: View {
    @State private var currentShader: String = sampleShaders[0].0
    @State private var currentIndex: Int = 0
    
    
    let previewDate = Date()
    
    var body: some View {

        if #available(iOS 17.0, *) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .gray.opacity(0.8)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                TimelineView(.animation) { context in
                    ZStack {
                        Image("sampleCard")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 224,
                                   height: 314)
                            .colorEffect(
                                sampleScanlightTexturedEffect(previewDate)
                            )
                            .layerEffect(
                                gaussianBlurEffect(date: previewDate,
                                                   x: 224, y: 314,
                                                   intensity: 2.0,
                                                   blurSize: 5),
                                maxSampleOffset: .init(width: 10, height: 10)
                            )
                            .layerEffect(
                                sampleBloomEffect(previewDate),
                                maxSampleOffset: .init(width: 30, height: 30)
                            )
                        Image("sampleCard")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 224,
                                   height: 314)
                    }
                }
            }
            
        } else {
            Text("This feature is not available on this platform.")
        }
    }
}

#Preview {
    TestView()
}
