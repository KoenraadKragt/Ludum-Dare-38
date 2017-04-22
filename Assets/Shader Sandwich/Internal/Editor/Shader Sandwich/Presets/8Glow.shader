Shader "Hidden/SS/Glow" {
Properties {
_MainTex ("Base", 2D) = "white" {}
_Color ("Color", Color) = (1,1,1,1)
_Shininess ("Hardness", Range(0.000100000,1.000000000)) = 0.692598800
_SpecColor ("Specular Color", Color) = (0.08088237,0.08088237,0.08088237,1)
_SSSGlow_Color ("Glow Color", Color) = (0,0.462069,1,1)
_SSSGlow_Size_Distance ("Glow Size Distance", Range(0.000000000,1.000000000)) = 0.099616860
_SSSGlow_Brightness ("Glow Brightness", Range(0.000000000,1.000000000)) = 0.040000000
_SSSGlow_Ease ("Glow Ease", Range(0.000000000,3.000000000)) = 2.367816000
}

SubShader {
Tags { "RenderType"="Opaque""Queue"="Transparent" }
LOD 200
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.07692308;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.07692308,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.07692308;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.1538462;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.1538462,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.1538462;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.2307692;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.2307692,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.2307692;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.3076923;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.3076923,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.3076923;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.3846154;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.3846154,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.3846154;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.4615385;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.4615385,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.4615385;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.5384616;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.5384616,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.5384616;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.6153846;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.6153846,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.6153846;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.6923077;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.6923077,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.6923077;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.7692308;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.7692308,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.7692308;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.8461539;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.8461539,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.8461539;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0.9230769;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(0.9230769,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0.9230769;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	ZWrite Off
	cull Off
blend One One
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLUnlit vertex:vert  addshadow  noforwardadd noambient novertexlights nolightmap nodynlightmap nodirlightmap fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLUnlit (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 1;
v.vertex.xyz += v.normal*(_SSSGlow_Size_Distance*pow(1,_SSSGlow_Ease));

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-1;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess*2;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_Sample1 = _SSSGlow_Color;
Texture_Sample1.rgb = (Texture_Sample1.rgb*_SSSGlow_Brightness);
o.Albedo= Texture_Sample1.rgb;
//Gloss
}
	ENDCG
	ZWrite On
	ZWrite Off
	cull Back
	CGPROGRAM

sampler2D _MainTex;
float4 _Color;
float _Shininess;
float4 _SSSGlow_Color;
float _SSSGlow_Size_Distance;
float _SSSGlow_Brightness;
float _SSSGlow_Ease;
	#pragma surface frag_surf CLPBR_Standard vertex:vert  addshadow  alpha:fade fullforwardshadows
	#pragma target 3.0
struct CSurfaceOutput 
{ 
	half3 Albedo; 
	half3 Normal; 
	half3 Emission; 
	half Smoothness; 
	half3 Specular; 
	half Alpha; 
	half Occlusion; 
};
struct Input {
	float3 viewDir;
	float2 uv_MainTex;
};

half4 LightingCLPBR_Standard (CSurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
half3 lightColor = _LightColor0.rgb;
	s.Normal = normalize(s.Normal);
	half NdotL = max (0, dot (s.Normal, lightDir));
	half4 c;
	c.rgb = s.Albedo * lightColor * (NdotL * atten * 2);
	c.a = s.Alpha;
	float3 Spec;
	half3 h = normalize (lightDir + viewDir);	
	float nh = max (0, dot (s.Normal, h));
	Spec = pow (nh, s.Smoothness*128.0) * s.Specular;
	Spec = Spec * atten * 2 * lightColor.rgb;
	Spec = Spec * float4(0.8, 0.8, 0.8, 1).rgb;
	Spec = Spec * ((((s.Smoothness*128.0f)+9.0f)/(28.26))/9.0f);
	c.rgb+=Spec;
	
	return c;
}
#ifdef UNITY_GLOBAL_ILLUMINATION_INCLUDED
#include "UnityPBSLighting.cginc"
half4 LightingCLPBR_Standard (CSurfaceOutput s, half3 viewDir, UnityGI gi){
	s.Normal = normalize(s.Normal);
	// energy conservation
	half oneMinusReflectivity;
	s.Albedo = EnergyConservationBetweenDiffuseAndSpecular (s.Albedo, s.Specular, /*out*/ oneMinusReflectivity);
	// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
	// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha
	half outputAlpha;
	s.Albedo = PreMultiplyAlpha (s.Albedo, s.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);
	half4 c = UNITY_BRDF_PBS (s.Albedo, s.Specular, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, gi.light, gi.indirect);
	c.rgb += UNITY_BRDF_GI (s.Albedo, s.Specular, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, s.Occlusion, gi);
	c.a = outputAlpha;
	return c;
}

inline void LightingCLPBR_Standard_GI (CSurfaceOutput s,UnityGIInput data,inout UnityGI gi){
	gi = UnityGlobalIllumination (data, 1.0, s.Smoothness, s.Normal);
}
#endif

void vert (inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input, o);
float SSShellDepth = 0;

float4 Vertex = v.vertex;
float Mask0 = 0;
//Mask0
//Vertex

v.vertex.rgb = Vertex;
}

void frag_surf (Input IN, inout CSurfaceOutput o) {
float SSShellDepth = 1-0;
float SSParallaxDepth = 0;
	float2 uv_MainTex = IN.uv_MainTex;
	o.Albedo = float3(0.8,0.8,0.8);
	float4 Emission = float4(0,0,0,0);
	o.Smoothness = _Shininess;
	o.Alpha = 1.0;
	o.Occlusion = 1.0;
	o.Specular = float3(0.3,0.3,0.3);

float Mask0 = 0;
//Mask0
//Normals
//Alpha
	o.Alpha *= 1;
//Diffuse
float4 Texture_2_Sample1 = tex2D(_MainTex,(((uv_MainTex.xy))));
o.Albedo= Texture_2_Sample1.rgb;
float4 Texture2_2_Sample1 = _Color;
o.Albedo*= Texture2_2_Sample1.rgb;
//Gloss
float4 Specular_Sample1 = _SpecColor;
o.Specular= Specular_Sample1.rgb;
}
	ENDCG
}

Fallback "VertexLit"
}

