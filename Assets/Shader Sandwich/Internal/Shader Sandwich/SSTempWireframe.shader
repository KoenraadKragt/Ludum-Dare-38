// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/SSTempWireframe" {//The Shaders Name
//The inputs shown in the material panel
Properties {
	_MainTex ("Texture - Main Texture", 2D) = "white" {}
	_ShellDistance ("Fur Distance", Range(-1000,1000)) = 0
	_SSSDepth_Darkening_AO ("Depth Darkening (AO)", Color) = (1,1,1,1)
	_SSSShell_Dist ("Shell Dist", Range(-1000,1000)) = 0
}

SubShader {
	Tags { "RenderType"="Opaque" "Queue"="Transparent" }//A bunch of settings telling Unity a bit about the shader.
	LOD 200
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582633); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture 2
			//Sample parts of the layer:
				half4 Texture_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2Albedo_Sample1.rgb,SSTEMPSV582540);

		//Generate Layer: Texture Copy 2 2
			//Sample parts of the layer:
				half4 Texture_Copy_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2_2Albedo_Sample1.rgb,Texture_Copy_2_2Albedo_Sample1.a*ShellDepth);

				d.Alpha-=SSTEMPSV582636;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582633); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture 2
			//Sample parts of the layer:
				half4 Texture_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2Albedo_Sample1.rgb,SSTEMPSV582540);

		//Generate Layer: Texture Copy 2 2
			//Sample parts of the layer:
				half4 Texture_Copy_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2_2Albedo_Sample1.rgb,Texture_Copy_2_2Albedo_Sample1.a*ShellDepth);

				d.Alpha-=SSTEMPSV582636;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.06666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.06666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.06666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.06666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.06666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.06666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.1333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.1333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.1333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.1333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.1333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.1333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.2;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.2,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.2;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.2;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.2,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.2;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.2666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.2666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.2666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.2666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.2666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.2666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.3333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.3333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.3333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.3333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.3333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.3333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.4;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.4,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.4;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.4;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.4,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.4;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.4666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.4666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.4666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.4666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.4666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.4666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.5333334;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.5333334,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.5333334;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.5333334;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.5333334,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.5333334;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.6;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.6,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.6;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.6;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.6,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.6;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.6666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.6666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.6666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.6666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.6666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.6666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.7333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.7333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.7333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.7333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.7333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.7333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.8;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.8,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.8;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.8;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.8,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.8;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.8666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.8666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.8666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.8666667;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.8666667,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.8666667;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.9333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.9333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.9333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0.9333333;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(0.9333333,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-0.9333333;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

		
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
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 1;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(1,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				#ifndef LIGHTMAP_OFF
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-1;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
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
				sampler2D _MainTex;
float4 _MainTex_ST;
				float _ShellDistance;
				float4 _SSSDepth_Darkening_AO;
				float _SSSShell_Dist;

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV582536;//Main Color
				float4 SSTEMPSV582537;//Second Color
				float SSTEMPSV582538;//Noise A
				float SSTEMPSV582539;//Noise B
				float SSTEMPSV582540;//Mix Amount
				float SSTEMPSV582541;//Fadeout Limit Min
				float SSTEMPSV582542;//Fadeout Limit Max
				float SSTEMPSV582543;//Fadeout Start
				float SSTEMPSV582544;//Fadeout End
				float SSTEMPSV582545;//Vertex Mask
				float4 SSTEMPSV582546;//Color
				float4 SSTEMPSV582547;//Color 2
				float SSTEMPSV582548;//Jitter
				float SSTEMPSV582549;//Fill
				float SSTEMPSV582550;//MinSize
				float SSTEMPSV582551;//Edge
				float SSTEMPSV582552;//MaxSize
				float4 SSTEMPSV582553;//Second Color
				float SSTEMPSV582554;//Noise A
				float SSTEMPSV582555;//Noise B
				float SSTEMPSV582556;//Fadeout Limit Min
				float SSTEMPSV582557;//Fadeout Limit Max
				float SSTEMPSV582558;//Fadeout Start
				float SSTEMPSV582559;//Fadeout End
				float SSTEMPSV582560;//Vertex Mask
				float4 SSTEMPSV582561;//Color 2
				float SSTEMPSV582562;//Jitter
				float SSTEMPSV582563;//Fill
				float SSTEMPSV582564;//MinSize
				float SSTEMPSV582565;//Edge
				float SSTEMPSV582566;//MaxSize
				float4 SSTEMPSV582567;//Main Color
				float4 SSTEMPSV582568;//Second Color
				float SSTEMPSV582569;//Noise A
				float SSTEMPSV582570;//Noise B
				float SSTEMPSV582571;//Mix Amount
				float SSTEMPSV582572;//Fadeout Limit Min
				float SSTEMPSV582573;//Fadeout Limit Max
				float SSTEMPSV582574;//Fadeout Start
				float SSTEMPSV582575;//Fadeout End
				float SSTEMPSV582576;//Vertex Mask
				float4 SSTEMPSV582577;//Color
				float4 SSTEMPSV582578;//Color 2
				float SSTEMPSV582579;//Jitter
				float SSTEMPSV582580;//Fill
				float SSTEMPSV582581;//MinSize
				float SSTEMPSV582582;//Edge
				float SSTEMPSV582583;//MaxSize
				float4 SSTEMPSV582584;//Second Color
				float SSTEMPSV582585;//Noise A
				float SSTEMPSV582586;//Noise B
				float SSTEMPSV582587;//Fadeout Limit Min
				float SSTEMPSV582588;//Fadeout Limit Max
				float SSTEMPSV582589;//Fadeout Start
				float SSTEMPSV582590;//Fadeout End
				float SSTEMPSV582591;//Vertex Mask
				float4 SSTEMPSV582592;//Color 2
				float SSTEMPSV582593;//Jitter
				float SSTEMPSV582594;//Fill
				float SSTEMPSV582595;//MinSize
				float SSTEMPSV582596;//Edge
				float SSTEMPSV582597;//MaxSize
				float4 SSTEMPSV582598;//Main Color
				float4 SSTEMPSV582599;//Second Color
				float SSTEMPSV582600;//Noise A
				float SSTEMPSV582601;//Noise B
				float SSTEMPSV582602;//Mix Amount
				float SSTEMPSV582603;//Fadeout Limit Min
				float SSTEMPSV582604;//Fadeout Limit Max
				float SSTEMPSV582605;//Fadeout Start
				float SSTEMPSV582606;//Fadeout End
				float SSTEMPSV582607;//Vertex Mask
				float4 SSTEMPSV582608;//Color
				float4 SSTEMPSV582609;//Color 2
				float SSTEMPSV582610;//Jitter
				float SSTEMPSV582611;//Fill
				float SSTEMPSV582612;//MinSize
				float SSTEMPSV582613;//Edge
				float SSTEMPSV582614;//MaxSize
				float4 SSTEMPSV607064;//Main Color
				float4 SSTEMPSV607066;//Second Color
				float SSTEMPSV607068;//Noise A
				float SSTEMPSV607070;//Noise B
				float SSTEMPSV607074;//Fadeout Limit Min
				float SSTEMPSV607076;//Fadeout Limit Max
				float SSTEMPSV607078;//Fadeout Start
				float SSTEMPSV607080;//Fadeout End
				float SSTEMPSV607082;//Vertex Mask
				float4 SSTEMPSV607084;//Color
				float SSTEMPSV582616;//Tech Shader Target
				float SSTEMPSV582617;//Setting1
				float4 SSTEMPSV582618;//Wrap Color
				float SSTEMPSV582619;//Use Normals
				float SSTEMPSV582620;//Spec Hardness
				float SSTEMPSV582621;//Spec Offset
				float SSTEMPSV582622;//Transparency
				float SSTEMPSV582623;//Shell Count
				float SSTEMPSV582624;//Shell Ease
				float SSTEMPSV582625;//Shells Transparency
				float SSTEMPSV582626;//Parallax Height
				float SSTEMPSV582627;//Parallax Quality
				float SSTEMPSV582628;//Tessellation Quality
				float SSTEMPSV582629;//Tessellation Falloff
				float SSTEMPSV582630;//Tessellation Smoothing Amount
				float SSTEMPSV582631;//Setting1
				float4 SSTEMPSV582632;//Wrap Color
				float SSTEMPSV582633;//Disable Normals
				float SSTEMPSV582634;//Spec Hardness
				float SSTEMPSV582635;//Spec Offset
				float SSTEMPSV582636;//Transparency
				float SSTEMPSV582637;//CutoffZWriteTransparency
				float SSTEMPSV582638;//Shell Ease
				float SSTEMPSV582535;//Parallax Height
				float SSTEMPSV582640;//Parallax Shadow Strength
				float SSTEMPSV582641;//Parallax Shadow Size
				float SSTEMPSV582642;//Tessellation Quality
				float SSTEMPSV582643;//Tessellation Falloff
				float SSTEMPSV582644;//Tessellation Smoothing Amount
				float SSTEMPSV582645;//Setting1
				float4 SSTEMPSV582646;//Wrap Color
				float SSTEMPSV582647;//Disable Normals
				float SSTEMPSV582648;//Spec Hardness
				float SSTEMPSV582649;//Spec Offset
				float SSTEMPSV582650;//Transparency
				float SSTEMPSV582651;//CutoffZWriteTransparency
				float SSTEMPSV582652;//Shell Ease
				float SSTEMPSV582653;//Parallax Height
				float SSTEMPSV582654;//Parallax Shadow Strength
				float SSTEMPSV582655;//Parallax Shadow Size
				float SSTEMPSV582656;//Tessellation Quality
				float SSTEMPSV582657;//Tessellation Falloff
				float SSTEMPSV582658;//Tessellation Smoothing Amount
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

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
				float ShellDepth;
				float2 uv_MainTex;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float2 uv_MainTex: TEXCOORD2;
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









			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
					o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 1;
	//Generate layers for the Vertex channel.
		//Generate Layer: Vertex
			//Sample parts of the layer:
				half4 VertexVertex_Sample1 = SSTEMPSV607084;

			//Blend the layer into the channel using the Subtract blend mode
				Vertex -= VertexVertex_Sample1.rgba*ShellDepth;

				Vertex.w = v.vertex.w;
				Vertex.xyz += v.normal*(_ShellDistance*pow(1,SSTEMPSV582652));
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
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
				half NdotL = lerp(max (0, gi.light.ndotl),1,SSTEMPSV582647); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)
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
				d.ShellDepth = 1-1;
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
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture Copy 2
			//Sample parts of the layer:
				half4 Texture_Copy_2Albedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_Copy_2Albedo_Sample1.rgb,SSTEMPSV582571);

		//Generate Layer: Texture 2 2
			//Sample parts of the layer:
				half4 Texture_2_2Albedo_Sample1 = _SSSDepth_Darkening_AO;

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,Texture_2_2Albedo_Sample1.rgb,Texture_2_2Albedo_Sample1.a*ShellDepth);

	//Generate layers for the Alpha channel.
		//Generate Layer: Texture Copy
			//Sample parts of the layer:
				half4 Texture_CopyAlpha_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Blend the layer into the channel using the Mix blend mode
				d.Alpha = lerp(d.Alpha,Texture_CopyAlpha_Sample1.a,SSTEMPSV582602);

				d.Alpha-=SSTEMPSV582650;
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
}

Fallback "VertexLit"
}
