#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7
#define PRE_UNITY_5
#else
#define UNITY_5
#endif
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Runtime.Serialization;
using System.Xml;
using System.Xml.Serialization;
using UEObject = UnityEngine.Object;

[System.Serializable]
public class ShaderPass : ScriptableObject{
//Pass Settings
	public ShaderVar Name = new ShaderVar("Name","");
	public ShaderVar Visible = new ShaderVar("Visible",true);
//Settings
	public ShaderVar TechLOD = new ShaderVar("Tech Lod",200);
	public ShaderVar TechCull = new ShaderVar("Cull",new string[]{"All","Front","Back"},new string[]{"","",""},new string[]{"Off","Back","Front"}); 
	public ShaderVar TechZTest = new ShaderVar("Ztest",new string[]{"Off","Less","Greater","LEqual","GEqual","Equal","NotEqual","Always"},new string[]{"","","","","","","",""},new string[]{"Off","Less","Greater","LEqual","GEqual","Equal","NotEqual","Always"}); 

	public ShaderVar TechShaderTarget = new ShaderVar("Tech Shader Target",3f);

	//Misc
	public ShaderVar MiscVertexRecalculation = new ShaderVar("Vertex Recalculation",false);
	public ShaderVar MiscFog = new ShaderVar("Use Fog",true);
	public ShaderVar MiscAmbient = new ShaderVar("Use Ambient",true);
	public ShaderVar MiscVertexLights = new ShaderVar("Use Vertex Lights",true);
	public ShaderVar MiscLightmap = new ShaderVar("Use Lightmaps",true);
	public ShaderVar MiscForwardAdd = new ShaderVar("Forward Add",true);
	public ShaderVar MiscShadows = new ShaderVar("Shadows",true);
	public ShaderVar MiscFullShadows = new ShaderVar("Use All Shadows",true);
	public ShaderVar MiscInterpolateView = new ShaderVar("Interpolate View",false);
	public ShaderVar MiscRecalculateAfterVertex = new ShaderVar("Recalculate After Vertex",true);

	//DIFFUSE
	public ShaderVar DiffuseOn = new ShaderVar("Diffuse On",true);

	public ShaderVar DiffuseLightingType = new ShaderVar("Lighting Type",new string[] {"PBR Standard","Standard", "Microfaceted", "Translucent","Custom"},new string[]{"ImagePreviews/DiffusePBRStandard.png","ImagePreviews/DiffuseStandard.png","ImagePreviews/DiffuseRough.png","ImagePreviews/DiffuseTranslucent.png",""},"",new string[] {"PBR Standard - A physically based version of the Standard option.","Smooth/Lambert - A good approximation of hard, but smooth surfaced objects.\n(Wood,Plastic)", "Rough/Oren-Nayar - Useful for rough surfaces, or surfaces with billions of tiny indents.\n(Carpet,Skin)", "Translucent/Wrap - Good for simulating sub-surface scattering, or translucent objects.\n(Skin,Plants)","Custom - Create your own lighting calculations in the lighting tab."});//);

	public ShaderVar DiffuseSetting1 = new ShaderVar("Setting1",0f);
	public ShaderVar DiffuseSetting2 = new ShaderVar("Wrap Color",new Vector4(0.4f,0.2f,0.2f,1f));
	public ShaderVar PBRQuality = new ShaderVar("PBR Quality",new string[] {"Auto", "High", "Medium", "Low"},new string[] {"","","",""},new string[] {"UNITY_BRDF_PBSSS","BRDF1_Unity_PBSSS", "BRDF2_Unity_PBSSS", "BRDF3_Unity_PBSSS"});
	public ShaderVar DiffuseNormals = new ShaderVar("Disable Normals",0f);
	public bool IsPBR{
		get{
			if (DiffuseLightingType.Type==0&&DiffuseOn.On)
			return true;
			
			return false;
		}
		set{
		}
	}
	//SPECULAR
	public ShaderVar SpecularOn = new ShaderVar("Specular On",true);
	public ShaderVar SpecularLightingType = new ShaderVar("Specular Type",new string[] {"Standard", "Circular","Wave"},new string[]{"ImagePreviews/SpecularNormal.png","ImagePreviews/SpecularCircle.png","ImagePreviews/SpecularWave.png"},"",new string[] {"BlinnPhong - Standard specular highlights.", "Circular - Circular specular highlights(Unrealistic)","Wave - A strange wave like highlight."});	

	public ShaderVar SpecularHardness = new ShaderVar("Spec Hardness",0.3f);
	public ShaderVar SpecularEnergy = new ShaderVar("Spec Energy Conserve",true);
	public ShaderVar SpecularOffset = new ShaderVar("Spec Offset",0f);

	//EMISSION
	public ShaderVar EmissionOn = new ShaderVar("Emission On",false);
	public ShaderVar EmissionColor = new ShaderVar("Emission Color",new Vector4(0f,0f,0f,0f));
	public ShaderVar EmissionType = new ShaderVar(
	"Emission Type",new string[]{"Standard","Multiply","Set"},new string[]{"ImagePreviews/EmissionOn.png","ImagePreviews/EmissionMul.png","ImagePreviews/EmissionSet.png"},"",new string[]{"Standard - Simply add the emission on top of the base color.","Multiply - Add the emission multiplied by the base color. An emission color of white adds the base color to itself.","Set - Mixes the shadeless color on top based on the alpha."}
	); 	

	//Transparency
	public ShaderVar TransparencyOn = new ShaderVar("Transparency On",false);
	public ShaderVar TransparencyType = new ShaderVar(
	"Transparency Type",new string[]{"Cutout","Fade"},new string[]{"ImagePreviews/TransparentCutoff.png","ImagePreviews/TransparentFade.png"},"",new string[]{"Cutout - Only allows alpha to be on or off, fast, but creates sharp edges. This can have aliasing issues and is slower on mobile.","Fade - Can have many levels of transparency, but can have depth sorting issues (Objects can appear in front of each other incorrectly)."}
	); 
	public ShaderVar TransparencyZWrite = new ShaderVar("ZWrite",false); 
	public ShaderVar TransparencyPBR = new ShaderVar("Use PBR",true); 
	public ShaderVar TransparencyReceive = new ShaderVar("Receive Shadows",false);
	public ShaderVar TransparencyZWriteType = new ShaderVar("ZWrite Type",new string[]{"Full","Cutoff"},new string[]{"","",""},new string[]{"Full","Cutoff"});
	public ShaderVar BlendMode = new ShaderVar("Blend Mode",new string[]{"Mix","Add","Mul"},new string[]{"","",""},new string[]{"Mix","Add","Mul"});

	public ShaderVar TransparencyAmount = new ShaderVar("Transparency",0f);
	public ShaderVar TransparencyZWriteAmount = new ShaderVar("CutoffZWriteTransparency",0f);

	//Blend Mode
	public int BlendModeType = 0;


	//Shells
	public ShaderVar ShellsOn = new ShaderVar("Shells On",false);
	public ShaderVar ShellsCount = new ShaderVar("Shell Count",1,0,50);	
	public ShaderVar ShellsDistance = new ShaderVar("Shells Distance",0.1f);
	public ShaderVar ShellsEase = new ShaderVar("Shell Ease",1,0f,3f);
	public ShaderVar ShellsZWrite = new ShaderVar("Shells ZWrite",true);
	public ShaderVar ShellsFront = new ShaderVar("Shell Front",true); 
	public ShaderVar ShellsSkipFirst = new ShaderVar("Shell Skip First",true); 

	//Parallax Occlusion
	public ShaderVar ParallaxOn = new ShaderVar("Parallax On",false);
	public ShaderVar ParallaxHeight = new ShaderVar("Parallax Height",0.1f); 
	public int ParallaxLinearQuality = 5;
	public ShaderVar ParallaxBinaryQuality = new ShaderVar("Parallax Quality",10,0,50);
	public ShaderVar ParallaxSilhouetteClipping = new ShaderVar("Silhouette Clipping",false);
	
	public ShaderVar ParallaxShadows = new ShaderVar("Parallax Shadows",false);
	public ShaderVar ParallaxShadowSize = new ShaderVar("Parallax Shadow Size",1f,1f,10f);
	public ShaderVar ParallaxShadowStrength = new ShaderVar("Parallax Shadow Strength",1f,0f,10f);
	
	
	//Tessellation
	public ShaderVar TessellationOn = new ShaderVar("Tessellation On",false);
	
	public ShaderVar TessellationType = new ShaderVar("Tessellation Type",new string[]{"Equal","Size","Distance"},new string[]{"Tessellate all faces the same amount (Not Recommended!).","Tessellate faces based on their size (larger = more tessellation).","Tessellate faces based on distance and screen area."},new string[]{"Equal","Size","Distance"});
	public ShaderVar TessellationQuality = new ShaderVar("Tessellation Quality",10,1,50);
	public ShaderVar TessellationFalloff = new ShaderVar("Tessellation Falloff",1,1,3);
	public ShaderVar TessellationSmoothingAmount = new ShaderVar("Tessellation Smoothing Amount",0f,-3,3);
	public ShaderVar TessellationTopology = new ShaderVar("Tessellation Toplogy",new string[]{"Triangles","Point"},new string[]{"",""},new string[]{"triangle_cw","point"});

	public bool Initiated = false;

	public string[] TechShaderTargetNames = {"2.0", "3.0", "4.0", "5.0"};
	public string[] DiffuseLightingTypeNames = {"Smooth", "Rough", "Translucent","Unlit"};
	public string[] DiffuseLightingTypeDescriptions = {"Smooth/Lambert - A good approximation of hard, but smooth surfaced objects.(Wood,Plastic)", "Rough/Oren-Nayar - Useful for showing rough surfaces.(Carpet,Skin)", "Translucent/Wrap - Good for simulating sub-surface scattering, or translucent objects.(Skin,Plants)","Unlit/Shadeless - No lighting, full brightness.(Sky,Globe)"};
	public string[] SpecularLightingTypeNames = {"None","Standard", "Circular","Wave"};
	public string[] TransparencyTypeNames = {"None","Cutoff", "Fade"};
	public string[] BlendModeTypeNames = {"Normal","Add"};

	[XmlIgnore,NonSerialized]public List<int> NameInputs;
	[XmlIgnore,NonSerialized]public Dictionary<string, int> NameToInt;

	public ShaderVar OtherTypes = new ShaderVar("Parallax Type",new string[] {"Off", "On","Off","Off","Off","On"},new string[]{"ImagePreviews/ParallaxOff.png","ImagePreviews/ParallaxOn.png","ImagePreviews/TransparentOff.png","ImagePreviews/EmissionOff.png","ImagePreviews/ShellsOff.png","ImagePreviews/ShellsOn.png","ImagePreviews/TessellationOff.png","ImagePreviews/TessellationOn.png"},"",new string[] {"", "","","","",""});	
	
//LayerLists
	public ShaderLayerList	ShaderLayersDiffuse = new ShaderLayerList("Albedo","Albedo","The color of the surface.","Texture","d.Albedo","rgb","",new Color(0.8f,0.8f,0.8f,1f));
	public ShaderLayerList	ShaderLayersAlpha = new ShaderLayerList("Alpha","Alpha","Which parts are see through.","Transparency","d.Alpha","a","",new Color(1f,1f,1f,1f));
	public ShaderLayerList	ShaderLayersSpecular = new ShaderLayerList("Specular","Specular","Where the shine appears.","Gloss","d.Specular","rgb","",new Color(0.3f,0.3f,0.3f,1f));
	public ShaderLayerList	ShaderLayersNormal = new ShaderLayerList("Normals","Normals","Used to add fake bumps.","NormalMap","d.Normal","rgb","",new Color(0f,0f,1f,1f));
	public ShaderLayerList	ShaderLayersEmission = new ShaderLayerList("Emission","Emission","Where and what color the glow is.","Emission","d.Emission","rgba","",new Color(0f,0f,0f,1f));
	public ShaderLayerList	ShaderLayersHeight = new ShaderLayerList("Height","Height","Which parts of the shader are higher than the others.","Height","d.Height","a","",new Color(1f,1f,1f,1));
	public ShaderLayerList	ShaderLayersVertex = new ShaderLayerList("Vertex","Vertex","Used to move the models vertices.","Vertex","rgba","",new Color(1f,1f,1f,1));
	
	public ShaderLayerList	ShaderLayersLightingDiffuse = new ShaderLayerList("LightingDiffuse","Diffuse","Customize the diffuse lighting.","Lighting","cDiff","rgb","",new Color(0.8f,0.8f,0.8f,1f));
	public ShaderLayerList	ShaderLayersLightingSpecular = new ShaderLayerList("LightingSpecular","Specular","Custom speculars highlights and reflections.","Lighting","cSpec","rgb","",new Color(0.8f,0.8f,0.8f,1f));
	public ShaderLayerList	ShaderLayersLightingAmbient = new ShaderLayerList("LightingIndirect","Ambient","Customize the ambient lighting.","Lighting","cAmb","rgb","",new Color(0.8f,0.8f,0.8f,1f));
	public ShaderLayerList	ShaderLayersLightingAll = new ShaderLayerList("LightingDirect","Direct","Custom both direct diffuse and specular lighting.","Lighting","cTemp","rgb","",new Color(0.8f,0.8f,0.8f,1f));
	
