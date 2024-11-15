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
[[ stitchable ]] half4 gaussianBlur(float2 position, SwiftUI::Layer layer) {
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
