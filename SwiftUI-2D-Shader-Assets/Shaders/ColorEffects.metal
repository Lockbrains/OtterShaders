//
//  ColorEffects.metal
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

/// Simply note that from Apple Developer documentation, for a shader function to act as a fill pattern,
/// it must have a function signature matching:
/// `[[ stitchable ]] half4 shaderName (float2 position, args...) `
/// where `position` is the user-space coordinates of the pixel applied to the shader,
/// and `args...` should be compatible with uniform arguments bound to shader.

// MARK: Dissolve Effects
[[ stitchable ]] half4 dissolveEffect (float2 position,
                                       half4 currentColor,
                                       float2 size,
                                       float time,
                                       float fadeBurnWidth,
                                       float fadeBurnTransition,
                                       float fadeBurnGlow,
                                       half4 fadeBurnColor,
                                       texture2d<half, access::sample> fadeTex){
    constexpr sampler s(address::repeat);
    
    float fadeAmount = fmod(time * 0.1, 1.0);

    float2 uv = position / size;

    // sample the texture using the current position
    float fadeTemp = fadeTex.sample(s, uv).r;
    float fade = smoothstep(fadeAmount, fadeAmount + fadeBurnTransition, fadeTemp);

    half4 finalColor = currentColor;
    finalColor.a *= fade;
    
    fadeBurnColor.rgb *= fadeBurnGlow;
    finalColor += fade * fadeBurnColor * currentColor.a * (1.0 - finalColor.a);
    
    finalColor.rgb *= finalColor.a;

    return finalColor;
}
