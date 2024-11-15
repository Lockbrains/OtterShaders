//
//  SampleShaders.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

let sampleShaders: [(String, (Date) -> Shader)] = [
    ("Trivial Gradient", trivialGradient),
    ("Dissolve", sampleDissolveShader),
    ("Outline", sampleOutlineShader),
    ("Glare Effect 1", sampleGlareEffect1),
    ("Star Effect", sampleStarShader),
]

// MARK: Verifications
@available(iOS 17.0, *)
func trivialGradient(_ date: Date) -> Shader {
    return ShaderLibrary.trivialGradient(
        .float2(224, 314)
    )
}

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

@available(iOS 17.0, *)
func sampleOutlineShader(_ date: Date) -> Shader {
    return outlineEffect(date: date,
                         clipThreshold: 1.0,
                         outlineWidth : 0.9999,
                         outlineMultiplier : 2.0,
                         outlineColor: Color.white)
}

@available(iOS 17.0, *)
func sampleStarShader(_ date: Date) -> Shader {
    return starEffect(date: date,
                      speed: 1.0,
                      x: 314,
                      y: 314,
                      layers: 8,
                      intensity: 0.2,
                      starColor: Color.green)
}

@available(iOS 17.0, *)
func sampleGlareEffect1(_ date: Date) -> Shader {
    return glareEffect1(date: date,
                        speed: 1.0,
                        x: 224,
                        y: 314)
}


// MARK: Layer Effects
@available(iOS 17.0, *)
func sampleGaussianBlur(_ date: Date) -> Shader {
    return ShaderLibrary.gaussianBlur()
}

