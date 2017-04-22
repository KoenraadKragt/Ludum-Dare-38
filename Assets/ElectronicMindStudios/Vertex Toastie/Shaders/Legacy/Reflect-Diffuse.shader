Shader "Vertex Toastie/Legacy Shaders/Reflective/Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {} 
	_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
	_AOStrength("AO Strength", Range(0,1)) = 0.8
}
SubShader {
	LOD 200
	Tags { "RenderType"="Opaque" }
	
CGPROGRAM
#pragma multi_compile __ Visualize_AO
#pragma multi_compile __ ApplyAOToDiffuse
#pragma surface surf Lambert

sampler2D _MainTex;
samplerCUBE _Cube;
float _AOStrength;

fixed4 _Color;
fixed4 _ReflectColor;

struct Input {
	float2 uv_MainTex;
	float3 worldRefl;
	float4 color : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex * _Color;
	o.Albedo = c.rgb;
	
	fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
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
	
FallBack "Legacy Shaders/Reflective/VertexLit"
} 
