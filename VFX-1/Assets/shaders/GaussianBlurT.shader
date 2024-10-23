Shader"Tarde/Gaussian Blur"
{
    Properties{
        _mainTexture("mainTexture", 2D) = "white" {}
        _pixelOffset("pixelOffset", float) = 1.0
    }
    
    Subshader{
        Tags{
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        
        ZWrite Off
        Blend One One
        
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

            Varyings Vertex(Input IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
                OUT.uv = IN.uv;
                return OUT;
            }

            float4 Fragment(Varyings IN ): SV_Target{
                return 1;
            }
            
            ENDHLSL
        }
    }
}