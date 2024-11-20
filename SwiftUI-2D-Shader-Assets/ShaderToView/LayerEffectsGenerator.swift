//
//  LayerEffectsGenerator.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

// MARK: OutlineLayerEffect
@available(iOS 17.0, *)
func outlineLayerEffect(date: Date,
                        x: Float,
                        y: Float,
                        outlineWidth: Float,
                        outlineColor: Color,
                        outlineTex: String) -> Shader {
    return ShaderLibrary.outlineLayerEffect(
        .float2(x,y),
        .float(outlineWidth),
        .color(outlineColor),
        .image(Image(outlineTex))
    )
}

// MARK: Dynamic Outline Effect
@available(iOS 17.0, *)
func dynamicOutlineLayerEffect(date: Date,
                        x: Float,
                        y: Float,
                        speed: Double,
                        direction: (Float, Float),
                        outlineWidth: Float,
                        outlineColor: Color,
                        outlineTex: String) -> Shader {
    return ShaderLibrary.dynamicOutlineLayerEffect(
        .float2(x,y),
        .float2(direction.0, direction.1),
        .float(abs(date.timeIntervalSinceNow) * speed),
        .float(outlineWidth),
        .color(outlineColor),
        .image(Image(outlineTex))
    )
}

// MARK: Polar Outline Effect
@available(iOS 17.0, *)
func polarOutlineLayerEffect(date: Date,
                             x: Float,
                             y: Float,
                             speed: Double,
                             direction: (Float, Float),
                             outlineWidth: Float,
                             outlineColor: Color,
                             outlineTex: String) -> Shader {
    return ShaderLibrary.polarOutlineLayerEffect(
        .float2(x,y),
        .float2(direction.0, direction.1),
        .float(abs(date.timeIntervalSinceNow) * speed),
        .float(outlineWidth),
        .color(outlineColor),
        .image(Image(outlineTex))
    )
}

// MARK: Pixellate Effect
@available(iOS 17.0, *)
func pixellateEffect(date: Date,
                     strength: Float) -> Shader {
    return ShaderLibrary.pixellateEffect(
        .float(strength)
    )
}

// MARK: Innerline Effect
@available(iOS 17.0, *)
func innerlineEffect(date: Date,
                     strength: Float,
                     stepX: Float,
                     stepY: Float,
                     edgeOnly: Bool,
                     fillColor: Color,
                     lineColor: Color) -> Shader {
    return ShaderLibrary.innerlineEffect(
        .float(strength),
        .float(stepX),
        .float(stepY),
        .float(edgeOnly ? 1.0 : 0.0),
        .color(fillColor),
        .color(lineColor)
    )
}

// MARK: Bloom Effect
@available(iOS 17.0, *)
func bloomEffect(date: Date,
                 strength: Float,
                 threshold: Float,
                 amount: Float) -> Shader {
    return ShaderLibrary.bloomEffect(
        .float(strength),
        .float(threshold),
        .float(amount)
    )
}
