// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Shader Sandwich/DX11/Tessellated Fur" {//The Shaders Name
//The inputs shown in the material panel
Properties {
	[HideInInspector]Texcoord ("Generic UV Coords (You shouldn't be seeing this aaaaah!)", 2D) = "white" {}
	_MainTex ("Texture", 2D) = "white" {}
	_Color ("Color", Color) = (0.5614604,1,0.3088235,1)
	_SSSAO_Strength ("AO Strength", Range(0.000000000,1.000000000)) = 0.541322300
	_ShellDistance ("Grass Height", Range(0.000000000,1.000000000)) = 0.196022700
	_SSSGrass_Scale ("Grass Scale", Float) = 30.000000000
	_SSSGrass_Quality_Tessellation ("Grass Quality (Tessellation)", Range(1.000000000,50.000000000)) = 50.000000000
	_Shininess ("Specular Hardness", Range(0.000100000,1.000000000)) = 0.262960300
	_SpecColor ("Specular Color", Color) = (0.125,0.125,0.125,1)
	_SSSWind_Strength ("Wind Strength", Range(0.000000000,1.000000000)) = 0.082644630
	_SSSWind_Direction ("Wind Direction", Color) = (0.1617647,0,0.1617647,1)
	_SSSWind_Scale ("Wind Scale", Float) = 55.700000000
}

SubShader {
	Tags { "RenderType"="Opaque" "Queue"="Geometry" }//A bunch of settings telling Unity a bit about the shader.
	LOD 200
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
	ZTest LEqual
	ZWrite On
	Blend Off//No transparency
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex tessvert_frag_surf
				#pragma fragment FragmentShader
				#pragma hull hs_frag_surf
				#pragma domain ds_frag_surf
				#pragma target 5.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdbase noshadow
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
				#include "Tessellation.cginc" //Include some Unity code for tessellation.

			//Make our inputs accessible by declaring them here.
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _Color;
				float _SSSAO_Strength;
				float _ShellDistance;
				float _SSSGrass_Scale;
				float _SSSGrass_Quality_Tessellation;
				float _Shininess;
								float _SSSWind_Strength;
				float4 _SSSWind_Direction;
				float _SSSWind_Scale;

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
				float Mask1;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float3 viewDir: TEXCOORD2;
					float4 dataToPack0 : TEXCOORD3;
					#if UNITY_SHOULD_SAMPLE_SH
						half3 sh : TEXCOORD4;
					#endif
					UNITY_FOG_COORDS(5)
				};
			#endif
			// with lightmaps:
			#ifndef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float3 viewDir: TEXCOORD2;
					float4 dataToPack0 : TEXCOORD3;
					float4 lmap : TEXCOORD4;
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