	public ShaderPass(){
		ShaderLayersLightingDiffuse.IsLighting.On = true;
		ShaderLayersLightingSpecular.IsLighting.On = true;
		ShaderLayersLightingAmbient.IsLighting.On = true;
		ShaderLayersLightingAll.IsLighting.On = true;
		TechCull.Type = 1;
		TechZTest.Type = 3;
		TessellationType.Type = 2;
	}
	public ShaderPass(string N){
		Name.Text = N;
		ShaderLayersLightingDiffuse.IsLighting.On = true;
		ShaderLayersLightingSpecular.IsLighting.On = true;
		ShaderLayersLightingAmbient.IsLighting.On = true;
		ShaderLayersLightingAll.IsLighting.On = true;
		TechCull.Type = 1;
		TechZTest.Type = 3;
		TessellationType.Type = 2;
	}
	public void GetMyShaderVars(List<ShaderVar> SVs){
		
		SVs.Add(Name);
		SVs.Add(Visible);
		SVs.Add(TechLOD);
		SVs.Add(TechCull);
		SVs.Add(TechShaderTarget);

		SVs.Add(DiffuseOn);
		SVs.Add(DiffuseLightingType);
		SVs.Add(DiffuseSetting1);
		SVs.Add(DiffuseSetting2);
		SVs.Add(PBRQuality);
		SVs.Add(DiffuseNormals);

		SVs.Add(SpecularOn);
		SVs.Add(SpecularLightingType);
		SVs.Add(SpecularHardness);
		SVs.Add(SpecularEnergy);
		SVs.Add(SpecularOffset);

		SVs.Add(EmissionOn);
		SVs.Add(EmissionType);

		SVs.Add(TransparencyOn);
		SVs.Add(TransparencyType);
		SVs.Add(TransparencyZWrite);
		SVs.Add(TransparencyPBR);
		SVs.Add(TransparencyAmount);
		SVs.Add(TransparencyReceive);
		SVs.Add(TransparencyZWriteType);
		SVs.Add(TransparencyZWriteAmount);
		SVs.Add(BlendMode);

		SVs.Add(ShellsOn);
		SVs.Add(ShellsCount);
		SVs.Add(ShellsDistance);
		SVs.Add(ShellsEase);
		SVs.Add(ShellsZWrite);
		
		SVs.Add(ShellsFront);
		SVs.Add(ShellsSkipFirst);

		SVs.Add(ParallaxOn);
		SVs.Add(ParallaxHeight);
		SVs.Add(ParallaxBinaryQuality);
		SVs.Add(ParallaxSilhouetteClipping);
		SVs.Add(ParallaxShadows);
		SVs.Add(ParallaxShadowStrength);
		SVs.Add(ParallaxShadowSize);

		SVs.Add(TessellationOn);
		SVs.Add(TessellationType);
		SVs.Add(TessellationQuality);
		SVs.Add(TessellationFalloff);
		SVs.Add(TessellationSmoothingAmount);
		SVs.Add(TessellationTopology);
	}
	public string GeneratePassGroup(ShaderGenerate SG,float d){
		string ShaderCode = "";
			SG.Dist = d;
			if (TransparencyOn.On&&TransparencyType.Type==1&&TransparencyZWrite.On&&TransparencyZWriteType.Type==0)
				ShaderCode += GenerateForwardMask(SG);
			if (TransparencyOn.On&&TransparencyType.Type==1&&TransparencyZWrite.On&&TransparencyZWriteType.Type==1){
				SG.PassSubset = "Mask";
				int OldTransType = TransparencyType.Type;
				TransparencyType.Type = 0;
				ShaderCode += GenerateForwardBase(SG);
				if (SG.UseLighting&&MiscForwardAdd.On)
					ShaderCode += GenerateForwardAdd(SG);
				TransparencyType.Type = OldTransType;
			}
			SG.PassSubset = "";
			ShaderCode += GenerateForwardBase(SG);
			if (SG.UseLighting&&MiscForwardAdd.On)
				ShaderCode += GenerateForwardAdd(SG);
		return ShaderCode;
	}
	public string GenerateCode(ShaderGenerate SG){
		string ShaderCode = "";
			if (ShellsOn.On&&!ShellsFront.On){
				for (float i = 1f;i<=ShellsCount.Float;i+=1f){
					ShaderCode += GeneratePassGroup(SG,i/ShellsCount.Float);
				}
			}
			if (!ShellsOn.On||!ShellsSkipFirst.On)
				ShaderCode += GeneratePassGroup(SG,0f);
			if (ShellsOn.On&&ShellsFront.On){
				for (float i = 1f;i<=ShellsCount.Float;i+=1f){
					ShaderCode += GeneratePassGroup(SG,i/ShellsCount.Float);
				}
			}
		return ShaderCode;
	}
	public string GeneratePassStart(ShaderGenerate SG,string PassName, string LightMode, string MultiCompile, string Define){
		string ShaderCode = "";
		ShaderCode +=
		"	Pass {\n" + 
		"		Name \"" + PassName+"\"\n" + 
		"		Tags { ";
		if (LightMode!="")
			ShaderCode +="\"LightMode\" = \"" + LightMode+"\" ";
		ShaderCode +=
		"}\n" + 
		GenerateTags(SG)+"\n"+
		"		\n" + 
		"		CGPROGRAM\n" + 
		"			// compile directives\n";
		if (!TessellationOn.On)
		ShaderCode += 
		"				#pragma vertex VertShader\n"+
		"				#pragma fragment FragmentShader\n";
		else
		ShaderCode += 
		"				#pragma vertex tessvert_frag_surf\n"+
		"				#pragma fragment FragmentShader\n"+
		"				#pragma hull hs_frag_surf\n"+
		"				#pragma domain ds_frag_surf\n";
		ShaderCode +=
		"				#pragma target "+((int)TechShaderTarget.Float).ToString()+".0\n";
		if (MiscFog.On&&!SG.U4)
		ShaderCode +=
		"				#pragma multi_compile_fog\n";
		ShaderCode +=
		"				#pragma " + MultiCompile+"\n" + 
		"				#include \"HLSLSupport.cginc\"\n" + 
		"				#include \"UnityShaderVariables.cginc\"\n" + 
		"				#define " + Define+"\n" + 
		"				#include \"UnityCG.cginc\"\n" + 
		"				#include \"Lighting.cginc\"\n";
		if (!SG.U4)
		ShaderCode +=
		"				#include \"UnityPBSLighting.cginc\"\n";
		ShaderCode +=
		"				#include \"AutoLight.cginc\"\n" + 
		"\n" + 
		"				#define INTERNAL_DATA\n" + 
		"				#define WorldReflectionVector(data,normal) data.worldRefl\n" + 
		"				#define WorldNormalVector(data,normal) normal\n";
		ShaderCode +=
		"				(DEFINEGLSLHERE)\n";
		
		if (TransparencyOn.On&&TransparencyType.Type==1&&TransparencyPBR.On&&IsPBR)
		ShaderCode += "				#define _ALPHAPREMULTIPLY_ON 1\n";
		if (!MiscLightmap.On||SG.Pass=="Mask")
		ShaderCode += "				#ifndef LIGHTMAP_OFF\n					#define LIGHTMAP_OFF\n				#endif\n";
		
		if (ParallaxOn.On)
		ShaderCode+=
		"				//Set up some Parallax Occlusion Mapping Settings\n#define LINEAR_SEARCH "+(Math.Round(ParallaxBinaryQuality.Float/2)).ToString()+"\n"+
		"				#define BINARY_SEARCH "+ParallaxBinaryQuality.Get()+"\n";
		if (TessellationOn.On)
		ShaderCode+=
		"				#include \"Tessellation.cginc\" //Include some Unity code for tessellation.\n";
		return ShaderCode;	
	}
	public string GenerateUniforms(ShaderGenerate SG){
		string ShaderCode = "			//Make our inputs accessible by declaring them here.\n";
			#if PRE_UNITY_5
				if (IsPBR){
					ShaderCode+="				samplerCUBE _Cube;\n";
				}
				if (MiscLightmap.On&&SG.Pass!="ForwardAdd"){
					ShaderCode+="				#ifndef LIGHTMAP_OFF\n"+
								"					float4 unity_LightmapST;\n"+
								"				#endif\n"+
								"				#ifndef LIGHTMAP_OFF\n"+
								"					sampler2D unity_Lightmap;\n"+
								"					#ifndef DIRLIGHTMAP_OFF\n"+
								"						sampler2D unity_LightmapInd;\n"+
								"					#endif\n"+
								"				#endif\n";
				}
			#endif
			//ShaderCode+="				float4 specColor;\n";
			foreach(ShaderInput SI in SG.Base.ShaderInputs){
				if (SI.InEditor||SG.Temp){
					ShaderCode += "				";
					if (SI.Type==0){
						ShaderCode += "sampler2D " + SI.Get()+";\n";
						ShaderCode += "float4 " + SI.Get()+"_ST;\n";
					}
					if (SI.Type==1&&(SI.Get()!="_SpecColor"))
						ShaderCode += "float4 " + SI.Get()+";\n";
					if (SI.Type==2)
						ShaderCode += "samplerCUBE " + SI.Get()+";\n";
					if (SI.Type==3 || SI.Type==4)
						ShaderCode += "float " + SI.Get()+";\n";
				}
			}
			if (ShaderSandwich.Instance.ImprovedUpdates&&SG.Temp){
				ShaderCode += "\n			//Inputs for temporary quicker editing.\n";
			
				foreach(ShaderVar SV in ShaderUtil.GetAllShaderVars()){
					if (SV.Input==null){
						if (SV.CType == Types.Vec)
							ShaderCode+="				float4 SSTEMPSV" + SV.GetID().ToString()+";//" + SV.Name+"\n";
						if (SV.CType == Types.Float&&!SV.NoInputs)
							ShaderCode+="				float SSTEMPSV" + SV.GetID().ToString()+";//" + SV.Name+"\n";
					}
				}
			}
			if (SG.Temp){
				ShaderCode+="			//Setup some time stuff for the Shader Sandwich preview.\n" +
							"				float4 _SSTime;\n" +
							"				float4 _SSSinTime;\n" +
							"				float4 _SSCosTime;\n";
			}
		
		return ShaderCode;
	}
	public string GenerateLayers(ShaderGenerate SG, ShaderLayerList SLL,string Function)
	{
		string ShaderCode = "";

		if (SLL.SLs.Count>0){
			ShaderCode += "	//Generate layers for the " + SLL.Name.Text + " channel.\n";
			
			int ShaderNumber = 0;
			foreach (ShaderLayer SL in SLL.SLs)
			{
				ShaderNumber+=1;
				
				SL.LayerEffects.Reverse();
				string Map = SL.GCUVs(SG);
				SL.LayerEffects.Reverse();
				SL.Parent = SLL;
				
				string PixelColor = SL.GCPixel(SG,Map)+"\n";
				PixelColor += SL.GCCalculateMix(SG,SLL.CodeName,SL.GetSampleNameFirst(),Function,ShaderNumber)+"\n\n";
				ShaderCode += PixelColor;
			}
		}

		return ShaderCode;
	}
	public string GenerateVertexStuffThatWillNeedRecalculating(ShaderGenerate SG){
		string ShaderCode = "";
			if (SG.UsedScreenPos)
				ShaderCode +=	 "				float4 screenPos = ComputeScreenPos (o.pos);\n";
			if (SG.UsedWorldPos||SG.UsedViewDir||SG.UsedWorldRefl)
				ShaderCode +=	 "				float3 worldPos = mul(_Object2World, Vertex).xyz;\n";
			if (SG.UsedViewDir||SG.UsedWorldRefl)
				ShaderCode += 	"				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));\n";
			if (SG.UsedWorldRefl)
				ShaderCode += 	"				float3 worldRefl = reflect(-worldViewDir, worldNormal);\n";
			if (SG.UseTangentSpace){
				ShaderCode +=	"				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);\n"+
								"				fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;\n"+
								"				o.TtoWSpaceX = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);\n"+
								"				o.TtoWSpaceY = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);\n"+
								"				o.TtoWSpaceZ = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);\n";
			}
				
			if (!SG.UseTangentSpace){	
				if (SG.UsedWorldPos)
					ShaderCode += "				o.worldPos = worldPos;\n";
				if (SG.UsedWorldNormals)
					ShaderCode += "				o.worldNormal = worldNormal;\n";
			}
			if (SG.UsedScreenPos)
				ShaderCode += "				o.screenPos = screenPos;\n";
			if (SG.UsedWorldRefl)
				ShaderCode += "				o.worldRefl = worldRefl;\n";
			if (SG.UsedViewDir&&MiscInterpolateView.On)
				ShaderCode += "				o.viewDir = worldViewDir;\n";		
		return ShaderCode;
	}
	public string GenerateVertexShader(ShaderGenerate SG){
		SG.InVertex = true;
		string ShaderCode = "";
			ShaderCode += "			v2f_surf VertShader (appdata_min v) {\n";
			ShaderCode += "				v2f_surf o;\n";
			ShaderCode += "				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);\n";
			ShaderCode += "				float4 Vertex = v.vertex;\n";
			ShaderCode += "				o.pos = mul (UNITY_MATRIX_MVP, Vertex);\n";
			
			bool XY = true;
			int i = 0;
			foreach (ShaderInput SI in SG.Base.ShaderInputs){
				if (SI.Type==0){
					if (SI.UsedMapType0==true||SI.UsedMapType1==true){
						if (!SG.Float2sCombined){
							if (SI.UsedMapType0==true)
								ShaderCode += "					o.uv"+SI.Get()+" = TRANSFORM_TEX(v.texcoord, "+SI.Get()+");\n";
							if (SI.UsedMapType1==true)
								ShaderCode += "					o.uv2"+SI.Get()+" = TRANSFORM_TEX(v.texcoord2, "+SI.Get()+");\n";
						}else{
							if (SI.UsedMapType0==true||SI.UsedMapType1==true){
								if (SI.UsedMapType0==true)
									ShaderCode += "					o.dataToPack"+i.ToString()+"."+(XY?"xy":"zw")+" = TRANSFORM_TEX(v.texcoord, "+SI.Get()+");\n";
								if (SI.UsedMapType1==true)
									ShaderCode += "					o.dataToPack"+i.ToString()+"."+(XY?"xy":"zw")+" = TRANSFORM_TEX(v.texcoord2, "+SI.Get()+");\n";
							}
							XY = !XY;
							if (XY)
								i+=2;
						}
					}
				}				
			}
			if (SG.UsedGenericUV){
				if (!SG.Float2sCombined)
					ShaderCode += "					o."+SG.GeneralUV+"."+(XY?"xy":"zw")+" = v.texcoord;\n";
				else
					ShaderCode += "					o.dataToPack"+i.ToString()+"."+(XY?"xy":"zw")+" = v.texcoord;\n";
					XY = !XY;
					if (XY)
						i+=2;
			}
			if (SG.UsedWorldNormals||SG.UsedWorldRefl||MiscVertexLights.On)
				ShaderCode += 	"				float3 worldNormal = UnityObjectToWorldNormal(v.normal);\n";
			if (SG.UsedVertex){
				ShaderCode += "				o.color = v.color;\n";
			}
			ShaderCode += GenerateVertexStuffThatWillNeedRecalculating(SG);
			if (SG.UsedMapGenerate==true)
				ShaderCode += "				half3 blend = pow(abs(worldNormal),5);\n"+
							  "				blend /= blend.x+blend.y+blend.z;\n";
			ShaderCode += "				float ShellDepth = "+SG.Dist.ToString()+";\n";
			
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += SLL.GCVariable();
					ShaderCode += GenerateLayers(SG,SLL,"");
				}
			}
			ShaderCode += GenerateLayers(SG,ShaderLayersVertex,"");
			ShaderCode += "				Vertex.w = v.vertex.w;\n";
		
			if (SG.Dist>0){
				string Disp = "";
				if (ShellsDistance.Get()==ShellsDistance.Float.ToString()){
					if (ShellsEase.Get()!="1"){
						if (ShellsEase.Get()==ShellsEase.Float.ToString())
							Disp=(ShellsDistance.Float*Mathf.Pow(SG.Dist,ShellsEase.Float)).ToString();
						else
							Disp=(ShellsDistance.Float.ToString()+"*pow("+SG.Dist.ToString()+","+ShellsEase.Get()+")");
					}
					else
						Disp = (ShellsDistance.Float*SG.Dist).ToString();
				}
				else{
					if (ShellsEase.Get()=="1")
						Disp=ShellsDistance.Get()+"*"+SG.Dist.ToString();
					else
						Disp=(ShellsDistance.Get()+"*"+"pow("+SG.Dist.ToString().ToString()+","+ShellsEase.Get()+")");
				}
				ShaderCode+="				Vertex.xyz += v.normal*("+Disp+");\n";
			}
			ShaderCode += 	"				o.pos = mul (UNITY_MATRIX_MVP, Vertex);\n";
			
			if (MiscRecalculateAfterVertex.On&&ShaderLayersVertex.SLs.Count>0){
				ShaderCode += GenerateVertexStuffThatWillNeedRecalculating(SG).Replace("float4 ","").Replace("float3 ","").Replace("fixed3 ","");
			}
				
			if (MiscLightmap.On&&SG.Pass=="ForwardBase")
			ShaderCode += 
						"				#ifndef LIGHTMAP_OFF\n"+
						//"					#ifndef DYNAMICLIGHTMAP_OFF\n"+
						//"						o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;\n"+
						//"					#endif\n"+
						//
						"					o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;\n"+
						"				#endif\n"+
						"				\n";
			if ((MiscVertexLights.On||MiscAmbient.On)&&SG.Pass=="ForwardBase")
			ShaderCode +=
						"				// SH/ambient and vertex lights\n"+
						"				#ifdef LIGHTMAP_OFF\n"+
						"					#if UNITY_SHOULD_SAMPLE_SH\n"+
						"						#if UNITY_SAMPLE_FULL_SH_PER_PIXEL\n"+
						"							o.sh = 0;\n"+
						"						#elif (SHADER_TARGET < 30)\n"+
						"							o.sh = ShadeSH9 (float4(worldNormal,1.0));\n"+
						"						#else\n"+
						"							o.sh = ShadeSH3Order (half4(worldNormal, 1.0));\n"+
						"						#endif\n";
			if (MiscVertexLights.On&&SG.Pass=="ForwardBase")
			ShaderCode += 
						"						// Add approximated illumination from non-important point lights\n"+
						"						#ifdef VERTEXLIGHT_ON\n"+
						"							o.sh += Shade4PointLights (\n"+
						"							unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,\n"+
						"							unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,\n"+
						"							unity_4LightAtten0, worldPos, worldNormal);\n"+
						"						#endif\n";
			if ((MiscVertexLights.On||MiscAmbient.On)&&SG.Pass=="ForwardBase")
				ShaderCode +=
						"					#endif\n"+
						"				#endif // LIGHTMAP_OFF\n"+
						"				\n";
			if (SG.Pass!="Mask"&&MiscShadows.On&&(SG.Pass!="ForwardAdd"||MiscFullShadows.On)&&!SG.U4)
				ShaderCode += 
						"				TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader\n";
			if (SG.Pass!="Mask"&&MiscFog.On&&!SG.U4)
				ShaderCode += 
						"				UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader\n";
			if (SG.Pass!="Mask"&&SG.U4)
				ShaderCode += 
						"				TRANSFER_VERTEX_TO_FRAGMENT(o); // pass lighting information to pixel shader\n";
			ShaderCode += "				return o;\n";
			
			ShaderCode += "			}\n";
		SG.InVertex = false;
		return ShaderCode;
	}
	public string GenerateFragmentShader(ShaderGenerate SG){
		string ShaderCode = "";
			ShaderCode += "			fixed4 FragmentShader (v2f_surf IN) : SV_Target {\n";
			ShaderCode += "				UsefulData d;\n";
			ShaderCode += "				UNITY_INITIALIZE_OUTPUT(UsefulData,d);\n";
			ShaderCode += "				d.Albedo = float3(0.8,0.8,0.8);\n";
			ShaderCode += "				d.Specular = float3(0.3,0.3,0.3);\n";
			
			if (SG.UseTangentSpace)
			ShaderCode += "				d.Normal = float3(0,0,1);\n";
			else
			if (SG.UsedWorldNormals)
			ShaderCode += "				d.Normal = IN.worldNormal;\n";
			
			ShaderCode += "				d.Alpha = 1;\n";
			ShaderCode += "				d.Occlusion = 1;\n";
			ShaderCode += "				d.Emission = float4(0,0,0,0);\n";
			
			if (IsPBR){
				if (SpecularOn.On)
					ShaderCode+="				d.Smoothness = "+SpecularHardness.Get()+";\n";
				else
					ShaderCode+="				d.Smoothness = 0;\n";
			}
			else{
				if (SpecularOn.On)
					ShaderCode+="				d.Smoothness = "+SpecularHardness.Get()+"*2;\n";
				else
					ShaderCode+="				d.Smoothness = 0;\n";
			}
			
			ShaderCode += "				//Unpack all the data\n";
			if (SG.UsedWorldPos){
				if (SG.UseTangentSpace)
					ShaderCode += "				d.worldPos = float3(IN.TtoWSpaceX.w,IN.TtoWSpaceY.w,IN.TtoWSpaceZ.w);\n";
				else
					ShaderCode += "				d.worldPos = IN.worldPos;\n";
			}
			if (SG.UsedScreenPos)
				ShaderCode += "				d.screenPos = IN.screenPos;\n"+
							  "				d.screenPos.xy /= d.screenPos.w;\n";
			if (SG.UsedWorldNormals){
				if (SG.UseTangentSpace)
					ShaderCode += "				d.worldNormal = normalize(float3(IN.TtoWSpaceX.z,IN.TtoWSpaceY.z,IN.TtoWSpaceZ.z));\n";
				else
					ShaderCode += "				d.worldNormal = normalize(IN.worldNormal);\n";
			}
			if (SG.UsedWorldRefl)
				ShaderCode += "				d.worldRefl = IN.worldRefl;\n";
			if (SG.UsedViewDir){
				if (MiscInterpolateView.On)
					ShaderCode += "				float3 viewDir = (IN.viewDir);\n";
				else
					ShaderCode += "				float3 viewDir = normalize(UnityWorldSpaceViewDir(d.worldPos));\n";
				ShaderCode += "				d.worldViewDir = viewDir;\n";
				if (SG.UseTangentSpace)
					ShaderCode += "				d.viewDir = IN.TtoWSpaceX.xyz * viewDir.x + IN.TtoWSpaceY.xyz * viewDir.y  + IN.TtoWSpaceZ.xyz * viewDir.z;;\n";
				else
					ShaderCode += "				d.viewDir = viewDir;\n";
				
			}
			if (SG.UseTangentSpace){
				ShaderCode += "				d.TtoWSpaceX = IN.TtoWSpaceX;\n";
				ShaderCode += "				d.TtoWSpaceY = IN.TtoWSpaceY;\n";
				ShaderCode += "				d.TtoWSpaceZ = IN.TtoWSpaceZ;\n";
			}
			if (SG.UsedVertex){
				ShaderCode += "				d.color = IN.color;\n";
			}
				
			if (SG.UsedMapGenerate==true)
				ShaderCode += 
								"				half3 blend = pow(abs(d.worldNormal),5);\n"+
								"				blend /= blend.x+blend.y+blend.z;\n";
			
			ShaderCode += 		"				d.ShellDepth = 1-"+SG.Dist.ToString()+";\n";
			ShaderCode += 		"				float ShellDepth = d.ShellDepth;\n";
			
			bool XY = true;
			int i = 0;
			foreach (ShaderInput SI in SG.Base.ShaderInputs){
				if (SI.Type==0){
					if (SI.UsedMapType0==true||SI.UsedMapType1==true){
						if (!SG.Float2sCombined){
							if (SI.UsedMapType0==true)
								ShaderCode += "					d.uv"+SI.Get()+" = IN.uv"+SI.Get()+";\n";
							if (SI.UsedMapType1==true)
								ShaderCode += "					d.uv2"+SI.Get()+" = IN.uv"+SI.Get()+";\n";
						}else{
							if (SI.UsedMapType0==true||SI.UsedMapType1==true){
								if (SI.UsedMapType0==true)
									ShaderCode += "					d.uv"+SI.Get()+" = IN.dataToPack"+i.ToString()+"."+(XY?"xy":"zw")+";\n";
								if (SI.UsedMapType1==true)
									ShaderCode += "					d.uv2"+SI.Get()+" = IN.dataToPack"+i.ToString()+"."+(XY?"xy":"zw")+";\n";
							}
							XY = !XY;
							if (XY)
								i+=2;
						}
					}
				}				
			}
			if (SG.UsedGenericUV){
				if (!SG.Float2sCombined)
					ShaderCode += "				d."+SG.GeneralUV+" = IN."+SG.GeneralUV+";\n";
				else
					ShaderCode += "				d."+SG.GeneralUV+" = IN.dataToPack"+i.ToString()+"."+(XY?"xy":"zw")+";\n";
					XY = !XY;
					if (XY)
						i+=2;
			}
			ShaderCode += 	"				fixed4 c = 0;\n"+
							"				UnityGI gi;\n"+
							"				UNITY_INITIALIZE_OUTPUT(UnityGI, gi);\n"+
							"				#ifndef USING_DIRECTIONAL_LIGHT\n"+
							"					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(d.worldPos));\n"+
							"				#else\n"+
							"					fixed3 lightDir = _WorldSpaceLightPos0.xyz;\n"+
							"				#endif\n";
			if (SG.UseLighting){
			ShaderCode +=	
							
							"				// compute lighting & shadowing factor\n";
							if (!SG.U4)
			ShaderCode +=	"				UNITY_LIGHT_ATTENUATION(atten, IN, d.worldPos)\n";
							else
			ShaderCode +=	"				fixed atten = LIGHT_ATTENUATION(IN);\n";
			ShaderCode +=
							"				\n"+
							"				// Setup lighting environment\n"+
							"				gi.indirect.diffuse = 0;\n"+
							"				gi.indirect.specular = 0;\n"+
							"				#if !defined(LIGHTMAP_ON)\n"+
							"					gi.light.color = _LightColor0.rgb;\n"+
							"					gi.light.dir = lightDir;\n"+
							"					gi.light.ndotl = LambertTerm (d.worldNormal, gi.light.dir);\n"+
							"				#endif\n";
				if (!SG.U4){
				ShaderCode+=
							"				// Call GI (lightmaps/SH/reflections) lighting function\n"+
							"				UnityGIInput giInput;\n"+
							"				UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);\n"+
							"				giInput.light = gi.light;\n"+
							"				giInput.worldPos = d.worldPos;\n";
			if (SG.UsedViewDir)
			ShaderCode +=
							"				giInput.worldViewDir = d.worldViewDir;\n";
			ShaderCode +=
							"				giInput.atten = atten;\n"+
							"				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)\n"+
							"					giInput.lightmapUV = IN.lmap;\n"+
							"				#else\n"+
							"					giInput.lightmapUV = 0.0;\n"+
							"				#endif\n"+
							"				#if UNITY_SHOULD_SAMPLE_SH\n"+
							"					giInput.ambient = IN.sh;\n"+
							"				#else\n"+
							"					giInput.ambient.rgb = 0.0;\n"+
							"				#endif\n"+
							"				giInput.probeHDR[0] = unity_SpecCube0_HDR;\n"+
							"				giInput.probeHDR[1] = unity_SpecCube1_HDR;\n"+
							"				#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION\n"+
							"					giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending\n"+
							"				#endif\n"+
							"				#if UNITY_SPECCUBE_BOX_PROJECTION\n"+
							"					giInput.boxMax[0] = unity_SpecCube0_BoxMax;\n"+
							"					giInput.probePosition[0] = unity_SpecCube0_ProbePosition;\n"+
							"					giInput.boxMax[1] = unity_SpecCube1_BoxMax;\n"+
							"					giInput.boxMin[1] = unity_SpecCube1_BoxMin;\n"+
							"					giInput.probePosition[1] = unity_SpecCube1_ProbePosition;\n"+
							"				#endif\n";
				}
			}
			if (ParallaxOn.On&&SG.UsedParallax){
				ShaderCode+=
				"				float2 view = d.viewDir.xy*(-1*"+ParallaxHeight.Get()+");\n"+
				"				float3 worldView = d.worldNormal*(-1*"+ParallaxHeight.Get()+");\n"+
				"				d.Depth = CalculateHeight(d, gi, view);\n"+
				"				d.ShadowFactor = 1;";
				string UvClipName = "uvTexcoord";
				foreach (ShaderInput SI in SG.Base.ShaderInputs){
					if (SI.Type==0){
						if (SI.UsedMapType0==true){
							ShaderCode+="	d.uv"+SI.Get()+".xy += view*d.Depth;\n";
							UvClipName = "d.uv"+SI.Get();
						}
					}
				}
				if (SG.GeneralUV=="uvTexcoord")
					ShaderCode+="d.uvTexcoord.xy += view*d.Depth;\n";
				if (SG.UsedWorldNormals&&SG.UsedWorldPos)
					ShaderCode+="	d.worldPos += worldView*d.Depth;\n";
				if (ParallaxOn.On==true&&ParallaxSilhouetteClipping.On==true&&UvClipName!=""){
					ShaderCode+="	clip(d."+SG.GeneralUV+".x);\n"+
					"	clip(d."+SG.GeneralUV+".y);\n"+
					"	clip(-(d."+SG.GeneralUV+".x-1));\n"+
					"	clip(-(d."+SG.GeneralUV+".y-1));\n";
				}
				if (ParallaxShadows.On){
					ShaderCode+=
					"				//POM Shadowing\n"+
					"				float3 TangentLightDir = d.TtoWSpaceX*lightDir.x + d.TtoWSpaceY*lightDir.y + d.TtoWSpaceZ*lightDir.z;\n"+
					"				float2 lightview = TangentLightDir.xy*"+ParallaxHeight.Get()+";\n"+
					"				float lightdepth = 0;\n"+
					"				lightdepth = CalculateHeight(d,gi,lightview);\n"+
					"				d.ShadowFactor = saturate(lerp(0.5,((d.Depth-lightdepth)),"+ParallaxShadowSize.Get()+"));\n"+
					"				d.ShadowFactor*="+ParallaxShadowStrength.Get()+";\n"+
					"				d.ShadowFactor = 1-clamp(d.ShadowFactor,0,1);\n";
				}
			}
			foreach(string Ty in ShaderSandwich.EffectsList){
				bool IsUsed = false;
				foreach (ShaderLayer SL in ShaderUtil.GetAllLayers(this)){
					foreach(ShaderEffect SE in SL.LayerEffects)
					{
						if (Ty==SE.TypeS&&SE.Visible)
						IsUsed = true;
					}
				}
				if (IsUsed){
					ShaderEffect NewEffect = ShaderEffect.CreateInstance<ShaderEffect>();
					NewEffect.ShaderEffectIn(Ty);
					if (ShaderEffect.GetMethod(NewEffect.TypeS,"GenerateStart")!=null)
					ShaderCode+= (string)ShaderEffect.GetMethod(NewEffect.TypeS,"GenerateStart").Invoke(null,new object[]{SG})+"\n";
				}
			}
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += SLL.GCVariable();
					ShaderCode += GenerateLayers(SG,SLL,"");
					ShaderCode += "				d."+SLL.CodeName+" = "+SLL.CodeName+";\n";
				}
			}
			ShaderCode += GenerateLayers(SG,ShaderLayersNormal,"");
			ShaderCode += GenerateLayers(SG,ShaderLayersDiffuse,"");
			if (SpecularOn.On)
				ShaderCode += GenerateLayers(SG,ShaderLayersSpecular,"");
			if (EmissionOn.On&&SG.Pass!="ForwardAdd")
				ShaderCode += GenerateLayers(SG,ShaderLayersEmission,"");
			if (TransparencyOn.On)
				ShaderCode += GenerateLayers(SG,ShaderLayersAlpha,"");
			if (TransparencyOn.On){
				if (SG.PassSubset != "Mask"){
					if (TransparencyType.Type==0)
						ShaderCode += "				d.Alpha-="+TransparencyAmount.Get()+";\n";
					else
						ShaderCode += "				d.Alpha-="+TransparencyAmount.Get()+";\n";
				}
				else
				ShaderCode += "				d.Alpha-="+TransparencyZWriteAmount.Get()+";\n";
			}
			//if (TransparencyOn.On&&TransparencyType.Type==1&&BlendMode.Type==2)
			//	ShaderCode += "				d.Alpha = saturate(1-d.Alpha);\n";
			if (TransparencyOn.On&&TransparencyType.Type==0)
				ShaderCode += "				clip(d.Alpha);\n";
			//if (ParallaxOn.On)
			//	ShaderCode += GenerateLayers(SG,ShaderLayersHeight,"");
				
			if (EmissionOn.On&&SG.Pass!="ForwardAdd"){
				if (EmissionType.Type==1)
					ShaderCode+="	d.Emission.rgb*=d.Albedo;\n";
				if (EmissionType.Type==2){
					ShaderCode+="	d.Albedo *= 1-d.Emission.a;\n";
				}
			}
			if (SG.UseLighting){
				ShaderCode +=
				"				fixed3 worldN;\n";
				if (SG.UseTangentSpace)
					ShaderCode +=
				"				worldN.x = dot(IN.TtoWSpaceX.xyz, d.Normal);\n"+
				"				worldN.y = dot(IN.TtoWSpaceY.xyz, d.Normal);\n"+
				"				worldN.z = dot(IN.TtoWSpaceZ.xyz, d.Normal);\n";
				else
					ShaderCode +=
				"				worldN = d.worldNormal;\n";
				ShaderCode +=
				"				d.Normal = worldN;\n"+
				"				\n"+
				"				#if !defined(LIGHTMAP_ON)\n"+
				"					gi.light.ndotl = LambertTerm (d.Normal, gi.light.dir);\n"+
				"				#endif\n\n";
				if (SG.Pass == "ForwardBase"&&!SG.U4)
					ShaderCode += "				CalculateGI(d, giInput, gi);\n";
				else
					ShaderCode += "				gi.light.color *= atten;\n";
				if (SG.U4&&SG.Pass == "ForwardBase")
					ShaderCode += 
									"				gi.indirect.diffuse = UNITY_LIGHTMODEL_AMBIENT;\n";
				if (SG.U4&&IsPBR&&SG.Pass == "ForwardBase"){
					ShaderCode += 	"				gi.indirect.specular = Unity_GlossyEnvironment (_Cube, reflect(d.worldViewDir,worldN), 1-d.Smoothness);\n"+
									"				//gi.indirect.specular =  texCUBE(_Cube, float4(reflect(d.worldViewDir,worldN),3));\n";
				}
				if (SG.Pass!="ForwardAdd")
					ShaderCode += "				c = CalculateLighting (d, gi)+d.Emission;\n";
				else
					ShaderCode += "				c = CalculateLighting (d, gi);\n";
			}else{
				if (SG.Pass!="ForwardAdd")
					ShaderCode += "				c = float4(d.Albedo+d.Emission.rgb,d.Alpha);\n";
				else
					ShaderCode += "				c = float4(d.Albedo,d.Alpha);\n";
			}
			if (MiscFog.On&&!SG.U4)
				ShaderCode += "				UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog;\n";
			if (!TransparencyOn.On||TransparencyType.Type==0)
				ShaderCode += "				c.a = 1;\n";
			else if (TransparencyOn.On&&TransparencyType.Type==1&&BlendMode.Type==1&&(!IsPBR||!TransparencyPBR.On))
				ShaderCode += "				c *= d.Alpha;\n";
			ShaderCode += "				return c;\n";
			
			ShaderCode += "			}\n";
		return ShaderCode;
	}
	public string GeneratePassEnd(ShaderGenerate SG){
		string ShaderCode = "";
			ShaderCode +=
			"		ENDCG\n"+
			"	}\n";
		return ShaderCode;
	}
	public string GetTexCoord(ref int Texcoord){
		Texcoord+=1;
		return (Texcoord-1).ToString();
	}
	public string GenerateStructs(ShaderGenerate SG){
		string ShaderCode = "";
			string UsefulDataToPack = "";
			string StuffToPack = "";
			string StuffToPackF2s = "";
			string StuffToPackF3s = "";
			string StuffToPackF4s = "";
			int TexCoords = 0;
			int FloatsToSend = 0;
			int Float2sToSend = 0;
			int Float3sToSend = 0;
			int Float4sToSend = 0;
			if (SG.UseTangentSpace){
				StuffToPackF4s += "					float4 TtoWSpaceX: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				UsefulDataToPack += "				float4 TtoWSpaceX;\n";
				StuffToPackF4s += "					float4 TtoWSpaceY: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				UsefulDataToPack += "				float4 TtoWSpaceY;\n";
				StuffToPackF4s += "					float4 TtoWSpaceZ: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				UsefulDataToPack += "				float4 TtoWSpaceZ;\n";
				UsefulDataToPack += "				float3 worldPos;\n";
				UsefulDataToPack += "				float3 worldNormal;\n";
				FloatsToSend += 4*3;
				Float4sToSend += 3;
			}
			else{
				if (SG.UsedWorldPos){
					StuffToPackF3s += "					float3 worldPos: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
					UsefulDataToPack += "				float3 worldPos;\n";
					FloatsToSend += 3;
					Float3sToSend += 1;
				}
				if (SG.UsedWorldNormals){
					StuffToPackF3s += "					float3 worldNormal: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
					UsefulDataToPack += "				float3 worldNormal;\n";
					FloatsToSend += 3;
					Float3sToSend += 1;
				}
			}
			if (SG.UsedScreenPos){
				StuffToPackF3s += "					float4 screenPos: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				UsefulDataToPack += "				float4 screenPos;\n";
				FloatsToSend += 3;
				Float3sToSend += 1;
			}
			if (SG.UsedWorldRefl){
				StuffToPackF3s += "					float3 worldRefl: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				UsefulDataToPack += "				float3 worldRefl;\n";
				FloatsToSend += 3;
				Float3sToSend += 1;
			}
			if (SG.UsedViewDir){
				if (MiscInterpolateView.On){
					StuffToPackF3s += "					float3 viewDir: TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
					FloatsToSend += 3;
					Float3sToSend += 1;
				}
				UsefulDataToPack += "				float3 viewDir;\n";
				UsefulDataToPack += "				float3 worldViewDir;\n";
			}
			if (SG.UsedVertex){
				StuffToPackF4s += "					fixed4 color : COLOR0;\n";
				UsefulDataToPack += "				fixed4 color;\n";
			}
			if (ParallaxOn.On){
				UsefulDataToPack += "				float Depth;\n";
				UsefulDataToPack += "				float ShadowFactor;\n";
			}
			UsefulDataToPack += "				float ShellDepth;\n";
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					if (SLL.EndTag.Text.Length==1)
						UsefulDataToPack+="				float "+SLL.CodeName+";\n";
					if (SLL.EndTag.Text.Length==2)
						UsefulDataToPack+="				float2 "+SLL.CodeName+";\n";
					if (SLL.EndTag.Text.Length==3)
						UsefulDataToPack+="				float3 "+SLL.CodeName+";\n";
					if (SLL.EndTag.Text.Length==4)
						UsefulDataToPack+="				float4 "+SLL.CodeName+";\n";
				}
			}
			SG.Float3sCombined = false;
			/*if (Float3sToSend>0&&Float3sToSend%4 == 0){
				SG.Float3sCombined = true;
				TexCoords-=Float3sToSend;
				StuffToPackF3s = "";
				for( int i = 0;i<Float3sToSend; i+=4){
					StuffToPackF3s += "					float4 dataToPack"+i.ToString()+" : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				}
			}*/
			foreach (ShaderInput SI in SG.Base.ShaderInputs){
				if (SI.Type==0){
					if (SI.UsedMapType0==true||SI.UsedMapType1==true){
						if (SI.UsedMapType0==true){
							StuffToPackF2s += "					float2 uv"+SI.Get()+": TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
							UsefulDataToPack += "				float2 uv"+SI.Get()+";\n";
							FloatsToSend += 2;
							Float2sToSend += 1;
						}
						if (SI.UsedMapType1==true){
							StuffToPackF2s += "					float2 uv2"+SI.Get()+": TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
							UsefulDataToPack += "				float2 uv2"+SI.Get()+";\n";
							FloatsToSend += 2;
							Float2sToSend += 1;
						}
					}
				}				
			}
			if (SG.UsedGenericUV){
				StuffToPackF2s += "					float2 "+SG.GeneralUV+": TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				UsefulDataToPack += "				float2 "+SG.GeneralUV+";\n";
				FloatsToSend += 2;
				Float2sToSend += 1;			
			}
			TexCoords = Float2sToSend+Float3sToSend+Float4sToSend;
			//UnityEngine.Debug.Log(FloatsToSend);
			SG.Float2sCombined = false;
			if (Float2sToSend>0&&Float2sToSend%2 == 0){
				SG.Float2sCombined = true;
				StuffToPackF2s = "";
				TexCoords-=Float2sToSend;
				for( int i = 0;i<Float2sToSend; i+=2){
					StuffToPackF2s += "					float4 dataToPack"+i.ToString()+" : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
				}
			}
			StuffToPack = StuffToPackF3s+StuffToPackF2s+StuffToPackF4s;
			
			ShaderCode +=
			"			struct UsefulData{\n"+
			"				float3 Albedo;\n"+
			"				float3 Specular;\n"+
			"				float3 Normal;\n"+
			"				float Alpha;\n"+
			"				float Occlusion;\n"+
			"				float Height;\n"+
			"				float4 Emission;\n"+
			"				float Smoothness;\n"+
			UsefulDataToPack+
			"			};\n";
			
			if (SG.Pass=="Mask"){
				ShaderCode +=
				"			#ifdef LIGHTMAP_OFF\n"+
				"				struct v2f_surf {\n"+
				"					float4 pos : SV_POSITION;\n"+
				StuffToPack+
				"				};\n"+
				"			#endif\n";
			}
			if (SG.Pass=="ForwardBase"){
				ShaderCode +=
				"			#ifdef LIGHTMAP_OFF\n"+
				"				struct v2f_surf {\n"+
				"					float4 pos : SV_POSITION;\n"+
				StuffToPack+
				"					#if UNITY_SHOULD_SAMPLE_SH\n"+
				"						half3 sh : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n"+
				"					#endif\n";
				if (MiscShadows.On&&(SG.Pass!="ForwardAdd"||MiscFullShadows.On)&&!SG.U4)
				ShaderCode +=
				"					SHADOW_COORDS("+GetTexCoord(ref TexCoords)+")\n";
				if (MiscFog.On&&!SG.U4)
				ShaderCode +=
				"					UNITY_FOG_COORDS("+GetTexCoord(ref TexCoords)+")\n";
				if (SG.U4)
				ShaderCode +=
				"				LIGHTING_COORDS("+GetTexCoord(ref TexCoords)+","+GetTexCoord(ref TexCoords)+")\n";
				ShaderCode +=
				"				};\n"+
				"			#endif\n";
				TexCoords -= 1;
				if (MiscShadows.On&&!SG.U4)
					TexCoords -= 1;
				if (MiscFog.On&&!SG.U4)
					TexCoords -= 1;
				if (SG.U4)
					TexCoords -= 2;
				if (MiscLightmap.On){
					ShaderCode +=
					"			// with lightmaps:\n"+
					"			#ifndef LIGHTMAP_OFF\n"+
					"				struct v2f_surf {\n"+
					"					float4 pos : SV_POSITION;\n"+
					StuffToPack+
					"					float4 lmap : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n";
					if (MiscShadows.On&&(SG.Pass!="ForwardAdd"||MiscFullShadows.On)&&!SG.U4)
					ShaderCode +=
					"					SHADOW_COORDS("+GetTexCoord(ref TexCoords)+")\n";
					if (MiscFog.On&&!SG.U4)
					ShaderCode +=
					"					UNITY_FOG_COORDS("+GetTexCoord(ref TexCoords)+")\n";
					if (SG.U4)
					ShaderCode +=
					"				LIGHTING_COORDS("+GetTexCoord(ref TexCoords)+","+GetTexCoord(ref TexCoords)+")\n";
					if (!SG.UseTangentSpace){
					ShaderCode +=
					"					#ifdef DIRLIGHTMAP_COMBINED\n"+
					"						fixed3 TtoWSpace1 : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n"+
					"						fixed3 TtoWSpace2 : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n"+
					"						fixed3 TtoWSpace3 : TEXCOORD"+GetTexCoord(ref TexCoords)+";\n"+
					"					#endif\n";
					}
					ShaderCode +=
					"				};\n"+
					"			#endif\n";
				}
			}
			if (SG.Pass=="ForwardAdd"){
				ShaderCode +=
				"			struct v2f_surf {\n"+
				"				float4 pos : SV_POSITION;\n"+
				StuffToPack;
				if (MiscShadows.On&&MiscFullShadows.On&&!SG.U4)
				ShaderCode +=
				"				SHADOW_COORDS("+GetTexCoord(ref TexCoords)+")\n";
				if (MiscFog.On&&!SG.U4)
				ShaderCode +=
				"				UNITY_FOG_COORDS("+GetTexCoord(ref TexCoords)+")\n";
				if (SG.U4)
				ShaderCode +=
				"				LIGHTING_COORDS("+GetTexCoord(ref TexCoords)+","+GetTexCoord(ref TexCoords)+")\n";
				ShaderCode +=
				"			};\n";
			}
		ShaderCode+=
			"			//Create a struct for the inputs of the vertex shader which includes whatever Shader Sandwich might need.\n"+
			"			struct appdata_min {\n"+
			"				float4 vertex : POSITION;\n"+
			"				float4 tangent : TANGENT;\n"+
			"				float3 normal : NORMAL;\n"+
			"				float4 texcoord : TEXCOORD0;\n"+
			"				float4 texcoord1 : TEXCOORD1;\n";
			if (!SG.U4)
		ShaderCode +=
			"				float4 texcoord2 : TEXCOORD2;\n";
		ShaderCode +=
			"				fixed4 color : COLOR;\n"+
			"			};";
		return ShaderCode;
	}
	public string GeneratePOMFunction(ShaderGenerate SG){
		string ShaderCode = "";
		if (ParallaxOn.On){
				ShaderCode+=
			"float CalculateHeight(UsefulData d, UnityGI gi,float2 view){"+
			"\n"+
			"		float size = 1.0/LINEAR_SEARCH; // stepping size\n"+
			"		float depth = 0;//pos\n"+
			"		int i;\n"+
			"		float Height = 1;\n"+
			"		for(i = 0; i < LINEAR_SEARCH-1; i++)// search until it steps over (Front to back)\n"+
			"		{\n"+
			GenerateLayers(SG,ShaderLayersHeight,"")+"\n"+
			"			\n"+
			"			if(depth < (1-d.Height))\n"+
			"				depth += size;				\n"+
			"		}\n"+
			"		//depth = best_depth;\n"+
			"		for(i = 0; i < BINARY_SEARCH; i++) // look around for a closer match\n"+
			"		{\n"+
			"			size*=0.5;\n"+
			"			\n"+
			GenerateLayers(SG,ShaderLayersHeight,"")+"\n"+
			"			\n"+
			"			if(depth < (1-d.Height))\n"+
			"				depth += (2*size);\n"+
			"			\n"+
			"			depth -= size;			\n"+	
			"		}\n"+
			"		return depth;\n"+
			"	}\n";
		}
		return ShaderCode;
	}
	public void GenerateUsed(ShaderGenerate SG){
		SG.ResetPass();
		SG.PassSetNormals = ShaderLayersNormal.SLs.Count>0;
		
		
		SG.UseTangentSpace = SG.PassSetNormals;
		
		if (DiffuseOn.On||SpecularOn.On)
			SG.UseLighting = true;
			
		if (ParallaxHeight.Get()!="0"&&ParallaxOn.On){
			SG.UsedParallax = true;
			TechShaderTarget.Float = Mathf.Max(TechShaderTarget.Float,3);
			
			if (ParallaxSilhouetteClipping.On)
			SG.UsedGenericUV = true;
			
			SG.UsedWorldNormals = true;
			SG.UsedViewDir = true;
			SG.UseTangentSpace = true;
		}
	
		if (SG.UseTangentSpace){
			SG.UsedWorldNormals = true;
			SG.UsedWorldPos = true;
		}		
		
		if (SG.UseLighting){
			SG.UsedWorldNormals = true;
			SG.UsedWorldPos = true;
			if (DiffuseLightingType.Type!=1)
				SG.UsedViewDir = true;
			if (SpecularOn.On)
				SG.UsedViewDir = true;
		}
		if (!MiscInterpolateView.On)
			SG.UsedWorldPos = true;
	}
	public string GenerateDiffuseFunction(ShaderGenerate SG){
		string DiffuseCode = "";
		if (DiffuseOn.On){
			if (DiffuseLightingType.Type==1){//Diffuse
				if (DiffuseNormals.Get()=="1")
					DiffuseCode += "				half NdotL = 1; //Disabled using normals, so just set this to 1.\n";
				else if (DiffuseNormals.Get()=="0")
					DiffuseCode += "				half NdotL = gi.light.ndotl; //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source.\n";
				else
					DiffuseCode += "				half NdotL = lerp(max (0, gi.light.ndotl),1,"+DiffuseNormals.Get()+"); //Calculate the dot of the faces normal and the lights direction. This means a lower number the further the angle of the face is from the light source. Finally, we blend this with the default value of 1 (Due to no normals being turned up)\n";
					
				DiffuseCode += 
				"				cDiff = gi.light.color * NdotL; //Output the final RGB color by multiplying the surfaces color with the light color, then by the distance from the light (or some function of it), and finally by the Dot of the normal and the light direction.\n";
			}
			if (DiffuseLightingType.Type==2){//Microfaceted
				string TempStr1 = DiffuseSetting1.Get();
				DiffuseCode =
				"				\n"+
				"				half roughness2=("+TempStr1+"*2)*("+TempStr1+"*2);\n"+
				"				half2 AandB = roughness2/(roughness2 + float2(0.33,0.09));//Computing some constants\n"+
				"				half2 oren_nayar = float2(1, 0) + float2(-0.5, 0.45) * AandB;\n"+
				"				\n"+
				"				//Theta and phi\n"+
				"				half2 cos_theta = saturate(float2(dot(d.Normal,gi.light.dir),dot(d.Normal,d.worldViewDir)));\n"+
				"				half2 cos_theta2 = cos_theta * cos_theta;\n"+
				"				half sin_theta = sqrt((1-cos_theta2.x)*(1-cos_theta2.y));\n"+
				"				half3 light_plane = normalize(gi.light.dir - cos_theta.x*d.Normal);\n"+
				"				half3 view_plane = normalize(d.worldViewDir - cos_theta.y*d.Normal);\n"+
				"				half cos_phi = saturate(dot(light_plane, view_plane));\n"+
				"				\n"+
				"				//composition\n"+
				"				half diffuse_oren_nayar = cos_phi * sin_theta / max(cos_theta.x, cos_theta.y);\n"+
				"				\n"+
				"				half diffuse = cos_theta.x * (oren_nayar.x + oren_nayar.y * diffuse_oren_nayar);\n"+
				"				cDiff = gi.light.color*max(0,diffuse);\n";
			}
			if (DiffuseLightingType.Type==3){//Translucent
				DiffuseCode =
				"				half3 Surf1 = gi.light.color * (max(0,dot (d.Normal, gi.light.dir)));//Calculate lighting the standard way (See Diffuse lighting modes comments).\n";


				string TempStr1 = DiffuseSetting1.Get();
				string TempStr2 = DiffuseSetting2.Get();
				DiffuseCode+=
				"				half3 Surf2 = gi.light.color * (max(0,dot (-d.Normal, gi.light.dir)* "+TempStr1+"/2.0 + "+TempStr1+"/2.0));//Calculate diffuse lighting with inverted normals while taking the Wrap Amount into consideration.\n"+
				"				cDiff = Surf1+(Surf2*(0.8-abs(dot(normalize(d.Normal), normalize(gi.light.dir))))*"+TempStr1+" * "+TempStr2+".rgb);//Combine the two lightings together, by adding the standard one with the inverted one.\n";
			}
		}
		return DiffuseCode;
	}
	public string GenerateSpecularFunction(ShaderGenerate SG){
		string SpecularCode = "";
			string TempStr1 = SpecularOffset.Get();
			if (TempStr1=="0")
			TempStr1 = "";
			else
			TempStr1 = "+float3(sin((float)"+TempStr1+"),cos((float)"+TempStr1+"+1.57075),tan((float)"+TempStr1+"))";
			if (SpecularLightingType.Type == 0){
				SpecularCode += 
				"				half3 h = normalize (gi.light.dir + d.worldViewDir"+TempStr1+");	\n"+	
				"				float nh = max (0, dot (d.Normal, h));\n"+
				"				cSpec = pow (nh, d.Smoothness*128.0) * d.Specular;\n";
			}		
			if (SpecularLightingType.Type == 1){
				SpecularCode += 
				"				cSpec = (dot(reflect(-gi.light.dir, d.Normal),d.worldViewDir"+TempStr1+"));\n"+	
				"				cSpec = pow(max(0.0,cSpec),d.Smoothness*128.0) * d.Specular;\n";
			}		
			if (SpecularLightingType.Type == 2){
				SpecularCode += 
				"				cSpec = abs(dot(d.Normal,reflect(-gi.light.dir, -d.worldViewDir"+TempStr1+")));\n"+
				"				cSpec = (half3(1.0f,1.0f,1.0f)-(pow(sqrt(cSpec),2 - d.Smoothness)));\n"+
				"				cSpec = saturate(cSpec)*d.Specular;";
			}					
			SpecularCode += "	cSpec = cSpec * 2 * gi.light.color;\n";
			if (SpecularEnergy.On==true)
				SpecularCode += "	cSpec = cSpec * ((((d.Smoothness*128.0f)+9.0f)/("+(9.0f*3.14f).ToString()+"))/9.0f);\n";
		return SpecularCode;
	}
	public string GenerateLightingFunction(ShaderGenerate SG){
		string ShaderCode = "";
		if (SG.UseLighting){
			if (MiscAmbient.On&&SG.U4&&SG.Pass=="ForwardBase")
				ShaderCode += "			#define UNITY_LIGHT_FUNCTION_APPLY_INDIRECT\n";
			string CustomDiffuse = GenerateLayers(SG,ShaderLayersLightingDiffuse,"");
			string CustomSpecular = "";
			if (SpecularOn.On)
				CustomSpecular = GenerateLayers(SG,ShaderLayersLightingSpecular,"");
			string CustomAmbient = GenerateLayers(SG,ShaderLayersLightingAmbient,"");
			string CustomLighting = GenerateLayers(SG,ShaderLayersLightingAll,"");
			if (CustomLighting!=""){
				ShaderCode+=
				"			float3 CalculateCustomAll(UsefulData d, UnityGI gi, float3 cTemp){\n";
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += "		"+SLL.GCVariable();
					ShaderCode += "				"+SLL.CodeName+" = d."+SLL.CodeName+";\n";
				}
			}
			ShaderCode +=
				CustomLighting+
				"				return cTemp;\n			}\n";
			}			
			if (IsPBR){//Generate PBR code, this is a long one XD
				ShaderCode+="//Include a bunch of PBS Code from files UnityPBSLighting.cginc and UnityStandardBRDF.cginc for the purpose of custom lighting effects.\n";
			ShaderCode+=
			"half4 BRDF1_Unity_PBSSS (UsefulData d, UnityGI gi,half oneMinusReflectivity, half oneMinusRoughness)\n"+
			"{";
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += "		"+SLL.GCVariable();
					ShaderCode += "				"+SLL.CodeName+" = d."+SLL.CodeName+";\n";
				}
			}
