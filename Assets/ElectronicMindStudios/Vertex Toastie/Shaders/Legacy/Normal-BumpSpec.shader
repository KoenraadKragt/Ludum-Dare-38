Shader "Vertex Toastie/Legacy Shaders/Bumped Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_AOStrength("AO Strength", Range(0,1)) = 0.8
}

CGINCLUDE
#pragma multi_compile __ Visualize_AO
#pragma multi_compile __ ApplyAOToDiffuse

sampler2D _MainTex;
sampler2D _BumpMap;
fixed4 _Color;
half _Shininess;
float _AOStrength;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float4 color : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb * _Color.rgb;
	o.Gloss = tex.a;
	o.Alpha = tex.a * _Color.a;
	o.Specular = _Shininess;
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
	
	o.Albedo *= (1-((1-IN.color.a)*_AOStrength));
	#if defined(Visualize_AO)
o.Emission = IN.color.aaa;
		o.Albedo = 0;
	#endif
}
ENDCG

SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
	CGPROGRAM
	#pragma surface surf BlinnPhong
	#pragma target 3.0
	ENDCG
}

SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
	CGPROGRAM
	#pragma surface surf BlinnPhong nodynlightmap
	ENDCG
}

FallBack "Legacy Shaders/Specular"
}