//Some noise code based on the fantastic library by Brian Sharpe, he deserves a ton of credit :)
//brisharpe CIRCLE_A yahoo DOT com
//http://briansharpe.wordpress.com
//https://github.com/BrianSharpe
float2 PerlinInterpolation_C2( float2 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
void PerlinFastHash2D(float2 Pos,out float4 hash_0, out float4 hash_1){
	float2 Offset = float2(26,161);
	float Domain = 71;
	float2 SomeLargeFloats = float2(951.135664,642.9478304);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/Domain))*Domain;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/SomeLargeFloats.x));
	hash_1 = frac(P*(1/SomeLargeFloats.y));
}
float PerlinNoise2D(float2 P)
{
	float2 Pi = floor(P);
	float4 Pf_Pfmin1 = P.xyxy-float4(Pi,Pi+1);
	float4 HashX, HashY;
	PerlinFastHash2D(Pi,HashX,HashY);
	float4 GradX = HashX-0.499999;
	float4 GradY = HashY-0.499999;
	float4 GradRes = rsqrt(GradX*GradX+GradY*GradY)*(GradX*Pf_Pfmin1.xzxz+GradY*Pf_Pfmin1.yyww);
	
	GradRes *= 1.4142135623730950488016887242097;
	float2 blend = PerlinInterpolation_C2(Pf_Pfmin1.xy);
	float4 blend2 = float4(blend,float2(1.0-blend));
	return (dot(GradRes,blend2.zxzx*blend2.wwyy));
}
float3 PerlinInterpolation_C2( float3 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
void PerlinFastHash3D(float3 Pos,out float4 hash_0, out float4 hash_1,out float4 hash_2, out float4 hash_3,out float4 hash_4, out float4 hash_5){
	float2 Offset = float2(50,161);
	float Domain = 69;
	float3 SomeLargeFloats = float3(635.298681, 682.357502, 668.926525 );
	float3 Zinc = float3( 48.500388, 65.294118, 63.934599 );
	
	Pos = Pos-floor(Pos*(1.0/Domain))*Domain;
	float3 Pos_Inc1 = step(Pos,float(Domain-1.5).rrr)*(Pos+1);
	
	float4 P = float4(Pos.xy,Pos_Inc1.xy)+Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	
	float3 lowz_mod = float3(1/(SomeLargeFloats+Pos.zzz*Zinc));//Pos.zzz
	float3 highz_mod = float3(1/(SomeLargeFloats+Pos_Inc1.zzz*Zinc));//Pos_Inc1.zzz
	
	hash_0 = frac(P*lowz_mod.xxxx);
	hash_1 = frac(P*lowz_mod.yyyy);
	hash_2 = frac(P*lowz_mod.zzzz);
	hash_3 = frac(P*highz_mod.xxxx);
	hash_4 = frac(P*highz_mod.yyyy);
	hash_5 = frac(P*highz_mod.zzzz);
}
float PerlinNoise3D(float3 P)
{
	float3 Pi = floor(P);
	float3 Pf = P-Pi;
	float3 Pf_min1 = Pf-1.0;
	
	float4 HashX0, HashY0, HashZ0, HashX1, HashY1, HashZ1;
	PerlinFastHash3D(Pi, HashX0, HashY0, HashZ0, HashX1, HashY1, HashZ1);
	
	float4 GradX0 = HashX0-0.49999999;
	float4 GradX1 = HashX1-0.49999999;
	float4 GradY0 = HashY0-0.49999999;
	float4 GradY1 = HashY1-0.49999999;
	float4 GradZ0 = HashZ0-0.49999999;
	float4 GradZ1 = HashZ1-0.49999999;

	float4 GradRes = rsqrt( GradX0 * GradX0 + GradY0 * GradY0 + GradZ0 * GradZ0) * ( float2( Pf.x, Pf_min1.x ).xyxy * GradX0 + float2( Pf.y, Pf_min1.y ).xxyy * GradY0 + Pf.zzzz * GradZ0 );
	float4 GradRes2 = rsqrt( GradX1 * GradX1 + GradY1 * GradY1 + GradZ1 * GradZ1) * ( float2( Pf.x, Pf_min1.x ).xyxy * GradX1 + float2( Pf.y, Pf_min1.y ).xxyy * GradY1 + Pf_min1.zzzz * GradZ1 );
	
	float3 Blend = PerlinInterpolation_C2(Pf);
	
	float4 Res = lerp(GradRes,GradRes2,Blend.z);
	float4 Blend2 = float4(Blend.xy,float2(1.0-Blend.xy));
	float Final = dot(Res,Blend2.zxzx*Blend2.wwyy);
	Final *= 1.1547005383792515290182975610039;
	return Final;
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
				o.viewDir = worldViewDir;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the GrassDisp channel.
		//Generate Layer: Vertex Copy
			//Sample parts of the layer:
				half4 Vertex_CopyMask0_Sample1 = (PerlinNoise2D((((((v.texcoord.xyz.xy*float2(_SSSGrass_Scale,_SSSGrass_Scale)))))*3)*3)+1)/2;

			//Set the mask to the new color
				Mask0 = Vertex_CopyMask0_Sample1.r;

	//Set default mask color
		float Mask1 = 1;
	//Generate layers for the WindDisp channel.
		//Generate Layer: Vertex2 Copy
			//Sample parts of the layer:
				half4 Vertex2_CopyMask1_Sample1 = (PerlinNoise2D(((((((v.texcoord.xyz.xy*float2(_SSSWind_Scale,_SSSWind_Scale))+float2(_Time.y/2,0)))))*3)*3)+1)/2;

			//Blend the layer into the channel using the Mix blend mode
				Mask1 = lerp(Mask1,Vertex2_CopyMask1_Sample1.r,Mask0);

	//Generate layers for the Vertex channel.
		//Generate Layer: GrassDisp
			//Sample parts of the layer:
				half4 GrassDispVertex_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Add blend mode
				Vertex += ((GrassDispVertex_Sample1)*float4(v.normal.rgb,1)).rgba*_ShellDistance*Mask0;

		//Generate Layer: WindDisp
			//Sample parts of the layer:
				half4 WindDispVertex_Sample1 = _SSSWind_Direction;

			//Blend the layer into the channel using the Add blend mode
				Vertex += WindDispVertex_Sample1.rgba*_SSSWind_Strength*Mask1;

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				o.viewDir = worldViewDir;
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
				
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			#ifdef UNITY_CAN_COMPILE_TESSELLATION
				// tessellation vertex shader
				struct Tess_appdata_min {
					float4 vertex : INTERNALTESSPOS;
					float4 tangent : TANGENT;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					half4 color : COLOR;
				};
				float4 tess (Tess_appdata_min v0, Tess_appdata_min v1, Tess_appdata_min v2){
					return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, (51-_SSSGrass_Quality_Tessellation)*2);
				}				Tess_appdata_min tessvert_frag_surf (appdata_min v) {
					Tess_appdata_min o;
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					o.color = v.color;
					return o;
				}
				// tessellation hull constant shader
				UnityTessellationFactors hsconst_frag_surf (InputPatch<Tess_appdata_min,3> v) {
					UnityTessellationFactors o;
					float4 tf;
					tf = tess(v[0], v[1], v[2]);
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}
				// tessellation hull shader
				[UNITY_domain("tri")]
				[UNITY_partitioning("fractional_odd")]
				[UNITY_outputtopology("triangle_cw")]
				[UNITY_patchconstantfunc("hsconst_frag_surf")]
				[UNITY_outputcontrolpoints(3)]
				Tess_appdata_min hs_frag_surf (InputPatch<Tess_appdata_min,3> v, uint id : SV_OutputControlPointID) {
					return v[id];
				}
				[UNITY_domain("tri")]
				v2f_surf ds_frag_surf (UnityTessellationFactors tessFactors, const OutputPatch<Tess_appdata_min,3> vi, float3 bary : SV_DomainLocation) {
					appdata_min v;
					v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
					v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
					v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
					v.texcoord = vi[0].texcoord*bary.x + vi[1].texcoord*bary.y + vi[2].texcoord*bary.z;
					v.texcoord1 = vi[0].texcoord1*bary.x + vi[1].texcoord1*bary.y + vi[2].texcoord1*bary.z;
					v.texcoord2 = vi[0].texcoord2*bary.x + vi[1].texcoord2*bary.y + vi[2].texcoord2*bary.z;
					v.color = vi[0].color*bary.x + vi[1].color*bary.y + vi[2].color*bary.z;
					v2f_surf o = VertShader (v);
					return o;
				}
			#endif


//Include a bunch of PBS Code from files UnityPBSLighting.cginc and UnityStandardBRDF.cginc for the purpose of custom lighting effects.
half4 BRDF1_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;

	half roughness = 1-oneMinusRoughness;
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);
	half lv = DotClamped (gi.light.dir, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

#if UNITY_BRDF_GGX
	half V = SmithGGXVisibilityTerm (nl, nv, roughness);
	half D = GGXTerm (nh, roughness);
#else
	half V = SmithBeckmannVisibilityTerm (nl, nv, roughness);
	half D = NDFBlinnPhongNormalizedTerm (nh, RoughnessToSpecPower (roughness));
#endif

	half nlPow5 = Pow5 (1-nl);
	half nvPow5 = Pow5 (1-nv);
	half Fd90 = 0.5 + 2 * lh * lh * roughness;
	half disneyDiffuse = (1 + (Fd90-1) * nlPow5) * (1 + (Fd90-1) * nvPow5);
	
	// HACK: theoretically we should divide by Pi diffuseTerm and not multiply specularTerm!
	// BUT 1) that will make shader look significantly darker than Legacy ones
	// and 2) on engine side Non-important lights have to be divided by Pi to in cases when they are injected into ambient SH
	// NOTE: multiplication by Pi is part of single constant together with 1/4 now
half specularTerm = max(0, (V * D * nl) * unity_LightGammaCorrectionConsts_PIDiv4);// Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)
	half3 cDiff = disneyDiffuse * nl * gi.light.color;
	
	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
	half3 cSpec = specularTerm*gi.light.color * FresnelTerm (d.Specular, lh)+(gi.indirect.specular * FresnelLerp (d.Specular, grazingTerm, nv));
	


half3 cAmb = gi.indirect.diffuse;

cDiff += cAmb;

    half3 color =	d.Albedo * cDiff
                    + cSpec;

	return half4(color, 1);
}			
			