ShaderCode+=@"
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
";
	if (SG.U4)
	ShaderCode+=@"half specularTerm = max(0, (V * D * nl));// Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)";
	else
	ShaderCode+=@"half specularTerm = max(0, (V * D * nl) * unity_LightGammaCorrectionConsts_PIDiv4);// Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)";
	
	ShaderCode+=@"
	half3 cDiff = disneyDiffuse * nl * gi.light.color;
	
	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));
	half3 cSpec = specularTerm*gi.light.color * FresnelTerm (d.Specular, lh)+(gi.indirect.specular * FresnelLerp (d.Specular, grazingTerm, nv));
	";
	if (ParallaxOn.On&&ParallaxShadows.On){
		ShaderCode += 
		"				//POM Shadowing\n"+
		"				cDiff *= d.ShadowFactor;\n"+
		"				cSpec *= d.ShadowFactor;\n"+
		"				gi.indirect.specular *= d.ShadowFactor;\n";
	}

	ShaderCode+=CustomDiffuse+"\n";
	ShaderCode += CustomSpecular+"\n";
	
	if (CustomLighting!=""){
		ShaderCode += "				cDiff = CalculateCustomAll(d,gi,cDiff);\n";
		ShaderCode += "				cSpec = CalculateCustomAll(d,gi,cSpec);\n";
	}	
	//if (!SG.U4)
	ShaderCode+="\nhalf3 cAmb = gi.indirect.diffuse;\n"+CustomAmbient;
	if (SG.Pass!="ForwardAdd")
	ShaderCode+= "\ncDiff += cAmb;\n";
	
	ShaderCode+=@"
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
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);";
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += "		"+SLL.GCVariable();
					ShaderCode += "				"+SLL.CodeName+" = d."+SLL.CodeName+";\n";
				}
			}
	ShaderCode+=@"

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
	";
	if (ParallaxOn.On&&ParallaxShadows.On){
		ShaderCode += 
		"				//POM Shadowing\n"+
		"				cDiff *= d.ShadowFactor;\n"+
		"				cSpec *= d.ShadowFactor;\n";
	}
	ShaderCode += CustomDiffuse+"\n";
	ShaderCode += CustomSpecular+"\n";
	
	if (CustomLighting!=""){
		ShaderCode += "				cDiff = CalculateCustomAll(d,gi,cDiff);\n";
		ShaderCode += "				cSpec = CalculateCustomAll(d,gi,cSpec);\n";
	}
	//if (!SG.U4)
	ShaderCode+="\nhalf3 cAmb = gi.indirect.diffuse;\n"+CustomAmbient;
	if (SG.Pass!="ForwardAdd")
	ShaderCode+= "\ncDiff += cAmb;\n";
	
	ShaderCode+=@"
	
	half3 color =	d.Albedo* cDiff + cSpec;

	return half4(color, 1);
}"+

  /*  half3 color =	diffColor * lightColor
                    + specularColor;
    half3 color =	(diffColor + specular * specColor) * light.color * nl
    				+ gi.diffuse * diffColor
					+ gi.specular * FresnelLerpFast (specColor, grazingTerm, nv);*/
