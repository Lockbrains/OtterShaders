//
//  SampleShaders.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

let sampleColorEffectShaders: [(String, (Date) -> Shader)] = [
    ("Trivial Gradient", trivialGradient),
    ("Dissolve", sampleDissolveShader),
    ("Outline Internal", sampleOutlineShader),
    ("Glare Effect 1", sampleGlareEffect1),
    ("Star Effect", sampleStarShader),
]

let sampleLayerEffectShaders:  [(String, (Date) -> Shader)] = [
    ("Gaussian Blur", sampleGaussianBlur),
    ("Outline External", sampleOutlineLayerEffect),
    ("Dynamic Outline", sampleDynamicOutlineLayerEffect),
    ("Pixellate", samplePixellateEffect),
]

let sampleDistortEffectShaders:  [(String, (Date) -> Shader)] = [

]

let sampleShaders = sampleColorEffectShaders
                  + sampleLayerEffectShaders
                  + sampleDistortEffectShaders

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

@available(iOS 17.0, *)
func sampleOutlineLayerEffect(_ date: Date) -> Shader {
    return outlineLayerEffect(date: date,
                              x: 314,
                              y: 314,
                              outlineWidth: 4.0,
                              outlineColor: Color.white,
                              outlineTex: "sampleRainbow")
}

@available(iOS 17.0, *)
func sampleDynamicOutlineLayerEffect(_ date: Date) -> Shader {
    return dynamicOutlineLayerEffect(date: date,
                              x: 314,
                              y: 314,
                              speed: 0.2,
                              direction: (1.0, 1.0),
                              outlineWidth: 4.0,
                              outlineColor: Color.white,
                              outlineTex: "sampleRainbow")
}

@available(iOS 17.0, *)
func samplePixellateEffect(_ date: Date) -> Shader {
    return pixellateEffect(date: date,
                           strength: 10.0)
}