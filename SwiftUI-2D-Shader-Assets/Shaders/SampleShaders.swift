//
//  SampleShaders.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

let sampleShaders: [(String, (Date) -> Shader)] = [
    ("Dissolve", sampleDissolveShader),
]


// MARK: Color Effects
@available(iOS 17.0, *)
func sampleDissolveShader(_ date: Date) -> Shader {
    return dissolveEffect(date: date,
                          speed: 3.0,
                          x: 300,
                          y: 300,
                          fadeBurnWidth: 25,
                          fadeBurnTransition: 0.2,
                          fadeBurnGrow: 12.0,
                          fadeBurnColor: Color.red,
                          fadeTex: "sampleNoise")
}
