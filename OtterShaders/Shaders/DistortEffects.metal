//
//  DistortEffects.metal
//  SwiftUI-2D-Shader-Assets
//
//  Created by Lingheng Tony Tao on 11/14/24.
//

#include "Common.metal"


// MARK: Wave Effect
[[ stitchable ]] float2 waveEffect(float2 position,
                                   float2 size,
                                   float time,
                                   float strength,
                                   float frequency) {
    float2 uv = position / size;
    float amount = time;

    float2 res = position;
    res.x += sin((uv.x + amount) * frequency) * strength;
    res.y += cos((uv.y + amount) * frequency) * strength;

    return res;
}

