//
//  DistortEffectsGenerator.swift
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

import SwiftUI
import Foundation

// MARK: Outline Effect
@available(iOS 17.0, *)
func waveEffect(date: Date,
                speed: Double,
                x: Float,
                y : Float,
                strength : Float,
                frequency: Float) -> Shader {
 
    return ShaderLibrary.waveEffect(
        .float2(x, y),
        .float(abs(date.timeIntervalSinceNow) * speed),
        .float(strength),
        .float(frequency)
    )
}
