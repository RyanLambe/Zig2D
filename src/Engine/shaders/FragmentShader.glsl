#version 410 core

out vec4 FragColor;

in vec2 TexCoord;

uniform vec3 colour;
uniform sampler2D ourTexture;
uniform bool useTexture;

void main()
{
    if(useTexture)
        FragColor = texture(ourTexture, TexCoord) * vec4(colour, 1);
    else
        FragColor = vec4(colour, 1);
    
} 