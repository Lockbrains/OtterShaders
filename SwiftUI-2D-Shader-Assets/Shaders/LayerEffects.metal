//
//  LayerEffects.metal
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Reference: https://www.cnblogs.com/jerrywossion/p/18090457
[[ stitchable ]] half4 gaussianBlur(float2 position,
                                    SwiftUI::Layer layer) {
    return
    layer.sample(position) * 0.0707355 +
    layer.sample(position + float2(-1, -1)) * 0.0453542 +
    layer.sample(position + float2(0, -1)) * 0.0566406 +
    layer.sample(position + float2(1, -1)) * 0.0453542 +
    layer.sample(position + float2(-1, 0)) * 0.0566406 +
    layer.sample(position + float2(1, 0)) * 0.0566406 +
    layer.sample(position + float2(-1, 1)) * 0.0453542 +
    layer.sample(position + float2(0, 1)) * 0.0566406 +
    layer.sample(position + float2(1, 1)) * 0.0453542;
}


[[ stitchable ]] half4 outlineLayerEffect(float2 position,
                                          SwiftUI::Layer layer,
                                          float2 size,
                                          float outlineWidth,
                                          half4 outlineColor,
                                          texture2d<half, access::sample> outlineTex) {
    constexpr sampler s(address::repeat);
    float2 uv = position / size;
    half4 curColor = layer.sample(position);
    half4 resColor(0.0);
    
    half neighboringASum = 0.0;
    for(float i = 0.0; i < outlineWidth; i += 1.0) {
        neighboringASum += layer.sample(position + float2(i, 0)).a
                         + layer.sample(position + float2(0, i)).a
                         + layer.sample(position - float2(i, 0)).a
                         + layer.sample(position - float2(0, i)).a;
    }
    
    half4 outline = outlineColor * outlineTex.sample(s, uv);
    half4 tmpColor = neighboringASum == 0.0 ? curColor : outline;
    
    resColor = curColor.a == 1.0 ? curColor : tmpColor;
    
    return resColor;
}

[[ stitchable ]] half4 dynamicOutlineLayerEffect(float2 position,
                                          SwiftUI::Layer layer,
                                          float2 size,
                                          float2 direction,
                                          float time,
                                          float outlineWidth,
                                          half4 outlineColor,
                                          texture2d<half, access::sample> outlineTex) {
    constexpr sampler s(address::repeat);
    float2 uv = position / size;
    uv += normalize(direction) * time;
    half4 curColor = layer.sample(position);
    half4 resColor(0.0);
    
    half neighboringASum = 0.0;
    for(float i = 0.0; i < outlineWidth; i += 1.0) {
        neighboringASum += layer.sample(position + float2(i, 0)).a
                         + layer.sample(position + float2(0, i)).a
                         + layer.sample(position - float2(i, 0)).a
                         + layer.sample(position - float2(0, i)).a;
    }
    
    half4 outline = outlineColor * outlineTex.sample(s, uv);
    half4 tmpColor = neighboringASum == 0.0 ? curColor : outline;
    
    resColor = curColor.a == 1.0 ? curColor : tmpColor;
    
    return resColor;
}

[[ stitchable ]] half4 pixellateEffect (float2 position,
                                        SwiftUI::Layer layer,
                                        float strength) {
    float strengthSafeGuard = max(strength, 0.0001);
    float u = strengthSafeGuard * round(position.x / strengthSafeGuard);
    float v = strengthSafeGuard * round(position.y / strengthSafeGuard);
    return layer.sample(float2(u, v));
}
