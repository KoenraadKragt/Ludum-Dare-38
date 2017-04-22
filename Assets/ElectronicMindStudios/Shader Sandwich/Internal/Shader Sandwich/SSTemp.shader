// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/SSTemp" {//The Shaders Name
//The inputs shown in the material panel
Properties {
	_AOStrength("Occlusion Strength", Range(0,1)) = 1
	_AOPower("Occlusion Pushback", Range(0,4)) = 1
}

SubShader {
	Tags { "RenderType"="Opaque" "Queue"="Geometry" }//A bunch of settings telling Unity a bit about the shader.
	LOD 200
AlphaToMask Off
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
	ZTest LEqual
	Blend Off//No transparency
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile __ UNITY_COLORSPACE_GAMMA
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

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV0;//Main Color
				float4 SSTEMPSV2;//Second Color
				float SSTEMPSV4;//Noise A
				float SSTEMPSV6;//Noise B
				float SSTEMPSV8;//Mix Amount
				float SSTEMPSV10;//Fadeout Limit Min
				float SSTEMPSV12;//Fadeout Limit Max
				float SSTEMPSV14;//Fadeout Start
				float SSTEMPSV16;//Fadeout End
				float SSTEMPSV18;//Vertex Mask
				float SSTEMPSV20;//Vertex Space
				float4 SSTEMPSV22;//Color
				float4 SSTEMPSV24;//Main Color
				float4 SSTEMPSV26;//Second Color
				float SSTEMPSV28;//Noise A
				float SSTEMPSV30;//Noise B
				float SSTEMPSV32;//Mix Amount
				float SSTEMPSV34;//Fadeout Limit Min
				float SSTEMPSV36;//Fadeout Limit Max
				float SSTEMPSV38;//Fadeout Start
				float SSTEMPSV40;//Fadeout End
				float SSTEMPSV42;//Vertex Mask
				float SSTEMPSV44;//Vertex Space
				float4 SSTEMPSV46;//Color
				float4 SSTEMPSV48;//Main Color
				float4 SSTEMPSV50;//Second Color
				float SSTEMPSV52;//Noise A
				float SSTEMPSV54;//Noise B
				float SSTEMPSV56;//Mix Amount
				float SSTEMPSV58;//Fadeout Limit Min
				float SSTEMPSV60;//Fadeout Limit Max
				float SSTEMPSV62;//Fadeout Start
				float SSTEMPSV64;//Fadeout End
				float SSTEMPSV66;//Vertex Mask
				float SSTEMPSV68;//Vertex Space
				float4 SSTEMPSV70;//Color
				float SSTEMPSV73;//Tech Shader Target
				float SSTEMPSV75;//Setting1
				float4 SSTEMPSV77;//Wrap Color
				float SSTEMPSV79;//Use Normals
				float SSTEMPSV81;//Spec Hardness
				float SSTEMPSV83;//Spec Offset
				float SSTEMPSV85;//Transparency
				float SSTEMPSV87;//Shell Count
				float SSTEMPSV89;//Shells Distance
				float SSTEMPSV91;//Shell Ease
				float SSTEMPSV93;//Shells Transparency
				float SSTEMPSV95;//Parallax Height
				float SSTEMPSV97;//Parallax Quality
				float SSTEMPSV99;//Tessellation Quality
				float SSTEMPSV101;//Tessellation Falloff
				float SSTEMPSV103;//Tessellation Smoothing Amount
				float SSTEMPSV107;//Indirect Ambient Occlusion Strength
				float SSTEMPSV109;//Indirect Ambient Occlusion Pushback
				float SSTEMPSV111;//SSS Mix
				float SSTEMPSV113;//SSS Constant Scatter
				float SSTEMPSV115;//SSS Density
				float SSTEMPSV117;//SSS Fresnel Distortion
				float SSTEMPSV119;//SSS Fresnel Brightness
				float SSTEMPSV121;//SSS Fresnel Thinness
				float4 SSTEMPSV123;//SSS Color
				float SSTEMPSV125;//Setting1
				float4 SSTEMPSV127;//Wrap Color
				float SSTEMPSV129;//Disable Normals
				float SSTEMPSV131;//Spec Hardness
				float SSTEMPSV133;//Max Light Spec Hardness
				float SSTEMPSV135;//Spec Offset
				float SSTEMPSV137;//Transparency
				float SSTEMPSV139;//CutoffZWriteTransparency
				float SSTEMPSV142;//Shells Distance
				float SSTEMPSV144;//Shell Ease
				float SSTEMPSV146;//Parallax Height
				float SSTEMPSV149;//Parallax Shadow Strength
				float SSTEMPSV151;//Parallax Shadow Size
				float SSTEMPSV153;//Tessellation Quality
				float SSTEMPSV155;//Tessellation Falloff
				float SSTEMPSV157;//Tessellation Smoothing Amount
				float SSTEMPSV160;//Poke Float3 Count
				float SSTEMPSV162;//Poke Float Count
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

			struct UsefulData{
				float3 Albedo;
				float Metallic;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float LightSmoothness;
				float Atten;
				float Thickness;
				float3 SubsurfaceColor;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				fixed4 color;
				float ShellDepth;
			};
			#ifdef LIGHTMAP_OFF
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					fixed4 color : COLOR0;
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
					float3 worldNormal: TEXCOORD1;
					fixed4 color : COLOR0;
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

	float4 GammaToLinear(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 GammaToLinearForce(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 LinearToGamma(float4 col){
		return col;
	}

	float4 LinearToGammaForWeirdSituations(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinear(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinearForce(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 LinearToGamma(float3 col){
		return col;
	}





			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.color = v.color;
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
				Vertex.w = v.vertex.w;
				v.vertex.xyz = Vertex.xyz;
				o.pos = UnityObjectToClipPos (Vertex);
				#ifndef LIGHTMAP_OFF
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				
				// SH/ambient and vertex lights
				#ifdef LIGHTMAP_OFF
					#if UNITY_SHOULD_SAMPLE_SH
						o.sh = 0;
						// Add approximated illumination from non-important point lights
						#ifdef VERTEXLIGHT_ON
							o.sh += Shade4PointLights (
							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
							unity_4LightAtten0, worldPos, worldNormal);
						#endif
						o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
				#endif // LIGHTMAP_OFF
				
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}



//Include a bunch of PBS Code from files UnityPBSLighting.cginc and UnityStandardBRDF.cginc for the purpose of custom lighting effects.
half4 BRDF1_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half roughness = 1-oneMinusRoughness;
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	#if UNITY_BRDF_GGX 
		// NdotV should not be negative for visible pixels, but it can happen due to perspective projection and normal mapping
		// In this case we will modify the normal so it become valid and not cause weird artifact (other game try to clamp or abs the NdotV to prevent this trouble).
		// The amount we shift the normal toward the view vector is define by the dot product.
		// This correction is only apply with smithJoint visibility function because artifact are more visible in this case due to highlight edge of rough surface
		half shiftAmount = dot(d.Normal, d.worldViewDir);
		d.Normal = shiftAmount < 0.0f ? d.Normal + d.worldViewDir * (-shiftAmount + 1e-5f) : d.Normal;
		// A re-normalization should be apply here but as the shift is small we don't do it to save ALU.
		//normal = normalize(normal);

		// As we have modify the normal we need to recalculate the dot product nl. 
		// Note that  light.ndotl is a clamped cosine and only the ForwardSimple mode use a specific ndotL with BRDF3
		half nl = DotClamped(d.Normal, gi.light.dir);
	#else
		half nl = gi.light.ndotl;
	#endif
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped(d.Normal, d.worldViewDir);

	half lv = DotClamped (gi.light.dir, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

	#if UNITY_BRDF_GGX
		half V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
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
	half specularTerm = (V * D) * (UNITY_PI/4); // Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)

	if (IsGammaSpace())
		specularTerm = sqrt(max(1e-4h, specularTerm));
	specularTerm = max(0, specularTerm * nl);

	half diffuseTerm = disneyDiffuse * nl;

	// surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(realRoughness^2+1)
	half realRoughness = roughness*roughness;		// need to square perceptual roughness
	half surfaceReduction;
	if (IsGammaSpace()) surfaceReduction = 1.0 - 0.28*realRoughness*roughness;		// 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
	else surfaceReduction = 1.0 / (realRoughness*realRoughness + 1.0);			// fade \in [0.5;1]

	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
    half3 cDiff = (gi.light.color * diffuseTerm);
	half3 cSpec = specularTerm * gi.light.color * FresnelTerm (d.Specular, lh) + surfaceReduction * gi.indirect.specular * FresnelLerp (d.Specular, grazingTerm, nv);

	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113*pow(d.Atten,SSTEMPSV115))) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * disneyDiffuse* lerp(fLT,nl,SSTEMPSV111);
		


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
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

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
	
	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113)) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * lerp(fLT,nl,SSTEMPSV111);
		


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
	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp

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
	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113)) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * lerp(fLT,nl,SSTEMPSV111);
		


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
				// energy conservation
				half oneMinusReflectivity;
