/// This file is only for verifying some properties of user space in SwiftUI and Metal.

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 trivialGradient (float2 position, half4 currentColor, float2 size) {
    float2 uv = position / size;
    return half4(uv.x, uv.y, 0, 1);
}
