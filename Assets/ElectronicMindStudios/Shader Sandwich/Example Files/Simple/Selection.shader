// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Shader Sandwich/Simple/Selection" {//The Shaders Name
//The inputs shown in the material panel
Properties {
	[HideInInspector]Texcoord ("Generic UV Coords (You shouldn't be seeing this aaaaah!)", 2D) = "white" {}
	_Color ("Color", Color) = (0.4779412,0.4779412,0.4779412,1)
	_MainTex ("Texture", 2D) = "white" {}
	_SSSOutline_Color ("Outline Color", Color) = (1,0.6685237,0,1)
	_ShellDistance ("Outline Distance", Range(0.000000000,1.000000000)) = 0.038697320
	_SSSRim_Thinness ("Rim Thinness", Float) = 2.680000000
	_SSSWave_Strength ("Wave Strength", Range(0.000000000,1.000000000)) = 0.020661160
	_SSSWave_Scale ("Wave Scale", Float) = 5.920000000
}

SubShader {
	Tags { "RenderType"="Opaque" "Queue"="Transparent" }//A bunch of settings telling Unity a bit about the shader.
	LOD 200
	Pass {
		Name "MASK"
		Tags { }
	ZTest LEqual
	ZWrite On
	ZWrite On
	Blend SrcAlpha One//Standard Transparency (Forward Add Mode)
	Cull Back//Culling specifies which sides of the models faces to hide.
	ColorMask 0

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 2.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define SHADERSANDWICH_MASK
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
				};
			#endif
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = NoiseCloud2D(((((((v.texcoord.xyz.xy+float2(_Time.y/2,0))*float2(_SSSWave_Scale,_SSSWave_Scale)))))*3)*3*1);

			//Blend the layer into the channel using the Add blend mode
				Vertex += ((VertexVertex_Sample1)*float4(v.normal.rgb,1)).rgba*_SSSWave_Strength*Mask0;

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}


