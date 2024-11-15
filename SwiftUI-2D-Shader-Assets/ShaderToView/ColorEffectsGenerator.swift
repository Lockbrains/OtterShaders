//
//  ColorEffectsGenerator.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

let startDate = Date()
extension Color {
    func toRGB() -> (r: Float, g: Float, b: Float, a: Float) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (Float(red), Float(green), Float(blue), Float(alpha))
    }
}

// MARK: DissolveEffect
@available(iOS 17.0, *)
func dissolveEffect(date: Date,
                    speed: Double,
                    x: CGFloat,
                    y: CGFloat,
                    fadeBurnWidth: Float,
                    fadeBurnTransition: Float,
                    fadeBurnGrow: Float,
                    fadeBurnColor: Color,
                    fadeTex: String) -> Shader {
    let fadeTexture = Image(fadeTex)
    
    return ShaderLibrary.dissolveEffect(
        .float2(x, y),
        .float(abs(date.timeIntervalSinceNow) * speed),
        .float(fadeBurnWidth),
        .float(fadeBurnTransition),
        .float(fadeBurnGrow),
        .color(fadeBurnColor),
        .image(fadeTexture)
    )
}

// MARK: Outline Effect
@available(iOS 17.0, *)
func outlineEffect(date: Date,
                   clipThreshold: Float,
                   outlineWidth : Float,
                   outlineMultiplier : Float,
                   outlineColor: Color) -> Shader {
 
    return ShaderLibrary.outlineEffect(
        .float(clipThreshold),
        .float(outlineWidth),
        .float(outlineMultiplier),
        .color(outlineColor)
    )
}

// MARK: Star Effect
@available(iOS 17.0, *)
func starEffect(date: Date,
                speed: Double,
                x: CGFloat,
                y: CGFloat,
                layers: Float,
                intensity: Float,
                starColor: Color) -> Shader {
    return ShaderLibrary.starEffect(
        .float2(x, y),
        .float(abs(date.timeIntervalSinceNow) * speed),
        .float(layers),
        .float(intensity),
        .color(starColor)
    )
}


// MARK: Glare Effect 1
@available(iOS 17.0, *)
func glareEffect1 (date: Date,
                   speed: Double,
                   x: CGFloat,
                   y: CGFloat) -> Shader {
    return ShaderLibrary.glareEffect1(
        .float2(x,y),
        .float(abs(date.timeIntervalSinceNow) * speed)
    )
}
