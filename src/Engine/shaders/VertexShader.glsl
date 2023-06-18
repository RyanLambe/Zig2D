#version 410 core
layout (location = 0) in vec2 Pos;

uniform vec2 camPos;
uniform float camScale;
uniform float aspectRatio;

uniform mat3 objectTransform;
uniform mat3 objectRotation;
uniform int objectLayer; //-128 to 127

out vec2 TexCoord;

void main()
{
    //transform object to correct position
    vec3 finalPosition = objectRotation * (vec3(vec2(Pos.x, Pos.y), 1.0) * objectTransform  - vec3(camPos, 1.0)) / camScale;

    finalPosition.y *= aspectRatio;

    //add depth(layers)
    finalPosition.z = objectLayer/128.0;

    //return
    gl_Position = vec4(finalPosition, 1.0);
    TexCoord = (Pos + vec2(0.5, 0.5)) * vec2(1, -1);
}