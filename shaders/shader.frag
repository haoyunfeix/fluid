#version 310 es
precision mediump float;
in vec4 COLOR0;
in vec2 xsv_TEXCOORD0;
layout(location = 0) out vec4 fragColor;

void main()
{
    fragColor = COLOR0;
}

