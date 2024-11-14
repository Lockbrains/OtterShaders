//
//  ContentView.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    let previewDate = Date()
    
    var body: some View {
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
                    //                        .colorEffect(ShineEffect(date: previewDate))
                }
            }
            
        } else {
            Text("This feature is not available on this platform.")
        }
        
        Text("Shader Assets")
            .font(.largeTitle)
            .bold()
    }
}

#Preview {
    ContentView()
}
