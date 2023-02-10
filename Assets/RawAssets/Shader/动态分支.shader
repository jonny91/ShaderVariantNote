Shader "动态分支"
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
                bool I_AM_RED = false;
                if (I_AM_RED)
                {
                    return float4(1, 0, 0, 1);
                }
                else
                {
                    return float4(0, 1, 0, 1);
                }
            }
            ENDCG
        }
    }
}