fixed4 FragmentShader (v2f_surf IN) : SV_Target {
return fixed4(0,0,0,0);
}		ENDCG
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
	ZTest LEqual
	ZWrite On
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha//Standard Transparency
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 2.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define UNITY_PASS_FORWARDBASE
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
					#if UNITY_SHOULD_SAMPLE_SH
						half3 sh : TEXCOORD3;
					#endif
					SHADOW_COORDS(4)
					UNITY_FOG_COORDS(5)
				};
			#endif
			// with lightmaps:
			#ifndef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
					float4 lmap : TEXCOORD3;
					SHADOW_COORDS(4)
					UNITY_FOG_COORDS(5)
					#ifdef DIRLIGHTMAP_COMBINED
						fixed3 TtoWSpace1 : TEXCOORD6;
						fixed3 TtoWSpace2 : TEXCOORD7;
						fixed3 TtoWSpace3 : TEXCOORD8;
					#endif
				};
			#endif
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = NoiseCloud2D(((((((v.texcoord.xyz.xy+float2(_Time.y/2,0))*float2(_SSSWave_Scale,_SSSWave_Scale)))))*3)*3*1);

			//Blend the layer into the channel using the Add blend mode
				Vertex += ((VertexVertex_Sample1)*float4(v.normal.rgb,1)).rgba*_SSSWave_Strength*Mask0;

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
					#ifndef DYNAMICLIGHTMAP_OFF
						o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				
				// SH/ambient and vertex lights
				#ifdef LIGHTMAP_OFF
					#if UNITY_SHOULD_SAMPLE_SH
						#if UNITY_SAMPLE_FULL_SH_PER_PIXEL
							o.sh = 0;
						#elif (SHADER_TARGET < 30)
							o.sh = ShadeSH9 (float4(worldNormal,1.0));
						#else
							o.sh = ShadeSH3Order (half4(worldNormal, 1.0));
						#endif
						// Add approximated illumination from non-important point lights
						#ifdef VERTEXLIGHT_ON
							o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
					#endif
				#endif // LIGHTMAP_OFF
				
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}



			float4 CalculateLighting(UsefulData d, UnityGI gi){
				float4 c = float4(d.Albedo,d.Alpha);
				float3 cTemp = float3(0,0,0);
				float3 cDiff = float3(1,1,1);
				float3 cAmb = float3(0,0,0);
				float3 cSpec = float3(0,0,0);
			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
				half NdotL = gi.light.ndotl; //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source.
				cDiff = gi.light.color * NdotL; //Output the final RGB color by multiplying the surfaces color with the light color, then by the distance from the light (or some function of it), and finally by the Dot of the normal and the light direction.
				#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
					cAmb = gi.indirect.diffuse;
				#endif



				c.rgb *= cDiff;
				c.rgb += cSpec+(d.Albedo * cAmb);
				return c;
			};

			void CalculateGI (UsefulData d,UnityGIInput data,inout UnityGI gi){
				#if UNITY_VERSION >= 520
					UNITY_GI(gi, d, data);
				#else
					gi = UnityGlobalIllumination (data, 1.0, 0.0, d.Normal);
				#endif
			}

			fixed4 FragmentShader (v2f_surf IN) : SV_Target {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Specular = float3(0.3,0.3,0.3);
				d.Normal = IN.worldNormal;
				d.Alpha = 1;
				d.Occlusion = 1;
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
					d.uv_MainTex = IN.dataToPack0.xy;
				d.uvTexcoord = IN.dataToPack0.zw;
				fixed4 c = 0;
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif
				// compute lighting & shadowing factor
				UNITY_LIGHT_ATTENUATION(atten, IN, d.worldPos)
				
				// Setup lighting environment
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				#if !defined(LIGHTMAP_ON)
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = lightDir;
					gi.light.ndotl = LambertTerm (d.worldNormal, gi.light.dir);
				#endif
				// Call GI (lightmaps/SH/reflections) lighting function
				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = d.worldPos;
				giInput.worldViewDir = d.worldViewDir;
				giInput.atten = atten;
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
					giInput.lightmapUV = IN.lmap;
				#else
					giInput.lightmapUV = 0.0;
				#endif
				#if UNITY_SHOULD_SAMPLE_SH
					giInput.ambient = IN.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
				giInput.probeHDR[0] = unity_SpecCube0_HDR;
				giInput.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
				#endif
				#if UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMax[0] = unity_SpecCube0_BoxMax;
					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
					giInput.boxMax[1] = unity_SpecCube1_BoxMax;
					giInput.boxMin[1] = unity_SpecCube1_BoxMin;
					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				d.Mask0 = Mask0;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture 2
			//Sample parts of the layer:
				half4 Texture_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Set the channel to the new color
				d.Albedo = Texture_2Albedo_Sample1.rgb;

		//Generate Layer: Color
			//Sample parts of the layer:
				half4 ColorAlbedo_Sample1 = _Color;

			//Apply Effects:
				ColorAlbedo_Sample1.rgb = lerp(float3(0.5,0.5,0.5),ColorAlbedo_Sample1.rgb,1.857143);

			//Blend the layer into the channel using the Multiply blend mode
				d.Albedo *= ColorAlbedo_Sample1.rgb;

				d.Alpha-=0;
				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = worldN;
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				CalculateGI(d, giInput, gi);
				c = CalculateLighting (d, gi)+d.Emission;
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				return c;
			}

		ENDCG
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
	ZTest LEqual
	ZWrite On
	ZWrite Off
	Blend SrcAlpha One//Standard Transparency (Forward Add Mode)
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 2.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdadd_fullshadows
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define UNITY_PASS_FORWARDADD
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
				SHADOW_COORDS(3)
				UNITY_FOG_COORDS(4)
			};
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = NoiseCloud2D(((((((v.texcoord.xyz.xy+float2(_Time.y/2,0))*float2(_SSSWave_Scale,_SSSWave_Scale)))))*3)*3*1);

			//Blend the layer into the channel using the Add blend mode
				Vertex += ((VertexVertex_Sample1)*float4(v.normal.rgb,1)).rgba*_SSSWave_Strength*Mask0;

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}



			float4 CalculateLighting(UsefulData d, UnityGI gi){
				float4 c = float4(d.Albedo,d.Alpha);
				float3 cTemp = float3(0,0,0);
				float3 cDiff = float3(0,0,0);
				float3 cAmb = float3(0,0,0);
				float3 cSpec = float3(0,0,0);
			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
				half NdotL = gi.light.ndotl; //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source.
				cDiff = gi.light.color * NdotL; //Output the final RGB color by multiplying the surfaces color with the light color, then by the distance from the light (or some function of it), and finally by the Dot of the normal and the light direction.



				c.rgb *= cDiff;
				c.rgb += cSpec;
				return c;
			};

			void CalculateGI (UsefulData d,UnityGIInput data,inout UnityGI gi){
				#if UNITY_VERSION >= 520
					UNITY_GI(gi, d, data);
				#else
					gi = UnityGlobalIllumination (data, 1.0, 0.0, d.Normal);
				#endif
			}

			fixed4 FragmentShader (v2f_surf IN) : SV_Target {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Specular = float3(0.3,0.3,0.3);
				d.Normal = IN.worldNormal;
				d.Alpha = 1;
				d.Occlusion = 1;
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
					d.uv_MainTex = IN.dataToPack0.xy;
				d.uvTexcoord = IN.dataToPack0.zw;
				fixed4 c = 0;
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif
				// compute lighting & shadowing factor
				UNITY_LIGHT_ATTENUATION(atten, IN, d.worldPos)
				
				// Setup lighting environment
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				#if !defined(LIGHTMAP_ON)
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = lightDir;
					gi.light.ndotl = LambertTerm (d.worldNormal, gi.light.dir);
				#endif
				// Call GI (lightmaps/SH/reflections) lighting function
				UnityGIInput giInput;
				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
				giInput.light = gi.light;
				giInput.worldPos = d.worldPos;
				giInput.worldViewDir = d.worldViewDir;
				giInput.atten = atten;
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
					giInput.lightmapUV = IN.lmap;
				#else
					giInput.lightmapUV = 0.0;
				#endif
				#if UNITY_SHOULD_SAMPLE_SH
					giInput.ambient = IN.sh;
				#else
					giInput.ambient.rgb = 0.0;
				#endif
				giInput.probeHDR[0] = unity_SpecCube0_HDR;
				giInput.probeHDR[1] = unity_SpecCube1_HDR;
				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
				#endif
				#if UNITY_SPECCUBE_BOX_PROJECTION
					giInput.boxMax[0] = unity_SpecCube0_BoxMax;
					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
					giInput.boxMax[1] = unity_SpecCube1_BoxMax;
					giInput.boxMin[1] = unity_SpecCube1_BoxMin;
					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
				#endif
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				d.Mask0 = Mask0;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture 2
			//Sample parts of the layer:
				half4 Texture_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Set the channel to the new color
				d.Albedo = Texture_2Albedo_Sample1.rgb;

		//Generate Layer: Color
			//Sample parts of the layer:
				half4 ColorAlbedo_Sample1 = _Color;

			//Apply Effects:
				ColorAlbedo_Sample1.rgb = lerp(float3(0.5,0.5,0.5),ColorAlbedo_Sample1.rgb,1.857143);

			//Blend the layer into the channel using the Multiply blend mode
				d.Albedo *= ColorAlbedo_Sample1.rgb;

				d.Alpha-=0;
				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = worldN;
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				gi.light.color *= atten;
				c = CalculateLighting (d, gi);
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				return c;
			}

		ENDCG
	}
	Pass {
		Name "MASK"
		Tags { }
	ZTest LEqual
	ZWrite On
	ZWrite On
	Blend One One//Add Blend Mode
	Cull Back//Culling specifies which sides of the models faces to hide.
	ColorMask 0

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define SHADERSANDWICH_MASK
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
				};
			#endif
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}


