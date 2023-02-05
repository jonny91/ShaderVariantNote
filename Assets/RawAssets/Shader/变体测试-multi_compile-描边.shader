Shader "变体测试/multi_compile 描边"
{
    Properties
    {
        _OutlineFactor("OutlineFactor", Range(0,10)) = 0.01

        [MainTexture] _BaseMap("Albedo", 2D) = "white" {}
        [MainColor] _BaseColor("Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        Pass
        {
            Cull BACK
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            HLSLPROGRAM
            // #pragma vertex LitPassVertex
            // #pragma fragment LitPassFragment

            // #include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            // #include "Packages/com.unity.render-pipelines.universal/Shaders/LitForwardPass.hlsl"
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _BaseMap;
            float4 _BaseMap_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BaseMap);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_BaseMap, i.uv);
                return col;
            }
            ENDHLSL
        }

        Pass
        {
            Cull Front
            Name "Outline"
            Tags
            {
                "LightMode" = "SRPDefaultUnlit"
            }

            HLSLPROGRAM
            #pragma multi_compile OUTLINE_RED OUTLINE_GREEN

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            float _OutlineFactor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };


            v2f vert(appdata v)
            {
                v2f o;
                v.vertex.xyz *= _OutlineFactor;
                //v.vertex.xyz = v.vertex.xyz + v.normal * _OutlineFactor;
                o.vertex = TransformObjectToHClip(v.vertex);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half4 color = half4(0, 0, 0, 0);
                #if OUTLINE_RED
                    color = color +  half4(1,0.11,0.11,1);
                #endif

                #if OUTLINE_GREEN
                color = color + half4(0.21, 0.95, 0.3, 1);
                #endif

                return color;
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}