// Based on Minimalist CookTorrance BRDF
// Implementation is slightly different from original derivation: http://www.thetenthplanet.de/archives/255
//
// * BlinnPhong as NDF
// * Modified Kelemen and Szirmay-​Kalos for Visibility term
// * Fresnel approximated with 1/LdotH
half4 BRDF2_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;


	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

	half roughness = 1-oneMinusRoughness;
	half specularPower = RoughnessToSpecPower (roughness);
	// Modified with approximate Visibility function that takes roughness into account
	// Original ((n+1)*N.H^n) / (8*Pi * L.H^3) didn't take into account roughness 
	// and produced extremely bright specular at grazing angles

	// HACK: theoretically we should divide by Pi diffuseTerm and not multiply specularTerm!
	// BUT 1) that will make shader look significantly darker than Legacy ones
	// and 2) on engine side Non-important lights have to be divided by Pi to in cases when they are injected into ambient SH
	// NOTE: multiplication by Pi is cancelled with Pi in denominator

	half invV = lh * lh * oneMinusRoughness + roughness * roughness; // approx ModifiedKelemenVisibilityTerm(lh, 1-oneMinusRoughness);
	half invF = lh;
	half specular = ((specularPower + 1) * pow (nh, specularPower)) / (unity_LightGammaCorrectionConsts_8 * invV * invF + 1e-4f); // @TODO: might still need saturate(nl*specular) on Adreno/Mali

	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
	
	half3 cDiff = gi.light.color * nl;
	half3 cSpec = specular * d.Specular * cDiff + gi.indirect.specular * FresnelLerpFast (d.Specular, grazingTerm, nv);
	


half3 cAmb = gi.indirect.diffuse;

cDiff += cAmb;

	
	half3 color =	d.Albedo* cDiff + cSpec;

	return half4(color, 1);
}

// Old school, not microfacet based Modified Normalized Blinn-Phong BRDF
// Implementation uses Lookup texture for performance
//
// * Normalized BlinnPhong in RDF form
// * Implicit Visibility term
// * No Fresnel term
//
// TODO: specular is too weak in Linear rendering mode
half4 BRDF3_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;


	half3 reflDir = reflect (d.worldViewDir, d.Normal);
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);

	// Vectorize Pow4 to save instructions
	half2 rlPow4AndFresnelTerm = Pow4 (half2(dot(reflDir, gi.light.dir), 1-nv));  // use R.L instead of N.H to save couple of instructions
	half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp
	half fresnelTerm = rlPow4AndFresnelTerm.y;
#if 1 // Lookup texture to save instructions

	half specular = tex2D(unity_NHxRoughness, half2(rlPow4, 1-oneMinusRoughness)).UNITY_ATTEN_CHANNEL * LUT_RANGE;
#else
	half roughness = 1-oneMinusRoughness;
	half n = RoughnessToSpecPower (roughness) * .25;
	half specular = (n + 2.0) / (2.0 * UNITY_PI * UNITY_PI) * pow(dot(reflDir, gi.light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;
	//half specular = (1.0/(UNITY_PI*roughness*roughness)) * pow(dot(reflDir, gi.light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;
#endif
	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));

	half3 cDiff = gi.light.color * nl;
	half3 cSpec = specular * d.Specular * cDiff + gi.indirect.specular * lerp (d.Specular, grazingTerm, fresnelTerm);


half3 cAmb = gi.indirect.diffuse;

cDiff += cAmb;

	
    half3 color =	d.Albedo* cDiff + cSpec;

	return half4(color, 1);
}
#if !defined (UNITY_BRDF_PBSSS) // allow to explicitly override BRDF in custom shader
	#if (SHADER_TARGET < 30) || defined(SHADER_API_PSP2)
		// Fallback to low fidelity one for pre-SM3.0
		#define UNITY_BRDF_PBSSS BRDF3_Unity_PBSSS
	#elif defined(SHADER_API_MOBILE)
		// Somewhat simplified for mobile
		#define UNITY_BRDF_PBSSS BRDF2_Unity_PBSSS
	#else
		// Full quality for SM3+ PC / consoles
		#define UNITY_BRDF_PBSSS BRDF1_Unity_PBSSS
	#endif
#endif
			float4 CalculateLighting(UsefulData d, UnityGI gi){
				float4 c = float4(d.Albedo,d.Alpha);
				float3 cTemp = float3(0,0,0);
				float3 cDiff = float3(1,1,1);
				float3 cAmb = float3(0,0,0);
				float3 cSpec = float3(0,0,0);
			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;
				// energy conservation
				half oneMinusReflectivity;
				d.Albedo = EnergyConservationBetweenDiffuseAndSpecular (d.Albedo, d.Specular, /*out*/ oneMinusReflectivity);
				
				// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
				// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha
				half outputAlpha = d.Alpha;
				//For some reason #if defined() never works!!! So have to preprocess this when generating the shader...
				//d.Albedo = PreMultiplyAlpha (d.Albedo, d.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);
				
				c = UNITY_BRDF_PBSSS (d, gi, oneMinusReflectivity, d.Smoothness);
				c.rgb += UNITY_BRDF_GI (d.Albedo, d.Specular, oneMinusReflectivity, d.Smoothness, d.Normal, d.worldViewDir, d.Occlusion, gi);
				c.a = outputAlpha;
				return c;
			};

			void CalculateGI (UsefulData d,UnityGIInput data,inout UnityGI gi){
				#if UNITY_VERSION >= 520
					UNITY_GI(gi, d, data);
				#else
					gi = UnityGlobalIllumination (data, 1.0, d.Smoothness, d.Normal);
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
				d.Smoothness = _Shininess;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = (IN.viewDir);
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
	//Generate layers for the GrassDisp channel.
		//Generate Layer: Vertex Copy
			//Sample parts of the layer:
				half4 Vertex_CopyMask0_Sample1 = (PerlinNoise2D((((((d.uvTexcoord.xy*float2(_SSSGrass_Scale,_SSSGrass_Scale)))))*3)*3)+1)/2;

			//Set the mask to the new color
				Mask0 = Vertex_CopyMask0_Sample1.r;

				d.Mask0 = Mask0;
	//Set default mask color
		float Mask1 = 1;
	//Generate layers for the WindDisp channel.
		//Generate Layer: Vertex2 Copy
			//Sample parts of the layer:
				half4 Vertex2_CopyMask1_Sample1 = (PerlinNoise2D(((((((d.uvTexcoord.xy*float2(_SSSWind_Scale,_SSSWind_Scale))+float2(_Time.y/2,0)))))*3)*3)+1)/2;

			//Blend the layer into the channel using the Mix blend mode
				Mask1 = lerp(Mask1,Vertex2_CopyMask1_Sample1.r,Mask0);

				d.Mask1 = Mask1;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture
			//Sample parts of the layer:
				half4 TextureAlbedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Set the channel to the new color
				d.Albedo = TextureAlbedo_Sample1.rgb;

		//Generate Layer: Color
			//Sample parts of the layer:
				half4 ColorAlbedo_Sample1 = _Color;

			//Blend the layer into the channel using the Multiply blend mode
				d.Albedo *= ColorAlbedo_Sample1.rgb;

		//Generate Layer: AO
			//Sample parts of the layer:
				half4 AOAlbedo_Sample1 = (PerlinNoise2D((((((d.uvTexcoord.xy*float2(_SSSGrass_Scale,_SSSGrass_Scale)))))*3)*3)+1)/2;

			//Blend the layer into the channel using the Multiply blend mode
				d.Albedo = lerp(d.Albedo,d.Albedo*AOAlbedo_Sample1.rgb,_SSSAO_Strength);

	//Generate layers for the Specular channel.
		//Generate Layer: Specular
			//Sample parts of the layer:
				half4 SpecularSpecular_Sample1 = _SpecColor;

			//Set the channel to the new color
				d.Specular = SpecularSpecular_Sample1.rgb;

				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = worldN;
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				CalculateGI(d, giInput, gi);
				c = CalculateLighting (d, gi)+d.Emission;
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				c.a = 1;
				return c;
			}

		ENDCG
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
	ZTest LEqual
	ZWrite On
	Blend One One//No transparency (But add in the Forward Add pass)
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex tessvert_frag_surf
				#pragma fragment FragmentShader
				#pragma hull hs_frag_surf
				#pragma domain ds_frag_surf
				#pragma target 5.0
				#pragma multi_compile_fog
				#pragma multi_compile_fwdadd_fullshadows noshadow
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
				#include "Tessellation.cginc" //Include some Unity code for tessellation.

			//Make our inputs accessible by declaring them here.
				sampler2D _MainTex;
