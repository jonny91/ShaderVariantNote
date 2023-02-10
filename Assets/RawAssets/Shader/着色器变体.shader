Shader "着色器变体"
{
    Properties
    {
        [Toggle(I_AM_RED)]I_AM_RED("红色?", int ) = 0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma shader_feature I_AM_RED

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD1;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            float4 frag(v2f i):SV_Target
            {
                #if I_AM_RED
                    return float4(1, 0, 0, 1);
                #else
                    return float4(0, 1, 0, 1);
                #endif
                
            }
            ENDCG
        }
    }
}