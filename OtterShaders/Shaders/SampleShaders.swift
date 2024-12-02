//
//  SampleShaders.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

let sampleColorEffectShaders: [(String, (Date) -> Shader)] = [
    ("Scanlight Effect", sampleScanlightTexturedEffect),
   // ("Trivial Gradient", trivialGradient),
    ("Dissolve", sampleDissolveShader),
    ("Outline Internal", sampleOutlineShader),
    ("Glare Effect", sampleGlareEffect1),
    ("Star Effect", sampleStarShader),
    ("Dynamic Multiply", sampleMultiplyEffect),
    
]

let sampleLayerEffectShaders:  [(String, (Date) -> Shader)] = [
    ("Gaussian Blur", sampleGaussianBlur),
    ("Outline External", sampleOutlineLayerEffect),
    ("Dynamic Outline", sampleDynamicOutlineLayerEffect),
    ("Polar Outline", samplePolarOutlineLayerEffect),
    ("Pixellate", samplePixellateEffect),
    ("Innerline", sampleInnerEffect),
    ("Bloom", sampleBloomEffect),
]

let sampleDistortEffectShaders:  [(String, (Date) -> Shader)] = [
    ("Wave Effect", sampleWaveEffect)
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
                         outlineWidth : 0.99999,
                         outlineMultiplier : 10.0,
                         outlineColor: Color.black)
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

@available(iOS 17.0, *)
func sampleMultiplyEffect(_ date: Date) -> Shader {
    return multiplyEffect(date: date,
                          speed: 1.0,
                          x: 314,
                          y: 314,
                          tile: (1, 1),
                          offset: (0, 0),
                          direction: (1, 1),
                          texture: "sampleRazor")
}

@available(iOS 17.0, *)
func sampleScanlightTexturedEffect(_ date: Date) -> Shader {
    return scanlightTexturedEffect(date: date,
                                   speed: 0.2,
                                   x: 314,
                                   y: 314,
                                   rotate: 0.4,
                                   startLocation1: 1.0,
                                   startLocation2: 0.8,
                                   startLocation3: 0.9,
                                   scanWidth1: 0.1,
                                   scanWidth2: 0.02,
                                   scanWidth3: 0.02,
                                   scanIntensity: 2.0,
                                   top: -1.0,
                                   bottom: 1.0,
                                   opacity: 0.4,
                                   texture: "sampleRazor2")
}



// MARK: Layer Effects
@available(iOS 17.0, *)
func sampleGaussianBlur(_ date: Date) -> Shader {
    return gaussianBlurEffect(date: date,
                              x: 314,
                              y: 314,
                              intensity: 2.0,
                              blurSize: 15.0)
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
                              outlineTex: "sampleRazor")
}

@available(iOS 17.0, *)
func samplePolarOutlineLayerEffect(_ date: Date) -> Shader {
    return polarOutlineLayerEffect(date: date,
                                   x: 314,
                                   y: 314,
                                   speed: 1.0,
                                   direction: (1.0, 1.0),
                                   outlineWidth: 6.0,
                                   outlineColor: Color.white,
                                   outlineTex: "sampleOutline2")
}

@available(iOS 17.0, *)
func samplePixellateEffect(_ date: Date) -> Shader {
    return pixellateEffect(date: date,
                           strength: 10.0)
}

@available(iOS 17.0, *)
func sampleInnerEffect (_ date: Date) -> Shader {
    return innerlineEffect(date: date,
                           strength: 5.0,
                           stepX: 1.0,
                           stepY: 1.0,
                           edgeOnly: true,
                           fillColor: Color.white,
                           lineColor: Color.red)
}

@available(iOS 17.0, *)
func sampleBloomEffect (_ date: Date) -> Shader {
    return bloomEffect(date: date,
                       strength: 15.0,
                       threshold: 0.5,
                       amount: 0.5)
}


// MARK: Distort Effects
@available(iOS 17.0, *)
func sampleWaveEffect (_ date: Date) -> Shader {
    return waveEffect(date: date,
                      speed: 1.0,
                      x: 314,
                      y: 314,
                      strength: 3.0,
                      frequency: 3)
}