/*
BeginShaderParse
0.9
BeginShaderBase
BeginShaderInput
Type #! 0 #?Type
VisName #! Base #?VisName
ImageDefault #! 0 #?ImageDefault
Image #! 9f3187bc2c72c9842b24739d8ab2a1ed #?Image
Cube #!  #?Cube
Color #! 0.8,0.8,0.8,1 #?Color
Number #! 0 #?Number
Range0 #! 0 #?Range0
Range1 #! 1 #?Range1
MainType #! 2 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 1 #?Type
VisName #! Color #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 1,1,1,1 #?Color
Number #! 0 #?Number
Range0 #! 0 #?Range0
Range1 #! 1 #?Range1
MainType #! 1 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 4 #?Type
VisName #! Hardness #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 0.8,0.8,0.8,1 #?Color
Number #! 0.6925988 #?Number
Range0 #! 0.0001 #?Range0
Range1 #! 1 #?Range1
MainType #! 6 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 1 #?Type
VisName #! Specular Color #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 0.08088237,0.08088237,0.08088237,1 #?Color
Number #! 0 #?Number
Range0 #! 0 #?Range0
Range1 #! 1 #?Range1
MainType #! 5 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 1 #?Type
VisName #! Glow Color #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 0,0.462069,1,1 #?Color
Number #! 0 #?Number
Range0 #! 0 #?Range0
Range1 #! 1 #?Range1
MainType #! 0 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 4 #?Type
VisName #! Glow Size Distance #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 0,0,0,0 #?Color
Number #! 0.09961686 #?Number
Range0 #! 0 #?Range0
Range1 #! 1 #?Range1
MainType #! 0 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 4 #?Type
VisName #! Glow Brightness #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 0.8,0.8,0.8,1 #?Color
Number #! 0.04 #?Number
Range0 #! 0 #?Range0
Range1 #! 1 #?Range1
MainType #! 0 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
BeginShaderInput
Type #! 4 #?Type
VisName #! Glow Ease #?VisName
ImageDefault #! 0 #?ImageDefault
Image #!  #?Image
Cube #!  #?Cube
Color #! 0,0,0,0 #?Color
Number #! 2.367816 #?Number
Range0 #! 0 #?Range0
Range1 #! 3 #?Range1
MainType #! 0 #?MainType
SpecialType #! 0 #?SpecialType
EndShaderInput
ShaderName #! SS/Glow #?ShaderName
Hard Mode #! True #?Hard Mode
Tech Lod #! 200 #?Tech Lod
Cull #! 1 #?Cull
Tech Shader Target #! 3 #?Tech Shader Target
Vertex Recalculation #! False #?Vertex Recalculation
Use Fog #! True #?Use Fog
Use Ambient #! True #?Use Ambient
Use Vertex Lights #! True #?Use Vertex Lights
Use Lightmaps #! True #?Use Lightmaps
Use All Shadows #! True #?Use All Shadows
Diffuse On #! True #?Diffuse On
Lighting Type #! 4 #?Lighting Type
Color #! 0.8,0.8,0.8,1 #?Color
Setting1 #! 0 #?Setting1
Wrap Color #! 0.4,0.2,0.2,1 #?Wrap Color
Specular On #! True #?Specular On
Specular Type #! 0 #?Specular Type
Spec Hardness #! 0.6925988 #^ 2 #?Spec Hardness
Spec Color #! 0.8,0.8,0.8,1 #?Spec Color
Spec Energy Conserve #! True #?Spec Energy Conserve
Spec Offset #! 0 #?Spec Offset
Emission On #! False #?Emission On
Emission Color #! 0,0,0,0 #?Emission Color
Emission Type #! 0 #?Emission Type
Transparency On #! True #?Transparency On
Transparency Type #! 1 #?Transparency Type
ZWrite #! False #?ZWrite
Use PBR #! False #?Use PBR
Transparency #! 1 #?Transparency
Receive Shadows #! False #?Receive Shadows
ZWrite Type #! 0 #?ZWrite Type
Blend Mode #! 0 #?Blend Mode
Shells On #! True #?Shells On
Shell Count #! 13 #?Shell Count
Shells Distance #! 0.09961686 #^ 5 #?Shells Distance
Shell Ease #! 2.367816 #^ 7 #?Shell Ease
Shell Transparency Type #! 0 #?Shell Transparency Type
Shell Transparency ZWrite #! False #?Shell Transparency ZWrite
Shell Cull #! 0 #?Shell Cull
Shells ZWrite #! False #?Shells ZWrite
Shells Use Transparency #! True #?Shells Use Transparency
Shell Blend Mode #! 1 #?Shell Blend Mode
Shells Transparency #! 1 #?Shells Transparency
Shell Lighting #! False #?Shell Lighting
Shell Front #! False #?Shell Front
Parallax On #! False #?Parallax On
Parallax Height #! 0.1 #?Parallax Height
Parallax Quality #! 10 #?Parallax Quality
Silhouette Clipping #! False #?Silhouette Clipping
BeginShaderLayerList
LayerListUniqueName #! Mask0 #?LayerListUniqueName
LayerListName #! Mask0 #?LayerListName
Is Mask #! True #?Is Mask
EndTag #! r #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Diffuse #?LayerListUniqueName
LayerListName #! Diffuse #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgb #?EndTag
BeginShaderLayer
Layer Name #! Texture 2 #?Layer Name
Layer Type #! 3 #?Layer Type
Main Color #! 0.8,0.8,0.8,1 #?Main Color
Second Color #! 0,0,0,1 #?Second Color
Main Texture #! 9f3187bc2c72c9842b24739d8ab2a1ed #^ 0 #?Main Texture
Cubemap #!  #?Cubemap
Noise Type #! 0 #?Noise Type
Noise Dimensions #! 0 #?Noise Dimensions
Use Alpha #! False #?Use Alpha
UV Map #! 0 #?UV Map
Mix Amount #! 1 #?Mix Amount
Mix Type #! 0 #?Mix Type
Stencil #! -1 #?Stencil
Vertex Mask #! 2 #?Vertex Mask
EndShaderLayer
BeginShaderLayer
Layer Name #! Texture2 2 #?Layer Name
Layer Type #! 0 #?Layer Type
Main Color #! 1,1,1,1 #^ 1 #?Main Color
Second Color #! 0,0,0,1 #?Second Color
Main Texture #!  #?Main Texture
Cubemap #!  #?Cubemap
Noise Type #! 0 #?Noise Type
Noise Dimensions #! 0 #?Noise Dimensions
Use Alpha #! False #?Use Alpha
UV Map #! 0 #?UV Map
Mix Amount #! 1 #?Mix Amount
Mix Type #! 3 #?Mix Type
Stencil #! -1 #?Stencil
Vertex Mask #! 2 #?Vertex Mask
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! ShellDiffuse #?LayerListUniqueName
LayerListName #! Diffuse #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgb #?EndTag
BeginShaderLayer
Layer Name #! Texture #?Layer Name
Layer Type #! 0 #?Layer Type
Main Color #! 0,0.462069,1,1 #^ 4 #?Main Color
Second Color #! 0,0,0,1 #?Second Color
Main Texture #!  #?Main Texture
Cubemap #!  #?Cubemap
Noise Type #! 0 #?Noise Type
Noise Dimensions #! 0 #?Noise Dimensions
Use Alpha #! False #?Use Alpha
UV Map #! 0 #?UV Map
Mix Amount #! 1 #?Mix Amount
Mix Type #! 0 #?Mix Type
Stencil #! -1 #?Stencil
Vertex Mask #! 2 #?Vertex Mask
BeginShaderEffect
TypeS #! SSEMathMul #?TypeS
IsVisible #! True #?IsVisible
UseAlpha #! 0 #?UseAlpha
Multiply #! 0.04 #^ 6 #?Multiply
EndShaderEffect
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Alpha #?LayerListUniqueName
LayerListName #! Alpha #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! a #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! ShellAlpha #?LayerListUniqueName
LayerListName #! Alpha #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! a #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Specular #?LayerListUniqueName
LayerListName #! Specular #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgb #?EndTag
BeginShaderLayer
Layer Name #! Specular #?Layer Name
Layer Type #! 0 #?Layer Type
Main Color #! 0.08088237,0.08088237,0.08088237,1 #^ 3 #?Main Color
Second Color #! 0,0,0,1 #?Second Color
Main Texture #!  #?Main Texture
Cubemap #!  #?Cubemap
Noise Type #! 0 #?Noise Type
Noise Dimensions #! 0 #?Noise Dimensions
Use Alpha #! False #?Use Alpha
UV Map #! 0 #?UV Map
Mix Amount #! 1 #?Mix Amount
Mix Type #! 0 #?Mix Type
Stencil #! -1 #?Stencil
Vertex Mask #! 2 #?Vertex Mask
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! ShellSpecular #?LayerListUniqueName
LayerListName #! Specular #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgb #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Normals #?LayerListUniqueName
LayerListName #! Normals #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgb #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! ShellNormals #?LayerListUniqueName
LayerListName #! Normals #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgb #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Emission #?LayerListUniqueName
LayerListName #! Emission #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgba #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! ShellEmission #?LayerListUniqueName
LayerListName #! Emission #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgba #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Height #?LayerListUniqueName
LayerListName #! Height #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! a #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! Vertex #?LayerListUniqueName
LayerListName #! Vertex #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgba #?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName #! ShellVertex #?LayerListUniqueName
LayerListName #! Vertex #?LayerListName
Is Mask #! False #?Is Mask
EndTag #! rgba #?EndTag
EndShaderLayerList
EndShaderBase
EndShaderParse
*/