float4 _MainTex_ST;
				float4 _Color;
				float _SSSAO_Strength;
				float _ShellDistance;
				float _SSSGrass_Scale;
				float _SSSGrass_Quality_Tessellation;
				float _Shininess;
								float _SSSWind_Strength;
				float4 _SSSWind_Direction;
				float _SSSWind_Scale;

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
				float Mask1;
				float2 uv_MainTex;
				float2 uvTexcoord;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					float3 viewDir: TEXCOORD2;
					float4 dataToPack0 : TEXCOORD3;
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



//Some noise code based on the fantastic library by Brian Sharpe, he deserves a ton of credit :)
//brisharpe CIRCLE_A yahoo DOT com
//http://briansharpe.wordpress.com
//https://github.com/BrianSharpe
float2 PerlinInterpolation_C2( float2 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
void PerlinFastHash2D(float2 Pos,out float4 hash_0, out float4 hash_1){
	float2 Offset = float2(26,161);
	float Domain = 71;
	float2 SomeLargeFloats = float2(951.135664,642.9478304);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/Domain))*Domain;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/SomeLargeFloats.x));
	hash_1 = frac(P*(1/SomeLargeFloats.y));
}
float PerlinNoise2D(float2 P)
{
	float2 Pi = floor(P);
	float4 Pf_Pfmin1 = P.xyxy-float4(Pi,Pi+1);
	float4 HashX, HashY;
	PerlinFastHash2D(Pi,HashX,HashY);
	float4 GradX = HashX-0.499999;
	float4 GradY = HashY-0.499999;
	float4 GradRes = rsqrt(GradX*GradX+GradY*GradY)*(GradX*Pf_Pfmin1.xzxz+GradY*Pf_Pfmin1.yyww);
	
	GradRes *= 1.4142135623730950488016887242097;
	float2 blend = PerlinInterpolation_C2(Pf_Pfmin1.xy);
	float4 blend2 = float4(blend,float2(1.0-blend));
	return (dot(GradRes,blend2.zxzx*blend2.wwyy));
}
float3 PerlinInterpolation_C2( float3 x ) { return x * x * x * (x * (x * 6.0 - 15.0) + 10.0); }
void PerlinFastHash3D(float3 Pos,out float4 hash_0, out float4 hash_1,out float4 hash_2, out float4 hash_3,out float4 hash_4, out float4 hash_5){
	float2 Offset = float2(50,161);
	float Domain = 69;
	float3 SomeLargeFloats = float3(635.298681, 682.357502, 668.926525 );
	float3 Zinc = float3( 48.500388, 65.294118, 63.934599 );
	
	Pos = Pos-floor(Pos*(1.0/Domain))*Domain;
	float3 Pos_Inc1 = step(Pos,float(Domain-1.5).rrr)*(Pos+1);
	
	float4 P = float4(Pos.xy,Pos_Inc1.xy)+Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	
	float3 lowz_mod = float3(1/(SomeLargeFloats+Pos.zzz*Zinc));//Pos.zzz
	float3 highz_mod = float3(1/(SomeLargeFloats+Pos_Inc1.zzz*Zinc));//Pos_Inc1.zzz
	
	hash_0 = frac(P*lowz_mod.xxxx);
	hash_1 = frac(P*lowz_mod.yyyy);
	hash_2 = frac(P*lowz_mod.zzzz);
	hash_3 = frac(P*highz_mod.xxxx);
	hash_4 = frac(P*highz_mod.yyyy);
	hash_5 = frac(P*highz_mod.zzzz);
}
float PerlinNoise3D(float3 P)
{
	float3 Pi = floor(P);
	float3 Pf = P-Pi;
	float3 Pf_min1 = Pf-1.0;
	
	float4 HashX0, HashY0, HashZ0, HashX1, HashY1, HashZ1;
	PerlinFastHash3D(Pi, HashX0, HashY0, HashZ0, HashX1, HashY1, HashZ1);
	
	float4 GradX0 = HashX0-0.49999999;
	float4 GradX1 = HashX1-0.49999999;
	float4 GradY0 = HashY0-0.49999999;
	float4 GradY1 = HashY1-0.49999999;
	float4 GradZ0 = HashZ0-0.49999999;
	float4 GradZ1 = HashZ1-0.49999999;

	float4 GradRes = rsqrt( GradX0 * GradX0 + GradY0 * GradY0 + GradZ0 * GradZ0) * ( float2( Pf.x, Pf_min1.x ).xyxy * GradX0 + float2( Pf.y, Pf_min1.y ).xxyy * GradY0 + Pf.zzzz * GradZ0 );
	float4 GradRes2 = rsqrt( GradX1 * GradX1 + GradY1 * GradY1 + GradZ1 * GradZ1) * ( float2( Pf.x, Pf_min1.x ).xyxy * GradX1 + float2( Pf.y, Pf_min1.y ).xxyy * GradY1 + Pf_min1.zzzz * GradZ1 );
	
	float3 Blend = PerlinInterpolation_C2(Pf);
	
	float4 Res = lerp(GradRes,GradRes2,Blend.z);
	float4 Blend2 = float4(Blend.xy,float2(1.0-Blend.xy));
	float Final = dot(Res,Blend2.zxzx*Blend2.wwyy);
	Final *= 1.1547005383792515290182975610039;
	return Final;
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
				o.viewDir = worldViewDir;
				float ShellDepth = 0;
	//Set default mask color
		float Mask0 = 1;
	//Generate layers for the GrassDisp channel.
		//Generate Layer: Vertex Copy
			//Sample parts of the layer:
				half4 Vertex_CopyMask0_Sample1 = (PerlinNoise2D((((((v.texcoord.xyz.xy*float2(_SSSGrass_Scale,_SSSGrass_Scale)))))*3)*3)+1)/2;

			//Set the mask to the new color
				Mask0 = Vertex_CopyMask0_Sample1.r;

	//Set default mask color
		float Mask1 = 1;
	//Generate layers for the WindDisp channel.
		//Generate Layer: Vertex2 Copy
			//Sample parts of the layer:
				half4 Vertex2_CopyMask1_Sample1 = (PerlinNoise2D(((((((v.texcoord.xyz.xy*float2(_SSSWind_Scale,_SSSWind_Scale))+float2(_Time.y/2,0)))))*3)*3)+1)/2;

			//Blend the layer into the channel using the Mix blend mode
				Mask1 = lerp(Mask1,Vertex2_CopyMask1_Sample1.r,Mask0);

	//Generate layers for the Vertex channel.
		//Generate Layer: GrassDisp
			//Sample parts of the layer:
				half4 GrassDispVertex_Sample1 = float4(1, 1, 1, 1);

			//Blend the layer into the channel using the Add blend mode
				Vertex += ((GrassDispVertex_Sample1)*float4(v.normal.rgb,1)).rgba*_ShellDistance*Mask0;

		//Generate Layer: WindDisp
			//Sample parts of the layer:
				half4 WindDispVertex_Sample1 = _SSSWind_Direction;

			//Blend the layer into the channel using the Add blend mode
				Vertex += WindDispVertex_Sample1.rgba*_SSSWind_Strength*Mask1;

				Vertex.w = v.vertex.w;
				o.pos = UnityObjectToClipPos (Vertex);
				worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				o.viewDir = worldViewDir;
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			#ifdef UNITY_CAN_COMPILE_TESSELLATION
				// tessellation vertex shader
				struct Tess_appdata_min {
					float4 vertex : INTERNALTESSPOS;
					float4 tangent : TANGENT;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					half4 color : COLOR;
				};
				float4 tess (Tess_appdata_min v0, Tess_appdata_min v1, Tess_appdata_min v2){
					return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, (51-_SSSGrass_Quality_Tessellation)*2);
				}				Tess_appdata_min tessvert_frag_surf (appdata_min v) {
					Tess_appdata_min o;
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					o.color = v.color;
					return o;
				}
				// tessellation hull constant shader
				UnityTessellationFactors hsconst_frag_surf (InputPatch<Tess_appdata_min,3> v) {
					UnityTessellationFactors o;
					float4 tf;
					tf = tess(v[0], v[1], v[2]);
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}
				// tessellation hull shader
				[UNITY_domain("tri")]
				[UNITY_partitioning("fractional_odd")]
				[UNITY_outputtopology("triangle_cw")]
				[UNITY_patchconstantfunc("hsconst_frag_surf")]
				[UNITY_outputcontrolpoints(3)]
				Tess_appdata_min hs_frag_surf (InputPatch<Tess_appdata_min,3> v, uint id : SV_OutputControlPointID) {
					return v[id];
				}
				[UNITY_domain("tri")]
				v2f_surf ds_frag_surf (UnityTessellationFactors tessFactors, const OutputPatch<Tess_appdata_min,3> vi, float3 bary : SV_DomainLocation) {
					appdata_min v;
					v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
					v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
					v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
					v.texcoord = vi[0].texcoord*bary.x + vi[1].texcoord*bary.y + vi[2].texcoord*bary.z;
					v.texcoord1 = vi[0].texcoord1*bary.x + vi[1].texcoord1*bary.y + vi[2].texcoord1*bary.z;
					v.texcoord2 = vi[0].texcoord2*bary.x + vi[1].texcoord2*bary.y + vi[2].texcoord2*bary.z;
					v.color = vi[0].color*bary.x + vi[1].color*bary.y + vi[2].color*bary.z;
					v2f_surf o = VertShader (v);
					return o;
				}
			#endif


