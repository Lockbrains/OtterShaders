# SwiftUI 2D Shader Assets 

There will be 3 types of effects for 2D shaders in SwiftUI:
- 1. `colorEffect`: if the effect ONLY changes color, find the shader in Color Effect Section
- 2. `layerEffect`: if the effect requires information from the background (neighboring pixels, background pixels, etc), find the shader in Layer Effect Section.
- 3. `distortEffect`: if the effect requires the morph of the shape / vertex manipulations, find the shader in the Distort Effect Section.

Read Apple Developer's documentation for more details: https://developer.apple.com/documentation/swiftui/shader

## How To Use
To plug the code into your project, you may get the code from the `Shaders` folder (and feel free to edit anything in these shaders written in MSL to meet your own demand!).

There are 3 files that you should take a look:
1. `Shaders\ColorEffects.metal`: All the color effects live here.
2. `Shaders\DistortEffects.metal`: All the distort effects live here
3. `Shaders\LayerEffects.metal`: All the layer effects live here.

If you don't feel like to see the implementation details of these shaders, you may also use the generators for generating a SwiftUI Shader. These generators live in the `ShaderToView` folder. Similar to the above, just find the effect in its category.

### Generators
To activate a visual effect on a swift view, you will use the `.colorEffect` or `.layerEffect` or `.distortEffect` modifier, for example:
```
Image("example")
    .resizable()
    .colorEffect(
        // Add the shader here
    )
)
```
You will need to provide a shader and some additional fields for Layer and Distort effects. 

For color effects, for example, if you'd like to plug in a 
star effect, you will simply need to do
```
Image("example")
    .resizable()
    .colorEffect(
        starEffect(
            date: date,
            speed: 1.0, 
            x: 200, // the width of the frame
            y: 200, // the height of the frame
            layers: 8,
            intensity: 10,
            starColor: Color.red
        )
    )
```

or, if you feel this codestyle makes your code wordy, you may set up file for saving these shaders as constants, just as what we did in the `Shaders/SampleShaders.swift`.

For layer effects, you will additionally need a `maxSampleOffset`. This is telling the shader how many neighboring pixels' infomation it needs to pack. Please refer to the official documentation for more details: https://developer.apple.com/documentation/swiftui/view/layereffect(_:maxsampleoffset:isenabled:). 


## System Requirement
The shader effects are available only on iOS after iOS 17. Make sure you meet the system requirement, otherwise there will be no effects.
