varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniforms for GMS2
uniform float u_blur_size;
uniform float u_intensity;
uniform float u_time;

const float blurSize = 0.2/512.0;
const float intensity = 0.8;
const float time = 0.5;

void main()
{
   vec4 sum = vec4(0);
   vec2 texcoord = v_vTexcoord;
   int j;
   int i;

   //thank you! http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/ for the 
   //blur tutorial
   // blur in y (vertical)
   // take nine samples, with the distance blurSize between them
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x - 4.0*blurSize, texcoord.y)) * 0.05;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x - 3.0*blurSize, texcoord.y)) * 0.09;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x - 2.0*blurSize, texcoord.y)) * 0.12;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x - blurSize, texcoord.y)) * 0.15;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y)) * 0.16;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x + blurSize, texcoord.y)) * 0.15;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x + 2.0*blurSize, texcoord.y)) * 0.12;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x + 3.0*blurSize, texcoord.y)) * 0.09;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x + 4.0*blurSize, texcoord.y)) * 0.05;
   
   // blur in y (vertical)
   // take nine samples, with the distance blurSize between them
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y - 4.0*blurSize)) * 0.05;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y - 3.0*blurSize)) * 0.09;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y - 2.0*blurSize)) * 0.12;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y - blurSize)) * 0.15;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y)) * 0.16;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y + blurSize)) * 0.15;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y + 2.0*blurSize)) * 0.12;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y + 3.0*blurSize)) * 0.09;
   sum += texture2D(gm_BaseTexture, vec2(texcoord.x, texcoord.y + 4.0*blurSize)) * 0.05;

   //increase blur with intensity!
   //gl_FragColor = sum*intensity + texture2D(gm_BaseTexture, texcoord); 
   
   gl_FragColor = sum * time + texture2D(gm_BaseTexture, texcoord);
   gl_FragColor *= v_vColour;
}