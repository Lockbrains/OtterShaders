# Shader Documentation

## Color Effects
1. **Dissolve Effect**
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

2. **Outline Effect**
- API: `outlineEffect(date: Date, clipThreshold: Float, outlineWidth : Float, outlineMultiplier : Float, outlineColor: Color)`.
- Parameter Descriptions:
    - `clipThreshold`: the alpha value where it is considered as transparent.
    - `outlineWidth`: the width of the interior outline.
    - `outlineMultiplier`: the intensity of the outline.
    - `outlineColor`: the color of the outline.
- Notes: this outline effect won't support outlines outside of the original image. If you want to outline on the outside, go check out `Layer Effects > Outline Layer Effect`.

3. **Star Effect**
- API: starEffect(date: Date, x: CGFloat, y: CGFloat, layers: Float, intensity: Float, starColor: Color)
- Parameter Descriptions:
    - `x`: the width of the view.
    - `y`: the height of the view.
    - `layers`: number of parallax layers of starfields.
    - `intensity`: how strongly the star effect is blended.
    - `starColor`: the tint color of the stars.
- Notes: Based on procedural starfield generation with rotation. Produces a dreamy animated effect.

4. **Glare Effect 1**  
- API: `glareEffect1(date: Date, x: CGFloat, y: CGFloat)`  
- Parameter Descriptions:
    - `x`: the width of the view.
    - `y`: the height of the view.
- Notes: A procedural animated glare based on mathematical patterns. Creates a radial chromatic glare effect.

5. **Multiply Effect**  
- API: `multiplyEffect(date: Date, x: CGFloat, y: CGFloat, tile: CGSize, offset: CGSize, direction: CGSize, texture: String)`  
- Parameter Descriptions:
    - `x`: the width of the view.
    - `y`: the height of the view.
    - `tile`: how many times the texture tiles across the surface.
    - `offset`: UV offset of the texture.
    - `direction`: the movement direction of the texture over time.
    - `texture`: the texture used for multiplication.
- Notes: Multiplies the current color by a scrolling texture pattern. Great for animated overlays.

6. **Scanlight Effect**  
- API: `scanlightEffect(date: Date, x: CGFloat, y: CGFloat, rotation: Float, start1: Float, start2: Float, start3: Float, width1: Float, width2: Float, width3: Float, glow: Float, top: Float, bottom: Float, opacity: Float, color1: Color, color2: Color, color3: Color)`  
- Parameter Descriptions:
    - `rotation`: angle of the scanline.
    - `start1`, `start2`, `start3`: starting locations of the three scanlines (0.0–1.0).
    - `width1`, `width2`, `width3`: width of each scanline.
    - `glow`: brightness of the scanlines.
    - `top`, `bottom`: control remapping range (typically 0.0–1.0).
    - `opacity`: the strength of the scanlines.
    - `color1`, `color2`, `color3`: colors of each scanline.
- Notes: Renders three animated glowing scanlines moving over the surface, commonly used for sci-fi or retro UIs.

7. **Scanlight Textured Effect**  
- API: `scanlightTexturedEffect(date: Date, x: CGFloat, y: CGFloat, rotation: Float, start1: Float, start2: Float, start3: Float, width1: Float, width2: Float, width3: Float, glow: Float, top: Float, bottom: Float, opacity: Float, texture: String)`  
- Parameter Descriptions:
    - `rotation`: angle of the scanline.
    - `start1`, `start2`, `start3`: starting locations of the three scanlines (0.0–1.0).
    - `width1`, `width2`, `width3`: width of each scanline.
    - `glow`: brightness of the scanlines.
    - `top`, `bottom`: remapping boundaries for line movement.
    - `opacity`: how much the scanline affects final color.
    - `texture`: the texture used for scanline tinting.
- Notes: Like `scanlightEffect`, but uses an external texture instead of flat color. Good for stylized scans.

