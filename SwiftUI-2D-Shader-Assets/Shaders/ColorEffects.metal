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

// MARK: Outline Effects
// I recommend using outlineLayerEffect instead of this
[[ stitchable ]] half4 outlineEffect (float2 position,
                                      half4 currentColor,
                                      float clipThreshold,
                                      float outlineWidth,
                                      float outlineMultiplier,
                                      half4 outlineColor) {
    float stepAlpha = step(clipThreshold, (float)currentColor.a);
    float stepWidth = step(clipThreshold - outlineWidth, (float)currentColor.a);
    
    float stepDiff = stepWidth - stepAlpha;
    
    half4 colorMultiplied = stepDiff * outlineColor + currentColor;
    half4 res(0.0);
    res.rgb = colorMultiplied.rgb;
    res.a = stepWidth;
    
    return res;
}

// MARK: Star Effect
// Credit to https://www.shadertoy.com/view/XcVcRh
// the rotation matrix
float2x2 rot(float a) {
    float sinA = sin(a);
    float cosA = cos(a);
    return float2x2(cosA, -sinA, sinA, cosA);
}

float hash21(float2 p) {
    p = fract(p * float2(424.34, 342.21));
    p += dot(p, p + 34.32);
    return fract(p.x * p.y);
}

float star(float2 uv, float flare) {
    float d = length(uv);
    float m = 0.05/d;
    float rays = max(0.0, 1.0 - abs(uv.x * uv.y * 1000.0));
    m += rays * flare;
    uv *= rot(M_PI_F / 4.0);
    
    rays = max(0.0, 1.0 - abs(uv.x * uv.y * 1000.0));
    m += rays * 0.3 * flare;
    m *= smoothstep(1.0, 0.2, d);
    
    return m;
}

half3 starLayer(float2 uv, float time, half3 starColor) {
    half3 col(0.0);
    float2 gridUV = fract(uv) - 0.5;
    float2 id = floor(uv);
    
    for(int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 offs = float2(x,y);
            
            // pseudorandom fract
            float n = hash21(id + offs);
            float size = fract(n * 345.32);
            
            float curStar = star(gridUV - offs - float2(n, fract(n * 34.0)) + 0.5,
                                 smoothstep(0.85, 1.0, size));
            
            half3 color = sin(starColor * fract(n * 3245.23) * 11.33) * 0.5 + 0.5;
            
            color *= half3(1.0, 0.5, 1.0 + size);
            curStar *= sin(time * 3.0 + n * 6.2831) * 0.5 + 1.0;
            col += curStar * size * color;
        }
    }
    
    return col;
}


[[ stitchable ]] half4 starEffect (float2 position,
                                     half4 currentColor,
                                     float2 size,
                                     float time,
                                     float layers,
                                     float intensity,
                                     half4 starColor) {
    float2 uv = position / size;
    float t = time * 0.02;
    
    uv *= rot(t);
    
    half3 col = half3(0.0);
    
    for(float i = 0.0; i < 1.0; i+= 1.0 / layers) {
        float depth = fract(i + t);
        float scale = mix(20.0, 0.5, depth);
        float fade = depth * smoothstep(1.0, 0.9, depth);
        col += starLayer(uv * scale + i * 454.23, time, starColor.rgb) * fade;
    }
    
//    return half4(col,1);
    half4 finalColor = currentColor;
    finalColor += intensity * half4(col, 0);
    return finalColor * currentColor.a;
}


// MARK: Glare Effect 1
// Created by Silexars on ShaderToy, https://www.shadertoy.com/view/XsXXDn
// Credit to Danilo Guanabara
[[ stitchable ]] half4 glareEffect1 (float2 position,
                                     half4 currentColor,
                                     float2 size,
                                     float time) {
    float3 c(0.0);
    float l, z = time;
    for (int i = 0; i < 3; i++) {
        float2 uv, p = position / size;
        uv = p;
        p -= 0.5;
        p.x *= size.x / size.y;
        z += 0.07;
        l = length(p);
        uv += p / l * (sin(z) + 1.0) * abs(sin(l * 9.0 - z - z));
        c[i] = 0.01 / length(abs(fmod(uv, 1.0)) - 0.5);
    }
    
    half4 finalColor = currentColor;
    finalColor += half4((c/l).r, (c/l).g, (c/l).b, time);
    finalColor *= currentColor.a;
    return finalColor;
}