fixed4 FragmentShader (v2f_surf IN) : SV_Target {
return fixed4(0,0,0,0);
}		ENDCG
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
	ZTest LEqual
	ZWrite On
	ZWrite Off
	Blend One One//Add Blend Mode
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define UNITY_PASS_FORWARDBASE
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
					#if UNITY_SHOULD_SAMPLE_SH
						half3 sh : TEXCOORD3;
					#endif
					SHADOW_COORDS(4)
					UNITY_FOG_COORDS(5)
				};
			#endif
			// with lightmaps:
			#ifndef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
					float4 lmap : TEXCOORD3;
					SHADOW_COORDS(4)
					UNITY_FOG_COORDS(5)
					#ifdef DIRLIGHTMAP_COMBINED
						fixed3 TtoWSpace1 : TEXCOORD6;
						fixed3 TtoWSpace2 : TEXCOORD7;
						fixed3 TtoWSpace3 : TEXCOORD8;
					#endif
				};
			#endif
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				#ifndef LIGHTMAP_OFF
					#ifndef DYNAMICLIGHTMAP_OFF
						o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				
				// SH/ambient and vertex lights
				#ifdef LIGHTMAP_OFF
					#if UNITY_SHOULD_SAMPLE_SH
						#if UNITY_SAMPLE_FULL_SH_PER_PIXEL
							o.sh = 0;
						#elif (SHADER_TARGET < 30)
							o.sh = ShadeSH9 (float4(worldNormal,1.0));
						#else
							o.sh = ShadeSH3Order (half4(worldNormal, 1.0));
						#endif
						// Add approximated illumination from non-important point lights
						#ifdef VERTEXLIGHT_ON
							o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
					#endif
				#endif // LIGHTMAP_OFF
				
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}




			fixed4 FragmentShader (v2f_surf IN) : SV_Target {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Specular = float3(0.3,0.3,0.3);
				d.Normal = IN.worldNormal;
				d.Alpha = 1;
				d.Occlusion = 1;
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
					d.uv_MainTex = IN.dataToPack0.xy;
				d.uvTexcoord = IN.dataToPack0.zw;
				fixed4 c = 0;
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				d.Mask0 = Mask0;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = lerp(float4(0, 0, 0, 1), _SSSOutline_Color, (((1-(dot(d.Normal, d.viewDir))))));

			//Apply Effects:
				Texture_2_2Albedo_Sample1.rgb = pow(Texture_2_2Albedo_Sample1.rgb,_SSSRim_Thinness);

			//Set the channel to the new color
				d.Albedo = Texture_2_2Albedo_Sample1.rgb;

				d.Alpha-=0;
				c = float4(d.Albedo+d.Emission.rgb,d.Alpha);
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				c *= d.Alpha;
				return c;
			}

		ENDCG
	}
	Pass {
		Name "MASK"
		Tags { }
	ZTest LEqual
	ZWrite On
	ZWrite On
	Blend One One//Add Blend Mode
	Cull Back//Culling specifies which sides of the models faces to hide.
	ColorMask 0

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define SHADERSANDWICH_MASK
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
				};
			#endif
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 1;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(1,1.022989));
				o.pos = UnityObjectToClipPos (Vertex);
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}


fixed4 FragmentShader (v2f_surf IN) : SV_Target {
return fixed4(0,0,0,0);
}		ENDCG
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
	ZTest LEqual
	ZWrite On
	ZWrite Off
	Blend One One//Add Blend Mode
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define UNITY_PASS_FORWARDBASE
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal

			//Make our inputs accessible by declaring them here.
				float4 _Color;
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _SSSOutline_Color;
				float _ShellDistance;
				float _SSSRim_Thinness;
				float _SSSWave_Strength;
				float _SSSWave_Scale;

			struct UsefulData{
				float3 Albedo;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
					#if UNITY_SHOULD_SAMPLE_SH
						half3 sh : TEXCOORD3;
					#endif
					SHADOW_COORDS(4)
					UNITY_FOG_COORDS(5)
				};
			#endif
			// with lightmaps:
			#ifndef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float4 dataToPack0 : TEXCOORD2;
					float4 lmap : TEXCOORD3;
					SHADOW_COORDS(4)
					UNITY_FOG_COORDS(5)
					#ifdef DIRLIGHTMAP_COMBINED
						fixed3 TtoWSpace1 : TEXCOORD6;
						fixed3 TtoWSpace2 : TEXCOORD7;
						fixed3 TtoWSpace3 : TEXCOORD8;
					#endif
				};
			#endif
			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.
			struct appdata_min {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				fixed4 color : COLOR;
			};











