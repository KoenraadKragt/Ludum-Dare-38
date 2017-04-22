Shader "Vertex Toastie/Legacy Shaders/Reflective/Bumped Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
	_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrGloss (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_AOStrength("AO Strength", Range(0,1)) = 0.8
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 400
CGPROGRAM
#pragma multi_compile __ Visualize_AO
#pragma multi_compile __ ApplyAOToDiffuse
#pragma surface surf BlinnPhong
#pragma target 3.0

sampler2D _MainTex;
sampler2D _BumpMap;
samplerCUBE _Cube;
float _AOStrength;

fixed4 _Color;
fixed4 _ReflectColor;
half _Shininess;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 worldRefl;
	float4 color : COLOR;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb;
	
	o.Gloss = tex.a;
	o.Specular = _Shininess;
	
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	
	float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	fixed4 reflcol = texCUBE (_Cube, worldRefl);
	reflcol *= tex.a;
	o.Emission = reflcol.rgb * _ReflectColor.rgb;
	o.Alpha = reflcol.a * _ReflectColor.a;
	
	o.Albedo *= (1-((1-IN.color.a)*_AOStrength));
	#if defined(Visualize_AO)
		o.Emission = IN.color.aaa;
		o.Albedo = 0;
	#endif
}
ENDCG
}

FallBack "Legacy Shaders/Reflective/Bumped Diffuse"
}
