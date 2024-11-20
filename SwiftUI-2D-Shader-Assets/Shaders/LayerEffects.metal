//
//  LayerEffects.metal
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

#include "Common.metal"

// MARK: Gaussian Blur
[[ stitchable ]] half4 gaussianBlurEffect(float2 position,
                                          SwiftUI::Layer layer,
                                          float2 size,
                                          float intensity,
                                          float blurSize) {
        half4 blurredColor = half4(0.0);
        
        // Calculate weights for the Gaussian kernel
        int radiusInt = int(blurSize);
        float sigma = blurSize * 0.5;
        float sigma2 = 2.0 * sigma * sigma;
        float normalization = 1.0 / (sqrt(2.0 * M_PI_F) * sigma);

        float totalWeight = 0.0;

        // Accumulate weights and color values
        for (int x = -radiusInt; x <= radiusInt; x++) {
            for (int y = -radiusInt; y <= radiusInt; y++) {
                float2 offset = float2(x, y);
                float weight = normalization * exp(-(x * x + y * y) / sigma2);
                totalWeight += weight;

                half4 sampleColor = layer.sample(position + offset);
                blurredColor += sampleColor * half(weight);
            }
        }

        // Normalize the accumulated color by the total weight
        blurredColor /= half(totalWeight);

        // Blend the original color with the blurred color using intensity
        return blurredColor;
}


// MARK: Outline Layer Effect
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

// MARK: Dynamic Outline Effect
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

// MARK: Polar Outline Effect
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

// MARK: Pixellate Effect
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

// MARK: Innerline Effect
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

// MARK: Bloom Effect
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