@"

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
	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp";
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += "		"+SLL.GCVariable();
					ShaderCode += "				"+SLL.CodeName+" = d."+SLL.CodeName+";\n";
				}
			}
	ShaderCode+=@"

	half3 reflDir = reflect (d.worldViewDir, d.Normal);
	half3 halfDir = normalize (gi.light.dir + d.worldViewDir);

	half nl = gi.light.ndotl;
	half nh = BlinnTerm (d.Normal, halfDir);
	half nv = DotClamped (d.Normal, d.worldViewDir);

	// Vectorize Pow4 to save instructions
	half2 rlPow4AndFresnelTerm = Pow4 (half2(dot(reflDir, gi.light.dir), 1-nv));  // use R.L instead of N.H to save couple of instructions
	half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp
	half fresnelTerm = rlPow4AndFresnelTerm.y;
";
if (SG.U4)
ShaderCode+="#if 0 // Lookup texture to save instructions\n";
else
ShaderCode+="#if 1 // Lookup texture to save instructions\n";

ShaderCode+=@"
	half specular = tex2D(unity_NHxRoughness, half2(rlPow4, 1-oneMinusRoughness)).UNITY_ATTEN_CHANNEL * LUT_RANGE;
#else
	half roughness = 1-oneMinusRoughness;
	half n = RoughnessToSpecPower (roughness) * .25;
	half specular = (n + 2.0) / (2.0 * UNITY_PI * UNITY_PI) * pow(dot(reflDir, gi.light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;
	//half specular = (1.0/(UNITY_PI*roughness*roughness)) * pow(dot(reflDir, gi.light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;
#endif
	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));

	half3 cDiff = gi.light.color * nl;
	half3 cSpec = specular * d.Specular * cDiff + gi.indirect.specular * lerp (d.Specular, grazingTerm, fresnelTerm);";
	if (ParallaxOn.On&&ParallaxShadows.On){
		ShaderCode += 
		"				//POM Shadowing\n"+
		"				cDiff *= d.ShadowFactor;\n"+
		"				cSpec *= d.ShadowFactor;\n";
	}
	ShaderCode += CustomDiffuse+"\n";
	ShaderCode += CustomSpecular+"\n";
	
	if (CustomLighting!=""){
		ShaderCode += "				cDiff = CalculateCustomAll(d,gi,cDiff);\n";
		ShaderCode += "				cSpec = CalculateCustomAll(d,gi,cSpec);\n";
	}
	//if (!SG.U4)
	ShaderCode+="\nhalf3 cAmb = gi.indirect.diffuse;\n"+CustomAmbient;
	if (SG.Pass!="ForwardAdd")
	ShaderCode+= "\ncDiff += cAmb;\n";
	
	ShaderCode+=@"
	
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
";
			
			}
			
			ShaderCode += 
			"			float4 CalculateLighting(UsefulData d, UnityGI gi){\n"+
			"				float4 c = float4(d.Albedo,d.Alpha);\n"+
			"				float3 cTemp = float3(0,0,0);\n";
			if (SG.Pass=="ForwardAdd")
				ShaderCode +="				float3 cDiff = float3(0,0,0);\n";
			else
				ShaderCode +="				float3 cDiff = float3(1,1,1);\n";
			ShaderCode += 
			"				float3 cAmb = float3(0,0,0);\n"+
			"				float3 cSpec = float3(0,0,0);\n";
			if (!MiscAmbient.On)
			ShaderCode += "				gi.indirect.diffuse = 0;";
			
			foreach(ShaderLayerList SLL in SG.Base.ShaderLayersMasks){
				if (SG.UsedMasks[SLL]>0){
					ShaderCode += "		"+SLL.GCVariable();
					ShaderCode += "				"+SLL.CodeName+" = d."+SLL.CodeName+";\n";
				}
			}
			if (DiffuseLightingType.Type>0||!DiffuseOn.On){//Anything that ain't pbr
				ShaderCode += GenerateDiffuseFunction(SG);

				
				if (SpecularOn.On)
				ShaderCode += GenerateSpecularFunction(SG);
				
				if (DiffuseOn.On&&MiscAmbient.On&&SG.Pass!="ForwardAdd")
				ShaderCode += "				#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT\n"+
							"					cAmb = gi.indirect.diffuse;\n"+
							"				#endif\n";
				if (SG.U4)
				ShaderCode += "				cDiff *= 2;\n"+
							  "				cAmb *= 2;\n";
				ShaderCode += CustomDiffuse+"\n";
				ShaderCode += CustomSpecular+"\n";
				ShaderCode += CustomAmbient+"\n";
				if (CustomLighting!=""){
					ShaderCode += "				cDiff = CalculateCustomAll(d,gi,cDiff);\n";
					ShaderCode += "				cSpec = CalculateCustomAll(d,gi,cSpec);\n";
				}
				
				if (ParallaxOn.On&&ParallaxShadows.On){
					ShaderCode += 
					"				//POM Shadowing\n"+
					"				cDiff *= d.ShadowFactor;\n"+
					"				cSpec *= d.ShadowFactor;\n";
				}
				ShaderCode += "				c.rgb *= cDiff;\n";
				if (SG.Pass!="ForwardAdd")
				ShaderCode += "				c.rgb += cSpec+(d.Albedo * cAmb);\n";
				else
				ShaderCode += "				c.rgb += cSpec;\n";
			}else{
				ShaderCode +=
				"				// energy conservation\n"+
				"				half oneMinusReflectivity;\n"+
				"				d.Albedo = EnergyConservationBetweenDiffuseAndSpecular (d.Albedo, d.Specular, /*out*/ oneMinusReflectivity);\n"+
				"				\n"+
				"				// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)\n"+
				"				// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha\n"+
				"				half outputAlpha = d.Alpha;\n"+
				"				//For some reason #if defined() never works!!! So have to preprocess this when generating the shader...\n"+
				"				//d.Albedo = PreMultiplyAlpha (d.Albedo, d.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);\n";
				if (TransparencyOn.On&&TransparencyType.Type==1&&IsPBR&&TransparencyPBR.On)
				ShaderCode +=
				"				outputAlpha = 1-oneMinusReflectivity + d.Alpha*oneMinusReflectivity;\n"+
				"				d.Albedo *= d.Alpha;\n";
				ShaderCode +=
				"				\n"+
				"				c = "+PBRQuality.CodeNames[PBRQuality.Type]+" (d, gi, oneMinusReflectivity, d.Smoothness);\n"+
				"				c.rgb += UNITY_BRDF_GI (d.Albedo, d.Specular, oneMinusReflectivity, d.Smoothness, d.Normal, d.worldViewDir, d.Occlusion, gi);\n"+
				"				c.a = outputAlpha;\n";
			}
			ShaderCode += 
			"				return c;\n"+
			"			};\n";

			if (!SG.U4){
				ShaderCode+="\n"+
				"			void CalculateGI (UsefulData d,UnityGIInput data,inout UnityGI gi){\n";
				if (SpecularOn.On){
					ShaderCode+="				#if UNITY_VERSION >= 520\n"+
								"					UNITY_GI(gi, d, data);\n"+
								"				#else\n"+
								"					gi = UnityGlobalIllumination (data, 1.0, d.Smoothness, d.Normal);\n"+
								"				#endif\n";
								//"}\n";
				}
				else{
					ShaderCode+="				#if UNITY_VERSION >= 520\n"+
								"					UNITY_GI(gi, d, data);\n"+
								"				#else\n"+
								"					gi = UnityGlobalIllumination (data, 1.0, 0.0, d.Normal);\n"+
								"				#endif\n";
								//"}\n";
				}
				ShaderCode+=
				"			}\n";
			}			
		}
		
		return ShaderCode;		
	}
	public string GenerateTags(ShaderGenerate SG){
		string ShaderCode = "";
		if (!SG.Wireframe){
			if (MiscFog.On==false)
			ShaderCode+="	Fog {Mode Off}\n";
			else{
				if (SG.Pass=="ForwardAdd")
				ShaderCode+="	Fog { Color (0,0,0,0) }\n";
			}
			if  (TechZTest.Type!=0){
				ShaderCode+="	ZTest "+TechZTest.CodeNames[TechZTest.Type]+"\n";
				ShaderCode+="	ZWrite On\n";
			}else{
				ShaderCode+="	ZWrite Off\n";
			}
			if (SG.Pass == "Mask")
					ShaderCode+="	ZWrite On\n";
			if (TransparencyOn.On&&TransparencyType.Type==1){
				if (SG.Pass != "Mask")
					ShaderCode+="	ZWrite Off\n";
				
				if (BlendMode.Type==0){
					if (SG.Pass == "ForwardBase"){
						if (TransparencyPBR.On&&IsPBR)
							ShaderCode+="	Blend One OneMinusSrcAlpha//Standard Transparency\n";
						else
							ShaderCode+="	Blend SrcAlpha OneMinusSrcAlpha//Standard Transparency\n";
					}
					else{
						if (TransparencyPBR.On&&IsPBR)
							ShaderCode+="	Blend One One//Standard Transparency (Forward Add Mode)\n";
						else
							ShaderCode+="	Blend SrcAlpha One//Standard Transparency (Forward Add Mode)\n";
						
					}
				}
				if (BlendMode.Type==1)
					ShaderCode+="	Blend One One//Add Blend Mode\n";
				if (BlendMode.Type==2)
					ShaderCode+="	Blend DstColor Zero//Multiply Blend Mode\n";
			}else{
				if (SG.Pass == "ForwardBase")
					ShaderCode+="	Blend Off//No transparency\n";
				else
					ShaderCode+="	Blend One One//No transparency (But add in the Forward Add pass)\n";
			}
			
			ShaderCode+="	Cull "+TechCull.CodeNames[TechCull.Type]+"//Culling specifies which sides of the models faces to hide.\n";
		}
		if (SG.Pass == "Mask")
			ShaderCode+="	ColorMask 0\n";
		return ShaderCode;
	}
	public string GenerateTessellationFunction(ShaderGenerate SG){
		string ShaderCode = "";
		if (TessellationOn.On){
			ShaderCode += 			
			"			#ifdef UNITY_CAN_COMPILE_TESSELLATION\n"+
			"				// tessellation vertex shader\n"+
			"				struct Tess_appdata_min {\n"+
			"					float4 vertex : INTERNALTESSPOS;\n"+
			"					float4 tangent : TANGENT;\n"+
			"					float3 normal : NORMAL;\n"+
			"					float4 texcoord : TEXCOORD0;\n"+
			"					float4 texcoord1 : TEXCOORD1;\n";
			if (!SG.U4)
		ShaderCode += "					float4 texcoord2 : TEXCOORD2;\n";
		ShaderCode +=
			"					half4 color : COLOR;\n"+
			"				};\n";
			if (TessellationType.Type==0){
				ShaderCode+="				float4 tess (Tess_appdata_min v0, Tess_appdata_min v1, Tess_appdata_min v2){\n"+
							"					return "+TessellationQuality.Get()+";\n"+
							"				}\n";
			}
			if (TessellationType.Type==1){
				ShaderCode+=
				"				float4 tess (Tess_appdata_min v0, Tess_appdata_min v1, Tess_appdata_min v2){\n"+
				"					float3 pos0 = mul(_Object2World,v0.vertex).xyz;\n"+
				"					float3 pos1 = mul(_Object2World,v1.vertex).xyz;\n"+
				"					float3 pos2 = mul(_Object2World,v2.vertex).xyz;\n"+
				"					float4 tess;\n"+
				"					tess.x = distance(pos1, pos2)*"+TessellationQuality.Get()+";\n"+
				"					tess.y = distance(pos2, pos0)*"+TessellationQuality.Get()+";\n"+
				"					tess.z = distance(pos0, pos1)*"+TessellationQuality.Get()+";\n"+
				"					tess.w = (tess.x + tess.y + tess.z) / 3.0f;\n";
				if (TessellationFalloff.Get()!="1")
				ShaderCode+="					return pow(tess/50,"+TessellationFalloff.Get()+")*50;\n";
				else
				ShaderCode+="					return tess;\n";
				ShaderCode+="				}\n";
			}
			if (TessellationType.Type==2){
				ShaderCode+="				float4 tess (Tess_appdata_min v0, Tess_appdata_min v1, Tess_appdata_min v2){\n";
				if (TessellationFalloff.Get()!="1")
				ShaderCode+="					return pow(UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, (51-"+TessellationQuality.Get()+")*2)/50,"+TessellationFalloff.Get()+")*50;\n";
				else
				ShaderCode+="					return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, (51-"+TessellationQuality.Get()+")*2);\n";
				ShaderCode+="				}";
			}
		
		
			ShaderCode+=
				"				Tess_appdata_min tessvert_frag_surf (appdata_min v) {\n"+
				"					Tess_appdata_min o;\n"+
				"					o.vertex = v.vertex;\n"+
				"					o.tangent = v.tangent;\n"+
				"					o.normal = v.normal;\n"+
				"					o.texcoord = v.texcoord;\n"+
				"					o.texcoord1 = v.texcoord1;\n";
				if (!SG.U4)
		ShaderCode += 
				"					o.texcoord2 = v.texcoord2;\n";
		ShaderCode += 
				"					o.color = v.color;\n"+
				"					return o;\n"+
				"				}\n"+
				"				// tessellation hull constant shader\n"+
				"				UnityTessellationFactors hsconst_frag_surf (InputPatch<Tess_appdata_min,3> v) {\n"+
				"					UnityTessellationFactors o;\n"+
				"					float4 tf;\n"+
				"					tf = tess(v[0], v[1], v[2]);\n"+
				"					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;\n"+
				"					return o;\n"+
				"				}\n"+
				"				// tessellation hull shader\n"+
				"				[UNITY_domain(\"tri\")]\n"+
				"				[UNITY_partitioning(\"fractional_odd\")]\n"+
				"				[UNITY_outputtopology(\""+TessellationTopology.CodeNames[TessellationTopology.Type]+"\")]\n"+
				"				[UNITY_patchconstantfunc(\"hsconst_frag_surf\")]\n"+
				"				[UNITY_outputcontrolpoints(3)]\n"+
				"				Tess_appdata_min hs_frag_surf (InputPatch<Tess_appdata_min,3> v, uint id : SV_OutputControlPointID) {\n"+
				"					return v[id];\n"+
				"				}\n"+
				"				[UNITY_domain(\"tri\")]\n"+
				"				v2f_surf ds_frag_surf (UnityTessellationFactors tessFactors, const OutputPatch<Tess_appdata_min,3> vi, float3 bary : SV_DomainLocation) {\n"+
				"					appdata_min v;\n"+
				"					v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;\n"+
				"					v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;\n"+
				"					v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;\n"+
				"					v.texcoord = vi[0].texcoord*bary.x + vi[1].texcoord*bary.y + vi[2].texcoord*bary.z;\n"+
				"					v.texcoord1 = vi[0].texcoord1*bary.x + vi[1].texcoord1*bary.y + vi[2].texcoord1*bary.z;\n";
				if (!SG.U4)
		ShaderCode += 
				"					v.texcoord2 = vi[0].texcoord2*bary.x + vi[1].texcoord2*bary.y + vi[2].texcoord2*bary.z;\n";
		ShaderCode += 
				"					v.color = vi[0].color*bary.x + vi[1].color*bary.y + vi[2].color*bary.z;\n"+
				"					v2f_surf o = VertShader (v);\n"+
				"					return o;\n"+
				"				}\n"+
				"			#endif\n";
		}
		
		return ShaderCode;
	}
	public string GenerateForwardMask(ShaderGenerate SG){
		GenerateUsed(SG);
		string ShaderCode = "";
			SG.Pass = "Mask";
			ShaderCode += GeneratePassStart(SG,"MASK","","multi_compile_fwdbase","SHADERSANDWICH_MASK")+"\n";
			ShaderCode += GenerateUniforms(SG)+"\n";
			ShaderCode += GenerateStructs(SG)+"\n";
			ShaderCode += GenerateFunctions(SG)+"\n";
			ShaderCode += GenerateVertexShader(SG)+"\n";
			ShaderCode += GenerateTessellationFunction(SG)+"\n";
			ShaderCode += "fixed4 FragmentShader (v2f_surf IN) : SV_Target {\nreturn fixed4(0,0,0,0);\n}";
			ShaderCode += GeneratePassEnd(SG);
		return ShaderCode;
	}
	public string GenerateForwardBase(ShaderGenerate SG){
		GenerateUsed(SG);
		string ShaderCode = "";
			SG.Pass = "ForwardBase";
			ShaderCode += GeneratePassStart(SG,"FORWARD","ForwardBase","multi_compile_fwdbase"+(MiscShadows.On?"":" noshadow")+(MiscLightmap.On?"":" nolightmap nodynlightmap")+(MiscVertexLights.On?"":" novertexlight"),"UNITY_PASS_FORWARDBASE")+"\n";
			ShaderCode += GenerateUniforms(SG)+"\n";
			ShaderCode += GenerateStructs(SG)+"\n";
			ShaderCode += GenerateFunctions(SG)+"\n";
			ShaderCode += GenerateVertexShader(SG)+"\n";
			ShaderCode += GenerateTessellationFunction(SG)+"\n";
			ShaderCode += GeneratePOMFunction(SG)+"\n";
			ShaderCode += GenerateLightingFunction(SG)+"\n";
			ShaderCode += GenerateFragmentShader(SG)+"\n";
			ShaderCode += GeneratePassEnd(SG);
		return ShaderCode;
	}
	public string GenerateForwardAdd(ShaderGenerate SG){
		GenerateUsed(SG);
		string ShaderCode = "";
			SG.Pass = "ForwardAdd";
			ShaderCode += GeneratePassStart(SG,"FORWARD","ForwardAdd","multi_compile_fwdadd_fullshadows"+((SG.Pass!="ForwardAdd"||MiscFullShadows.On)?"":" noshadow")+(MiscLightmap.On?"":" nolightmap nodynlightmap")+(MiscVertexLights.On?"":" novertexlight"),"UNITY_PASS_FORWARDADD")+"\n";
			ShaderCode += GenerateUniforms(SG)+"\n";
			ShaderCode += GenerateStructs(SG)+"\n";
			ShaderCode += GenerateFunctions(SG)+"\n";
			ShaderCode += GenerateVertexShader(SG)+"\n";
			ShaderCode += GenerateTessellationFunction(SG)+"\n";
			ShaderCode += GeneratePOMFunction(SG)+"\n";
			ShaderCode += GenerateLightingFunction(SG)+"\n";
			ShaderCode += GenerateFragmentShader(SG)+"\n";
			ShaderCode += GeneratePassEnd(SG);
		return ShaderCode;
	}
	public string Save(){
		string S = "BeginShaderPass\n";
			S += ShaderUtil.SaveDict(GetSaveLoadDict());
			foreach (ShaderLayerList SLL in GetShaderLayerLists()){
				S+=SLL.Save();
			}
			S += "EndShaderPass\n";
		return S;
	}
	public void CorrectStuff(){
		SpecularHardness.Range0 = 0.0001f;
		if (IsPBR){
			SpecularOn.On = true;
			SpecularEnergy.On = true;
			SpecularLightingType.Type = 0;
		}

		ShellsCount.NoInputs=true;
		ShellsEase.Range0 = 0f;
		ShellsEase.Range1 = 3f;
		ParallaxHeight.Range1 = 0.4f;
		ParallaxBinaryQuality.NoInputs = true;
		
		TechLOD.NoInputs = true;
		TechLOD.Range0 = 0;
		TechLOD.Range1 = 1000;
		TechLOD.Float = Mathf.Round(TechLOD.Float);
		
		TechShaderTarget.NoInputs = true;
		TechShaderTarget.Range0 = 2;
		TechShaderTarget.Range1 = 5;
		TechShaderTarget.Float = Mathf.Round(TechShaderTarget.Float);
		if (!MiscShadows.On)
			MiscFullShadows.On = false;
	}
	public void Load(StringReader S){
		var D = GetSaveLoadDict();
		while(1==1){
			string Line =  S.ReadLine();
			if (Line!=null){
				if(Line=="EndShaderPass")break;

				if (Line.Contains("#!"))
					ShaderUtil.LoadLine(D,Line);
				else if (Line=="BeginShaderLayerList")
					ShaderLayerList.Load(S,GetShaderLayerLists(),null);
			}
			else
			break;
		}
		CorrectStuff();
	}
	public List<ShaderLayerList> GetShaderLayerLists(){
		List<ShaderLayerList> tempList = new List<ShaderLayerList>();
		tempList.Add(ShaderLayersDiffuse);
		tempList.Add(ShaderLayersAlpha);
		tempList.Add(ShaderLayersSpecular);
		tempList.Add(ShaderLayersNormal);
		tempList.Add(ShaderLayersEmission);
		tempList.Add(ShaderLayersHeight);
		tempList.Add(ShaderLayersVertex);
		tempList.Add(ShaderLayersLightingDiffuse);
		tempList.Add(ShaderLayersLightingSpecular);
		tempList.Add(ShaderLayersLightingAmbient);
		tempList.Add(ShaderLayersLightingAll);
		return tempList;
	}
	public List<List<ShaderLayer>> GetShaderLayers(){
		List<List<ShaderLayer>> tempList = new List<List<ShaderLayer>>();
		tempList.Add(ShaderLayersDiffuse.SLs);
		tempList.Add(ShaderLayersAlpha.SLs);
		tempList.Add(ShaderLayersSpecular.SLs);
		tempList.Add(ShaderLayersNormal.SLs);
		tempList.Add(ShaderLayersEmission.SLs);
		tempList.Add(ShaderLayersHeight.SLs);
		tempList.Add(ShaderLayersVertex.SLs);
		tempList.Add(ShaderLayersLightingDiffuse.SLs);
		tempList.Add(ShaderLayersLightingSpecular.SLs);
		tempList.Add(ShaderLayersLightingAmbient.SLs);
		tempList.Add(ShaderLayersLightingAll.SLs);
		return tempList;
	}
	public Dictionary<string,ShaderVar> GetSaveLoadDict(){
		Dictionary<string,ShaderVar> D = new Dictionary<string,ShaderVar>();
		D.Add(Name.Name,Name);
		D.Add(Visible.Name,Visible);
		D.Add(TechLOD.Name,TechLOD);
		D.Add(TechCull.Name,TechCull);
		D.Add(TechZTest.Name,TechZTest);
		D.Add(TechShaderTarget.Name,TechShaderTarget);

		D.Add(MiscVertexRecalculation.Name,MiscVertexRecalculation);
		D.Add(MiscFog.Name,MiscFog);
		D.Add(MiscAmbient.Name,MiscAmbient);
		D.Add(MiscVertexLights.Name,MiscVertexLights);
		D.Add(MiscLightmap.Name,MiscLightmap);
		D.Add(MiscFullShadows.Name,MiscFullShadows);
		D.Add(MiscForwardAdd.Name,MiscForwardAdd);
		D.Add(MiscShadows.Name,MiscShadows);
		D.Add(MiscInterpolateView.Name,MiscInterpolateView);
		D.Add(MiscRecalculateAfterVertex.Name,MiscRecalculateAfterVertex);

		D.Add(DiffuseOn.Name,DiffuseOn);
		D.Add(DiffuseLightingType.Name,DiffuseLightingType);
		D.Add(DiffuseSetting1.Name,DiffuseSetting1);
		D.Add(DiffuseSetting2.Name,DiffuseSetting2);
		D.Add(PBRQuality.Name,PBRQuality);
		D.Add(DiffuseNormals.Name,DiffuseNormals);

		D.Add(SpecularOn.Name,SpecularOn);
		D.Add(SpecularLightingType.Name,SpecularLightingType);
		D.Add(SpecularHardness.Name,SpecularHardness);
		D.Add(SpecularEnergy.Name,SpecularEnergy);
		D.Add(SpecularOffset.Name,SpecularOffset);

		D.Add(EmissionOn.Name,EmissionOn);
		D.Add(EmissionType.Name,EmissionType);

		D.Add(TransparencyOn.Name,TransparencyOn);
		D.Add(TransparencyType.Name,TransparencyType);
		D.Add(TransparencyZWrite.Name,TransparencyZWrite);
		D.Add(TransparencyPBR.Name,TransparencyPBR);
		D.Add(TransparencyAmount.Name,TransparencyAmount);
		D.Add(TransparencyZWriteAmount.Name,TransparencyZWriteAmount);
		D.Add(TransparencyReceive.Name,TransparencyReceive);
		D.Add(TransparencyZWriteType.Name,TransparencyZWriteType);
		D.Add(BlendMode.Name,BlendMode);

		D.Add(ShellsOn.Name,ShellsOn);
		D.Add(ShellsCount.Name,ShellsCount);
		D.Add(ShellsDistance.Name,ShellsDistance);
		D.Add(ShellsEase.Name,ShellsEase);
		D.Add(ShellsZWrite.Name,ShellsZWrite);
		D.Add(ShellsFront.Name,ShellsFront);
		D.Add(ShellsSkipFirst.Name,ShellsSkipFirst);

		D.Add(ParallaxOn.Name,ParallaxOn);
		D.Add(ParallaxHeight.Name,ParallaxHeight);
		D.Add(ParallaxBinaryQuality.Name,ParallaxBinaryQuality);
		D.Add(ParallaxSilhouetteClipping.Name,ParallaxSilhouetteClipping);
		D.Add(ParallaxShadows.Name,ParallaxShadows);
		D.Add(ParallaxShadowStrength.Name,ParallaxShadowStrength);
		D.Add(ParallaxShadowSize.Name,ParallaxShadowSize);

		D.Add(TessellationOn.Name,TessellationOn);
		D.Add(TessellationType.Name,TessellationType);
		D.Add(TessellationQuality.Name,TessellationQuality);
		D.Add(TessellationFalloff.Name,TessellationFalloff);
		D.Add(TessellationSmoothingAmount.Name,TessellationSmoothingAmount);
		D.Add(TessellationTopology.Name,TessellationTopology);

		return D;
	}
	public void CorrectOld(){
		if (DiffuseLightingType.Type==4)//PBR
			DiffuseLightingType.Type = 0;
		else
		if (DiffuseLightingType.Type==0)//Standard
			DiffuseLightingType.Type = 1;
		else
		if (DiffuseLightingType.Type==1)//Micro
			DiffuseLightingType.Type = 2;
		else
		if (DiffuseLightingType.Type==2)//Transc
			DiffuseLightingType.Type = 3;
		else
		if (DiffuseLightingType.Type==5)//Custom
			DiffuseLightingType.Type = 4;
		else
		if (DiffuseLightingType.Type==3){//Unlit
			DiffuseLightingType.Type = 1;
			DiffuseOn.On = false;
		}
		if (TransparencyType.Type==1)
		TransparencyAmount.Float = 1f-TransparencyAmount.Float;
	}
	public string GenerateFunctions(ShaderGenerate SG){
		string shaderCode = "";
		#if PRE_UNITY_5
		shaderCode += "\n"+
		"#ifndef UNITY_LIGHTING_COMMON_INCLUDED\n"+
"#define UNITY_LIGHTING_COMMON_INCLUDED\n"+
"// Transforms direction from object to world space\n"+
"inline float3 UnityObjectToWorldDir( in float3 dir ){\n"+
"	return normalize(mul((float3x3)_Object2World, dir));\n"+
"}\n"+
"// Transforms direction from world to object space\n"+
"inline float3 UnityWorldToObjectDir( in float3 dir ){\n"+
"	return normalize(mul((float3x3)_World2Object, dir));\n"+
"}\n"+
"// Transforms normal from object to world space\n"+
"inline float3 UnityObjectToWorldNormal( in float3 norm ){\n"+
"	// Multiply by transposed inverse matrix, actually using transpose() generates badly optimized code\n"+
"	return normalize(_World2Object[0].xyz * norm.x + _World2Object[1].xyz * norm.y + _World2Object[2].xyz * norm.z);\n"+
"}\n"+
"// Computes world space light direction, from world space position\n"+
"inline float3 UnityWorldSpaceLightDir( in float3 worldPos ){\n"+
"	#ifndef USING_LIGHT_MULTI_COMPILE\n"+
"		return _WorldSpaceLightPos0.xyz - worldPos * _WorldSpaceLightPos0.w;\n"+
"	#else\n"+
"		#ifndef USING_DIRECTIONAL_LIGHT\n"+
"		return _WorldSpaceLightPos0.xyz - worldPos;\n"+
"		#else\n"+
"		return _WorldSpaceLightPos0.xyz;\n"+
"		#endif\n"+
"	#endif\n"+
"}\n"+
"// Computes world space view direction, from object space position\n"+
"inline float3 UnityWorldSpaceViewDir( in float3 worldPos ){\n"+
"	return _WorldSpaceCameraPos.xyz - worldPos;\n"+
"}\n"+
"inline half DotClamped (half3 a, half3 b){\n"+
"	#if (SHADER_TARGET < 30 || defined(SHADER_API_PS3))\n"+
"		return saturate(dot(a, b));\n"+
"	#else\n"+
"		return max(0.0h, dot(a, b));\n"+
"	#endif\n"+
"}\n"+
"inline half LambertTerm (half3 normal, half3 lightDir){\n"+
"	return DotClamped (normal, lightDir);\n"+
"}\n"+
"\n"+
"\n"+
"\n"+
"struct UnityLight\n"+
"{\n"+
"	half3 color;\n"+
"	half3 dir;\n"+
"	half  ndotl;\n"+
"};\n"+
"\n"+
"struct UnityIndirect\n"+
"{\n"+
"	half3 diffuse;\n"+
"	half3 specular;\n"+
"};\n"+
"\n"+
"struct UnityGI\n"+
"{\n"+
"	UnityLight light;\n"+
"	#ifdef DIRLIGHTMAP_SEPARATE\n"+
"		#ifdef LIGHTMAP_ON\n"+
"			UnityLight light2;\n"+
"		#endif\n"+
"		#ifdef DYNAMICLIGHTMAP_ON\n"+
"			UnityLight light3;\n"+
"		#endif\n"+
"	#endif\n"+
"	UnityIndirect indirect;\n"+
"};\n"+
"\n"+
"struct UnityGIInput \n"+
"{\n"+
"	UnityLight light; // pixel light, sent from the engine\n"+
"\n"+
"	float3 worldPos;\n"+
"	float3 worldViewDir;\n"+
"	half atten;\n"+
"	half3 ambient;\n"+
"	float4 lightmapUV; // .xy = static lightmap UV, .zw = dynamic lightmap UV\n"+
"\n"+
"	float4 boxMax[2];\n"+
"	float4 boxMin[2];\n"+
"	float4 probePosition[2];\n"+
"	float4 probeHDR[2];\n"+
"};\n"+
"\n"+
"#endif\n";
		if (IsPBR){
			shaderCode+="\n"+
"#define SHADER_TARGET (30)\n"+
"#define U4Imposter\n"+
"#ifndef UNITY_PBS_LIGHTING_INCLUDED\n"+
"#define UNITY_PBS_LIGHTING_INCLUDED\n"+

"#include \"UnityShaderVariables.cginc\"\n"+
"#ifndef UNITY_STANDARD_CONFIG_INCLUDED\n"+
"#define UNITY_STANDARD_CONFIG_INCLUDED\n"+

"// Define Specular cubemap constants\n"+
"#define UNITY_SPECCUBE_LOD_EXPONENT (1.5)\n"+
"#define UNITY_SPECCUBE_LOD_STEPS (7) // TODO: proper fix for different cubemap resolution needed. My assumptions were actually wrong!\n"+

"// Energy conservation for Specular workflow is Monochrome. For instance: Red metal will make diffuse Black not Cyan\n"+
"#define UNITY_CONSERVE_ENERGY 1\n"+
"#define UNITY_CONSERVE_ENERGY_MONOCHROME 1\n"+
"\n"+
"// High end platforms support Box Projection and Blending\n"+
"#define UNITY_SPECCUBE_BOX_PROJECTION ( !defined(SHADER_API_MOBILE) && (SHADER_TARGET >= 30) )\n"+
"#define UNITY_SPECCUBE_BLENDING ( !defined(SHADER_API_MOBILE) && (SHADER_TARGET >= 30) )\n"+
"\n"+
"#define UNITY_SAMPLE_FULL_SH_PER_PIXEL 0\n"+
"\n"+
"#define UNITY_GLOSS_MATCHES_MARMOSET_TOOLBAG2 1\n"+
"#define UNITY_BRDF_GGX 0\n"+

@"// Orthnormalize Tangent Space basis per-pixel
// Necessary to support high-quality normal-maps. Compatible with Maya and Marmoset.
// However xNormal expects oldschool non-orthnormalized basis - essentially preventing good looking normal-maps :(
// Due to the fact that xNormal is probably _the most used tool to bake out normal-maps today_ we have to stick to old ways for now.
// 
// Disabled by default, until xNormal has an option to bake proper normal-maps.
"+
"#define UNITY_TANGENT_ORTHONORMALIZE 0\n"+
"\n"+
"#endif // UNITY_STANDARD_CONFIG_INCLUDED\n"+
"#ifndef UNITY_GLOBAL_ILLUMINATION_INCLUDED\n"+
"#define UNITY_GLOBAL_ILLUMINATION_INCLUDED\n"+
"\n"+
"// Functions sampling light environment data (lightmaps, light probes, reflection probes), which is then returned as the UnityGI struct.\n"+
"\n"+
"\n"+
"#ifndef UNITY_STANDARD_BRDF_INCLUDED\n"+
"#define UNITY_STANDARD_BRDF_INCLUDED\n"+
"\n"+
"#include "+"\""+"UnityCG.cginc"+"\""+"\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"half4 unity_LightGammaCorrectionConsts = float4(100,100,100,100);\n"+
"#define unity_LightGammaCorrectionConsts_PIDiv4 (0.7853975)\n"+
"#define unity_LightGammaCorrectionConsts_PI (3.14159)\n"+
"#define unity_LightGammaCorrectionConsts_HalfDivPI (0.008)\n"+
"#define unity_LightGammaCorrectionConsts_8 (64)\n"+
"#define unity_LightGammaCorrectionConsts_SqrtHalfPI (0.04)\n"+
"#define unity_ColorSpaceDielectricSpec float4(0,0,0,0)\n"+
"#define UNITY_PI (3.14159)\n"+
"\n"+
"half4 DecodeHDR (half4 a, half3 b)\n"+
"{\n"+
"	return a;\n"+
"}\n"+
"\n"+
"inline half Pow4 (half x){\n"+
"	return x*x*x*x;\n"+
"}\n"+
"inline half2 Pow4 (half2 x){\n"+
"	return x*x*x*x;\n"+
"}\n"+
"inline half3 Pow4 (half3 x){\n"+
"	return x*x*x*x;\n"+
"}\n"+
"inline half4 Pow4 (half4 x){\n"+
"	return x*x*x*x;\n"+
"}\n"+
"\n"+
"// Pow5 uses the same amount of instructions as generic pow(), but has 2 advantages:\n"+
"// 1) better instruction pipelining\n"+
"// 2) no need to worry about NaNs\n"+
"half Pow5 (half x)\n"+
"{\n"+
"	return x*x * x*x * x;\n"+
"}\n"+
"\n"+
"half2 Pow5 (half2 x)\n"+
"{\n"+
"	return x*x * x*x * x;\n"+
"}\n"+
"\n"+
"half3 Pow5 (half3 x)\n"+
"{\n"+
"	return x*x * x*x * x;\n"+
"}\n"+
"\n"+
"half4 Pow5 (half4 x)\n"+
"{\n"+
"	return x*x * x*x * x;\n"+
"}\n"+
"\n"+
"half BlinnTerm (half3 normal, half3 halfDir)\n"+
"{\n"+
"	return DotClamped (normal, halfDir);\n"+
"}\n"+
"\n"+
"half3 FresnelTerm (half3 F0, half cosA)\n"+
"{\n"+
"	half t = Pow5 (1 - cosA);	// ala Schlick interpoliation\n"+
"	return F0 + (1-F0) * t;\n"+
"}\n"+
"half3 FresnelLerp (half3 F0, half3 F90, half cosA)\n"+
"{\n"+
"	half t = Pow5 (1 - cosA);	// ala Schlick interpoliation\n"+
"	return lerp (F0, F90, t);\n"+
"}\n"+
"// approximage Schlick with ^4 instead of ^5\n"+
"half3 FresnelLerpFast (half3 F0, half3 F90, half cosA)\n"+
"{\n"+
"	half t = Pow4 (1 - cosA);\n"+
"	return lerp (F0, F90, t);\n"+
"}\n"+
"half3 LazarovFresnelTerm (half3 F0, half roughness, half cosA)\n"+
"{\n"+
"	half t = Pow5 (1 - cosA);	// ala Schlick interpoliation\n"+
"	t /= 4 - 3 * roughness;\n"+
"	return F0 + (1-F0) * t;\n"+
"}\n"+
"half3 SebLagardeFresnelTerm (half3 F0, half roughness, half cosA)\n"+
"{\n"+
"	half t = Pow5 (1 - cosA);	// ala Schlick interpoliation\n"+
"	return F0 + (max (F0, roughness) - F0) * t;\n"+
"}\n"+
"\n"+
"// NOTE: Visibility term here is the full form from Torrance-Sparrow model, it includes Geometric term: V = G / (N.L * N.V)\n"+
"// This way it is easier to swap Geometric terms and more room for optimizations (except maybe in case of CookTorrance geom term)\n"+
"\n"+
"// Cook-Torrance visibility term, doesn't take roughness into account\n"+
"half CookTorranceVisibilityTerm (half NdotL, half NdotV,  half NdotH, half VdotH)\n"+
"{\n"+
"	VdotH += 1e-5f;\n"+
"	half G = min (1.0, min (\n"+
"		(2.0 * NdotH * NdotV) / VdotH,\n"+
"		(2.0 * NdotH * NdotL) / VdotH));\n"+
"	return G / (NdotL * NdotV + 1e-4f);\n"+
"}\n"+
"\n"+
"// Kelemen-Szirmay-Kalos is an approximation to Cook-Torrance visibility term\n"+
"// http://sirkan.iit.bme.hu/~szirmay/scook.pdf\n"+
"half KelemenVisibilityTerm (half LdotH)\n"+
"{\n"+
"	return 1.0 / (LdotH * LdotH);\n"+
"}\n"+
"\n"+
"// Modified Kelemen-Szirmay-Kalos which takes roughness into account, based on: http://www.filmicworlds.com/2014/04/21/optimizing-ggx-shaders-with-dotlh/ \n"+
"half ModifiedKelemenVisibilityTerm (half LdotH, half roughness)\n"+
"{\n"+
"	// c = sqrt(2 / Pi)\n"+
"	half c = unity_LightGammaCorrectionConsts_SqrtHalfPI;\n"+
"	half k = roughness * roughness * c;\n"+
"	half gH = LdotH * (1-k) + k;\n"+
"	return 1.0 / (gH * gH);\n"+
"}\n"+
"\n"+
"// Generic Smith-Schlick visibility term\n"+
"half SmithVisibilityTerm (half NdotL, half NdotV, half k)\n"+
"{\n"+
"	half gL = NdotL * (1-k) + k;\n"+
"	half gV = NdotV * (1-k) + k;\n"+
"	return 1.0 / (gL * gV + 1e-4f);\n"+
"}\n"+
"\n"+
"// Smith-Schlick derived for Beckmann\n"+
"half SmithBeckmannVisibilityTerm (half NdotL, half NdotV, half roughness)\n"+
"{\n"+
"	// c = sqrt(2 / Pi)\n"+
"	half c = unity_LightGammaCorrectionConsts_SqrtHalfPI;\n"+
"	half k = roughness * roughness * c;\n"+
"	return SmithVisibilityTerm (NdotL, NdotV, k);\n"+
"}\n"+
"\n"+
"// Smith-Schlick derived for GGX \n"+
"half SmithGGXVisibilityTerm (half NdotL, half NdotV, half roughness)\n"+
"{\n"+
"	half k = (roughness * roughness) / 2; // derived by B. Karis, http://graphicrants.blogspot.se/2013/08/specular-brdf-reference.html\n"+
"	return SmithVisibilityTerm (NdotL, NdotV, k);\n"+
"}\n"+
"\n"+
"half ImplicitVisibilityTerm ()\n"+
"{\n"+
"	return 1;\n"+
"}\n"+
"\n"+
"half RoughnessToSpecPower (half roughness)\n"+
"{\n"+
"roughness+=0.017;\n"+
"#if UNITY_GLOSS_MATCHES_MARMOSET_TOOLBAG2\n"+
"	// from https://s3.amazonaws.com/docs.knaldtech.com/knald/1.0.0/lys_power_drops.html\n"+
"	half n = 10.0 / log2((1-roughness)*0.968 + 0.03);\n"+
"#if defined(SHADER_API_PS3)\n"+
"	n = max(n,-255.9370);  //i.e. less than sqrt(65504)\n"+
"#endif\n"+
"	return n * n;\n"+
"\n"+
"	// NOTE: another approximate approach to match Marmoset gloss curve is to\n"+
"	// multiply roughness by 0.7599 in the code below (makes SpecPower range 4..N instead of 1..N)\n"+
"#else\n"+
"	half m = roughness * roughness * roughness + 1e-4f;	// follow the same curve as unity_SpecCube\n"+
"	half n = (2.0 / m) - 2.0;							// http://jbit.net/%7Esparky/academic/mm_brdf.pdf\n"+
"	n = max(n, 1e-4f);									// prevent possible cases of pow(0,0), which could happen when roughness is 1.0 and NdotH is zero\n"+
"	return n;\n"+
"#endif\n"+
"}\n"+
"\n"+
"// BlinnPhong normalized as normal distribution function (NDF)\n"+
"// for use in micro-facet model: spec=D*G*F\n"+
"// http://www.thetenthplanet.de/archives/255\n"+
"half NDFBlinnPhongNormalizedTerm (half NdotH, half n)\n"+
"{\n"+
"	// norm = (n+1)/(2*pi)\n"+
"	half normTerm = (n + 1.0) * unity_LightGammaCorrectionConsts_HalfDivPI;\n"+
"\n"+
"	half specTerm = pow (NdotH, n);\n"+
"	return specTerm * normTerm;\n"+
"}\n"+
"\n"+
"// BlinnPhong normalized as reflecδion denγity funcδion (RDF)\n"+
"// ready for use directly as specular: spec=D\n"+
"// http://www.thetenthplanet.de/archives/255\n"+
"half RDFBlinnPhongNormalizedTerm (half NdotH, half n)\n"+
"{\n"+
"	half normTerm = (n + 2.0) / (8.0 * UNITY_PI);\n"+
"	half specTerm = pow (NdotH, n);\n"+
"	return specTerm * normTerm;\n"+
"}\n"+
"\n"+
"half GGXTerm (half NdotH, half roughness)\n"+
"{\n"+
"	half a = roughness * roughness;\n"+
"	half a2 = a * a;\n"+
"	half d = NdotH * NdotH * (a2 - 1.f) + 1.f;\n"+
"	return a2 / (UNITY_PI * d * d);\n"+
"}\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"/*\n"+
"// https://s3.amazonaws.com/docs.knaldtech.com/knald/1.0.0/lys_power_drops.html\n"+
"\n"+
"const float k0 = 0.00098, k1 = 0.9921;\n"+
"// pass this as a constant for optimization\n"+
"const float fUserMaxSPow = 100000; // sqrt(12M)\n"+
"const float g_fMaxT = ( exp2(-10.0/fUserMaxSPow) - k0)/k1;\n"+
"float GetSpecPowToMip(float fSpecPow, int nMips)\n"+
"{\n"+
"   // Default curve - Inverse of TB2 curve with adjusted constants\n"+
"   float fSmulMaxT = ( exp2(-10.0/sqrt( fSpecPow )) - k0)/k1;\n"+
"   return float(nMips-1)*(1.0 - clamp( fSmulMaxT/g_fMaxT, 0.0, 1.0 ));\n"+
"}\n"+
"\n"+
"	//float specPower = RoughnessToSpecPower (roughness);\n"+
"	//float mip = GetSpecPowToMip (specPower, 7);\n"+
"*/\n"+
"\n"+
"// Decodes HDR textures\n"+
"// handles dLDR, RGBM formats\n"+
"// Modified version of DecodeHDR from UnityCG.cginc\n"+
"/*half3 DecodeHDR_NoLinearSupportInSM2 (half4 data, half4 decodeInstructions)\n"+
"{\n"+
"	// If Linear mode is not supported we can skip exponent part\n"+
"\n"+
"	// In Standard shader SM2.0 and SM3.0 paths are always using different shader variations\n"+
"	// SM2.0: hardware does not support Linear, we can skip exponent part\n"+
"	#if defined(UNITY_NO_LINEAR_COLORSPACE) && (SHADER_TARGET < 30)\n"+
"		return (data.a * decodeInstructions.x) * data.rgb;\n"+
"	#else\n"+
"		return DecodeHDR(data, decodeInstructions);\n"+
"	#endif\n"+
"}*/\n"+
"\n"+
"half3 Unity_GlossyEnvironment (samplerCUBE tex, half3 worldNormal, half roughness){\n"+
"#if !UNITY_GLOSS_MATCHES_MARMOSET_TOOLBAG2 || (SHADER_TARGET < 30)\n"+
"	float mip = roughness * UNITY_SPECCUBE_LOD_STEPS;\n"+
"#else\n"+
"	// TODO: remove pow, store cubemap mips differently\n"+
"	float mip = pow(roughness,3.0/4.0) * UNITY_SPECCUBE_LOD_STEPS;\n"+
"#endif\n"+
"\n"+
"	//half4 rgbm = SampleCubeReflection(tex, worldNormal.xyz, mip);\n"+
"	half4 rgbm = texCUBElod(tex, float4(worldNormal.xyz, mip));\n"+
"	return rgbm.rgb;//DecodeHDR_NoLinearSupportInSM2 (rgbm, hdr);\n"+
"}\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"\n"+
"// Note: BRDF entry points use oneMinusRoughness (aka "+"\""+"smoothness"+"\""+") and oneMinusReflectivity for optimization\n"+
"// purposes, mostly for DX9 SM2.0 level. Most of the math is being done on these (1-x) values, and that saves\n"+
"// a few precious ALU slots.\n"+
"\n"+
"\n"+
"// Main Physically Based BRDF\n"+
"// Derived from Disney work and based on Torrance-Sparrow micro-facet model\n"+
"//\n"+
"//   BRDF = kD / pi + kS * (D * V * F) / 4\n"+
"//   I = BRDF * NdotL\n"+
"//\n"+
"// * NDF (depending on UNITY_BRDF_GGX):\n"+
"//  a) Normalized BlinnPhong\n"+
"//  b) GGX\n"+
"// * Smith for Visiblity term\n"+
"// * Schlick approximation for Fresnel\n"+
"half4 BRDF1_Unity_PBS (half3 diffColor, half3 specColor, half oneMinusReflectivity, half oneMinusRoughness,\n"+
"	half3 normal, half3 viewDir,\n"+
"	UnityLight light, UnityIndirect gi)\n"+
"{\n"+
"	half roughness = 1-oneMinusRoughness;\n"+
"	half3 halfDir = normalize (light.dir + viewDir);\n"+
"\n"+
"	half nl = light.ndotl;\n"+
"	half nh = BlinnTerm (normal, halfDir);\n"+
"	half nv = DotClamped (normal, viewDir);\n"+
"	half lv = DotClamped (light.dir, viewDir);\n"+
"	half lh = DotClamped (light.dir, halfDir);\n"+
"\n"+
"#if UNITY_BRDF_GGX\n"+
"	half V = SmithGGXVisibilityTerm (nl, nv, roughness);\n"+
"	half D = GGXTerm (nh, roughness);\n"+
"#else\n"+
"	half V = SmithBeckmannVisibilityTerm (nl, nv, roughness);\n"+
"	half D = NDFBlinnPhongNormalizedTerm (nh, RoughnessToSpecPower (roughness));\n"+
"#endif\n"+
"\n"+
"	half nlPow5 = Pow5 (1-nl);\n"+
"	half nvPow5 = Pow5 (1-nv);\n"+
"	half Fd90 = 0.5 + 2 * lh * lh * roughness;\n"+
"	half disneyDiffuse = (1 + (Fd90-1) * nlPow5) * (1 + (Fd90-1) * nvPow5);\n"+
"	\n"+
"	// HACK: theoretically we should divide by Pi diffuseTerm and not multiply specularTerm!\n"+
"	// BUT 1) that will make shader look significantly darker than Legacy ones\n"+
"	// and 2) on engine side "+"\""+"Non-important"+"\""+" lights have to be divided by Pi to in cases when they are injected into ambient SH\n"+
"	// NOTE: multiplication by Pi is part of single constant together with 1/4 now\n"+
"\n"+
"	half specularTerm = max(0, (V * D * nl) * unity_LightGammaCorrectionConsts_PIDiv4);// Torrance-Sparrow model, Fresnel is applied later (for optimization reasons)\n"+
"	half diffuseTerm = disneyDiffuse * nl;\n"+
"	\n"+
"	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));\n"+
"    half3 color =	diffColor * (gi.diffuse + light.color * diffuseTerm)\n"+
"                    + specularTerm * light.color * FresnelTerm (specColor, lh)\n"+
"					+ gi.specular * FresnelLerp (specColor, grazingTerm, nv);\n"+
"\n"+
"	return half4(color, 1);\n"+
"}\n"+
"\n"+
"// Based on Minimalist CookTorrance BRDF\n"+
"// Implementation is slightly different from original derivation: http://www.thetenthplanet.de/archives/255\n"+
"//\n"+
"// * BlinnPhong as NDF\n"+
"// * Modified Kelemen and Szirmay-?Kalos for Visibility term\n"+
"// * Fresnel approximated with 1/LdotH\n"+
"half4 BRDF2_Unity_PBS (half3 diffColor, half3 specColor, half oneMinusReflectivity, half oneMinusRoughness,\n"+
"	half3 normal, half3 viewDir,\n"+
"	UnityLight light, UnityIndirect gi)\n"+
"{\n"+
"	half3 halfDir = normalize (light.dir + viewDir);\n"+
"\n"+
"	half nl = light.ndotl;\n"+
"	half nh = BlinnTerm (normal, halfDir);\n"+
"	half nv = DotClamped (normal, viewDir);\n"+
"	half lh = DotClamped (light.dir, halfDir);\n"+
"\n"+
"	half roughness = 1-oneMinusRoughness;\n"+
"	half specularPower = RoughnessToSpecPower (roughness);\n"+
"	// Modified with approximate Visibility function that takes roughness into account\n"+
"	// Original ((n+1)*N.H^n) / (8*Pi * L.H^3) didn't take into account roughness \n"+
"	// and produced extremely bright specular at grazing angles\n"+
"\n"+
"	// HACK: theoretically we should divide by Pi diffuseTerm and not multiply specularTerm!\n"+
"	// BUT 1) that will make shader look significantly darker than Legacy ones\n"+
"	// and 2) on engine side "+"\""+"Non-important"+"\""+" lights have to be divided by Pi to in cases when they are injected into ambient SH\n"+
"	// NOTE: multiplication by Pi is cancelled with Pi in denominator\n"+
"\n"+
"	half invV = lh * lh * oneMinusRoughness + roughness * roughness; // approx ModifiedKelemenVisibilityTerm(lh, 1-oneMinusRoughness);\n"+
"	half invF = lh;\n"+
"	half specular = ((specularPower + 1) * pow (nh, specularPower)) / (unity_LightGammaCorrectionConsts_8 * invV * invF + 1e-4f); // @TODO: might still need saturate(nl*specular) on Adreno/Mali\n"+
"\n"+
"	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));\n"+
"    half3 color =	(diffColor + specular * specColor) * light.color * nl\n"+
"    				+ gi.diffuse * diffColor\n"+
"					+ gi.specular * FresnelLerpFast (specColor, grazingTerm, nv);\n"+
"\n"+
"	return half4(color, 1);\n"+
"}\n"+
"\n"+
"// Old school, not microfacet based Modified Normalized Blinn-Phong BRDF\n"+
"// Implementation uses Lookup texture for performance\n"+
"//\n"+
"// * Normalized BlinnPhong in RDF form\n"+
"// * Implicit Visibility term\n"+
"// * No Fresnel term\n"+
"//\n"+
"// TODO: specular is too weak in Linear rendering mode\n"+
"sampler2D unity_NHxRoughness;\n"+
"half4 BRDF3_Unity_PBS (half3 diffColor, half3 specColor, half oneMinusReflectivity, half oneMinusRoughness,\n"+
"	half3 normal, half3 viewDir,\n"+
"	UnityLight light, UnityIndirect gi)\n"+
"{\n"+
"	half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp\n"+
"\n"+
"	half3 reflDir = reflect (viewDir, normal);\n"+
"	half3 halfDir = normalize (light.dir + viewDir);\n"+
"\n"+
"	half nl = light.ndotl;\n"+
"	half nh = BlinnTerm (normal, halfDir);\n"+
"	half nv = DotClamped (normal, viewDir);\n"+
"\n"+
"	// Vectorize Pow4 to save instructions\n"+
"	half2 rlPow4AndFresnelTerm = Pow4 (half2(dot(reflDir, light.dir), 1-nv));  // use R.L instead of N.H to save couple of instructions\n"+
"	half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp\n"+
"	half fresnelTerm = rlPow4AndFresnelTerm.y;\n"+
"\n"+
"#if 1 // Lookup texture to save instructions\n"+
"	half specular = tex2D(unity_NHxRoughness, half2(rlPow4, 1-oneMinusRoughness)).UNITY_ATTEN_CHANNEL * LUT_RANGE;\n"+
"#else\n"+
"	half roughness = 1-oneMinusRoughness;\n"+
"	half n = RoughnessToSpecPower (roughness) * .25;\n"+
"	half specular = (n + 2.0) / (2.0 * UNITY_PI * UNITY_PI) * pow(dot(reflDir, light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;\n"+
"	//half specular = (1.0/(UNITY_PI*roughness*roughness)) * pow(dot(reflDir, light.dir), n) * nl;// / unity_LightGammaCorrectionConsts_PI;\n"+
"#endif\n"+
"	half grazingTerm = saturate(oneMinusRoughness + (1-oneMinusReflectivity));\n"+
"\n"+
"    half3 color =	(diffColor + specular * specColor) * light.color * nl\n"+
"    				+ gi.diffuse * diffColor\n"+
"					+ gi.specular * lerp (specColor, grazingTerm, fresnelTerm);\n"+
"\n"+
"	return half4(color, 1);\n"+
"}\n"+
"\n"+
"\n"+
"#endif // UNITY_STANDARD_BRDF_INCLUDED\n"+
"\n"+
"#ifndef UNITY_STANDARD_UTILS_INCLUDED\n"+
"#define UNITY_STANDARD_UTILS_INCLUDED\n"+
"\n"+
"#include "+"\""+"UnityCG.cginc"+"\""+"\n"+
"\n"+
"// Helper functions, maybe move into UnityCG.cginc\n"+
"\n"+
"half SpecularStrength(half3 specular)\n"+
"{\n"+
"	#if (SHADER_TARGET < 30)\n"+
"		// SM2.0: instruction count limitation\n"+
"		// SM2.0: simplified SpecularStrength\n"+
"		return specular.r; // Red channel - because most metals are either monocrhome or with redish/yellowish tint\n"+
"	#else\n"+
"		return max (max (specular.r, specular.g), specular.b);\n"+
"	#endif\n"+
"}\n"+
"\n"+
"// Diffuse/Spec Energy conservation\n"+
"half3 EnergyConservationBetweenDiffuseAndSpecular (half3 albedo, half3 specColor, out half oneMinusReflectivity)\n"+
"{\n"+
"	oneMinusReflectivity = 1 - SpecularStrength(specColor);\n"+
"	#if !UNITY_CONSERVE_ENERGY\n"+
"		return albedo;\n"+
"	#elif UNITY_CONSERVE_ENERGY_MONOCHROME\n"+
"		return albedo * oneMinusReflectivity;\n"+
"	#else\n"+
"		return albedo * (half3(1,1,1) - specColor);\n"+
"	#endif\n"+
"}\n"+
"\n"+
"half3 DiffuseAndSpecularFromMetallic (half3 albedo, half metallic, out half3 specColor, out half oneMinusReflectivity)\n"+
"{\n"+
"	specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic);\n"+
"	// We'll need oneMinusReflectivity, so\n"+
"	//   1-reflectivity = 1-lerp(dielectricSpec, 1, metallic) = lerp(1-dielectricSpec, 0, metallic)\n"+
"	// store (1-dielectricSpec) in unity_ColorSpaceDielectricSpec.a, then\n"+
"	//	 1-reflectivity = lerp(alpha, 0, metallic) = alpha + metallic*(0 - alpha) = \n"+
"	//                  = alpha - metallic * alpha\n"+
"	half oneMinusDielectricSpec = unity_ColorSpaceDielectricSpec.a;\n"+
"	oneMinusReflectivity = oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;\n"+
"	return albedo * oneMinusReflectivity;\n"+
"}\n"+
"\n"+
"half3 PreMultiplyAlpha (half3 diffColor, half alpha, half oneMinusReflectivity, out half outModifiedAlpha)\n"+
"{\n"+
"	#if defined(_ALPHAPREMULTIPLY_ON)\n"+
"		// NOTE: shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)\n"+
"\n"+
"		// Transparency 'removes' from Diffuse component\n"+
" 		diffColor *= alpha;\n"+
" 		\n"+
" 		#if (SHADER_TARGET < 30)\n"+
" 			// SM2.0: instruction count limitation\n"+
" 			// Instead will sacrifice part of physically based transparency where amount Reflectivity is affecting Transparency\n"+
" 			// SM2.0: uses unmodified alpha\n"+
" 			outModifiedAlpha = alpha;\n"+
" 		#else\n"+
"	 		// Reflectivity 'removes' from the rest of components, including Transparency\n"+
"	 		// outAlpha = 1-(1-alpha)*(1-reflectivity) = 1-(oneMinusReflectivity - alpha*oneMinusReflectivity) =\n"+
"	 		//          = 1-oneMinusReflectivity + alpha*oneMinusReflectivity\n"+
"	 		outModifiedAlpha = 1-oneMinusReflectivity + alpha*oneMinusReflectivity;\n"+
" 		#endif\n"+
" 	#else\n"+
" 		outModifiedAlpha = alpha;\n"+
" 	#endif\n"+
" 	return diffColor;\n"+
"}\n"+
"\n"+
"// Same as ParallaxOffset in Unity CG, except:\n"+
"//  *) precision - half instead of float\n"+
"half2 ParallaxOffset1Step (half h, half height, half3 viewDir)\n"+
"{\n"+
"	h = h * height - height/2.0;\n"+
"	half3 v = normalize(viewDir);\n"+
"	v.z += 0.42;\n"+
"	return h * (v.xy / v.z);\n"+
"}\n"+
"\n"+
"half LerpOneTo(half b, half t)\n"+
"{\n"+
"	half oneMinusT = 1 - t;\n"+
"	return oneMinusT + b * t;\n"+
"}\n"+
"\n"+
"half3 LerpWhiteTo(half3 b, half t)\n"+
"{\n"+
"	half oneMinusT = 1 - t;\n"+
"	return half3(oneMinusT, oneMinusT, oneMinusT) + b * t;\n"+
"}\n"+
"\n"+
"half3 UnpackScaleNormal(half4 packednormal, half bumpScale)\n"+
"{\n"+
"	#if defined(UNITY_NO_DXT5nm)\n"+
"		return packednormal.xyz * 2 - 1;\n"+
"	#else\n"+
"		half3 normal;\n"+
"		normal.xy = (packednormal.wy * 2 - 1);\n"+
"		#if (SHADER_TARGET >= 30)\n"+
"			// SM2.0: instruction count limitation\n"+
"			// SM2.0: normal scaler is not supported\n"+
"			normal.xy *= bumpScale;\n"+
"		#endif\n"+
"		normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));\n"+
"		return normal;\n"+
"	#endif\n"+
"}		\n"+
"\n"+
"half3 BlendNormals(half3 n1, half3 n2)\n"+
"{\n"+
"	return normalize(half3(n1.xy + n2.xy, n1.z*n2.z));\n"+
"}\n"+
"\n"+
"half3x3 CreateTangentToWorldPerVertex(half3 normal, half3 tangent, half3 flip)\n"+
"{\n"+
"	half3 binormal = cross(normal, tangent) * flip;\n"+
"	return half3x3(tangent, binormal, normal);\n"+
"}\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"half3 BoxProjectedCubemapDirection (half3 worldNormal, float3 worldPos, float4 cubemapCenter, float4 boxMin, float4 boxMax)\n"+
"{\n"+
"	// Do we have a valid reflection probe?\n"+
"	\n"+
"	if (cubemapCenter.w > 0.0)\n"+
"	{\n"+
"		half3 nrdir = normalize(worldNormal);\n"+
"\n"+
"		#if 1				\n"+
"			half3 rbmax = (boxMax.xyz - worldPos) / nrdir;\n"+
"			half3 rbmin = (boxMin.xyz - worldPos) / nrdir;\n"+
"\n"+
"			half3 rbminmax = (nrdir > 0.0f) ? rbmax : rbmin;\n"+
"\n"+
"		#else // Optimized version\n"+
"			half3 rbmax = (boxMax.xyz - worldPos);\n"+
"			half3 rbmin = (boxMin.xyz - worldPos);\n"+
"\n"+
"			half3 select = step (half3(0,0,0), nrdir);\n"+
"			half3 rbminmax = lerp (rbmax, rbmin, select);\n"+
"			rbminmax /= nrdir;\n"+
"		#endif\n"+
"\n"+
"		half fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);\n"+
"\n"+
"		float3 aabbCenter = (boxMax.xyz + boxMin.xyz) * 0.5;\n"+
"		float3 offset = aabbCenter - cubemapCenter.xyz;\n"+
"		float3 posonbox = offset + worldPos + nrdir * fa;\n"+
"\n"+
"		worldNormal = posonbox - aabbCenter;\n"+
"	}\n"+
"	return worldNormal;\n"+
"}\n"+
"\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"// Derivative maps\n"+
"// http://www.rorydriscoll.com/2012/01/11/derivative-maps/\n"+
"// For future use.\n"+
"\n"+
"// Project the surface gradient (dhdx, dhdy) onto the surface (n, dpdx, dpdy)\n"+
"half3 CalculateSurfaceGradient(half3 n, half3 dpdx, half3 dpdy, half dhdx, half dhdy)\n"+
"{\n"+
"	half3 r1 = cross(dpdy, n);\n"+
"	half3 r2 = cross(n, dpdx);\n"+
"	return (r1 * dhdx + r2 * dhdy) / dot(dpdx, r1);\n"+
"}\n"+
"\n"+
"// Move the normal away from the surface normal in the opposite surface gradient direction\n"+
"half3 PerturbNormal(half3 n, half3 dpdx, half3 dpdy, half dhdx, half dhdy)\n"+
"{\n"+
"	//TODO: normalize seems to be necessary when scales do go beyond the 2...-2 range, should we limit that?\n"+
"	//how expensive is a normalize? Anything cheaper for this case?\n"+
"	return normalize(n - CalculateSurfaceGradient(n, dpdx, dpdy, dhdx, dhdy));\n"+
"}\n"+
"\n"+
"// Calculate the surface normal using the uv-space gradient (dhdu, dhdv)\n"+
"half3 CalculateSurfaceNormal(half3 position, half3 normal, half2 gradient, half2 uv)\n"+
"{\n"+
"	half3 dpdx = ddx(position);\n"+
"	half3 dpdy = ddy(position);\n"+
"\n"+
"	half dhdx = dot(gradient, ddx(uv));\n"+
"	half dhdy = dot(gradient, ddy(uv));\n"+
"\n"+
"	return PerturbNormal(normal, dpdx, dpdy, dhdx, dhdy);\n"+
"}\n"+
"\n"+
"\n"+
"#endif // UNITY_STANDARD_UTILS_INCLUDED\n"+
"\n"+
"\n"+
"half3 DecodeDirectionalSpecularLightmap (half3 color, fixed4 dirTex, half3 normalWorld, bool isRealtimeLightmap, fixed4 realtimeNormalTex, out UnityLight o_light)\n"+
"{\n"+
"	o_light.color = color;\n"+
"	o_light.dir = dirTex.xyz * 2 - 1;\n"+
"\n"+
"	// The length of the direction vector is the light's "+"\""+"directionality"+"\""+", i.e. 1 for all light coming from this direction,\n"+
"	// lower values for more spread out, ambient light.\n"+
"	half directionality = length(o_light.dir);\n"+
"	o_light.dir /= directionality;\n"+
"\n"+
"	#ifdef DYNAMICLIGHTMAP_ON\n"+
"	if (isRealtimeLightmap)\n"+
"	{\n"+
"		// Realtime directional lightmaps' intensity needs to be divided by N.L\n"+
"		// to get the incoming light intensity. Baked directional lightmaps are already\n"+
"		// output like that (including the max() to prevent div by zero).\n"+
"		half3 realtimeNormal = realtimeNormalTex.zyx * 2 - 1;\n"+
"		o_light.color /= max(0.125, dot(realtimeNormal, o_light.dir));\n"+
"	}\n"+
"	#endif\n"+
"\n"+
"	o_light.ndotl = LambertTerm(normalWorld, o_light.dir);\n"+
"\n"+
"	// Split light into the directional and ambient parts, according to the directionality factor.\n"+
"	half3 ambient = o_light.color * (1 - directionality);\n"+
"	o_light.color = o_light.color * directionality;\n"+
"\n"+
"	// Technically this is incorrect, but helps hide jagged light edge at the object silhouettes and\n"+
"	// makes normalmaps show up.\n"+
"	ambient *= o_light.ndotl;\n"+
"	return ambient;\n"+
"}\n"+
"\n"+
"half3 MixLightmapWithRealtimeAttenuation (half3 lightmapContribution, half attenuation, fixed4 bakedColorTex)\n"+
"{\n"+
"	// Let's try to make realtime shadows work on a surface, which already contains\n"+
"	// baked lighting and shadowing from the current light.\n"+
"	// Generally do min(lightmap,shadow), with "+"\""+"shadow"+"\""+" taking overall lightmap tint into account.\n"+
"	half3 shadowLightmapColor = bakedColorTex.rgb * attenuation;\n"+
"	half3 darkerColor = min(lightmapContribution, shadowLightmapColor);\n"+
"\n"+
"	// However this can darken overbright lightmaps, since "+"\""+"shadow color"+"\""+" will\n"+
"	// never be overbright. So take a max of that color with attenuated lightmap color.\n"+
"	return max(darkerColor, lightmapContribution * attenuation);\n"+
"}\n"+
"\n"+
"void ResetUnityLight(out UnityLight outLight)\n"+
"{\n"+
"	outLight.color = 0;\n"+
"	outLight.dir = 0;\n"+
"	outLight.ndotl = 0;\n"+
"}\n"+
"\n"+
"void ResetUnityGI(out UnityGI outGI)\n"+
"{\n"+
"	ResetUnityLight(outGI.light);\n"+
"	#ifdef DIRLIGHTMAP_SEPARATE\n"+
"		#ifdef LIGHTMAP_ON\n"+
"			ResetUnityLight(outGI.light2);\n"+
"		#endif\n"+
"		#ifdef DYNAMICLIGHTMAP_ON\n"+
"			ResetUnityLight(outGI.light3);\n"+
"		#endif\n"+
"	#endif\n"+
"	outGI.indirect.diffuse = 0;\n"+
"	outGI.indirect.specular = 0;\n"+
"}\n"+
"\n"+
"/*UnityGI UnityGlobalIllumination (UnityGIInput data, half occlusion, half oneMinusRoughness, half3 normalWorld, bool reflections)\n"+
"{\n"+
"	UnityGI o_gi;\n"+
"	UNITY_INITIALIZE_OUTPUT(UnityGI, o_gi);\n"+
"\n"+
"	// Explicitly reset all members of UnityGI\n"+
"	ResetUnityGI(o_gi);\n"+
"\n"+
"	#if UNITY_SHOULD_SAMPLE_SH\n"+
"		#if UNITY_SAMPLE_FULL_SH_PER_PIXEL\n"+
"			half3 sh = ShadeSH9(half4(normalWorld, 1.0));\n"+
"		#elif (SHADER_TARGET >= 30)\n"+
"			half3 sh = data.ambient + ShadeSH12Order(half4(normalWorld, 1.0));\n"+
"		#else\n"+
"			half3 sh = data.ambient;\n"+
"		#endif\n"+
"	\n"+
"		o_gi.indirect.diffuse += sh;\n"+
"	#endif\n"+
"\n"+
"	#if !defined(LIGHTMAP_ON)\n"+
"		o_gi.light = data.light;\n"+
"		o_gi.light.color *= data.atten;\n"+
"\n"+
"	#else\n"+
"		// Baked lightmaps\n"+
"		fixed4 bakedColorTex = UNITY_SAMPLE_TEX2D(unity_Lightmap, data.lightmapUV.xy); \n"+
"		half3 bakedColor = DecodeLightmap(bakedColorTex);\n"+
"		\n"+
"		#ifdef DIRLIGHTMAP_OFF\n"+
"			o_gi.indirect.diffuse = bakedColor;\n"+
"\n"+
"			#ifdef SHADOWS_SCREEN\n"+
"				o_gi.indirect.diffuse = MixLightmapWithRealtimeAttenuation (o_gi.indirect.diffuse, data.atten, bakedColorTex);\n"+
"			#endif // SHADOWS_SCREEN\n"+
"\n"+
"		#elif DIRLIGHTMAP_COMBINED\n"+
"			fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER (unity_LightmapInd, unity_Lightmap, data.lightmapUV.xy);\n"+
"			o_gi.indirect.diffuse = DecodeDirectionalLightmap (bakedColor, bakedDirTex, normalWorld);\n"+
"\n"+
"			#ifdef SHADOWS_SCREEN\n"+
"				o_gi.indirect.diffuse = MixLightmapWithRealtimeAttenuation (o_gi.indirect.diffuse, data.atten, bakedColorTex);\n"+
"			#endif // SHADOWS_SCREEN\n"+
"\n"+
"		#elif DIRLIGHTMAP_SEPARATE\n"+
"			// Left halves of both intensity and direction lightmaps store direct light; right halves - indirect.\n"+
"\n"+
"			// Direct\n"+
"			fixed4 bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, data.lightmapUV.xy);\n"+
"			o_gi.indirect.diffuse += DecodeDirectionalSpecularLightmap (bakedColor, bakedDirTex, normalWorld, false, 0, o_gi.light);\n"+
"\n"+
"			// Indirect\n"+
"			half2 uvIndirect = data.lightmapUV.xy + half2(0.5, 0);\n"+
"			bakedColor = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, uvIndirect));\n"+
"			bakedDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, uvIndirect);\n"+
"			o_gi.indirect.diffuse += DecodeDirectionalSpecularLightmap (bakedColor, bakedDirTex, normalWorld, false, 0, o_gi.light2);\n"+
"		#endif\n"+
"	#endif\n"+
"	\n"+
"	#ifdef DYNAMICLIGHTMAP_ON\n"+
"		// Dynamic lightmaps\n"+
"		fixed4 realtimeColorTex = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, data.lightmapUV.zw);\n"+
"		half3 realtimeColor = DecodeRealtimeLightmap (realtimeColorTex);\n"+
"\n"+
"		#ifdef DIRLIGHTMAP_OFF\n"+
"			o_gi.indirect.diffuse += realtimeColor;\n"+
"\n"+
"		#elif DIRLIGHTMAP_COMBINED\n"+
"			half4 realtimeDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, data.lightmapUV.zw);\n"+
"			o_gi.indirect.diffuse += DecodeDirectionalLightmap (realtimeColor, realtimeDirTex, normalWorld);\n"+
"\n"+
"		#elif DIRLIGHTMAP_SEPARATE\n"+
"			half4 realtimeDirTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, data.lightmapUV.zw);\n"+
"			half4 realtimeNormalTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicNormal, unity_DynamicLightmap, data.lightmapUV.zw);\n"+
"			o_gi.indirect.diffuse += DecodeDirectionalSpecularLightmap (realtimeColor, realtimeDirTex, normalWorld, true, realtimeNormalTex, o_gi.light3);\n"+
"		#endif\n"+
"	#endif\n"+
"	o_gi.indirect.diffuse *= occlusion;\n"+
"\n"+
"	if (reflections)\n"+
"	{\n"+
"		half3 worldNormal = reflect(-data.worldViewDir, normalWorld);\n"+
"\n"+
"		#if UNITY_SPECCUBE_BOX_PROJECTION		\n"+
"			half3 worldNormal0 = BoxProjectedCubemapDirection (worldNormal, data.worldPos, data.probePosition[0], data.boxMin[0], data.boxMax[0]);\n"+
"		#else\n"+
"			half3 worldNormal0 = worldNormal;\n"+
"		#endif\n"+
"\n"+
"		half3 env0 = Unity_GlossyEnvironment (UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], worldNormal0, 1-oneMinusRoughness);\n"+
"		#if UNITY_SPECCUBE_BLENDING\n"+
"			const float kBlendFactor = 0.99999;\n"+
"			float blendLerp = data.boxMin[0].w;\n"+
"			UNITY_BRANCH\n"+
"			if (blendLerp < kBlendFactor)\n"+
"			{\n"+
"				#if UNITY_SPECCUBE_BOX_PROJECTION\n"+
"					half3 worldNormal1 = BoxProjectedCubemapDirection (worldNormal, data.worldPos, data.probePosition[1], data.boxMin[1], data.boxMax[1]);\n"+
"				#else\n"+
"					half3 worldNormal1 = worldNormal;\n"+
"				#endif\n"+
"\n"+
"				half3 env1 = Unity_GlossyEnvironment (UNITY_PASS_TEXCUBE(unity_SpecCube1), data.probeHDR[1], worldNormal1, 1-oneMinusRoughness);\n"+
"				o_gi.indirect.specular = lerp(env1, env0, blendLerp);\n"+
"			}\n"+
"			else\n"+
"			{\n"+
"				o_gi.indirect.specular = env0;\n"+
"			}\n"+
"		#else\n"+
"			o_gi.indirect.specular = env0;\n"+
"		#endif\n"+
"	}\n"+
"	o_gi.indirect.specular *= occlusion;\n"+
"\n"+
"	return o_gi;\n"+
"}*/\n"+
"\n"+
"/*UnityGI UnityGlobalIllumination (UnityGIInput data, half occlusion, half oneMinusRoughness, half3 normalWorld)\n"+
"{\n"+
"	return UnityGlobalIllumination (data, occlusion, oneMinusRoughness, normalWorld, true);	\n"+
"}*/\n"+
"\n"+
"#endif\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"// Default BRDF to use:\n"+
"#if !defined (UNITY_BRDF_PBS) // allow to explicitly override BRDF in custom shader\n"+
"	#if (SHADER_TARGET < 30) || defined(SHADER_API_PSP2)\n"+
"		// Fallback to low fidelity one for pre-SM3.0\n"+
"		#define UNITY_BRDF_PBS BRDF3_Unity_PBS\n"+
"	#elif defined(SHADER_API_MOBILE)\n"+
"		// Somewhat simplified for mobile\n"+
"		#define UNITY_BRDF_PBS BRDF2_Unity_PBS\n"+
"	#else\n"+
"		// Full quality for SM3+ PC / consoles\n"+
"		#define UNITY_BRDF_PBS BRDF1_Unity_PBS\n"+
"	#endif\n"+
"#endif\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"// BRDF for lights extracted from *indirect* directional lightmaps (baked and realtime).\n"+
"// Baked directional lightmap with *direct* light uses UNITY_BRDF_PBS.\n"+
"// For better quality change to BRDF1_Unity_PBS.\n"+
"// No directional lightmaps in SM2.0.\n"+
"\n"+
"#if !defined(UNITY_BRDF_PBS_LIGHTMAP_INDIRECT)\n"+
"	#define UNITY_BRDF_PBS_LIGHTMAP_INDIRECT BRDF2_Unity_PBS\n"+
"#endif\n"+
"#if !defined (UNITY_BRDF_GI)\n"+
"	#define UNITY_BRDF_GI BRDF_Unity_Indirect\n"+
"#endif\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"\n"+
"\n"+
"half3 BRDF_Unity_Indirect (half3 baseColor, half3 specColor, half oneMinusReflectivity, half oneMinusRoughness, half3 normal, half3 viewDir, half occlusion, UnityGI gi)\n"+
"{\n"+
"	half3 c = 0;\n"+
"	#if defined(DIRLIGHTMAP_SEPARATE)\n"+
"		gi.indirect.diffuse = 0;\n"+
"		gi.indirect.specular = 0;\n"+
"\n"+
"		#ifdef LIGHTMAP_ON\n"+
"			c += UNITY_BRDF_PBS_LIGHTMAP_INDIRECT (baseColor, specColor, oneMinusReflectivity, oneMinusRoughness, normal, viewDir, gi.light2, gi.indirect).rgb * occlusion;\n"+
"		#endif\n"+
"		#ifdef DYNAMICLIGHTMAP_ON\n"+
"			c += UNITY_BRDF_PBS_LIGHTMAP_INDIRECT (baseColor, specColor, oneMinusReflectivity, oneMinusRoughness, normal, viewDir, gi.light3, gi.indirect).rgb * occlusion;\n"+
"		#endif\n"+
"	#endif\n"+
"	return c;\n"+
"}\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"\n"+
"\n"+
"\n"+
"// Surface shader output structure to be used with physically\n"+
"// based shading model.\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"// Metallic workflow\n"+
"\n"+
"struct SurfaceOutputStandard\n"+
"{\n"+
"	fixed3 Albedo;		// base (diffuse or specular) color\n"+
"	fixed3 Normal;		// tangent space normal, if written\n"+
"	half3 Emission;\n"+
"	half Metallic;		// 0=non-metal, 1=metal\n"+
"	half Smoothness;	// 0=rough, 1=smooth\n"+
"	half Occlusion;		// occlusion (default 1)\n"+
"	fixed Alpha;		// alpha for transparencies\n"+
"};\n"+
"\n"+
"half4 LightingStandard (SurfaceOutputStandard s, half3 viewDir, UnityGI gi)\n"+
"{\n"+
"	s.Normal = normalize(s.Normal);\n"+
"\n"+
"	half oneMinusReflectivity;\n"+
"	half3 specColor;\n"+
"	s.Albedo = DiffuseAndSpecularFromMetallic (s.Albedo, s.Metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);\n"+
"\n"+
"	// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)\n"+
"	// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha\n"+
"	half outputAlpha;\n"+
"	s.Albedo = PreMultiplyAlpha (s.Albedo, s.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);\n"+
"\n"+
"	half4 c = UNITY_BRDF_PBS (s.Albedo, specColor, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, gi.light, gi.indirect);\n"+
"	c.rgb += UNITY_BRDF_GI (s.Albedo, specColor, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, s.Occlusion, gi);\n"+
"	c.a = outputAlpha;\n"+
"	return c;\n"+
"}\n"+
"\n"+
"half4 LightingStandard_Deferred (SurfaceOutputStandard s, half3 viewDir, UnityGI gi, out half4 outDiffuseOcclusion, out half4 outSpecSmoothness, out half4 outNormal)\n"+
"{\n"+
"	half oneMinusReflectivity;\n"+
"	half3 specColor;\n"+
"	s.Albedo = DiffuseAndSpecularFromMetallic (s.Albedo, s.Metallic, /*out*/ specColor, /*out*/ oneMinusReflectivity);\n"+
"\n"+
"	half4 c = UNITY_BRDF_PBS (s.Albedo, specColor, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, gi.light, gi.indirect);\n"+
"	c.rgb += UNITY_BRDF_GI (s.Albedo, specColor, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, s.Occlusion, gi);\n"+
"\n"+
"	outDiffuseOcclusion = half4(s.Albedo, s.Occlusion);\n"+
"	outSpecSmoothness = half4(specColor, s.Smoothness);\n"+
"	outNormal = half4(s.Normal * 0.5 + 0.5, 1);\n"+
"	half4 emission = half4(s.Emission + c.rgb, 1);\n"+
"	return emission;\n"+
"}\n"+
"\n"+
"/*void LightingStandard_GI (\n"+
"	SurfaceOutputStandard s,\n"+
"	UnityGIInput data,\n"+
"	inout UnityGI gi)\n"+
"{\n"+
"#if UNITY_VERSION >= 520\n"+
"UNITY_GI(gi, s, data);\n"+
"#else\n"+
"	gi = UnityGlobalIllumination (data, s.Occlusion, s.Smoothness, s.Normal);\n"+
"#endif\n"+
"}*/\n"+
"\n"+
"//-------------------------------------------------------------------------------------\n"+
"// Specular workflow\n"+
"\n"+
"struct SurfaceOutputStandardSpecular\n"+
"{\n"+
"	fixed3 Albedo;		// diffuse color\n"+
"	fixed3 Specular;	// specular color\n"+
"	fixed3 Normal;		// tangent space normal, if written\n"+
"	half3 Emission;\n"+
"	half Smoothness;	// 0=rough, 1=smooth\n"+
"	half Occlusion;		// occlusion (default 1)\n"+
"	fixed Alpha;		// alpha for transparencies\n"+
"};\n"+
"\n"+
"half4 LightingStandardSpecular (SurfaceOutputStandardSpecular s, half3 viewDir, UnityGI gi)\n"+
"{\n"+
"	s.Normal = normalize(s.Normal);\n"+
"\n"+
"	// energy conservation\n"+
"	half oneMinusReflectivity;\n"+
"	s.Albedo = EnergyConservationBetweenDiffuseAndSpecular (s.Albedo, s.Specular, /*out*/ oneMinusReflectivity);\n"+
"\n"+
"	// shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)\n"+
"	// this is necessary to handle transparency in physically correct way - only diffuse component gets affected by alpha\n"+
"	half outputAlpha;\n"+
"	s.Albedo = PreMultiplyAlpha (s.Albedo, s.Alpha, oneMinusReflectivity, /*out*/ outputAlpha);\n"+
"\n"+
"	half4 c = UNITY_BRDF_PBS (s.Albedo, s.Specular, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, gi.light, gi.indirect);\n"+
"	c.rgb += UNITY_BRDF_GI (s.Albedo, s.Specular, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, s.Occlusion, gi);\n"+
"	c.a = outputAlpha;\n"+
"	return c;\n"+
"}\n"+
"\n"+
"half4 LightingStandardSpecular_Deferred (SurfaceOutputStandardSpecular s, half3 viewDir, UnityGI gi, out half4 outDiffuseOcclusion, out half4 outSpecSmoothness, out half4 outNormal)\n"+
"{\n"+
"	// energy conservation\n"+
"	half oneMinusReflectivity;\n"+
"	s.Albedo = EnergyConservationBetweenDiffuseAndSpecular (s.Albedo, s.Specular, /*out*/ oneMinusReflectivity);\n"+
"\n"+
"	half4 c = UNITY_BRDF_PBS (s.Albedo, s.Specular, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, gi.light, gi.indirect);\n"+
"	c.rgb += UNITY_BRDF_GI (s.Albedo, s.Specular, oneMinusReflectivity, s.Smoothness, s.Normal, viewDir, s.Occlusion, gi);\n"+
"\n"+
"	outDiffuseOcclusion = half4(s.Albedo, s.Occlusion);\n"+
"	outSpecSmoothness = half4(s.Specular, s.Smoothness);\n"+
"	outNormal = half4(s.Normal * 0.5 + 0.5, 1);\n"+
"	half4 emission = half4(s.Emission + c.rgb, 1);\n"+
"	return emission;\n"+
"}\n"+
"\n"+
"/*void LightingStandardSpecular_GI (\n"+
"	SurfaceOutputStandardSpecular s,\n"+
"	UnityGIInput data,\n"+
"	inout UnityGI gi)\n"+
"{\n"+
"	gi = UnityGlobalIllumination (data, s.Occlusion, s.Smoothness, s.Normal);\n"+
"}*/\n"+
"\n"+
"#endif // UNITY_PBS_LIGHTING_INCLUDED			\n"+
"			\n";
		}
		#endif
		foreach (ShaderPlugin SP in SG.UsedPlugins){
			shaderCode+="\n\n"+SP.Function+"\n\n";
		}
		if (SG.UsedNormalBlend==true)
		{
			shaderCode += "float3 NormalBlend(float3 Tex1,float3 Tex2){\n"+
			//"float3 t = Tex1*float3( 2,  2, 2) + float3(-1, -1,  0);\n"+
			//"float3 u = Tex2*float3(-2, -2, 2) + float3( 1,  1, -1);\n"+
			//"float3 r = t*dot(t, u)/t.z - u;\n"+
			"return normalize(float3(Tex1.xy + Tex2.xy, Tex1.z*Tex2.z));\n"+//normalize(float3(Tex1.xy + Tex2.xy, Tex1.z));\n"+
			"}\n";
		}
		foreach(string Ty in ShaderSandwich.EffectsList){
			bool IsUsed = false;
			foreach (ShaderLayer SL in ShaderUtil.GetAllLayers()){
				foreach(ShaderEffect SE in SL.LayerEffects)
				{
					if (Ty==SE.TypeS&&SE.Visible)
					IsUsed = true;
				}
			}
			if (IsUsed){
				ShaderEffect NewEffect = ShaderEffect.CreateInstance<ShaderEffect>();
				NewEffect.ShaderEffectIn(Ty);			
				shaderCode+=NewEffect.Function+"\n";
			}
		}
		return shaderCode;
	}
}