## Layer Effects
1. **Gaussian Blur Effect**  
- API: `gaussianBlurEffect(intensity: Float, blurSize: Float)`  
- Parameter Descriptions:
    - `intensity`: blending weight of the blur (usually used outside the shader).
    - `blurSize`: radius of the blur kernel in pixels.
- Notes: Uses a basic Gaussian kernel to blur surrounding pixels. Larger `blurSize` gives stronger blur but is more expensive.

2. **Outline Layer Effect**  
- API: `outlineLayerEffect(outlineWidth: Float, outlineColor: Color, outlineTex: String)`  
- Parameter Descriptions:
    - `outlineWidth`: distance (in pixels) to sample for neighboring alpha.
    - `outlineColor`: base color of the outline.
    - `outlineTex`: modulates the outline using a texture pattern.
- Notes: This outline works by checking alpha values of neighboring pixels and filling empty edges. It expands *outside* the original alpha shape.

3. **Dynamic Outline Layer Effect**  
- API: `dynamicOutlineLayerEffect(direction: CGSize, time: Float, outlineWidth: Float, outlineColor: Color, outlineTex: String)`  
- Parameter Descriptions:
    - `direction`: direction in which the outline texture scrolls.
    - `time`: used to animate the movement of the texture.
    - `outlineWidth`: thickness of the outline detection.
    - `outlineColor`: base color of the outline.
    - `outlineTex`: texture to use as outline pattern.
- Notes: Adds motion to the outline by moving the sampling UVs over time. Great for animated glows or fire-like edges.

4. **Polar Outline Layer Effect**  
- API: `polarOutlineLayerEffect(direction: CGSize, time: Float, outlineWidth: Float, outlineColor: Color, outlineTex: String)`  
- Parameter Descriptions:
    - `direction`: motion vector of the outline in polar space.
    - `time`: scroll time used for texture offset.
    - `outlineWidth`: how far to search for surrounding pixels.
    - `outlineColor`: color to apply to outlined areas.
    - `outlineTex`: sampled to modulate the outline shape.
- Notes: Similar to `dynamicOutlineLayerEffect`, but scrolls the texture in polar coordinates instead of linear space, creating swirling effects.

5. **Pixellate Effect**  
- API: `pixellateEffect(strength: Float)`  
- Parameter Descriptions:
    - `strength`: size of the pixelation block (higher = more pixelated).
- Notes: Creates a pixelated effect by rounding UVs to fixed-size blocks. Good for retro game looks.

6. **Innerline Effect**  
- API: `innerlineEffect(strength: Float, stepX: Float, stepY: Float, edgeOnly: Float, fillColor: Color, lineColor: Color)`  
- Parameter Descriptions:
    - `strength`: edge detection intensity (not used directly in the shader).
    - `stepX`, `stepY`: sampling offsets in each axis.
    - `edgeOnly`: set to 1.0 to render only edge lines; 0.0 to blend with original.
    - `fillColor`: base fill color when `edgeOnly` is 1.0.
    - `lineColor`: color of the detected edge.
- Notes: Applies a Sobel filter to detect image edges. Useful for sketch or ink-line effects.

7. **Bloom Effect**  
- API: `bloomEffect(strength: Float, threshold: Float, amount: Float)`  
- Parameter Descriptions:
    - `strength`: sampling radius for bloom.
    - `threshold`: only pixels brighter than this will bloom.
    - `amount`: how much bloom is added to the original image.
- Notes: A simple bloom approximation. Not physically accurate but effective for stylized glow.

## Distort Effects
1. **Wave Effect**  
- API: `waveEffect(time: Float, strength: Float, frequency: Float)`  
- Parameter Descriptions:
    - `time`: current animation time, drives wave movement.
    - `strength`: amplitude of the wave distortion.
    - `frequency`: number of wave cycles across the image.
- Notes: Applies sine/cosine-based displacement to both X and Y axes. Can be used for ripple or heat-haze effects. To use this, you typically pass its result into your `position` when sampling textures.
