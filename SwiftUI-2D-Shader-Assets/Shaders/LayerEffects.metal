//
//  LayerEffects.metal
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

#include "Common.metal"


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

[[ stitchable ]] half4 polarOutlineLayerEffect(float2 position,
                                               SwiftUI::Layer layer,
                                               float2 size,
                                               float2 direction,
                                               float time,
                                               float outlineWidth,
                                               half4 outlineColor,
                                               texture2d<half, access::sample> outlineTex) {
    constexpr sampler s(address::repeat);
    float2 uv = polarCoordinates(position, size, float2(0.5, 0.5));
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

float intensity(half4 color) {
    return sqrt((color.x * color.x)
              + (color.y * color.y)
              + (color.z * color.z));
}

// Sobel Operation, see:
// http://en.wikipedia.org/wiki/Sobel_operator
[[ stitchable ]] half4 innerlineEffect (float2 position,
                                        SwiftUI::Layer layer,
                                        float strength,
                                        float stepX,
                                        float stepY,
                                        float edgeOnly,
                                        half4 fillColor,
                                        half4 lineColor) {
    float topLeft     = intensity(layer.sample(position + float2(-stepX, stepY  )));
    float left        = intensity(layer.sample(position + float2(-stepX, 0      )));
    float bottomLeft  = intensity(layer.sample(position + float2(-stepX, -stepY )));
    float top         = intensity(layer.sample(position + float2(0,      stepY  )));
    float bottom      = intensity(layer.sample(position + float2(0,      -stepY )));
    float topRight    = intensity(layer.sample(position + float2(stepX,  stepY  )));
    float right       = intensity(layer.sample(position + float2(stepX,  0      )));
    float bottomRight = intensity(layer.sample(position + float2(stepX,  -stepY )));
    
    float x =  topLeft + 2.0 * left + bottomLeft - topRight - 2.0 * right - bottomRight;
    float y = -topLeft - 2.0 * top - topRight + bottomLeft + 2.0 * bottom + bottomRight;
    float inner = sqrt((x * x) + (y * y));
    half4 finalColor = layer.sample(position);
    float originalA = finalColor.a;
    finalColor = mix(edgeOnly == 1.0 ? fillColor : finalColor, lineColor, inner);
    
    return finalColor * originalA;
}

[[ stitchable ]] half4 bloomEffect (float2 position,
                                    SwiftUI::Layer layer,
                                    float strength,
                                    float threshold,
                                    float amount) {
    
    half4 result = half4(0.0);
    half4 color = half4(0.0);
    half4 original = layer.sample(position);
    float count = 0.0;
    
    for(float i = -strength; i < strength; i += 1.0) {
        for (float j = -strength; j < strength; j += 1.0 ) {
            color = layer.sample(position + float2(i, j));
            
            float value = max(color.r, max(color.g, color.b));
            if (value < threshold) {
                color = half4(0.0);
            }
            
            result += color;
            count += 1.0;
        }
    }
    
    result /= count;
    
    return original + mix(half4(0.0), result, amount);
}