half3 specColor;
				d.Albedo = DiffuseAndSpecularFromMetallic (d.Albedo, d.Metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);
d.Specular = specColor;
				
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

			void FragmentShader (v2f_surf IN,
				out fixed4 outputColor : SV_Target) {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Metallic = 0.3;
				d.Normal = IN.worldNormal;
				d.Occlusion = 1;
				d.SubsurfaceColor = float3(1,0,0);
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				d.LightSmoothness = 0;
				d.Alpha = 1;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.color = IN.color;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
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
				d.Atten = atten;
				
				// Setup lighting environment
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				#if !defined(LIGHTMAP_ON)
					gi.light.color = LinearToGamma(_LightColor0.rgb);
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
				d.Smoothness = SSTEMPSV131;
				d.LightSmoothness = SSTEMPSV133;
	//Generate layers for the Albedo channel.
		//Generate Layer: Albedo
			//Sample parts of the layer:
				half4 AlbedoAlbedo_Sample1 = GammaToLinear(SSTEMPSV22);

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,AlbedoAlbedo_Sample1.rgb,SSTEMPSV8);

	//Generate layers for the Metallic channel.
		//Generate Layer: Metallic
			//Sample parts of the layer:
				half4 MetallicMetallic_Sample1 = GammaToLinear(SSTEMPSV70);

			//Blend the layer into the channel using the Mix blend mode
				d.Metallic = lerp(d.Metallic,MetallicMetallic_Sample1.r,SSTEMPSV56);

				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = normalize(worldN);
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				CalculateGI(d, giInput, gi);
				//For some reason gamma correcting the indirect diffuse causes random black patches...don't ask.
				//gi.indirect.diffuse = LinearToGamma(gi.indirect.diffuse);
				gi.indirect.specular = LinearToGamma(gi.indirect.specular);
				d.Smoothness = min(d.Smoothness,d.LightSmoothness);
				d.Thickness = d.color.a;				c = CalculateLighting (d, gi)+d.Emission;
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				c.a = 1;
				outputColor = c;
			}

		ENDCG
	}
