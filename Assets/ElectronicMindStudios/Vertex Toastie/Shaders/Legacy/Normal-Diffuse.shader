Shader "Vertex Toastie/Legacy Shaders/Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_AOStrength("AO Strength", Range(0,1)) = 0.8
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200

CGPROGRAM
#pragma multi_compile __ Visualize_AO
#pragma multi_compile __ ApplyAOToDiffuse
#pragma surface surf Lambert

sampler2D _MainTex;
fixed4 _Color;
float _AOStrength;

struct Input {
	float2 uv_MainTex;
	float4 color : COLOR;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
	
	o.Albedo *= (1-((1-IN.color.a)*_AOStrength));
	#if defined(Visualize_AO)
		o.Emission = IN.color.aaa;
		o.Albedo = 0;
	#endif
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
