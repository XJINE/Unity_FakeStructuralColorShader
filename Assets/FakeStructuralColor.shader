Shader "Custom/FakeStructuralColor"
{
    Properties
    {
        _Color        ("Color",         Color      ) = (1,1,1,1)
        _MainTex      ("Albedo (RGB)",  2D         ) = "white" {}
        _Glossiness   ("Smoothness",    Range(0, 1)) = 0.5
        _Metallic     ("Metallic",      Range(0, 1)) = 0.0

        _SinCycle   ("Offset Cycle", Float      ) = 1
        _SinROffset ("R Offset",     Float      ) = 1
        _SinGOffset ("G Offset",     Float      ) = 1
        _SinBOffset ("B Offset",     Float      ) = 1
        _Power      ("Power",        Range(0, 1)) = 1
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldNormal;
        };

        sampler2D _MainTex;

        float4 _Color;
        float  _Glossiness;
        float  _Metallic;

        float _SinCycle;
        float _SinROffset;
        float _SinGOffset;
        float _SinBOffset;
        float _Power;

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            float4 color = tex2D (_MainTex, i.uv_MainTex) * _Color;
            float  dotNV = dot(i.worldNormal, i.viewDir);

            float sinR = sin(_SinROffset + _SinCycle * dotNV) * dotNV;
            float sinG = sin(_SinGOffset + _SinCycle * dotNV) * dotNV;
            float sinB = sin(_SinBOffset + _SinCycle * dotNV) * dotNV;

            float3 structuralColor = float3(color.r + sinR, color.g + sinG, color.b + sinB);

            o.Albedo     = lerp(color.rgb, structuralColor, _Power);
            o.Metallic   = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha      = 1;
        }

        ENDCG
    }

    FallBack "Diffuse"
}