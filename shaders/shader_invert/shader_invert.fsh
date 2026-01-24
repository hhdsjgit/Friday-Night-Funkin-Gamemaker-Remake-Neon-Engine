varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniforms
uniform float invert;

void main() {
    vec2 uv = v_vTexcoord;
    vec4 color = texture2D(gm_BaseTexture, uv);
    
    // 使用混合函数避免 if 语句（在某些硬件上更快）
    vec4 normal_color = v_vColour * color;
    vec4 inverted_color = v_vColour * vec4(color.a - color.rgb, color.a);
    
    // 当 invert < 0.5 时使用 normal_color，否则使用 inverted_color
    float use_inverted = step(0.5, invert);
    gl_FragColor = mix(normal_color, inverted_color, use_inverted);
}