float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
}












			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.dataToPack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.dataToPack0.zw = v.texcoord;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 1;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(1,1.022989));
				o.pos = UnityObjectToClipPos (Vertex);
				#ifndef LIGHTMAP_OFF
					#ifndef DYNAMICLIGHTMAP_OFF
						o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				
				// SH/ambient and vertex lights
				#ifdef LIGHTMAP_OFF
					#if UNITY_SHOULD_SAMPLE_SH
						#if UNITY_SAMPLE_FULL_SH_PER_PIXEL
							o.sh = 0;
						#elif (SHADER_TARGET < 30)
							o.sh = ShadeSH9 (float4(worldNormal,1.0));
						#else
							o.sh = ShadeSH3Order (half4(worldNormal, 1.0));
						#endif
						// Add approximated illumination from non-important point lights
						#ifdef VERTEXLIGHT_ON
							o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
					#endif
				#endif // LIGHTMAP_OFF
				
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}




			fixed4 FragmentShader (v2f_surf IN) : SV_Target {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Specular = float3(0.3,0.3,0.3);
				d.Normal = IN.worldNormal;
				d.Alpha = 1;
				d.Occlusion = 1;
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.ShellDepth = 1-1;
				float ShellDepth = d.ShellDepth;
					d.uv_MainTex = IN.dataToPack0.xy;
				d.uvTexcoord = IN.dataToPack0.zw;
				fixed4 c = 0;
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0
			//Sample parts of the layer:
				half4 Mask0Mask0_Sample1 = float4(0, 0, 0, 1);

			//Set the mask to the new color
				Mask0 = Mask0Mask0_Sample1.r;

		//Generate Layer: Mask02
			//Sample parts of the layer:
				half4 Mask02Mask0_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Mix blend mode
				Mask0 = lerp(Mask0,Mask02Mask0_Sample1.r,ShellDepth);

				d.Mask0 = Mask0;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = lerp(float4(0, 0, 0, 1), _SSSOutline_Color, (((1-(dot(d.Normal, d.viewDir))))));

			//Apply Effects:
				Texture_2_2Albedo_Sample1.rgb = pow(Texture_2_2Albedo_Sample1.rgb,_SSSRim_Thinness);

			//Set the channel to the new color
				d.Albedo = Texture_2_2Albedo_Sample1.rgb;

				d.Alpha-=0;
				c = float4(d.Albedo+d.Emission.rgb,d.Alpha);
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				c *= d.Alpha;
				return c;
			}

		ENDCG
	}
}

Fallback "VertexLit"
}

