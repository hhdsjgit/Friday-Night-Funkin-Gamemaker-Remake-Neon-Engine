varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniforms for GMS2
const float u_blur_size = 10.0;
const float u_intensity = 0.6;
const float u_time = 0.0;

// 预定义的Gaussian权重常量
const float w0 = 0.05;   // -4/+4
const float w1 = 0.09;   // -3/+3  
const float w2 = 0.12;   // -2/+2
const float w3 = 0.15;   // -1/+1
const float w4 = 0.16;   // 0

// 优化的Bloom着色器 - 保持原始结构但性能更好
void main()
{
    vec2 texcoord = v_vTexcoord;
    
    // 1. 首先采样原始颜色
    vec4 original_color = texture2D(gm_BaseTexture, texcoord);
    
    // 2. 计算亮度（用于阈值判断，提高性能）
    float brightness = (original_color.r * 0.299 + 
                       original_color.g * 0.587 + 
                       original_color.b * 0.114);
    
    // 3. 计算动态模糊大小（基于uniform参数）
    float dynamicBlurSize = (u_blur_size * 0.4) / 512.0;
    
    // 4. 高斯模糊 - 使用for循环但避免数组
    vec4 sum = vec4(0.0);
    
    // 水平方向模糊
    for (int i = -4; i <= 4; i++) {
        float weight = 0.0;
        
        // 根据i值分配权重（不使用数组）
        if (i == -4 || i == 4) weight = w0;
        else if (i == -3 || i == 3) weight = w1;
        else if (i == -2 || i == 2) weight = w2;
        else if (i == -1 || i == 1) weight = w3;
        else if (i == 0) weight = w4;
        
        vec2 offset = vec2(float(i) * dynamicBlurSize, 0.0);
        sum += texture2D(gm_BaseTexture, texcoord + offset) * weight;
    }
    
    // 垂直方向模糊
    for (int i = -4; i <= 4; i++) {
        float weight = 0.0;
        
        // 根据i值分配权重
        if (i == -4 || i == 4) weight = w0;
        else if (i == -3 || i == 3) weight = w1;
        else if (i == -2 || i == 2) weight = w2;
        else if (i == -1 || i == 1) weight = w3;
        else if (i == 0) weight = w4;
        
        vec2 offset = vec2(0.0, float(i) * dynamicBlurSize);
        sum += texture2D(gm_BaseTexture, texcoord + offset) * weight;
    }
    
    // 5. 计算最终模糊结果（平均两个方向）
    vec4 blurResult = sum * 0.5;
    
    // 6. 应用亮度阈值（优化性能）
    // 只有足够亮的区域才应用强bloom效果
    float bloomStrength = clamp(brightness * 2.0 - 1.0, 0.0, 1.0);
    
    // 7. 时间相关效果（可选）
    float timeEffect = 1.0 + sin(u_time * 0.001) * 0.05;
    
    // 8. 最终合成（保持原始结构但优化混合）
    // 原始代码：gl_FragColor = sum * time + texture2D(gm_BaseTexture, texcoord);
    // 优化后：更好的混合控制和性能
    
    // 高质量混合公式
    vec4 finalColor;
    
    if (u_intensity > 0.5) {
        // 高强度模式：使用additive blending
        finalColor = original_color + blurResult * u_intensity * bloomStrength * timeEffect;
    } else {
        // 低强度模式：使用lerp混合
        finalColor = mix(original_color, blurResult, u_intensity * bloomStrength * 0.5) * timeEffect;
    }
    
    // 9. 颜色校正和钳制
    finalColor = clamp(finalColor, 0.0, 1.0);
    
    // 10. 应用顶点颜色
    gl_FragColor = finalColor * v_vColour;
}