// MARK: Multiply Effect
[[ stitchable ]] half4 multiplyEffect (float2 position,
                                       half4 currentColor,
                                       float2 size,
                                       float2 tile,
                                       float2 offset,
                                       float2 direction,
                                       float time,
                                       texture2d<half, access::sample> texture) {
    half4 finalColor = currentColor;
    float2 uv = position / size;
    constexpr sampler s(address::repeat);
    
    finalColor *= texture.sample(s, uv * tile + offset + normalize(direction) * time);
    finalColor *= currentColor.a;
    
    return finalColor;
    
}

float remap(float input, float oldMin, float oldMax, float newMin, float newMax) {
    float percentage = (input - oldMin) / (oldMax - oldMin);
    return newMin + percentage * (newMax - newMin);
}

// MARK: Scanlight Effect (3 Scanlines)
[[stitchable]] half4 scanlightEffect (float2 position,
                                      half4 currentColor,
                                      float2 size,
                                      float time,
                                      float _ShineRotate,
                                      float _ShineStartLocation1,
                                      float _ShineStartLocation2,
                                      float _ShineStartLocation3,
                                      float _ShineWidth1,
                                      float _ShineWidth2,
                                      float _ShineWidth3,
                                      float _ShineGlow,
                                      float _top,
                                      float _bottom,
                                      float _opacity,
                                      half4 _ShineColor1,
                                      half4 _ShineColor2,
                                      half4 _ShineColor3) {
    // constexpr sampler s(address::clamp_to_edge);
    float2 uv = position / size;
    
    // Shine rotation matrix
    float cosAngle = cos(_ShineRotate);
    float sinAngle = sin(_ShineRotate);
    float2x2 rot = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

    // Transform uv to apply shine effect
    float2 uvShine = uv - float2(0.5, 0.5);
    uvShine = rot * uvShine; // Apply rotation
    uvShine += float2(0.5, 0.5);

    float _ShineLocation1 = _ShineStartLocation1;
    float _ShineLocation2 = _ShineStartLocation2;
    float _ShineLocation3 = _ShineStartLocation3;
    _ShineLocation1 = fract(_ShineLocation1 + time);
    _ShineLocation1 = remap(_ShineLocation1, 0, 1, _top, _bottom);
    _ShineLocation2 = fract(_ShineLocation2 + time);
    _ShineLocation2 = remap(_ShineLocation2, 0, 1, _top, _bottom);
    _ShineLocation3 = fract(_ShineLocation3 + time);
    _ShineLocation3 = remap(_ShineLocation3, 0, 1, _top, _bottom);
    
    // Sample the alpha channel from _ShineMask texture
    float shineMask = 1.0;

    // Calculate distance projection
    float currentDistanceProjection = (uvShine.x + uvShine.y) / 2.0;
    float whitePower1 = 1.0 - (abs(currentDistanceProjection - _ShineLocation1) / _ShineWidth1);
    float whitePower2 = 1.0 - (abs(currentDistanceProjection - _ShineLocation2) / _ShineWidth2);
    float whitePower3 = 1.0 - (abs(currentDistanceProjection - _ShineLocation3) / _ShineWidth3);


    // Calculate shine effect
    float shineEffect1 = max(sign(currentDistanceProjection - (_ShineLocation1 - _ShineWidth1)), 0.0) *
                        max(sign((_ShineLocation1 + _ShineWidth1) - currentDistanceProjection), 0.0);
    float shineEffect2 = max(sign(currentDistanceProjection - (_ShineLocation2 - _ShineWidth2)), 0.0) *
                        max(sign((_ShineLocation2 + _ShineWidth2) - currentDistanceProjection), 0.0);
    float shineEffect3 = max(sign(currentDistanceProjection - (_ShineLocation3 - _ShineWidth3)), 0.0) *
                        max(sign((_ShineLocation3 + _ShineWidth3) - currentDistanceProjection), 0.0);

    // Apply shine to the base color
    half4 finalColor = currentColor;
    half3 shineColor1 = half3(_ShineColor1.r, _ShineColor1.g, _ShineColor1.b);
    half3 shineColor2 = half3(_ShineColor2.r, _ShineColor2.g, _ShineColor2.b);
    half3 shineColor3 = half3(_ShineColor3.r, _ShineColor3.g, _ShineColor3.b);
    finalColor.rgb += currentColor.a * whitePower1 * _ShineGlow * shineEffect1 * shineColor1 * shineMask * _opacity;
    finalColor.rgb += currentColor.a * whitePower2 * _ShineGlow * shineEffect2 * shineColor2 * shineMask * _opacity;
    finalColor.rgb += currentColor.a * whitePower3 * _ShineGlow * shineEffect3 * shineColor3 * shineMask * _opacity;
                    
    
    half4 res = max(currentColor, finalColor);
    res *= currentColor.a;
    return res;
}

