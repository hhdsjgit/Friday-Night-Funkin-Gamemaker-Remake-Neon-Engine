varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// FXAA 参数
uniform float u_ContrastThreshold; // 对比度阈值，默认 0.0625
uniform float u_RelativeThreshold; // 相对阈值，默认 0.125
uniform float u_SubpixelBlending;  // 子像素混合，默认 0.75

// 获取亮度
float rgb2luma(vec3 rgb) {
    return dot(rgb, vec3(0.299, 0.587, 0.114));
}

void main() {
    // 获取纹素大小 - GMS2 的正确方法
    vec2 texelSize = vec2(1.0) / vec2(1280,720);
    
    // 中心像素
    vec3 colorCenter = texture2D(gm_BaseTexture, v_vTexcoord).rgb;
    
    // 简单 FXAA（简化版）
    // 采样周围像素
    vec3 colorUp    = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, texelSize.y)).rgb;
    vec3 colorDown  = texture2D(gm_BaseTexture, v_vTexcoord - vec2(0.0, texelSize.y)).rgb;
    vec3 colorLeft  = texture2D(gm_BaseTexture, v_vTexcoord - vec2(texelSize.x, 0.0)).rgb;
    vec3 colorRight = texture2D(gm_BaseTexture, v_vTexcoord + vec2(texelSize.x, 0.0)).rgb;
    
    // 对角线采样
    vec3 colorUpLeft    = texture2D(gm_BaseTexture, v_vTexcoord + vec2(-texelSize.x, texelSize.y)).rgb;
    vec3 colorUpRight   = texture2D(gm_BaseTexture, v_vTexcoord + vec2(texelSize.x, texelSize.y)).rgb;
    vec3 colorDownLeft  = texture2D(gm_BaseTexture, v_vTexcoord + vec2(-texelSize.x, -texelSize.y)).rgb;
    vec3 colorDownRight = texture2D(gm_BaseTexture, v_vTexcoord + vec2(texelSize.x, -texelSize.y)).rgb;
    
    // 计算平均值（9-tap 模糊）
    vec3 color = (colorCenter + 
                  colorUp + colorDown + colorLeft + colorRight +
                  colorUpLeft + colorUpRight + colorDownLeft + colorDownRight) / 9.0;
    
    // 边缘检测（可选）
    float lumaCenter = rgb2luma(colorCenter);
    float lumaUp = rgb2luma(colorUp);
    float lumaDown = rgb2luma(colorDown);
    float lumaLeft = rgb2luma(colorLeft);
    float lumaRight = rgb2luma(colorRight);
    
    float lumaMin = min(lumaCenter, min(min(lumaUp, lumaDown), min(lumaLeft, lumaRight)));
    float lumaMax = max(lumaCenter, max(max(lumaUp, lumaDown), max(lumaLeft, lumaRight)));
    float lumaRange = lumaMax - lumaMin;
    
    // 如果是边缘，使用更多混合
    if (lumaRange > max(u_ContrastThreshold, u_RelativeThreshold * lumaMax)) {
        // 简单模糊边缘
        color = mix(colorCenter, color, 0.75);
    }
    
    gl_FragColor = vec4(color, texture2D(gm_BaseTexture, v_vTexcoord).a);
}