//Include a bunch of PBS Code from files UnityPBSLighting.cginc and UnityStandardBRDF.cginc for the purpose of custom lighting effects.
half4 BRDF1_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;

	half roughness = 1-oneMinusRoughness;
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);
	half lv = DotClamped (gi.light.dir, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

#if UNITY_BRDF_GGX
	half V = SmithGGXVisibilityTerm (nl, nv, roughness);
	half D = GGXTerm (nh, roughness);
#else
	half V = SmithBeckmannVisibilityTerm (nl, nv, roughness);
	half D = NDFBlinnPhongNormalizedTerm (nh, RoughnessToSpecPower (roughness));
#endif

	half nlPow5 = Pow5 (1-nl);
	half nvPow5 = Pow5 (1-nv);
	half Fd90 = 0.5 + 2 * lh * lh * roughness;
	half disneyDiffuse = (1 + (Fd90-1) * nlPow5) * (1 + (Fd90-1) * nvPow5);
	
	// HACK: theoretically we should divide by Pi diffuseTerm and not multiply specularTerm!
	// BUT 1) that will make shader look significantly darker than Legacy ones
	// and 2) on engine side Non-important lights have to be divided by Pi to in cases when they are injected into ambient SH
	// NOTE: multiplication by Pi is part of single constant together with 1/4 now
half specularTerm = max(0, (V * D * nl) * unity_LightGammaCorrectionConsts_PIDiv4);// Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)
	half3 cDiff = disneyDiffuse * nl * gi.light.color;
	
	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
	half3 cSpec = specularTerm*gi.light.color * FresnelTerm (d.Specular, lh)+(gi.indirect.specular * FresnelLerp (d.Specular, grazingTerm, nv));
	


half3 cAmb = gi.indirect.diffuse;

    half3 color =	d.Albedo * cDiff
                    + cSpec;

	return half4(color, 1);
}			
			
// Based on Minimalist CookTorrance BRDF
// Implementation is slightly different from original derivation: http://www.thetenthplanet.de/archives/255
//
// * BlinnPhong as NDF
// * Modified Kelemen and Szirmay-​Kalos for Visibility term
// * Fresnel approximated with 1/LdotH
half4 BRDF2_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;


	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

	half roughness = 1-oneMinusRoughness;
	half specularPower = RoughnessToSpecPower (roughness);
	// Modified with approximate Visibility function that takes roughness into account
	// Original ((n+1)*N.H^n) / (8*Pi * L.H^3) didn't take into account roughness 
	// and produced extremely bright specular at grazing angles

	// HACK: theoretically we should divide by Pi diffuseTerm and not multiply specularTerm!
	// BUT 1) that will make shader look significantly darker than Legacy ones
	// and 2) on engine side Non-important lights have to be divided by Pi to in cases when they are injected into ambient SH
	// NOTE: multiplication by Pi is cancelled with Pi in denominator

	half invV = lh * lh * oneMinusRoughness + roughness * roughness; // approx ModifiedKelemenVisibilityTerm(lh, 1-oneMinusRoughness);
	half invF = lh;
	half specular = ((specularPower + 1) * pow (nh, specularPower)) / (unity_LightGammaCorrectionConsts_8 * invV * invF + 1e-4f); // @TODO: might still need saturate(nl*specular) on Adreno/Mali

	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
	
	half3 cDiff = gi.light.color * nl;
	half3 cSpec = specular * d.Specular * cDiff + gi.indirect.specular * FresnelLerpFast (d.Specular, grazingTerm, nv);
	