AlphaToMask Off
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
	Fog { Color (0,0,0,0) }
	ZTest LEqual
	Blend One One//No transparency (But add in the Forward Add pass)
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile __ UNITY_COLORSPACE_GAMMA
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

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV0;//Main Color
				float4 SSTEMPSV2;//Second Color
				float SSTEMPSV4;//Noise A
				float SSTEMPSV6;//Noise B
				float SSTEMPSV8;//Mix Amount
				float SSTEMPSV10;//Fadeout Limit Min
				float SSTEMPSV12;//Fadeout Limit Max
				float SSTEMPSV14;//Fadeout Start
				float SSTEMPSV16;//Fadeout End
				float SSTEMPSV18;//Vertex Mask
				float SSTEMPSV20;//Vertex Space
				float4 SSTEMPSV22;//Color
				float4 SSTEMPSV24;//Main Color
				float4 SSTEMPSV26;//Second Color
				float SSTEMPSV28;//Noise A
				float SSTEMPSV30;//Noise B
				float SSTEMPSV32;//Mix Amount
				float SSTEMPSV34;//Fadeout Limit Min
				float SSTEMPSV36;//Fadeout Limit Max
				float SSTEMPSV38;//Fadeout Start
				float SSTEMPSV40;//Fadeout End
				float SSTEMPSV42;//Vertex Mask
				float SSTEMPSV44;//Vertex Space
				float4 SSTEMPSV46;//Color
				float4 SSTEMPSV48;//Main Color
				float4 SSTEMPSV50;//Second Color
				float SSTEMPSV52;//Noise A
				float SSTEMPSV54;//Noise B
				float SSTEMPSV56;//Mix Amount
				float SSTEMPSV58;//Fadeout Limit Min
				float SSTEMPSV60;//Fadeout Limit Max
				float SSTEMPSV62;//Fadeout Start
				float SSTEMPSV64;//Fadeout End
				float SSTEMPSV66;//Vertex Mask
				float SSTEMPSV68;//Vertex Space
				float4 SSTEMPSV70;//Color
				float SSTEMPSV73;//Tech Shader Target
				float SSTEMPSV75;//Setting1
				float4 SSTEMPSV77;//Wrap Color
				float SSTEMPSV79;//Use Normals
				float SSTEMPSV81;//Spec Hardness
				float SSTEMPSV83;//Spec Offset
				float SSTEMPSV85;//Transparency
				float SSTEMPSV87;//Shell Count
				float SSTEMPSV89;//Shells Distance
				float SSTEMPSV91;//Shell Ease
				float SSTEMPSV93;//Shells Transparency
				float SSTEMPSV95;//Parallax Height
				float SSTEMPSV97;//Parallax Quality
				float SSTEMPSV99;//Tessellation Quality
				float SSTEMPSV101;//Tessellation Falloff
				float SSTEMPSV103;//Tessellation Smoothing Amount
				float SSTEMPSV107;//Indirect Ambient Occlusion Strength
				float SSTEMPSV109;//Indirect Ambient Occlusion Pushback
				float SSTEMPSV111;//SSS Mix
				float SSTEMPSV113;//SSS Constant Scatter
				float SSTEMPSV115;//SSS Density
				float SSTEMPSV117;//SSS Fresnel Distortion
				float SSTEMPSV119;//SSS Fresnel Brightness
				float SSTEMPSV121;//SSS Fresnel Thinness
				float4 SSTEMPSV123;//SSS Color
				float SSTEMPSV125;//Setting1
				float4 SSTEMPSV127;//Wrap Color
				float SSTEMPSV129;//Disable Normals
				float SSTEMPSV131;//Spec Hardness
				float SSTEMPSV133;//Max Light Spec Hardness
				float SSTEMPSV135;//Spec Offset
				float SSTEMPSV137;//Transparency
				float SSTEMPSV139;//CutoffZWriteTransparency
				float SSTEMPSV142;//Shells Distance
				float SSTEMPSV144;//Shell Ease
				float SSTEMPSV146;//Parallax Height
				float SSTEMPSV149;//Parallax Shadow Strength
				float SSTEMPSV151;//Parallax Shadow Size
				float SSTEMPSV153;//Tessellation Quality
				float SSTEMPSV155;//Tessellation Falloff
				float SSTEMPSV157;//Tessellation Smoothing Amount
				float SSTEMPSV160;//Poke Float3 Count
				float SSTEMPSV162;//Poke Float Count
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

			struct UsefulData{
				float3 Albedo;
				float Metallic;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float LightSmoothness;
				float Atten;
				float Thickness;
				float3 SubsurfaceColor;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				fixed4 color;
				float ShellDepth;
			};
			struct v2f_surf {
				float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					fixed4 color : COLOR0;
				SHADOW_COORDS(2)
				UNITY_FOG_COORDS(3)
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

	float4 GammaToLinear(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 GammaToLinearForce(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 LinearToGamma(float4 col){
		return col;
	}

	float4 LinearToGammaForWeirdSituations(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinear(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinearForce(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 LinearToGamma(float3 col){
		return col;
	}





			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.color = v.color;
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
				Vertex.w = v.vertex.w;
				v.vertex.xyz = Vertex.xyz;
				o.pos = UnityObjectToClipPos (Vertex);
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}



//Include a bunch of PBS Code from files UnityPBSLighting.cginc and UnityStandardBRDF.cginc for the purpose of custom lighting effects.
half4 BRDF1_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half roughness = 1-oneMinusRoughness;
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	#if UNITY_BRDF_GGX 
		// NdotV should not be negative for visible pixels, but it can happen due to perspective projection and normal mapping
		// In this case we will modify the normal so it become valid and not cause weird artifact (other game try to clamp or abs the NdotV to prevent this trouble).
		// The amount we shift the normal toward the view vector is define by the dot product.
		// This correction is only apply with smithJoint visibility function because artifact are more visible in this case due to highlight edge of rough surface
		half shiftAmount = dot(d.Normal, d.worldViewDir);
		d.Normal = shiftAmount < 0.0f ? d.Normal + d.worldViewDir * (-shiftAmount + 1e-5f) : d.Normal;
		// A re-normalization should be apply here but as the shift is small we don't do it to save ALU.
		//normal = normalize(normal);

		// As we have modify the normal we need to recalculate the dot product nl. 
		// Note that  light.ndotl is a clamped cosine and only the ForwardSimple mode use a specific ndotL with BRDF3
		half nl = DotClamped(d.Normal, gi.light.dir);
	#else
		half nl = gi.light.ndotl;
	#endif
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped(d.Normal, d.worldViewDir);

	half lv = DotClamped (gi.light.dir, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

	#if UNITY_BRDF_GGX
		half V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
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
	half specularTerm = (V * D) * (UNITY_PI/4); // Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)

	if (IsGammaSpace())
		specularTerm = sqrt(max(1e-4h, specularTerm));
	specularTerm = max(0, specularTerm * nl);

	half diffuseTerm = disneyDiffuse * nl;

	// surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(realRoughness^2+1)
	half realRoughness = roughness*roughness;		// need to square perceptual roughness
	half surfaceReduction;
	if (IsGammaSpace()) surfaceReduction = 1.0 - 0.28*realRoughness*roughness;		// 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
	else surfaceReduction = 1.0 / (realRoughness*realRoughness + 1.0);			// fade \in [0.5;1]

	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
    half3 cDiff = (gi.light.color * diffuseTerm);
	half3 cSpec = specularTerm * gi.light.color * FresnelTerm (d.Specular, lh) + surfaceReduction * gi.indirect.specular * FresnelLerp (d.Specular, grazingTerm, nv);

	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113*pow(d.Atten,SSTEMPSV115))) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * disneyDiffuse* lerp(fLT,nl,SSTEMPSV111);
		


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
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

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
	
	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113)) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * lerp(fLT,nl,SSTEMPSV111);
		


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
	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp

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
	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113)) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * lerp(fLT,nl,SSTEMPSV111);
		


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
				// energy conservation
				half oneMinusReflectivity;
half3 specColor;
				d.Albedo = DiffuseAndSpecularFromMetallic (d.Albedo, d.Metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);
d.Specular = specColor;
				
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

			void FragmentShader (v2f_surf IN,
				out fixed4 outputColor : SV_Target) {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Metallic = 0.3;
				d.Normal = IN.worldNormal;
				d.Occlusion = 1;
				d.SubsurfaceColor = float3(1,0,0);
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				d.LightSmoothness = 0;
				d.Alpha = 1;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.color = IN.color;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
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
				d.Atten = atten;
				
				// Setup lighting environment
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				#if !defined(LIGHTMAP_ON)
					gi.light.color = LinearToGamma(_LightColor0.rgb);
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
				d.Smoothness = SSTEMPSV131;
				d.LightSmoothness = SSTEMPSV133;
	//Generate layers for the Albedo channel.
		//Generate Layer: Albedo
			//Sample parts of the layer:
				half4 AlbedoAlbedo_Sample1 = GammaToLinear(SSTEMPSV22);

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,AlbedoAlbedo_Sample1.rgb,SSTEMPSV8);

	//Generate layers for the Metallic channel.
		//Generate Layer: Metallic
			//Sample parts of the layer:
				half4 MetallicMetallic_Sample1 = GammaToLinear(SSTEMPSV70);

			//Blend the layer into the channel using the Mix blend mode
				d.Metallic = lerp(d.Metallic,MetallicMetallic_Sample1.r,SSTEMPSV56);

				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = normalize(worldN);
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				gi.light.color *= atten;
				d.Smoothness = min(d.Smoothness,d.LightSmoothness);
				d.Thickness = d.color.a;				c = CalculateLighting (d, gi);
				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;
				c.a = 1;
				outputColor = c;
			}

		ENDCG
	}
