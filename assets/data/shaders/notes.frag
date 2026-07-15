#pragma header

uniform int u_noteData;
uniform vec3 u_leftColor;
uniform vec3 u_downColor;
uniform vec3 u_upColor;
uniform vec3 u_rightColor;

void main()
{
    // flixel_texture2D, bitmap y openfl_TextureCoordv ya vienen incluidos gracias a #pragma header
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    
    if (color.a > 0.0) {
        float br = (color.r + color.g + color.b) / 3.0;
        vec3 tc = vec3(1.0);
        
        if (u_noteData == 0) tc = u_leftColor;
        else if (u_noteData == 1) tc = u_downColor;
        else if (u_noteData == 2) tc = u_upColor;
        else if (u_noteData == 3) tc = u_rightColor;
        
        gl_FragColor = vec4(tc * br, color.a);
    } else {
        gl_FragColor = color;
    }
}