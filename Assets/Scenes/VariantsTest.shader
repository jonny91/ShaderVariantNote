Shader "VariantsTest"
{
    Properties
    {
        [Toggle]Light("Light Toggle", int ) = 0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma multi_compile LIGHT_OFF LIGHT_ON

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
                #ifdef LIGHT_ON
                    return float4(255.0/255,176.0/255,69.0/255,1);
                #else
                    return float4(0, 0, 0, 1);
                #endif
            }
            ENDCG
        }
    }
}