half3 cAmb = gi.indirect.diffuse;

	
	half3 color =	d.Albedo* cDiff + cSpec;

	return half4(color, 1);
}

// Old school, not microfacet based Modified Normalized Blinn-Phong BRDF
// Implementation uses Lookup texture for performance
//
// * Normalized BlinnPhong in RDF form
// * Implicit Visibility term
// * No Fresnel term
//
// TODO: specular is too weak in Linear rendering mode
half4 BRDF3_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;


	half3 reflDir = reflect (d.worldViewDir, d.Normal);
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);

	// Vectorize Pow4 to save instructions
	half2 rlPow4AndFresnelTerm = Pow4 (half2(dot(reflDir, gi.light.dir), 1-nv));  // use R.L instead of N.H to save couple of instructions
	half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp
	half fresnelTerm = rlPow4AndFresnelTerm.y;
#if 1 // Lookup texture to save instructions

	half specular = tex2D(unity_NHxRoughness, half2(rlPow4, 1-oneMinusRoughness)).UNITY_ATTEN_CHANNEL * LUT_RANGE;
#else
	half roughness = 1-oneMinusRoughness;
	half n = RoughnessToSpecPower (roughness) * .25;
	half specular = (n + 2.0) / (2.0 * UNITY_PI * UNITY_PI) * pow(dot(reflDir, gi.light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;
	//half specular = (1.0/(UNITY_PI*roughness*roughness)) * pow(dot(reflDir, gi.light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;
#endif
	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));

	half3 cDiff = gi.light.color * nl;
	half3 cSpec = specular * d.Specular * cDiff + gi.indirect.specular * lerp (d.Specular, grazingTerm, fresnelTerm);


half3 cAmb = gi.indirect.diffuse;

	
    half3 color =	d.Albedo* cDiff + cSpec;

	return half4(color, 1);
}
#if !defined (UNITY_BRDF_PBSSS) // allow to explicitly override BRDF in custom shader
	#if (SHADER_TARGET < 30) || defined(SHADER_API_PSP2)
		// Fallback to low fidelity one for pre-SM3.0
		#define UNITY_BRDF_PBSSS BRDF3_Unity_PBSSS
	#elif defined(SHADER_API_MOBILE)
		// Somewhat simplified for mobile
		#define UNITY_BRDF_PBSSS BRDF2_Unity_PBSSS
	#else
		// Full quality for SM3+ PC / consoles
		#define UNITY_BRDF_PBSSS BRDF1_Unity_PBSSS
	#endif
