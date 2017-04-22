Shader "Vertex Toastie/Legacy Shaders/Bumped Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_AOStrength("AO Strength", Range(0,1)) = 0.8
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300

CGPROGRAM
#pragma multi_compile __ Visualize_AO
#pragma multi_compile __ ApplyAOToDiffuse
#pragma surface surf Lambert

sampler2D _MainTex;
sampler2D _BumpMap;
fixed4 _Color;
float _AOStrength;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float4 color : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	
	o.Albedo *= (1-((1-IN.color.a)*_AOStrength));
	#if defined(Visualize_AO)
		o.Emission = IN.color.aaa;
		o.Albedo = 0;
	#endif
}
ENDCG  
}

FallBack "Legacy Shaders/Diffuse"
}