AlphaToMask Off
	Pass {
		Name "DEFERRED"
		Tags { "LightMode" = "Deferred" }
	ZTest LEqual
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile __ UNITY_COLORSPACE_GAMMA
				#pragma exclude_renderers nomrt
				#pragma multi_compile_prepassfinal
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define UNITY_PASS_DEFERRED
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal
				

			//Make our inputs accessible by declaring them here.

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV0;//Main Color
				float4 SSTEMPSV2;//Second Color
				float SSTEMPSV4;//Noise A
				float SSTEMPSV6;//Noise B
				float SSTEMPSV8;//Mix Amount
				float SSTEMPSV10;//Fadeout Limit Min
				float SSTEMPSV12;//Fadeout Limit Max
				float SSTEMPSV14;//Fadeout Start
				float SSTEMPSV16;//Fadeout End
				float SSTEMPSV18;//Vertex Mask
				float SSTEMPSV20;//Vertex Space
				float4 SSTEMPSV22;//Color
				float4 SSTEMPSV24;//Main Color
				float4 SSTEMPSV26;//Second Color
				float SSTEMPSV28;//Noise A
				float SSTEMPSV30;//Noise B
				float SSTEMPSV32;//Mix Amount
				float SSTEMPSV34;//Fadeout Limit Min
				float SSTEMPSV36;//Fadeout Limit Max
				float SSTEMPSV38;//Fadeout Start
				float SSTEMPSV40;//Fadeout End
				float SSTEMPSV42;//Vertex Mask
				float SSTEMPSV44;//Vertex Space
				float4 SSTEMPSV46;//Color
				float4 SSTEMPSV48;//Main Color
				float4 SSTEMPSV50;//Second Color
				float SSTEMPSV52;//Noise A
				float SSTEMPSV54;//Noise B
				float SSTEMPSV56;//Mix Amount
				float SSTEMPSV58;//Fadeout Limit Min
				float SSTEMPSV60;//Fadeout Limit Max
				float SSTEMPSV62;//Fadeout Start
				float SSTEMPSV64;//Fadeout End
				float SSTEMPSV66;//Vertex Mask
				float SSTEMPSV68;//Vertex Space
				float4 SSTEMPSV70;//Color
				float SSTEMPSV73;//Tech Shader Target
				float SSTEMPSV75;//Setting1
				float4 SSTEMPSV77;//Wrap Color
				float SSTEMPSV79;//Use Normals
				float SSTEMPSV81;//Spec Hardness
				float SSTEMPSV83;//Spec Offset
				float SSTEMPSV85;//Transparency
				float SSTEMPSV87;//Shell Count
				float SSTEMPSV89;//Shells Distance
				float SSTEMPSV91;//Shell Ease
				float SSTEMPSV93;//Shells Transparency
				float SSTEMPSV95;//Parallax Height
				float SSTEMPSV97;//Parallax Quality
				float SSTEMPSV99;//Tessellation Quality
				float SSTEMPSV101;//Tessellation Falloff
				float SSTEMPSV103;//Tessellation Smoothing Amount
				float SSTEMPSV107;//Indirect Ambient Occlusion Strength
				float SSTEMPSV109;//Indirect Ambient Occlusion Pushback
				float SSTEMPSV111;//SSS Mix
				float SSTEMPSV113;//SSS Constant Scatter
				float SSTEMPSV115;//SSS Density
				float SSTEMPSV117;//SSS Fresnel Distortion
				float SSTEMPSV119;//SSS Fresnel Brightness
				float SSTEMPSV121;//SSS Fresnel Thinness
				float4 SSTEMPSV123;//SSS Color
				float SSTEMPSV125;//Setting1
				float4 SSTEMPSV127;//Wrap Color
				float SSTEMPSV129;//Disable Normals
				float SSTEMPSV131;//Spec Hardness
				float SSTEMPSV133;//Max Light Spec Hardness
				float SSTEMPSV135;//Spec Offset
				float SSTEMPSV137;//Transparency
				float SSTEMPSV139;//CutoffZWriteTransparency
				float SSTEMPSV142;//Shells Distance
				float SSTEMPSV144;//Shell Ease
				float SSTEMPSV146;//Parallax Height
				float SSTEMPSV149;//Parallax Shadow Strength
				float SSTEMPSV151;//Parallax Shadow Size
				float SSTEMPSV153;//Tessellation Quality
				float SSTEMPSV155;//Tessellation Falloff
				float SSTEMPSV157;//Tessellation Smoothing Amount
				float SSTEMPSV160;//Poke Float3 Count
				float SSTEMPSV162;//Poke Float Count
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

			struct UsefulData{
				float3 Albedo;
				float Metallic;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float LightSmoothness;
				float Atten;
				float Thickness;
				float3 SubsurfaceColor;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				fixed4 color;
				float ShellDepth;
			};
				struct v2f_surf {
					float4 pos : SV_POSITION;
					float3 worldPos: TEXCOORD0;
					float3 worldNormal: TEXCOORD1;
					fixed4 color : COLOR0;
					float4 lmap : TEXCOORD2;
					#ifdef LIGHTMAP_OFF
						#if UNITY_SHOULD_SAMPLE_SH
							half3 sh : TEXCOORD3; // SH
					  	#endif
					  #else
					  	#ifdef DIRLIGHTMAP_OFF
					  		float4 lmapFadePos : TEXCOORD4;
					  	#endif
					  #endif;
					SHADOW_COORDS(5)
					UNITY_FOG_COORDS(6)
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

	float4 GammaToLinear(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 GammaToLinearForce(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 LinearToGamma(float4 col){
		return col;
	}

	float4 LinearToGammaForWeirdSituations(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinear(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinearForce(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 LinearToGamma(float3 col){
		return col;
	}





			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.color = v.color;
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
				Vertex.w = v.vertex.w;
				v.vertex.xyz = Vertex.xyz;
				o.pos = UnityObjectToClipPos (Vertex);
					o.lmap.zw = 0;
				#ifndef LIGHTMAP_OFF
					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#ifdef DIRLIGHTMAP_OFF
						o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
						o.lmapFadePos.w = (-mul(UNITY_MATRIX_MV, v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
					#endif
				#else
					o.lmap.xy = 0;
					#if UNITY_SHOULD_SAMPLE_SH
				 		o.sh = 0;
				 		o.sh = ShadeSHPerVertex (worldNormal, o.sh);
					#endif
				#endif
				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
				return o;
			}



//Include a bunch of PBS Code from files UnityPBSLighting.cginc and UnityStandardBRDF.cginc for the purpose of custom lighting effects.
half4 BRDF1_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)
{
	half roughness = 1-oneMinusRoughness;
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	#if UNITY_BRDF_GGX 
		// NdotV should not be negative for visible pixels, but it can happen due to perspective projection and normal mapping
		// In this case we will modify the normal so it become valid and not cause weird artifact (other game try to clamp or abs the NdotV to prevent this trouble).
		// The amount we shift the normal toward the view vector is define by the dot product.
		// This correction is only apply with smithJoint visibility function because artifact are more visible in this case due to highlight edge of rough surface
		half shiftAmount = dot(d.Normal, d.worldViewDir);
		d.Normal = shiftAmount < 0.0f ? d.Normal + d.worldViewDir * (-shiftAmount + 1e-5f) : d.Normal;
		// A re-normalization should be apply here but as the shift is small we don't do it to save ALU.
		//normal = normalize(normal);

		// As we have modify the normal we need to recalculate the dot product nl. 
		// Note that  light.ndotl is a clamped cosine and only the ForwardSimple mode use a specific ndotL with BRDF3
		half nl = DotClamped(d.Normal, gi.light.dir);
	#else
		half nl = gi.light.ndotl;
	#endif
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped(d.Normal, d.worldViewDir);

	half lv = DotClamped (gi.light.dir, d.worldViewDir);
	half lh = DotClamped (gi.light.dir, halfDir);

	#if UNITY_BRDF_GGX
		half V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
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
	half specularTerm = (V * D) * (UNITY_PI/4); // Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)

	if (IsGammaSpace())
		specularTerm = sqrt(max(1e-4h, specularTerm));
	specularTerm = max(0, specularTerm * nl);

	half diffuseTerm = disneyDiffuse * nl;

	// surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(realRoughness^2+1)
	half realRoughness = roughness*roughness;		// need to square perceptual roughness
	half surfaceReduction;
	if (IsGammaSpace()) surfaceReduction = 1.0 - 0.28*realRoughness*roughness;		// 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
	else surfaceReduction = 1.0 / (realRoughness*realRoughness + 1.0);			// fade \in [0.5;1]

	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
    half3 cDiff = (gi.light.color * diffuseTerm);
	half3 cSpec = specularTerm * gi.light.color * FresnelTerm (d.Specular, lh) + surfaceReduction * gi.indirect.specular * FresnelLerp (d.Specular, grazingTerm, nv);

	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113*pow(d.Atten,SSTEMPSV115))) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * disneyDiffuse* lerp(fLT,nl,SSTEMPSV111);
		


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
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

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
	
	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113)) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * lerp(fLT,nl,SSTEMPSV111);
		


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
	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp

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
	float3 vLTLight = gi.light.dir + d.Normal * SSTEMPSV117;//distortion;
	float fLTDot = pow(saturate(dot(d.worldViewDir,-vLTLight)),SSTEMPSV121) * SSTEMPSV119;
	float3 fLT = (fLTDot + (SSTEMPSV113)) * d.SubsurfaceColor;
	
    cDiff = gi.light.color * lerp(fLT,nl,SSTEMPSV111);
		


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
float4 CalculateLighting(UsefulData d, half3 viewDir, UnityGI gi, out half4 outDiffuseOcclusion, out half4 outSpecSmoothness, out half4 outNormal){
				float4 c = float4(d.Albedo,d.Alpha);
				float3 cTemp = float3(0,0,0);
				float3 cDiff = float3(1,1,1);
				float3 cAmb = float3(0,0,0);
				float3 cSpec = float3(0,0,0);
				// energy conservation
				half oneMinusReflectivity;
half3 specColor;
				d.Albedo = DiffuseAndSpecularFromMetallic (d.Albedo, d.Metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);
d.Specular = specColor;
				
				// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
				// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha
				half outputAlpha = d.Alpha;
				//For some reason #if defined() never works!!! So have to preprocess this when generating the shader...
				//d.Albedo = PreMultiplyAlpha (d.Albedo, d.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);
				
				c = UNITY_BRDF_PBSSS (d, gi, oneMinusReflectivity, d.Smoothness);
				c.rgb += UNITY_BRDF_GI (d.Albedo, d.Specular, oneMinusReflectivity, d.Smoothness, d.Normal, d.worldViewDir, d.Occlusion, gi);
				c.a = outputAlpha;
				outDiffuseOcclusion = half4(d.Albedo, d.Occlusion);
				outSpecSmoothness = half4(d.Specular, d.Smoothness);
				outNormal = half4(d.Normal * 0.5 + 0.5, 1);
				half4 emission = half4(d.Emission.rgb+c.rgb, 1);
				return emission;
			};

			void CalculateGI (UsefulData d,UnityGIInput data,inout UnityGI gi){
				#if UNITY_VERSION >= 520
					UNITY_GI(gi, d, data);
				#else
					gi = UnityGlobalIllumination (data, 1.0, d.Smoothness, d.Normal);
				#endif
			}

			void FragmentShader (v2f_surf IN,
				out half4 outDiffuse : SV_Target0,
				out half4 outSpecSmoothness : SV_Target1,
				out half4 outNormal : SV_Target2,
				out half4 outEmission : SV_Target3) {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Metallic = 0.3;
				d.Normal = IN.worldNormal;
				d.Occlusion = 1;
				d.SubsurfaceColor = float3(1,0,0);
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				d.LightSmoothness = 0;
				d.Alpha = 1;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.color = IN.color;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
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
				d.Atten = atten;
				
				// Setup lighting environment
				gi.indirect.diffuse = 0;
				gi.indirect.specular = 0;
				#if !defined(LIGHTMAP_ON)
					gi.light.color = 0;
					gi.light.dir = half3(0,1,0);
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
				d.Smoothness = SSTEMPSV131;
				d.LightSmoothness = SSTEMPSV133;
	//Generate layers for the Albedo channel.
		//Generate Layer: Albedo
			//Sample parts of the layer:
				half4 AlbedoAlbedo_Sample1 = GammaToLinear(SSTEMPSV22);

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,AlbedoAlbedo_Sample1.rgb,SSTEMPSV8);

	//Generate layers for the Metallic channel.
		//Generate Layer: Metallic
			//Sample parts of the layer:
				half4 MetallicMetallic_Sample1 = GammaToLinear(SSTEMPSV70);

			//Blend the layer into the channel using the Mix blend mode
				d.Metallic = lerp(d.Metallic,MetallicMetallic_Sample1.r,SSTEMPSV56);

				fixed3 worldN;
				worldN = d.worldNormal;
				d.Normal = normalize(worldN);
				
				#if !defined(LIGHTMAP_ON)
					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);
				#endif

				CalculateGI(d, giInput, gi);
				//For some reason gamma correcting the indirect diffuse causes random black patches...don't ask.
				//gi.indirect.diffuse = LinearToGamma(gi.indirect.diffuse);
				gi.indirect.specular = LinearToGamma(gi.indirect.specular);
				d.Smoothness = min(d.Smoothness,d.LightSmoothness);
				d.Thickness = d.color.a;				outEmission = CalculateLighting (d, d.worldViewDir, gi, outDiffuse, outSpecSmoothness, outNormal);
				#ifndef UNITY_HDR_ON
					outEmission.rgb = exp2(-outEmission.rgb);
				#endif
			}

		ENDCG
	}
AlphaToMask Off
	Pass {
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }
	ZTest LEqual
	ZWrite On
	Cull Back//Culling specifies which sides of the models faces to hide.

		
		CGPROGRAM
			// compile directives
				#pragma vertex VertShader
				#pragma fragment FragmentShader
				#pragma target 3.0
				#pragma multi_compile_fog
				#pragma multi_compile __ UNITY_COLORSPACE_GAMMA
				#pragma multi_compile_shadowcaster
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#define SHADERSANDWICH_SHADOWCASTER
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define INTERNAL_DATA
				#define WorldReflectionVector(data,normal) data.worldRefl
				#define WorldNormalVector(data,normal) normal
				
				#ifndef LIGHTMAP_OFF
					#define LIGHTMAP_OFF
				#endif

			//Make our inputs accessible by declaring them here.

			//Inputs for temporary quicker editing.
				float4 SSTEMPSV0;//Main Color
				float4 SSTEMPSV2;//Second Color
				float SSTEMPSV4;//Noise A
				float SSTEMPSV6;//Noise B
				float SSTEMPSV8;//Mix Amount
				float SSTEMPSV10;//Fadeout Limit Min
				float SSTEMPSV12;//Fadeout Limit Max
				float SSTEMPSV14;//Fadeout Start
				float SSTEMPSV16;//Fadeout End
				float SSTEMPSV18;//Vertex Mask
				float SSTEMPSV20;//Vertex Space
				float4 SSTEMPSV22;//Color
				float4 SSTEMPSV24;//Main Color
				float4 SSTEMPSV26;//Second Color
				float SSTEMPSV28;//Noise A
				float SSTEMPSV30;//Noise B
				float SSTEMPSV32;//Mix Amount
				float SSTEMPSV34;//Fadeout Limit Min
				float SSTEMPSV36;//Fadeout Limit Max
				float SSTEMPSV38;//Fadeout Start
				float SSTEMPSV40;//Fadeout End
				float SSTEMPSV42;//Vertex Mask
				float SSTEMPSV44;//Vertex Space
				float4 SSTEMPSV46;//Color
				float4 SSTEMPSV48;//Main Color
				float4 SSTEMPSV50;//Second Color
				float SSTEMPSV52;//Noise A
				float SSTEMPSV54;//Noise B
				float SSTEMPSV56;//Mix Amount
				float SSTEMPSV58;//Fadeout Limit Min
				float SSTEMPSV60;//Fadeout Limit Max
				float SSTEMPSV62;//Fadeout Start
				float SSTEMPSV64;//Fadeout End
				float SSTEMPSV66;//Vertex Mask
				float SSTEMPSV68;//Vertex Space
				float4 SSTEMPSV70;//Color
				float SSTEMPSV73;//Tech Shader Target
				float SSTEMPSV75;//Setting1
				float4 SSTEMPSV77;//Wrap Color
				float SSTEMPSV79;//Use Normals
				float SSTEMPSV81;//Spec Hardness
				float SSTEMPSV83;//Spec Offset
				float SSTEMPSV85;//Transparency
				float SSTEMPSV87;//Shell Count
				float SSTEMPSV89;//Shells Distance
				float SSTEMPSV91;//Shell Ease
				float SSTEMPSV93;//Shells Transparency
				float SSTEMPSV95;//Parallax Height
				float SSTEMPSV97;//Parallax Quality
				float SSTEMPSV99;//Tessellation Quality
				float SSTEMPSV101;//Tessellation Falloff
				float SSTEMPSV103;//Tessellation Smoothing Amount
				float SSTEMPSV107;//Indirect Ambient Occlusion Strength
				float SSTEMPSV109;//Indirect Ambient Occlusion Pushback
				float SSTEMPSV111;//SSS Mix
				float SSTEMPSV113;//SSS Constant Scatter
				float SSTEMPSV115;//SSS Density
				float SSTEMPSV117;//SSS Fresnel Distortion
				float SSTEMPSV119;//SSS Fresnel Brightness
				float SSTEMPSV121;//SSS Fresnel Thinness
				float4 SSTEMPSV123;//SSS Color
				float SSTEMPSV125;//Setting1
				float4 SSTEMPSV127;//Wrap Color
				float SSTEMPSV129;//Disable Normals
				float SSTEMPSV131;//Spec Hardness
				float SSTEMPSV133;//Max Light Spec Hardness
				float SSTEMPSV135;//Spec Offset
				float SSTEMPSV137;//Transparency
				float SSTEMPSV139;//CutoffZWriteTransparency
				float SSTEMPSV142;//Shells Distance
				float SSTEMPSV144;//Shell Ease
				float SSTEMPSV146;//Parallax Height
				float SSTEMPSV149;//Parallax Shadow Strength
				float SSTEMPSV151;//Parallax Shadow Size
				float SSTEMPSV153;//Tessellation Quality
				float SSTEMPSV155;//Tessellation Falloff
				float SSTEMPSV157;//Tessellation Smoothing Amount
				float SSTEMPSV160;//Poke Float3 Count
				float SSTEMPSV162;//Poke Float Count
			//Setup some time stuff for the Shader Sandwich preview.
				float4 _SSTime;
				float4 _SSSinTime;
				float4 _SSCosTime;

			struct UsefulData{
				float3 Albedo;
				float Metallic;
				float3 Specular;
				float3 Normal;
				float Alpha;
				float Occlusion;
				float Height;
				float4 Emission;
				float Smoothness;
				float LightSmoothness;
				float Atten;
				float Thickness;
				float3 SubsurfaceColor;
				float3 worldPos;
				float3 worldNormal;
				float3 viewDir;
				float3 worldViewDir;
				fixed4 color;
				float ShellDepth;
			};
				struct v2f_surf {
					V2F_SHADOW_CASTER;
					float3 worldPos: TEXCOORD1;
					float3 worldNormal: TEXCOORD2;
					fixed4 color : COLOR0;
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

	float4 GammaToLinear(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 GammaToLinearForce(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float4 LinearToGamma(float4 col){
		return col;
	}

	float4 LinearToGammaForWeirdSituations(float4 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinear(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 GammaToLinearForce(float3 col){
		#if defined(UNITY_COLORSPACE_GAMMA)
			//Best programming evar XD
		#else
			col = pow(col,2.2);
		#endif
		return col;
	}

	float3 LinearToGamma(float3 col){
		return col;
	}





			v2f_surf VertShader (appdata_min v) {
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
				float4 Vertex = v.vertex;
				o.pos = UnityObjectToClipPos (Vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.color = v.color;
				float3 worldPos = mul(unity_ObjectToWorld, Vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldPos = worldPos;
				o.worldNormal = worldNormal;
				float ShellDepth = 0;
				Vertex.w = v.vertex.w;
				v.vertex.xyz = Vertex.xyz;
				o.pos = UnityObjectToClipPos (Vertex);
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o) // pass various bits of shadow information (although mainly just vertex position from what I understand)
				return o;
			}



			fixed4 GetShadowCasterFragment(v2f_surf IN){
				SHADOW_CASTER_FRAGMENT(IN)
			}
			void FragmentShader (v2f_surf IN,
				out fixed4 outputColor : SV_Target) {
				UsefulData d;
				UNITY_INITIALIZE_OUTPUT(UsefulData,d);
				d.Albedo = float3(0.8,0.8,0.8);
				d.Metallic = 0.3;
				d.Normal = IN.worldNormal;
				d.Occlusion = 1;
				d.SubsurfaceColor = float3(1,0,0);
				d.Emission = float4(0,0,0,0);
				d.Smoothness = 0;
				d.LightSmoothness = 0;
				d.Alpha = 1;
				//Unpack all the data
				d.worldPos = IN.worldPos;
				d.worldNormal = normalize(IN.worldNormal);
				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));
				d.worldViewDir = viewDir;
				d.viewDir = viewDir;
				d.color = IN.color;
				d.ShellDepth = 1-0;
				float ShellDepth = d.ShellDepth;
				fixed4 c = 0;
				#ifndef USING_DIRECTIONAL_LIGHT
					d.viewDir = normalize(UnityWorldSpaceLightDir(d.worldPos));
				#else
					d.viewDir = _WorldSpaceLightPos0.xyz;
				#endif
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
				#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldPos));
				#else
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;
				#endif
				d.Smoothness = SSTEMPSV131;
				d.LightSmoothness = SSTEMPSV133;
	//Generate layers for the Albedo channel.
		//Generate Layer: Albedo
			//Sample parts of the layer:
				half4 AlbedoAlbedo_Sample1 = GammaToLinear(SSTEMPSV22);

			//Blend the layer into the channel using the Mix blend mode
				d.Albedo = lerp(d.Albedo,AlbedoAlbedo_Sample1.rgb,SSTEMPSV8);

	//Generate layers for the Metallic channel.
		//Generate Layer: Metallic
			//Sample parts of the layer:
				half4 MetallicMetallic_Sample1 = GammaToLinear(SSTEMPSV70);

			//Blend the layer into the channel using the Mix blend mode
				d.Metallic = lerp(d.Metallic,MetallicMetallic_Sample1.r,SSTEMPSV56);

				c = float4(d.Albedo+d.Emission.rgb,d.Alpha+d.Emission.a);
				c.a-=SSTEMPSV139;
				clip(c.a);
				outputColor = GetShadowCasterFragment(IN);
			}

		ENDCG
	}
}

Fallback "Legacy Shaders/Diffuse"
}


/*
BeginShaderParse
2.3
BeginShaderBase
ShaderName#!S2#^Text#^jifjpioir#^CC0#?ShaderName
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Fallback#!S2#^Type#^0#^CC0#?Fallback
CustomFallback#!S2#^Text#^Legacy Shaders/VertexLit#^CC0#?CustomFallback
Queue#!S2#^Type#^1#^CC0#?Queue
QueueAuto#!S2#^Toggle#^True#^CC0#?QueueAuto
Replacement#!S2#^Type#^1#^CC0#?Replacement
ReplacementAuto#!S2#^Toggle#^True#^CC0#?ReplacementAuto
Tech Shader Target#!S2#^Float#^3#^CC0#?Tech Shader Target
Exclude DX9#!S2#^Toggle#^False#^CC0#?Exclude DX9
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
Color Space#!S2#^Type#^1#^CC0#?Color Space
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^0#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
Use Normals#!S2#^Float#^0#^CC0#?Use Normals
Specular On#!S2#^Toggle#^False#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.5#^CC0#?Spec Hardness
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
EndShaderLayerList
EndMasks
BeginShaderPass
Name#!S2#^Text#^Pass 1#^CC0#?Name
Visible#!S2#^Toggle#^True#^CC0#?Visible
Tech Lod#!S2#^Float#^200#^CC0#?Tech Lod
Cull#!S2#^Type#^1#^CC0#?Cull
Ztest#!S2#^Type#^2#^CC0#?Ztest
BaseZWrite#!S2#^Type#^0#^CC0#?BaseZWrite
Tech Shader Target#!S2#^Float#^3#^CC0#?Tech Shader Target
Vertex Recalculation#!S2#^Toggle#^False#^CC0#?Vertex Recalculation
Use Fog#!S2#^Toggle#^True#^CC0#?Use Fog
Use Ambient#!S2#^Toggle#^True#^CC0#?Use Ambient
Use Vertex Lights#!S2#^Toggle#^True#^CC0#?Use Vertex Lights
Use Lightmaps#!S2#^Toggle#^True#^CC0#?Use Lightmaps
Use All Shadows#!S2#^Toggle#^True#^CC0#?Use All Shadows
Forward Add#!S2#^Toggle#^True#^CC0#?Forward Add
Shadow Caster#!S2#^Toggle#^True#^CC0#?Shadow Caster
Forward#!S2#^Toggle#^True#^CC0#?Forward
Deferred#!S2#^Toggle#^True#^CC0#?Deferred
Shadows#!S2#^Toggle#^True#^CC0#?Shadows
Interpolate View#!S2#^Toggle#^False#^CC0#?Interpolate View
Recalculate After Vertex#!S2#^Toggle#^True#^CC0#?Recalculate After Vertex
Vertex Toastie Support Type#!S2#^Toggle#^True#^CC0#?Vertex Toastie Support Type
Vertex Toastie Optimized#!S2#^Toggle#^False#^CC0#?Vertex Toastie Optimized
Indirect Control#!S2#^Type#^0#^CC0#?Indirect Control
Indirect Ambient Occlusion On#!S2#^Toggle#^False#^CC0#?Indirect Ambient Occlusion On
Indirect Ambient Occlusion Control#!S2#^Type#^0#^CC0#?Indirect Ambient Occlusion Control
Indirect Ambient Occlusion Realtime#!S2#^Type#^0#^CC0#?Indirect Ambient Occlusion Realtime
Indirect Ambient Occlusion Optimized#!S2#^Toggle#^False#^CC0#?Indirect Ambient Occlusion Optimized
Indirect Ambient Occlusion Optimized Type#!S2#^Type#^0#^CC0#?Indirect Ambient Occlusion Optimized Type
Indirect Ambient Occlusion Strength#!S2#^Float#^1#^CC0#?Indirect Ambient Occlusion Strength
Indirect Ambient Occlusion Pushback#!S2#^Float#^1#^CC0#?Indirect Ambient Occlusion Pushback
Indirect Ambient Occlusion Display Type#!S2#^Type#^0#^CC0#?Indirect Ambient Occlusion Display Type
Indirect Subsurface Scattering On#!S2#^Toggle#^True#^CC0#?Indirect Subsurface Scattering On
Indirect Subsurface Scattering Enabled#!S2#^Type#^0#^CC0#?Indirect Subsurface Scattering Enabled
SSS Mix#!S2#^Float#^0.5280665#^CC0#?SSS Mix
SSS Use Thickness#!S2#^Toggle#^False#^CC0#?SSS Use Thickness
SSS Constant Scatter#!S2#^Float#^0.02910603#^CC0#?SSS Constant Scatter
SSS Density#!S2#^Float#^100#^CC0#?SSS Density
SSS Fresnel Distortion#!S2#^Float#^0.3764706#^CC0#?SSS Fresnel Distortion
SSS Fresnel Brightness#!S2#^Float#^1#^CC0#?SSS Fresnel Brightness
SSS Fresnel Thinness#!S2#^Float#^5.253638#^CC0#?SSS Fresnel Thinness
SSS Color#!S2#^Vec#^1,1,1,1#^CC0#?SSS Color
Diffuse On#!S2#^Toggle#^True#^CC0#?Diffuse On
Lighting Type#!S2#^Type#^0#^CC0#?Lighting Type
Setting1#!S2#^Float#^0#^CC0#?Setting1
Wrap Color#!S2#^Vec#^0.4,0.2,0.2,1#^CC0#?Wrap Color
PBR Quality#!S2#^Type#^0#^CC0#?PBR Quality
PBR Model#!S2#^Type#^1#^CC0#?PBR Model
PBR Specular Type#!S2#^Type#^0#^CC0#?PBR Specular Type
Disable Normals#!S2#^Float#^0#^CC0#?Disable Normals
Specular On#!S2#^Toggle#^True#^CC0#?Specular On
Specular Type#!S2#^Type#^0#^CC0#?Specular Type
Spec Hardness#!S2#^Float#^0.0001#^CC0#?Spec Hardness
Max Light Spec Hardness#!S2#^Float#^1#^CC0#?Max Light Spec Hardness
Spec Energy Conserve#!S2#^Toggle#^True#^CC0#?Spec Energy Conserve
Spec Offset#!S2#^Float#^0#^CC0#?Spec Offset
Emission On#!S2#^Toggle#^False#^CC0#?Emission On
Emission Type#!S2#^Type#^0#^CC0#?Emission Type
Transparency On#!S2#^Toggle#^False#^CC0#?Transparency On
Transparency Type#!S2#^Type#^0#^CC0#?Transparency Type
ZWrite#!S2#^Toggle#^False#^CC0#?ZWrite
Correct Shadows#!S2#^Toggle#^True#^CC0#?Correct Shadows
Use PBR#!S2#^Toggle#^False#^CC0#?Use PBR
Alpha To Coverage#!S2#^Toggle#^False#^CC0#?Alpha To Coverage
Transparency#!S2#^Float#^0#^CC0#?Transparency
CutoffZWriteTransparency#!S2#^Float#^0#^CC0#?CutoffZWriteTransparency
Receive Shadows#!S2#^Toggle#^False#^CC0#?Receive Shadows
ZWrite Type#!S2#^Type#^0#^CC0#?ZWrite Type
Blend Mode#!S2#^Type#^0#^CC0#?Blend Mode
Pre-Multiply#!S2#^Toggle#^False#^CC0#?Pre-Multiply
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
Parallax Depth Correction#!S2#^Toggle#^False#^CC0#?Parallax Depth Correction
Parallax Shadows#!S2#^Toggle#^False#^CC0#?Parallax Shadows
Parallax Shadow Strength#!S2#^Float#^1#^CC0#?Parallax Shadow Strength
Parallax Shadow Size#!S2#^Float#^1#^CC0#?Parallax Shadow Size
Tessellation On#!S2#^Toggle#^False#^CC0#?Tessellation On
Tessellation Type#!S2#^Type#^2#^CC0#?Tessellation Type
Tessellation Quality#!S2#^Float#^10#^CC0#?Tessellation Quality
Tessellation Falloff#!S2#^Float#^1#^CC0#?Tessellation Falloff
Tessellation Smoothing Amount#!S2#^Float#^0#^CC0#?Tessellation Smoothing Amount
Tessellation Toplogy#!S2#^Type#^0#^CC0#?Tessellation Toplogy
Poke On#!S2#^Toggle#^False#^CC0#?Poke On
Poke Count#!S2#^Float#^4#^CC0#?Poke Count
Poke Line#!S2#^Toggle#^True#^CC0#?Poke Line
Poke Interaction#!S2#^Type#^1#^CC0#?Poke Interaction
Poke Float Count#!S2#^Float#^0#^CC0#?Poke Float Count
Poke Float3 Count#!S2#^Float#^0#^CC0#?Poke Float3 Count
Poke Custom#!S2#^Toggle#^False#^CC0#?Poke Custom
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Albedo#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Albedo#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Albedo#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.8,0.8,0.8,1#^CC0#?Main Color
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
Vertex Space#!S2#^Float#^0#^CC0#?Vertex Space
Color#!S2#^Vec#^1,1,1,1#^CC0#?Color
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
Main Color#!S2#^Vec#^0.3,0.3,0.3,1#^CC0#?Main Color
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
Vertex Space#!S2#^Float#^0#^CC0#?Vertex Space
Color#!S2#^Vec#^0.745,0.745,0.745,1#^CC0#?Color
EndShaderLayer
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^Metallic#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Metallic#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^r#^CC0#?EndTag
BeginShaderLayer
Layer Name#!S2#^Text#^Metallic#^CC0#?Layer Name
Real Layer Type#!S2#^Text#^SLTColor#^CC0#?Real Layer Type
Layer Type#!S2#^Type#^0#^CC0#?Layer Type
Main Color#!S2#^Vec#^0.3,0.3,0.3,1#^CC0#?Main Color
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
Vertex Space#!S2#^Float#^0#^CC0#?Vertex Space
Color#!S2#^Vec#^0,0,0,1#^CC0#?Color
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
LayerListUniqueName#!S2#^Text#^SubsurfaceScatteringColor#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^SSS Color#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgb#^CC0#?EndTag
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
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^FragmentPoke#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Poke Channel 1#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
EndShaderLayerList
BeginShaderLayerList
LayerListUniqueName#!S2#^Text#^VertexPoke#^CC0#?LayerListUniqueName
LayerListName#!S2#^Text#^Poke Channel 1#^CC0#?LayerListName
Is Mask#!S2#^Toggle#^False#^CC0#?Is Mask
Is Lighting#!S2#^Toggle#^False#^CC0#?Is Lighting
EndTag#!S2#^Text#^rgba#^CC0#?EndTag
EndShaderLayerList
EndShaderPass
EndShaderBase
EndShaderParse
*/