#endif
			float4 CalculateLighting(UsefulData d, UnityGI gi){
				float4 c = float4(d.Albedo,d.Alpha);
				float3 cTemp = float3(0,0,0);
				float3 cDiff = float3(0,0,0);
				float3 cAmb = float3(0,0,0);
				float3 cSpec = float3(0,0,0);
			//Set default mask color
		float Mask0 = 1;
				Mask0 = d.Mask0;
			//Set default mask color
		float Mask1 = 1;
				Mask1 = d.Mask1;
				// energy conservation
				half oneMinusReflectivity;
				d.Albedo = EnergyConservationBetweenDiffuseAndSpecular (d.Albedo, d.Specular, /*out*/ oneMinusReflectivity);
				
				// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
				// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha
				half outputAlpha = d.Alpha;
				//For some reason #if defined() never works!!! So have to preprocess this when generating the shader...
				//d.Albedo = PreMultiplyAlpha (d.Albedo, d.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);
				
				c = UNITY_BRDF_PBSSS (d, gi, oneMinusReflectivity, d.Smoothness);
				c.rgb += UNITY_BRDF_GI (d.Albedo, d.Specular, oneMinusReflectivity, d.Smoothness, d.Normal, d.worldViewDir, d.Occlusion, gi);
				c.a = outputAlpha;
				return c;
			};

			void CalculateGI (UsefulData d,UnityGIInput data,inout UnityGI gi){
				#if UNITY_VERSION >= 520
					UNITY_GI(gi, d, data);
				#else
					gi = UnityGlobalIllumination (data, 1.0, d.Smoothness, d.Normal);
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
				d.Smoothness = _Shininess;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = (IN.viewDir);
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
	//Generate layers for the GrassDisp channel.
		//Generate Layer: Vertex Copy
			//Sample parts of the layer:
				half4 Vertex_CopyMask0_Sample1 = (PerlinNoise2D((((((d.uvTexcoord.xy*float2(_SSSGrass_Scale,_SSSGrass_Scale)))))*3)*3)+1)/2;

			//Set the mask to the new color
				Mask0 = Vertex_CopyMask0_Sample1.r;

				d.Mask0 = Mask0;
	//Set default mask color
		float Mask1 = 1;
	//Generate layers for the WindDisp channel.
		//Generate Layer: Vertex2 Copy
			//Sample parts of the layer:
				half4 Vertex2_CopyMask1_Sample1 = (PerlinNoise2D(((((((d.uvTexcoord.xy*float2(_SSSWind_Scale,_SSSWind_Scale))+float2(_Time.y/2,0)))))*3)*3)+1)/2;

			//Blend the layer into the channel using the Mix blend mode
				Mask1 = lerp(Mask1,Vertex2_CopyMask1_Sample1.r,Mask0);

				d.Mask1 = Mask1;
	//Generate layers for the Diffuse channel.
		//Generate Layer: Texture
			//Sample parts of the layer:
				half4 TextureAlbedo_Sample1 = tex2D(_MainTex,(((d.uv_MainTex.xy))));

			//Set the channel to the new color
				d.Albedo = TextureAlbedo_Sample1.rgb;

		//Generate Layer: Color
			//Sample parts of the layer:
				half4 ColorAlbedo_Sample1 = _Color;

			//Blend the layer into the channel using the Multiply blend mode
				d.Albedo *= ColorAlbedo_Sample1.rgb;

		//Generate Layer: AO
			//Sample parts of the layer:
				half4 AOAlbedo_Sample1 = (PerlinNoise2D((((((d.uvTexcoord.xy*float2(_SSSGrass_Scale,_SSSGrass_Scale)))))*3)*3)+1)/2;

			//Blend the layer into the channel using the Multiply blend mode
				d.Albedo = lerp(d.Albedo,d.Albedo*AOAlbedo_Sample1.rgb,_SSSAO_Strength);

	//Generate layers for the Specular channel.
		//Generate Layer: Specular
			//Sample parts of the layer:
				half4 SpecularSpecular_Sample1 = _SpecColor;

			//Set the channel to the new color
				d.Specular = SpecularSpecular_Sample1.rgb;

				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = worldN;
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				gi.light.color *= atten;
				c = CalculateLighting (d, gi);
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				c.a = 1;
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
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0,0,0,0#^CC0#?Color
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
VisName#!S2#^Text#^Color#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.5614604,1,0.3088235,1#^CC0#?Color
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
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^AO Strength#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^0.5413223#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSAO_Strength#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Grass Height#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^0.1960227#^CC0#?Number
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
VisName#!S2#^Text#^Grass Scale#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^30#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSGrass_Scale#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Grass Quality (Tessellation)#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^50#^CC0#?Number
Range0#!S2#^Float#^1#^CC0#?Range0
Range1#!S2#^Float#^50#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSGrass_Quality_Tessellation#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Specular Hardness#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^0.2629603#^CC0#?Number
Range0#!S2#^Float#^0.0001#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^6#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_Shininess#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^1#^CC0#?Type
VisName#!S2#^Text#^Specular Color#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.125,0.125,0.125,1#^CC0#?Color
Number#!S2#^Float#^0#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^5#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SpecColor#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^4#^CC0#?Type
VisName#!S2#^Text#^Wind Strength#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^0.08264463#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSWind_Strength#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^1#^CC0#?Type
VisName#!S2#^Text#^Wind Direction#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.1617647,0,0.1617647,1#^CC0#?Color
Number#!S2#^Float#^0#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSWind_Direction#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^3#^CC0#?Type
VisName#!S2#^Text#^Wind Scale#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^55.7#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^0#^CC0#?SpecialType
InEditor#!S2#^Float#^1#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSWind_Scale#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
BeginShaderInput
Type#!S2#^Float#^3#^CC0#?Type
VisName#!S2#^Text#^Wind Offset#^CC0#?VisName
ImageDefault#!S2#^Float#^0#^CC0#?ImageDefault
Image#!S2#^Text#^#^CC0#?Image
Cube#!S2#^Text#^#^CC0#?Cube
Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Color
Number#!S2#^Float#^339.4731#^CC0#?Number
Range0#!S2#^Float#^0#^CC0#?Range0
Range1#!S2#^Float#^1#^CC0#?Range1
MainType#!S2#^Float#^0#^CC0#?MainType
SpecialType#!S2#^Float#^3#^CC0#?SpecialType
InEditor#!S2#^Float#^0#^CC0#?InEditor
NormalMap#!S2#^Float#^0#^CC0#?NormalMap
CustomFallback#!S2#^Text#^_SSSWind_Offset#^CC0#?CustomFallback
CustomSpecial#!S2#^Text#^1#^CC0#?CustomSpecial
EndShaderInput
ShaderName#!S2#^Text#^Shader Sandwich/DX11/Tessellated Fur#^CC0#?ShaderName
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Queue#!S2#^Type#^1#^CC0#?Queue
QueueAuto#!S2#^Toggle#^True#^CC0#?QueueAuto
Tech Shader Target#!S2#^Float#^5#^CC0#?Tech Shader Target
Vertex Recalculation#!S2#^Toggle#^False#^CC0#?Vertex Recalculation
Use Fog#!S2#^Toggle#^True#^CC0#?Use Fog
Use Ambient#!S2#^Toggle#^True#^CC0#?Use Ambient
Use Vertex Lights#!S2#^Toggle#^True#^CC0#?Use Vertex Lights
Use Lightmaps#!S2#^Toggle#^True#^CC0#?Use Lightmaps
Use All Shadows#!S2#^Toggle#^False#^CC0#?Use All Shadows
Forward Add#!S2#^Toggle#^True#^CC0#?Forward Add
Shadows#!S2#^Toggle#^False#^CC0#?Shadows
Interpolate View#!S2#^Toggle#^True#^CC0#?Interpolate View
Half as View#!S2#^Toggle#^False#^CC0#?Half as View
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^4#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
Use Normals#!S2#^Float#^0#^CC0#?Use Normals
Specular On#!S2#^Toggle#^True#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.2629603#^CC0 #^ 6#?Spec Hardness
Spec Energy Conserve#!S2#^Toggle#^True#^CC0#?Spec Energy Conserve
Spec Offset#!S2#^Float#^0#^CC0#?Spec Offset
Emission On#!S2#^Toggle#^False#^CC0#?Emission On
Emission Type#!S2#^Type#^0#^CC0#?Emission Type
Transparency On#!S2#^Toggle#^False#^CC0#?Transparency On
Transparency Type#!S2#^Type#^0#^CC0#?Transparency Type
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
Tessellation On#!S2#^Toggle#^True#^CC0#?Tessellation On
Tessellation Type#!S2#^Type#^2#^CC0#?Tessellation Type
Tessellation Quality#!S2#^Float#^50#^CC0 #^ 5#?Tessellation Quality
Tessellation Falloff#!S2#^Float#^1#^CC0#?Tessellation Falloff
Tessellation Smoothing Amount#!S2#^Float#^0#^CC0#?Tessellation Smoothing Amount
BeginMasks
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Mask0#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^GrassDisp#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^True#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^r#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Vertex Copy#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTPerlinNoise#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^5#^CC0#?Layer Type
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
Mix Amount#!S2#^Float#^1#^CC0#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^0#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^-1#^CC0#?Stencil
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
TypeS#!S2#^Text#^SSEUVScale#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Seperate#!S2#^Toggle#^False#^CC0#?Seperate
Scale#!S2#^Float#^30#^CC0 #^ 4#?Scale
Y Scale#!S2#^Float#^30#^CC0 #^ 4#?Y Scale
Z Scale#!S2#^Float#^30#^CC0 #^ 4#?Z Scale
EndShaderEffect
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Mask1#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^WindDisp#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^True#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^r#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Vertex2 Copy#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTPerlinNoise#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^5#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.1617647,0,0.1617647,1#^CC0 #^ 9#?Main Color
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
Stencil#!S2#^ObjectArray#^0#^CC0#?Stencil
Vertex Mask#!S2#^Float#^1#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0.1617647,0,0.1617647,1#^CC0 #^ 9#?Color
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEUVScale#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Seperate#!S2#^Toggle#^False#^CC0#?Seperate
Scale#!S2#^Float#^55.7#^CC0 #^ 10#?Scale
Y Scale#!S2#^Float#^55.7#^CC0 #^ 10#?Y Scale
Z Scale#!S2#^Float#^55.7#^CC0 #^ 10#?Z Scale
EndShaderEffect
BeginShaderEffect
TypeS#!S2#^Text#^SSEUVOffset#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
X Offset#!S2#^Float#^339.4731#^CC0 #^ 11#?X Offset
Y Offset#!S2#^Float#^0#^CC0#?Y Offset
Z Offset#!S2#^Float#^0#^CC0#?Z Offset
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
Tech Shader Target#!S2#^Float#^5#^CC0#?Tech Shader Target
Vertex Recalculation#!S2#^Toggle#^False#^CC0#?Vertex Recalculation
Use Fog#!S2#^Toggle#^True#^CC0#?Use Fog
Use Ambient#!S2#^Toggle#^True#^CC0#?Use Ambient
Use Vertex Lights#!S2#^Toggle#^True#^CC0#?Use Vertex Lights
Use Lightmaps#!S2#^Toggle#^True#^CC0#?Use Lightmaps
Use All Shadows#!S2#^Toggle#^False#^CC0#?Use All Shadows
Forward Add#!S2#^Toggle#^True#^CC0#?Forward Add
Shadows#!S2#^Toggle#^False#^CC0#?Shadows
Interpolate View#!S2#^Toggle#^True#^CC0#?Interpolate View
Recalculate After Vertex#!S2#^Toggle#^True#^CC0#?Recalculate After Vertex
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^0#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
PBR Quality#!S2#^Type#^0#^CC0#?PBR Quality
Disable Normals#!S2#^Float#^0#^CC0#?Disable Normals
Specular On#!S2#^Toggle#^True#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.2629603#^CC0 #^ 6#?Spec Hardness
Spec Energy Conserve#!S2#^Toggle#^True#^CC0#?Spec Energy Conserve
Spec Offset#!S2#^Float#^0#^CC0#?Spec Offset
Emission On#!S2#^Toggle#^False#^CC0#?Emission On
Emission Type#!S2#^Type#^0#^CC0#?Emission Type
Transparency On#!S2#^Toggle#^False#^CC0#?Transparency On
Transparency Type#!S2#^Type#^0#^CC0#?Transparency Type
ZWrite#!S2#^Toggle#^False#^CC0#?ZWrite
Use PBR#!S2#^Toggle#^True#^CC0#?Use PBR
Transparency#!S2#^Float#^1#^CC0#?Transparency
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
Parallax On#!S2#^Toggle#^False#^CC0#?Parallax On
Parallax Height#!S2#^Float#^0.1#^CC0#?Parallax Height
Parallax Quality#!S2#^Float#^10#^CC0#?Parallax Quality
Silhouette Clipping#!S2#^Toggle#^False#^CC0#?Silhouette Clipping
Parallax Shadows#!S2#^Toggle#^False#^CC0#?Parallax Shadows
Parallax Shadow Strength#!S2#^Float#^1#^CC0#?Parallax Shadow Strength
Parallax Shadow Size#!S2#^Float#^1#^CC0#?Parallax Shadow Size
Tessellation On#!S2#^Toggle#^True#^CC0#?Tessellation On
Tessellation Type#!S2#^Type#^2#^CC0#?Tessellation Type
Tessellation Quality#!S2#^Float#^50#^CC0 #^ 5#?Tessellation Quality
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
Main Texture#!S2#^Texture#^ #^CC0 #^ 0#?Main Texture
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
Texture#!S2#^Texture#^#^CC0 #^ 0#?Texture
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
Main Color#!S2#^Vec#^0.5614604,1,0.3088235,1#^CC0 #^ 1#?Main Color
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
Color#!S2#^Vec#^0.5614604,1,0.3088235,1#^CC0 #^ 1#?Color
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
Layer Name#!S2#^Text#^AO#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTPerlinNoise#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^5#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.627451,0.8,0.8823529,1#^CC0#?Main Color
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
Mix Amount#!S2#^Float#^0.5413223#^CC0 #^ 2#?Mix Amount
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
Color#!S2#^Vec#^0.627451,0.8,0.8823529,1#^CC0#?Color
Color 2#!S2#^Vec#^0,0,0,1#^CC0#?Color 2
Texture#!S2#^Texture#^#^CC0#?Texture
Jitter#!S2#^Float#^0#^CC0#?Jitter
Fill#!S2#^Float#^0#^CC0#?Fill
MinSize#!S2#^Float#^0#^CC0#?MinSize
Edge#!S2#^Float#^1#^CC0#?Edge
MaxSize#!S2#^Float#^1#^CC0#?MaxSize
Square#!S2#^Toggle#^False#^CC0#?Square
BeginShaderEffect
TypeS#!S2#^Text#^SSEUVScale#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Seperate#!S2#^Toggle#^False#^CC0#?Seperate
Scale#!S2#^Float#^30#^CC0 #^ 4#?Scale
Y Scale#!S2#^Float#^30#^CC0 #^ 4#?Y Scale
Z Scale#!S2#^Float#^30#^CC0 #^ 4#?Z Scale
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
BeginShaderLayer
Layer Name#!S2#^Text#^Specular#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.125,0.125,0.125,1#^CC0 #^ 7#?Main Color
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
Color#!S2#^Vec#^0.125,0.125,0.125,1#^CC0 #^ 7#?Color
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
Layer Name#!S2#^Text#^GrassDisp#^CC0#?Layer Name
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
Mix Amount#!S2#^Float#^0.1960227#^CC0 #^ 3#?Mix Amount
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
TypeS#!S2#^Text#^SSEUVScale#^CC0#?TypeS
IsVisible#!S2#^Toggle#^True#^CC0#?IsVisible
UseAlpha#!S2#^Float#^0#^CC0#?UseAlpha
Seperate#!S2#^Toggle#^False#^CC0#?Seperate
Scale#!S2#^Float#^30#^CC0 #^ 4#?Scale
Y Scale#!S2#^Float#^30#^CC0 #^ 4#?Y Scale
Z Scale#!S2#^Float#^30#^CC0 #^ 4#?Z Scale
EndShaderEffect
EndShaderLayer
BeginShaderLayer
Layer Name#!S2#^Text#^WindDisp#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.1617647,0,0.1617647,1#^CC0 #^ 9#?Main Color
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
Mix Amount#!S2#^Float#^0.08264463#^CC0 #^ 8#?Mix Amount
Use Fadeout#!S2#^Toggle#^False#^CC0#?Use Fadeout
Fadeout Limit Min#!S2#^Float#^0#^CC0#?Fadeout Limit Min
Fadeout Limit Max#!S2#^Float#^10#^CC0#?Fadeout Limit Max
Fadeout Start#!S2#^Float#^3#^CC0#?Fadeout Start
Fadeout End#!S2#^Float#^5#^CC0#?Fadeout End
Mix Type#!S2#^Type#^1#^CC0#?Mix Type
Stencil#!S2#^ObjectArray#^1#^CC0#?Stencil
Vertex Mask#!S2#^Float#^0#^CC0#?Vertex Mask
Cubemap#!S2#^Cubemap#^#^CC0#?Cubemap
Noise Dimensions#!S2#^Type#^0#^CC0#?Noise Dimensions
Color#!S2#^Vec#^0.1617647,0,0.1617647,1#^CC0 #^ 9#?Color
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