/*
BeginShaderParse
2.0
BeginShaderBase
BeginShaderInput
Type#!S2#^Float#^1#^CC0#?Type
VisName#!S2#^Text#^Color#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.4779412,0.4779412,0.4779412,1#^CC0#?Color
Number#!S2#^Float#^0#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^1#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_Color#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^0#^CC0#?Type
VisName#!S2#^Text#^Texture#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^0#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^2#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_MainTex#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^1#^CC0#?Type
VisName#!S2#^Text#^Outline Color#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^1,0.6685237,0,1#^CC0#?Color
Number#!S2#^Float#^0#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSOutline_Color#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Outline Distance#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
Number#!S2#^Float#^0.03869732#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^11#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_ShellDistance#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^3#^CC0#?Type
VisName#!S2#^Text#^Rim Thinness#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
Number#!S2#^Float#^2.68#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSRim_Thinness#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Wave Strength#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
Number#!S2#^Float#^0.02066116#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSWave_Strength#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^3#^CC0#?Type
VisName#!S2#^Text#^Wave Scale#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
Number#!S2#^Float#^5.92#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSWave_Scale#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Mask02 - Mix Amount#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
Number#!S2#^Float#^1#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^11#^CC0#?SpecialType
InEditor#!S2#^Float#^0#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSMask02_aMix_Amount#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^3#^CC0#?Type
VisName#!S2#^Text#^Vertex - X Offset#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
Number#!S2#^Float#^72.31738#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^3#^CC0#?SpecialType
InEditor#!S2#^Float#^0#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSVertex_aX_Offset#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
ShaderName#!S2#^Text#^Shader Sandwich/Simple/Selection#^CC0#?ShaderName
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Queue#!S2#^Type#^3#^CC0#?Queue
QueueAuto#!S2#^Toggle#^True#^CC0#?QueueAuto
Tech Shader Target#!S2#^Float#^2#^CC0#?Tech Shader Target
Vertex Recalculation#!S2#^Toggle#^False#^CC0#?Vertex Recalculation
Use Fog#!S2#^Toggle#^True#^CC0#?Use Fog
Use Ambient#!S2#^Toggle#^True#^CC0#?Use Ambient
Use Vertex Lights#!S2#^Toggle#^True#^CC0#?Use Vertex Lights
Use Lightmaps#!S2#^Toggle#^True#^CC0#?Use Lightmaps
Use All Shadows#!S2#^Toggle#^True#^CC0#?Use All Shadows
Forward Add#!S2#^Toggle#^True#^CC0#?Forward Add
Shadows#!S2#^Toggle#^True#^CC0#?Shadows
Interpolate View#!S2#^Toggle#^False#^CC0#?Interpolate View
Half as View#!S2#^Toggle#^False#^CC0#?Half as View
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^0#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
Use Normals#!S2#^Float#^0#^CC0#?Use Normals
Specular On#!S2#^Toggle#^False#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.3#^CC0#?Spec Hardness
Spec Energy Conserve#!S2#^Toggle#^True#^CC0#?Spec Energy Conserve
Spec Offset#!S2#^Float#^0#^CC0#?Spec Offset
Emission On#!S2#^Toggle#^False#^CC0#?Emission On
Emission Type#!S2#^Type#^0#^CC0#?Emission Type
Transparency On#!S2#^Toggle#^True#^CC0#?Transparency On
Transparency Type#!S2#^Type#^1#^CC0#?Transparency Type
ZWrite#!S2#^Toggle#^True#^CC0#?ZWrite
Use PBR#!S2#^Toggle#^True#^CC0#?Use PBR
Transparency#!S2#^Float#^1#^CC0#?Transparency
Receive Shadows#!S2#^Toggle#^False#^CC0#?Receive Shadows
ZWrite Type#!S2#^Type#^0#^CC0#?ZWrite Type
Blend Mode#!S2#^Type#^0#^CC0#?Blend Mode
Shells On#!S2#^Toggle#^True#^CC0#?Shells On
Shell Count#!S2#^Float#^1#^CC0#?Shell Count
Shells Distance#!S2#^Float#^0.03869732#^CC0 #^ 3#?Shells Distance
Shell Ease#!S2#^Float#^1.022989#^CC0#?Shell Ease
Shell Transparency Type#!S2#^Type#^0#^CC0#?Shell Transparency Type
Shell Transparency ZWrite#!S2#^Toggle#^False#^CC0#?Shell Transparency ZWrite
Shell Cull#!S2#^Type#^1#^CC0#?Shell Cull
Shells ZWrite#!S2#^Toggle#^False#^CC0#?Shells ZWrite
Shells Use Transparency#!S2#^Toggle#^True#^CC0#?Shells Use Transparency
Shell Blend Mode#!S2#^Type#^1#^CC0#?Shell Blend Mode
Shells Transparency#!S2#^Float#^1#^CC0#?Shells Transparency
Shell Lighting#!S2#^Toggle#^False#^CC0#?Shell Lighting
Shell Front#!S2#^Toggle#^True#^CC0#?Shell Front
Parallax On#!S2#^Toggle#^False#^CC0#?Parallax On
Parallax Height#!S2#^Float#^0.1#^CC0#?Parallax Height
Parallax Quality#!S2#^Float#^10#^CC0#?Parallax Quality
Silhouette Clipping#!S2#^Toggle#^False#^CC0#?Silhouette Clipping
Tessellation On#!S2#^Toggle#^False#^CC0#?Tessellation On
Tessellation Type#!S2#^Type#^2#^CC0#?Tessellation Type
Tessellation Quality#!S2#^Float#^10#^CC0#?Tessellation Quality
Tessellation Falloff#!S2#^Float#^1#^CC0#?Tessellation Falloff
Tessellation Smoothing Amount#!S2#^Float#^0#^CC0#?Tessellation Smoothing Amount
BeginMasks
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Mask0#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Mask0#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^True#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^r#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Mask0#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0,0,0,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^#^CC0#?Main Texture
NCubemap#!S2#^Cubemap#^#^CC0#?NCubemap
Noise Type#!S2#^Type#^0#^CC0#?Noise Type
NNoise Dimensions#!S2#^Type#^0#^CC0#?NNoise Dimensions
Noise A#!S2#^Float#^0#^CC0#?Noise A
Noise B#!S2#^Float#^1#^CC0#?Noise B
Noise C#!S2#^Toggle#^False#^CC0#?Noise C
Light Data#!S2#^Type#^0#^CC0#?Light Data
Special Type#!S2#^Type#^0#^CC0#?Special Type
Linearize Depth#!S2#^Toggle#^False#^CC0#?Linearize Depth
UV Map#!S2#^Type#^0#^CC0#?UV Map
Map Local#!S2#^Toggle#^False#^CC0#?Map Local
Use Alpha#!S2#^Toggle#^False#^CC0#?Use Alpha
Mix Amount#!S2#^Float#^1#^CC0#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^0#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0,0,0,1#^CC0#?Color
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
EndShaderLayer
BeginShaderLayer
Layer Name#!S2#^Text#^Mask02#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^1,1,1,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^#^CC0#?Main Texture
NCubemap#!S2#^Cubemap#^#^CC0#?NCubemap
Noise Type#!S2#^Type#^0#^CC0#?Noise Type
NNoise Dimensions#!S2#^Type#^0#^CC0#?NNoise Dimensions
Noise A#!S2#^Float#^0#^CC0#?Noise A
Noise B#!S2#^Float#^1#^CC0#?Noise B
Noise C#!S2#^Toggle#^False#^CC0#?Noise C
Light Data#!S2#^Type#^0#^CC0#?Light Data
Special Type#!S2#^Type#^0#^CC0#?Special Type
Linearize Depth#!S2#^Toggle#^False#^CC0#?Linearize Depth
UV Map#!S2#^Type#^0#^CC0#?UV Map
Map Local#!S2#^Toggle#^False#^CC0#?Map Local
Use Alpha#!S2#^Toggle#^False#^CC0#?Use Alpha
Mix Amount#!S2#^Float#^1#^CC0 #^ 7#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^0#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^1,1,1,1#^CC0#?Color
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Mask1#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Ambient#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^True#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Mask2#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Direct#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^True#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
EndShaderLayerList
EndMasks
BeginShaderPass
Name#!S2#^Text#^Base#^CC0#?Name
Visible#!S2#^Toggle#^True#^CC0#?Visible
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Ztest#!S2#^Type#^3#^CC0#?Ztest
Tech Shader Target#!S2#^Float#^2#^CC0#?Tech Shader Target
Vertex Recalculation#!S2#^Toggle#^False#^CC0#?Vertex Recalculation
Use Fog#!S2#^Toggle#^True#^CC0#?Use Fog
Use Ambient#!S2#^Toggle#^True#^CC0#?Use Ambient
Use Vertex Lights#!S2#^Toggle#^True#^CC0#?Use Vertex Lights
Use Lightmaps#!S2#^Toggle#^True#^CC0#?Use Lightmaps
Use All Shadows#!S2#^Toggle#^True#^CC0#?Use All Shadows
Forward Add#!S2#^Toggle#^True#^CC0#?Forward Add
Shadows#!S2#^Toggle#^True#^CC0#?Shadows
Interpolate View#!S2#^Toggle#^False#^CC0#?Interpolate View
Recalculate After Vertex#!S2#^Toggle#^True#^CC0#?Recalculate After Vertex
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^1#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
PBR Quality#!S2#^Type#^0#^CC0#?PBR Quality
Disable Normals#!S2#^Float#^0#^CC0#?Disable Normals
Specular On#!S2#^Toggle#^False#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.3#^CC0#?Spec Hardness
Spec Energy Conserve#!S2#^Toggle#^True#^CC0#?Spec Energy Conserve
Spec Offset#!S2#^Float#^0#^CC0#?Spec Offset
Emission On#!S2#^Toggle#^False#^CC0#?Emission On
Emission Type#!S2#^Type#^2#^CC0#?Emission Type
Transparency On#!S2#^Toggle#^True#^CC0#?Transparency On
Transparency Type#!S2#^Type#^1#^CC0#?Transparency Type
ZWrite#!S2#^Toggle#^True#^CC0#?ZWrite
Use PBR#!S2#^Toggle#^True#^CC0#?Use PBR
Transparency#!S2#^Float#^0#^CC0#?Transparency
CutoffZWriteTransparency#!S2#^Float#^0#^CC0#?CutoffZWriteTransparency
Receive Shadows#!S2#^Toggle#^False#^CC0#?Receive Shadows
ZWrite Type#!S2#^Type#^0#^CC0#?ZWrite Type
Blend Mode#!S2#^Type#^0#^CC0#?Blend Mode
Shells On#!S2#^Toggle#^False#^CC0#?Shells On
Shell Count#!S2#^Float#^1#^CC0#?Shell Count
Shells Distance#!S2#^Float#^0.03869732#^CC0 #^ 3#?Shells Distance
Shell Ease#!S2#^Float#^1.022989#^CC0#?Shell Ease
Shells ZWrite#!S2#^Toggle#^False#^CC0#?Shells ZWrite
Shell Front#!S2#^Toggle#^True#^CC0#?Shell Front
Shell Skip First#!S2#^Toggle#^True#^CC0#?Shell Skip First
Parallax On#!S2#^Toggle#^False#^CC0#?Parallax On
Parallax Height#!S2#^Float#^0.1#^CC0#?Parallax Height
Parallax Quality#!S2#^Float#^10#^CC0#?Parallax Quality
Silhouette Clipping#!S2#^Toggle#^False#^CC0#?Silhouette Clipping
Parallax Shadows#!S2#^Toggle#^False#^CC0#?Parallax Shadows
Parallax Shadow Strength#!S2#^Float#^1#^CC0#?Parallax Shadow Strength
Parallax Shadow Size#!S2#^Float#^1#^CC0#?Parallax Shadow Size
Tessellation On#!S2#^Toggle#^False#^CC0#?Tessellation On
Tessellation Type#!S2#^Type#^2#^CC0#?Tessellation Type
Tessellation Quality#!S2#^Float#^10#^CC0#?Tessellation Quality
Tessellation Falloff#!S2#^Float#^1#^CC0#?Tessellation Falloff
Tessellation Smoothing Amount#!S2#^Float#^0#^CC0#?Tessellation Smoothing Amount
Tessellation Toplogy#!S2#^Type#^0#^CC0#?Tessellation Toplogy
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Albedo#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Diffuse#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Texture 2#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTTexture#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^3#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.627451,0.8,0.8823529,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^  #^CC0 #^ 1#?Main Texture
NCubemap#!S2#^Cubemap#^#^CC0#?NCubemap
Noise Type#!S2#^Type#^0#^CC0#?Noise Type
NNoise Dimensions#!S2#^Type#^0#^CC0#?NNoise Dimensions
Noise A#!S2#^Float#^0#^CC0#?Noise A
Noise B#!S2#^Float#^1#^CC0#?Noise B
Noise C#!S2#^Toggle#^False#^CC0#?Noise C
Light Data#!S2#^Type#^0#^CC0#?Light Data
Special Type#!S2#^Type#^0#^CC0#?Special Type
Linearize Depth#!S2#^Toggle#^False#^CC0#?Linearize Depth
UV Map#!S2#^Type#^0#^CC0#?UV Map
Map Local#!S2#^Toggle#^False#^CC0#?Map Local
Use Alpha#!S2#^Toggle#^False#^CC0#?Use Alpha
Mix Amount#!S2#^Float#^1#^CC0#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^0#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0.627451,0.8,0.8823529,1#^CC0#?Color
Texture#!S2#^Texture#^#^CC0 #^ 1#?Texture
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
EndShaderLayer
BeginShaderLayer
Layer Name#!S2#^Text#^Color#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.4779412,0.4779412,0.4779412,1#^CC0 #^ 0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^#^CC0#?Main Texture
NCubemap#!S2#^Cubemap#^#^CC0#?NCubemap
Noise Type#!S2#^Type#^0#^CC0#?Noise Type
NNoise Dimensions#!S2#^Type#^0#^CC0#?NNoise Dimensions
Noise A#!S2#^Float#^0#^CC0#?Noise A
Noise B#!S2#^Float#^1#^CC0#?Noise B
Noise C#!S2#^Toggle#^False#^CC0#?Noise C
Light Data#!S2#^Type#^0#^CC0#?Light Data
Special Type#!S2#^Type#^0#^CC0#?Special Type
Linearize Depth#!S2#^Toggle#^False#^CC0#?Linearize Depth
UV Map#!S2#^Type#^0#^CC0#?UV Map
Map Local#!S2#^Toggle#^False#^CC0#?Map Local
Use Alpha#!S2#^Toggle#^False#^CC0#?Use Alpha
Mix Amount#!S2#^Float#^1#^CC0#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^3#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0.4779412,0.4779412,0.4779412,1#^CC0 #^ 0#?Color
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEContrast#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Contrast#!S2#^Float#^1.857143#^CC0#?Contrast
EndShaderEffect
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Alpha#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Alpha#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^a#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Specular#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Specular#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Normals#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Normals#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Emission#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Emission#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Height#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Height#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^a#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Vertex#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Vertex#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Vertex#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTCloudNoise#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^5#^CC0#?Layer Type
Main Color#!S2#^Vec#^1,1,1,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^#^CC0#?Main Texture
NCubemap#!S2#^Cubemap#^#^CC0#?NCubemap
Noise Type#!S2#^Type#^1#^CC0#?Noise Type
NNoise Dimensions#!S2#^Type#^0#^CC0#?NNoise Dimensions
Noise A#!S2#^Float#^0#^CC0#?Noise A
Noise B#!S2#^Float#^1#^CC0#?Noise B
Noise C#!S2#^Toggle#^False#^CC0#?Noise C
Light Data#!S2#^Type#^0#^CC0#?Light Data
Special Type#!S2#^Type#^0#^CC0#?Special Type
Linearize Depth#!S2#^Toggle#^False#^CC0#?Linearize Depth
UV Map#!S2#^Type#^0#^CC0#?UV Map
Map Local#!S2#^Toggle#^False#^CC0#?Map Local
Use Alpha#!S2#^Toggle#^False#^CC0#?Use Alpha
Mix Amount#!S2#^Float#^0.02066116#^CC0 #^ 5#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^1#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^0#^CC0#?Stencil
Vertex Mask#!S2#^Float#^1#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^1,1,1,1#^CC0#?Color
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEUVOffset#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
X Offset#!S2#^Float#^72.31738#^CC0 #^ 8#?X Offset
Y Offset#!S2#^Float#^0#^CC0#?Y Offset
Z Offset#!S2#^Float#^0#^CC0#?Z Offset
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEUVScale#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Seperate#!S2#^Toggle#^False#^CC0#?Seperate
Scale#!S2#^Float#^5.92#^CC0 #^ 6#?Scale
Y Scale#!S2#^Float#^5.92#^CC0 #^ 6#?Y Scale
Z Scale#!S2#^Float#^5.92#^CC0 #^ 6#?Z Scale
EndShaderEffect
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingDiffuse#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Diffuse#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingSpecular#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Specular#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingIndirect#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Ambient#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingDirect#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Direct#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
EndShaderPass
BeginShaderPass
Name#!S2#^Text#^Shells#^CC0#?Name
Visible#!S2#^Toggle#^True#^CC0#?Visible
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Ztest#!S2#^Type#^3#^CC0#?Ztest
Tech Shader Target#!S2#^Float#^3#^CC0#?Tech Shader Target
Vertex Recalculation#!S2#^Toggle#^False#^CC0#?Vertex Recalculation
Use Fog#!S2#^Toggle#^True#^CC0#?Use Fog
Use Ambient#!S2#^Toggle#^True#^CC0#?Use Ambient
Use Vertex Lights#!S2#^Toggle#^True#^CC0#?Use Vertex Lights
Use Lightmaps#!S2#^Toggle#^True#^CC0#?Use Lightmaps
Use All Shadows#!S2#^Toggle#^True#^CC0#?Use All Shadows
Forward Add#!S2#^Toggle#^True#^CC0#?Forward Add
Shadows#!S2#^Toggle#^True#^CC0#?Shadows
Interpolate View#!S2#^Toggle#^False#^CC0#?Interpolate View
Recalculate After Vertex#!S2#^Toggle#^True#^CC0#?Recalculate After Vertex
Diffuse On#!S2#^Toggle#^False#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^1#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
PBR Quality#!S2#^Type#^0#^CC0#?PBR Quality
Disable Normals#!S2#^Float#^0#^CC0#?Disable Normals
Specular On#!S2#^Toggle#^False#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.3#^CC0#?Spec Hardness
Spec Energy Conserve#!S2#^Toggle#^True#^CC0#?Spec Energy Conserve
Spec Offset#!S2#^Float#^0#^CC0#?Spec Offset
Emission On#!S2#^Toggle#^False#^CC0#?Emission On
Emission Type#!S2#^Type#^0#^CC0#?Emission Type
Transparency On#!S2#^Toggle#^True#^CC0#?Transparency On
Transparency Type#!S2#^Type#^1#^CC0#?Transparency Type
ZWrite#!S2#^Toggle#^True#^CC0#?ZWrite
Use PBR#!S2#^Toggle#^True#^CC0#?Use PBR
Transparency#!S2#^Float#^0#^CC0#?Transparency
CutoffZWriteTransparency#!S2#^Float#^0#^CC0#?CutoffZWriteTransparency
Receive Shadows#!S2#^Toggle#^False#^CC0#?Receive Shadows
ZWrite Type#!S2#^Type#^0#^CC0#?ZWrite Type
Blend Mode#!S2#^Type#^1#^CC0#?Blend Mode
Shells On#!S2#^Toggle#^True#^CC0#?Shells On
Shell Count#!S2#^Float#^1#^CC0#?Shell Count
Shells Distance#!S2#^Float#^0.03869732#^CC0 #^ 3#?Shells Distance
Shell Ease#!S2#^Float#^1.022989#^CC0#?Shell Ease
Shells ZWrite#!S2#^Toggle#^False#^CC0#?Shells ZWrite
Shell Front#!S2#^Toggle#^True#^CC0#?Shell Front
Shell Skip First#!S2#^Toggle#^False#^CC0#?Shell Skip First
Parallax On#!S2#^Toggle#^False#^CC0#?Parallax On
Parallax Height#!S2#^Float#^0.1#^CC0#?Parallax Height
Parallax Quality#!S2#^Float#^10#^CC0#?Parallax Quality
Silhouette Clipping#!S2#^Toggle#^False#^CC0#?Silhouette Clipping
Parallax Shadows#!S2#^Toggle#^False#^CC0#?Parallax Shadows
Parallax Shadow Strength#!S2#^Float#^1#^CC0#?Parallax Shadow Strength
Parallax Shadow Size#!S2#^Float#^1#^CC0#?Parallax Shadow Size
Tessellation On#!S2#^Toggle#^False#^CC0#?Tessellation On
Tessellation Type#!S2#^Type#^2#^CC0#?Tessellation Type
Tessellation Quality#!S2#^Float#^10#^CC0#?Tessellation Quality
Tessellation Falloff#!S2#^Float#^1#^CC0#?Tessellation Falloff
Tessellation Smoothing Amount#!S2#^Float#^0#^CC0#?Tessellation Smoothing Amount
Tessellation Toplogy#!S2#^Type#^0#^CC0#?Tessellation Toplogy
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Albedo#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Diffuse#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Texture 2 2#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTGradient#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^1#^CC0#?Layer Type
Main Color#!S2#^Vec#^1,0.6685237,0,1#^CC0 #^ 2#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^#^CC0#?Main Texture
NCubemap#!S2#^Cubemap#^#^CC0#?NCubemap
Noise Type#!S2#^Type#^0#^CC0#?Noise Type
NNoise Dimensions#!S2#^Type#^0#^CC0#?NNoise Dimensions
Noise A#!S2#^Float#^0#^CC0#?Noise A
Noise B#!S2#^Float#^1#^CC0#?Noise B
Noise C#!S2#^Toggle#^False#^CC0#?Noise C
Light Data#!S2#^Type#^0#^CC0#?Light Data
Special Type#!S2#^Type#^0#^CC0#?Special Type
Linearize Depth#!S2#^Toggle#^False#^CC0#?Linearize Depth
UV Map#!S2#^Type#^4#^CC0#?UV Map
Map Local#!S2#^Toggle#^False#^CC0#?Map Local
Use Alpha#!S2#^Toggle#^False#^CC0#?Use Alpha
Mix Amount#!S2#^Float#^1#^CC0#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^0#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^1,0.6685237,0,1#^CC0 #^ 2#?Color A
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color B
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEMathPow#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Power#!S2#^Float#^2.68#^CC0 #^ 4#?Power
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEUVFlip#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
X Flip#!S2#^Toggle#^True#^CC0#?X Flip
Y Flip#!S2#^Toggle#^False#^CC0#?Y Flip
Z Flip#!S2#^Toggle#^False#^CC0#?Z Flip
EndShaderEffect
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Alpha#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Alpha#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^a#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Specular#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Specular#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Normals#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Normals#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Emission#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Emission#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Height#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Height#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^a#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Vertex#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Vertex#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingDiffuse#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Diffuse#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingSpecular#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Specular#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingIndirect#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Ambient#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^LightingDirect#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Direct#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^True#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
EndShaderLayerList
EndShaderPass
EndShaderBase
EndShaderParse
*/
