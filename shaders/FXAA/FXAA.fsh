varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    // RGB通道偏移
    float offset = sin(v_vTexcoord.y * 50.0) * 0.005;
    
    float r = texture2D(gm_BaseTexture, v_vTexcoord + vec2(offset, 0.0)).r;
    float g = texture2D(gm_BaseTexture, v_vTexcoord).g;
    float b = texture2D(gm_BaseTexture, v_vTexcoord - vec2(offset, 0.0)).b;
    float a = texture2D(gm_BaseTexture, v_vTexcoord).a;
    
    gl_FragColor = vec4(r, g, b, a) * v_vColour;
}