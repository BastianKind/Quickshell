#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    vec2 itemPos;
    vec2 itemSize;

    float bgWidth;
    float bgHeight;
};

layout(binding = 1) uniform sampler2D background;
layout(binding = 2) uniform sampler2D textMask;

void main()
{
    float mask = texture(textMask, qt_TexCoord0).a;

    vec2 screenPos =
    itemPos +
    qt_TexCoord0 * itemSize;

    vec2 bgUv = vec2(
        screenPos.x / bgWidth,
        screenPos.y / bgHeight
    );

    vec4 bg = texture(background, bgUv);

    vec3 inverted = vec3(1.0) - bg.rgb;

    fragColor = vec4(
        inverted * mask,
        mask
    );
}