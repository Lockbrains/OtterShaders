# Shader Documentation

## Color Effects
1. Dissolve Effect
- API: `dissolveEffect(date: Date, speed: Double, x: CGFloat, y: CGFloat, fadeBurnWidth: Float, fadeBurnTransition: Float, fadeBurnGrow: Float, fadeBurnColor: Color, fadeTex: String)`.
- Parameter Descriptions: 
    - `speed`: the visual speed of the dissolve. Set this to -1 if you want to reverse the animation.
    - `x`: the width in pt of the current applied view.
    - `y`: the height in pt of the current applie view.
    - `fadeBurnWidth`: the blending width of the dissolve edges.
    - `fadeBurnTransition`: the blending factor of the dissolve edges.
    - `fadeBurnGlow`: the glow intensity of the dissolving edge.
    - `fadeBurnColor`: the LDR color of the fade edges.
    - `fadeTex`: the texture for sampling the dissolve progress.
- Notes: You may want to modify the shader to support manual progress control. Right now it is supposed to automatically loop.

2. Outline Effect
- API: `outlineEffect(date: Date, clipThreshold: Float, outlineWidth : Float, outlineMultiplier : Float, outlineColor: Color)`.
- Parameter Descriptions:
    - `clipThreshold`: the alpha value where it is considered as transparent.
    - `outlineWidth`: the width of the interior outline.
    - `outlineMultiplier`: the intensity of the outline.
    - `outlineColor`: the color of the outline.
- Notes: this outline effect won't support outlines outside of the original image. If you want to outline on the outside, go check out `Layer Effects > Outline Layer Effect`.

## Layer Effects

## Distort Effects
