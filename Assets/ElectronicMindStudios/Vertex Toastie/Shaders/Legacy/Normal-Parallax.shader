Shader "Vertex Toastie/Legacy Shaders/Parallax Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_Parallax ("Height", Range (0.005, 0.08)) = 0.02
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_ParallaxMap ("Heightmap (A)", 2D) = "black" {}
	_AOStrength("AO Strength", Range(0,1)) = 0.8
}

CGINCLUDE
#pragma multi_compile __ Visualize_AO
#pragma multi_compile __ ApplyAOToDiffuse
sampler2D _MainTex;
sampler2D _BumpMap;
sampler2D _ParallaxMap;
fixed4 _Color;
float _Parallax;
float _AOStrength;

struct Input {
	float2 uv_MainTex;
	float2 uv_BumpMap;
	float3 viewDir;
	float4 color : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	half h = tex2D (_ParallaxMap, IN.uv_BumpMap).w;
	float2 offset = ParallaxOffset (h, _Parallax, IN.viewDir);
	IN.uv_MainTex += offset;
	IN.uv_BumpMap += offset;
	
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

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 500

	CGPROGRAM
	#pragma surface surf Lambert
	#pragma target 3.0
	ENDCG
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 500

	CGPROGRAM
	#pragma surface surf Lambert nodynlightmap
	ENDCG
}

FallBack "Legacy Shaders/Bumped Diffuse"
}