[[stitchable]] half4 scanlightTexturedEffect (float2 position,
                                              half4 currentColor,
                                              float2 size,
                                              float time,
                                              float _ShineRotate,
                                              float _ShineStartLocation1,
                                              float _ShineStartLocation2,
                                              float _ShineStartLocation3,
                                              float _ShineWidth1,
                                              float _ShineWidth2,
                                              float _ShineWidth3,
                                              float _ShineGlow,
                                              float _top,
                                              float _bottom,
                                              float opacity,
                                              texture2d<half, access::sample> texture) {
    constexpr sampler s(address::repeat);
    float2 uv = position / size;
    
    // Shine rotation matrix
    float cosAngle = cos(_ShineRotate);
    float sinAngle = sin(_ShineRotate);
    float2x2 rot = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

    // Transform uv to apply shine effect
    float2 uvShine = uv - float2(0.5, 0.5);
    uvShine = rot * uvShine; // Apply rotation
    uvShine += float2(0.5, 0.5);

    float _ShineLocation1 = _ShineStartLocation1;
    float _ShineLocation2 = _ShineStartLocation2;
    float _ShineLocation3 = _ShineStartLocation3;
    _ShineLocation1 = fract(_ShineLocation1 + time);
    _ShineLocation1 = remap(_ShineLocation1, 0, 1, _top, _bottom);
    _ShineLocation2 = fract(_ShineLocation2 + time);
    _ShineLocation2 = remap(_ShineLocation2, 0, 1, _top, _bottom);
    _ShineLocation3 = fract(_ShineLocation3 + time);
    _ShineLocation3 = remap(_ShineLocation3, 0, 1, _top, _bottom);
    
    // Sample the alpha channel from _ShineMask texture
    float shineMask = 1.0;

    // Calculate distance projection
    float currentDistanceProjection = (uvShine.x + uvShine.y) / 2.0;
    float whitePower1 = 1.0 - (abs(currentDistanceProjection - _ShineLocation1) / _ShineWidth1);
    float whitePower2 = 1.0 - (abs(currentDistanceProjection - _ShineLocation2) / _ShineWidth2);
    float whitePower3 = 1.0 - (abs(currentDistanceProjection - _ShineLocation3) / _ShineWidth3);


    // Calculate shine effect
    float shineEffect1 = max(sign(currentDistanceProjection - (_ShineLocation1 - _ShineWidth1)), 0.0) *
                        max(sign((_ShineLocation1 + _ShineWidth1) - currentDistanceProjection), 0.0);
    float shineEffect2 = max(sign(currentDistanceProjection - (_ShineLocation2 - _ShineWidth2)), 0.0) *
                        max(sign((_ShineLocation2 + _ShineWidth2) - currentDistanceProjection), 0.0);
    float shineEffect3 = max(sign(currentDistanceProjection - (_ShineLocation3 - _ShineWidth3)), 0.0) *
                        max(sign((_ShineLocation3 + _ShineWidth3) - currentDistanceProjection), 0.0);

    // Apply shine to the base color
    half4 finalColor = currentColor;
    half4 shineColor = half4(texture.sample(s, uv));

    finalColor.rgb += currentColor.a * whitePower1 * _ShineGlow * shineEffect1 * shineColor.rgb * shineMask * opacity;
    finalColor.rgb += currentColor.a * whitePower2 * _ShineGlow * shineEffect2 * shineColor.rgb * shineMask * opacity;
    finalColor.rgb += currentColor.a * whitePower3 * _ShineGlow * shineEffect3 * shineColor.rgb * shineMask * opacity;
                    
    
    half4 res = max(currentColor, finalColor);
    res *= currentColor.a;
    return res;
}
