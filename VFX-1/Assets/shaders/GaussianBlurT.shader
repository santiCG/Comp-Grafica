Shader"Tarde/Gaussian Blur"
{
    Properties{
        _mainTexture("mainTexture", 2D) = "white" {}
        _pixelOffset("pixelOffset", float) = 1.0
    }
    
    Subshader{
        Tags{
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "Queue"="Transparent"
        }
        
        ZWrite Off
        
        Pass{
            Name "Gaussian3X3"
            
            HLSLPROGRAM 
            
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            struct Input{
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            Texture2D mainTexture;
            SamplerState sampler_mainTexture;

            sampler2D _mainTexture;
            float4 _mainTexture_TexelSize; // x = 1/width ; y = 1/height; z = width ; w = height
            float _pixelOffset;

            float4 ApplyKernel3x3(sampler2D tex, float2 uv, float pixelOffset, float2 texelSize, float kernel[9]) 
            {
                 float4 result = 0;


                 [unroll(9)]

                 for(int y = -1; y < 2; ++y)
                 {
                     for(int x = -1; x < 2; ++x)
                     {
                         float2 offset = float2(x, y) * texelSize * pixelOffset;
                         result += tex2D(tex, uv + offset) * kernel[x+1 + (y+1) * 3];
                     }
                 }

                 return result;
            }

            Varyings Vertex(Input IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
                OUT.uv = IN.uv;
                return OUT;
            }

            float4 Fragment(Varyings IN ): SV_Target{
                const float gaussianKernel[9] = {
                        0.0625, 0.125, 0.0625,
                        0.125, 0.250, 0.125,
                        0.0625, 0.125, 0.0625
                 };

                const float sharpenKernel[9] = {
                    0, 1,  0,
                    1, -4, 1,
                    0, 1,  0
                };

                const float sobelXKernel[9] = {
                    -1, 0,  1,
                    -2,  0,  2,
                    -1,  0,  1
                };

                const float sobelYKernel[9] = {
                    1, 2,  1,
                    0,  0,  0,
                    -1,  -2,  -1
                };

                float sobelX = ApplyKernel3x3(_mainTexture, IN.uv, _pixelOffset,_mainTexture_TexelSize.xy, sobelXKernel);
                float sobelY = ApplyKernel3x3(_mainTexture, IN.uv, _pixelOffset,_mainTexture_TexelSize.xy, sobelYKernel);

                float sobelXY = sqrt(sobelX * sobelX + sobelY * sobelY);
                float4 texturita = tex2D(_mainTexture, IN.uv);

                return lerp(texturita, 0, sobelXY);
                return tex2D(_mainTexture, IN.uv) + ApplyKernel3x3(_mainTexture, IN.uv, _pixelOffset,_mainTexture_TexelSize.xy, sharpenKernel);
            }
            
            ENDHLSL
        }
    }
}