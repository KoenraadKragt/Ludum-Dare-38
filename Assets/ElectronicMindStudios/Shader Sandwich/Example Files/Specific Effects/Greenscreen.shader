// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Shader Sandwich/Specific/Greenscreen" {//The Shaders Name
//The inputs shown in the material panel
Properties {
	_MainTex ("Texture", 2D) = "white" {}
	_SSSGreen_Despill ("Green Despill", Range(0.000000000,1.000000000)) = 1.000000000
	_SSSBias ("Bias", Range(0.000000000,-1.000000000)) = -0.281250000
	_SSSHardness ("Hardness", Range(1.000000000,20.000000000)) = 10.500000000
}

SubShader {
	Tags { "RenderType"="Opaque" "Queue"="Transparent" }//A bunch of settings telling Unity a bit about the shader.
	LOD 200
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _SSSGreen_Despill;
				float _SSSBias;
				float _SSSHardness;

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
				float ShellDepth;
				float Mask0;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float2 uv_MainTex: TEXCOORD1;
					#if UNITY_SHOULD_SAMPLE_SH
						half3 sh : TEXCOORD2;
					#endif
					SHADOW_COORDS(3)
					UNITY_FOG_COORDS(4)
				};
			#endif
			// with lightmaps:
			#ifndef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float2 uv_MainTex: TEXCOORD1;
					float4 lmap : TEXCOORD2;
					SHADOW_COORDS(3)
					UNITY_FOG_COORDS(4)
					#ifdef DIRLIGHTMAP_COMBINED
						fixed3 TtoWSpace1 : TEXCOORD5;
						fixed3 TtoWSpace2 : TEXCOORD6;
						fixed3 TtoWSpace3 : TEXCOORD7;
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













			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the Mask0 channel.
		//Generate Layer: Mask0 Copy Copy
			//Sample parts of the layer:
				half4 Mask0_Copy_CopyMask0_Sample1 = tex2Dlod(_MainTex,float4((((v.texcoord.xyz.xy))),0,0));

			//Apply Effects:
				Mask0_Copy_CopyMask0_Sample1.rgb = float4(dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)));

			//Set the mask to the new color
				Mask0 = Mask0_Copy_CopyMask0_Sample1.r;

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
				d.Alpha = 1;
				d.Occlusion = 1;
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
					d.uv_MainTex = IN.uv_MainTex;
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
		//Generate Layer: Mask0 Copy Copy
			//Sample parts of the layer:
				half4 Mask0_Copy_CopyMask0_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Apply Effects:
				Mask0_Copy_CopyMask0_Sample1.rgb = float4(dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_Copy_CopyMask0_Sample1.rgb,float3(-0.39,1,-0.59)));

			//Set the mask to the new color
				Mask0 = Mask0_Copy_CopyMask0_Sample1.r;

				d.Mask0 = Mask0;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture
			//Sample parts of the layer:
				half4 TextureAlbedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Darken blend mode
				d.Albedo = min(d.Albedo,TextureAlbedo_Sample1.rgb);

		//Generate Layer: Texture3
			//Sample parts of the layer:
				half4 Texture3Albedo_Sample1 = float4(0, 1, 0.213793, 1);

			//Blend the layer into the channel using the Subtract blend mode
				d.Albedo -= Texture3Albedo_Sample1.rgb*_SSSGreen_Despill*Mask0;

	//Generate layers for the Alpha channel.
		//Generate Layer: Mask0 Copy
			//Sample parts of the layer:
				half4 Mask0_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Apply Effects:
				Mask0_CopyAlpha_Sample1.rgb = float4(dot(Mask0_CopyAlpha_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_CopyAlpha_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_CopyAlpha_Sample1.rgb,float3(-0.39,1,-0.59)),dot(Mask0_CopyAlpha_Sample1.rgb,float3(-0.39,1,-0.59)));
				Mask0_CopyAlpha_Sample1.rgb = (float3(1,1,1)-Mask0_CopyAlpha_Sample1.rgb);
				Mask0_CopyAlpha_Sample1.rgb = (Mask0_CopyAlpha_Sample1.rgb+_SSSBias);
				Mask0_CopyAlpha_Sample1.rgb = lerp(float3(0.5,0.5,0.5),Mask0_CopyAlpha_Sample1.rgb,_SSSHardness);

			//Set the channel to the new color
				d.Alpha = Mask0_CopyAlpha_Sample1.r;

				d.Alpha-=0;
				c = float4(d.Albedo+d.Emission.rgb,d.Alpha);
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
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
Type#!S2#^Float#^0#^CC0#?Type
VisName#!S2#^Text#^Texture#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^dc3f8350ad07d0443b4dc300584d813a#^CC0#?Image
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
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Green Despill#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^1#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSGreen_Despill#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Bias#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^-0.28125#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^-1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSBias#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Hardness#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^10.5#^CC0#?Number
Range0#!S2#^Float#^1#^CC0#?Range0
Range1#!S2#^Float#^20#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSHardness#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
ShaderName#!S2#^Text#^Shader Sandwich/Specific/Greenscreen#^CC0#?ShaderName
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Queue#!S2#^Type#^3#^CC0#?Queue
QueueAuto#!S2#^Toggle#^True#^CC0#?QueueAuto
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
Half as View#!S2#^Toggle#^False#^CC0#?Half as View
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^3#^CC0#?Lighting Type
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
ZWrite#!S2#^Toggle#^False#^CC0#?ZWrite
Use PBR#!S2#^Toggle#^True#^CC0#?Use PBR
Transparency#!S2#^Float#^1#^CC0#?Transparency
Receive Shadows#!S2#^Toggle#^False#^CC0#?Receive Shadows
ZWrite Type#!S2#^Type#^0#^CC0#?ZWrite Type
Blend Mode#!S2#^Type#^0#^CC0#?Blend Mode
Shells On#!S2#^Toggle#^False#^CC0#?Shells On
Shell Count#!S2#^Float#^1#^CC0#?Shell Count
Shells Distance#!S2#^Float#^0.1#^CC0#?Shells Distance
Shell Ease#!S2#^Float#^1#^CC0#?Shell Ease
Shell Transparency Type#!S2#^Type#^0#^CC0#?Shell Transparency Type
Shell Transparency ZWrite#!S2#^Toggle#^False#^CC0#?Shell Transparency ZWrite
Shell Cull#!S2#^Type#^0#^CC0#?Shell Cull
Shells ZWrite#!S2#^Toggle#^True#^CC0#?Shells ZWrite
Shells Use Transparency#!S2#^Toggle#^True#^CC0#?Shells Use Transparency
Shell Blend Mode#!S2#^Type#^0#^CC0#?Shell Blend Mode
Shells Transparency#!S2#^Float#^1#^CC0#?Shells Transparency
Shell Lighting#!S2#^Toggle#^True#^CC0#?Shell Lighting
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
Layer Name#!S2#^Text#^Mask0 Copy Copy#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTTexture#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^3#^CC0#?Layer Type
Main Color#!S2#^Vec#^1,1,1,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^97cb5aa7410455849856bd69630294aa       #^CC0 #^ 0#?Main Texture
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
Color#!S2#^Vec#^1,1,1,1#^CC0#?Color
Texture#!S2#^Texture#^97cb5aa7410455849856bd69630294aa       #^CC0 #^ 0#?Texture
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEMathDot#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
R#!S2#^Float#^-0.39#^CC0#?R
G#!S2#^Float#^1#^CC0#?G
B#!S2#^Float#^-0.59#^CC0#?B
A#!S2#^Float#^0#^CC0#?A
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEInvert#^CC0#?TypeS
IsVisible#!S2#^Toggle#^False#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
EndShaderEffect
EndShaderLayer
EndShaderLayerList
EndMasks
BeginShaderPass
Name#!S2#^Text#^Base#^CC0#?Name
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
ZWrite#!S2#^Toggle#^False#^CC0#?ZWrite
Use PBR#!S2#^Toggle#^True#^CC0#?Use PBR
Transparency#!S2#^Float#^0#^CC0#?Transparency
CutoffZWriteTransparency#!S2#^Float#^0#^CC0#?CutoffZWriteTransparency
Receive Shadows#!S2#^Toggle#^False#^CC0#?Receive Shadows
ZWrite Type#!S2#^Type#^0#^CC0#?ZWrite Type
Blend Mode#!S2#^Type#^0#^CC0#?Blend Mode
Shells On#!S2#^Toggle#^False#^CC0#?Shells On
Shell Count#!S2#^Float#^1#^CC0#?Shell Count
Shells Distance#!S2#^Float#^0.1#^CC0#?Shells Distance
Shell Ease#!S2#^Float#^1#^CC0#?Shell Ease
Shells ZWrite#!S2#^Toggle#^True#^CC0#?Shells ZWrite
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
Layer Name#!S2#^Text#^Texture#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTTexture#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^3#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.627451,0.8,0.8823529,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^824bbecff5e03c7449eea0b94db3c76b       #^CC0 #^ 0#?Main Texture
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
Mix Type#!S2#^Type#^6#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0.627451,0.8,0.8823529,1#^CC0#?Color
Texture#!S2#^Texture#^dc3f8350ad07d0443b4dc300584d813a  #^CC0 #^ 0#?Texture
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
EndShaderLayer
BeginShaderLayer
Layer Name#!S2#^Text#^Texture3#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0,1,0.213793,1#^CC0#?Main Color
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
Mix Amount#!S2#^Float#^1#^CC0 #^ 1#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^2#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^0#^CC0#?Stencil
Vertex Mask#!S2#^Float#^2#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0,1,0.213793,1#^CC0#?Color
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
LayerListUniqueName#!S2#^Text#^Alpha#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Alpha#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^r#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Mask0 Copy#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTTexture#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^3#^CC0#?Layer Type
Main Color#!S2#^Vec#^1,1,1,1#^CC0#?Main Color
Second Color#!S2#^Vec#^0,0,0,1#^CC0#?Second Color
Main Texture#!S2#^Texture#^dc3f8350ad07d0443b4dc300584d813a    #^CC0 #^ 0#?Main Texture
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
Color#!S2#^Vec#^1,1,1,1#^CC0#?Color
Texture#!S2#^Texture#^dc3f8350ad07d0443b4dc300584d813a  #^CC0 #^ 0#?Texture
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEMathDot#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
R#!S2#^Float#^-0.39#^CC0#?R
G#!S2#^Float#^1#^CC0#?G
B#!S2#^Float#^-0.59#^CC0#?B
A#!S2#^Float#^0#^CC0#?A
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEInvert#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEMathAdd#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Add#!S2#^Float#^-0.28125#^CC0 #^ 2#?Add
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEContrast#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Contrast#!S2#^Float#^10.5#^CC0 #^ 3#?Contrast
EndShaderEffect
EndShaderLayer
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
