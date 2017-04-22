using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using SU = ShaderUtil;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Xml;
using System.Diagnostics;

public enum LayerTypes{
Color,
Gradient,
VertexColors,
Texture,
Cubemap,
Noise,
Previous,
Literal,
GrabDepth};

public enum VertexMasks{
None = 0,
Normal = 1,
Position = 2
//View = 3
};

public enum ShaderMapType{UVMap1,UVMap2,Reflection,Direction,RimLight,Generate,View,Position};

[System.Serializable]
public class ShaderLayer : ScriptableObject{
public List<ShaderVar> ShaderVars = new List<ShaderVar>();
public SVDictionary CustomData = new SVDictionary();
public int LayerID;

//[NonSerialized]public ShaderLayerList Parent = null;//
[NonSerialized]private ShaderLayerList Parent2;//
public ShaderLayerList Parent{
		get{
			if (Parent2==null){
				foreach(ShaderLayerList SLL in ShaderSandwich.Instance.OpenShader.GetShaderLayerLists()){
					SLL.FixParents();
				}
			}
			
			return Parent2;
		}
		set{
			Parent2 = value;
		}
	}
public bool IsVertex{
	get{
		return (Parent.Name.Text=="Vertex"||(ShaderBase.Current.SG!=null&&ShaderBase.Current.SG.InVertex));
	}
	set{
	
	}
}
public bool IsLighting{
	get{
		return (Parent.IsLighting.On||(ShaderBase.Current.SG!=null&&ShaderBase.Current.SG.InVertex));
	}
	set{
	
	}
}
public ShaderVar LayerType = new ShaderVar();
public ShaderVar RealLayerType = new ShaderVar();
public bool LayerTypeHelp;
public ShaderVar Name = new ShaderVar();
public bool Selected = true;
public bool Enabled = true;
//Types
//Color 0
public ShaderVar Color = new ShaderVar();
//Gradient 1 
public ShaderVar Color2 = new ShaderVar();
[XmlIgnore,NonSerialized] public Texture2D GradTex;
[XmlIgnore,NonSerialized] public Texture2D ColTex;


[XmlIgnore,NonSerialized] public Texture2D PreviewTex;
//Vertex Colors 2
//Texture 3 
//public Texture2D Image;
//public int ImageInput = -1;
public ShaderVar Image = new ShaderVar();
public bool IsNormalMap = false;
public enum ImageTypes {Normal,Greyscale,NormalMap,ScaledNormalMap,PackedNormalMap}
public ImageTypes ImageType = ImageTypes.Normal;
public Texture2D ImageResize;

//Cubemap 4
//public Cubemap Cube;
public ShaderVar Cube = new ShaderVar();
public Texture2D CubeResize;
//Noise 5
public ShaderVar NoiseDim = new ShaderVar();
public ShaderVar NoiseType = new ShaderVar();
public ShaderVar NoiseA = new ShaderVar();
public ShaderVar NoiseB = new ShaderVar();
public ShaderVar NoiseC = new ShaderVar();


public ShaderVar LightData = new ShaderVar();
public bool NoiseClamp;
//Previous Texture 6

//GrabDepth
public ShaderVar SpecialType = new ShaderVar();
public ShaderVar LinearizeDepth = new ShaderVar();

public int Rotation = 0;
	
public ShaderVar UseAlpha = new ShaderVar();
public ShaderVar Stencil = new ShaderVar();
//Color Editing

public int ColorR = 0;
public int ColorG = 1;
public int ColorB = 2;
public int ColorA = 3;
[XmlIgnore,NonSerialized]static public string[] ColorChannelNames = {"Red","Green","Blue","Alpha"};
[XmlIgnore,NonSerialized]static public string[] ColorChannelCodeNames = {"r","g","b","a"};


//Mapping
public bool MapTypeOpen;
public bool MapTypeHelp;
public ShaderVar MapType;
public ShaderVar MapLocal;
//1"UVs/UV1",
//2"UVs/UV2",
//3"World/Normals/Normal",
//4"World/Normals/Reflection",
//5"World/Normals/Edge",
//6"World/Generated/From View","
//7World/Generated/World Position",
//8"World/Generated/Cube",
//9"Local/Normals/Normal",
//10"Local/Normals/Reflection",
//11"Local/Normals/Edge",/
//12"Local/Generated/From View",
//13"Local/Generated/Local Position",
//14"Local/Generated/Cube"
public ShaderInput UVTexture;

[XmlIgnore,NonSerialized]static public string[] MapTypeDescriptions = {"Uses the 1st UV map. This is used in almost every shader.","Uses the 2nd UV map.","Used with cubemaps to simulate reflections","Based on the direction between the view and the normal of the object, it will use the first row of the texture.","The texture will be the same from any angle, based on the view.","The texture will be placed based on the world position.","The texture will be placed on each side of the model separately to eliminate seams.","Used with cubemaps to simulate Image Based Lighting."};

public int MappingX = 0;
public int MappingY = 1;
public int MappingZ = 2;
static public string[] MappingNames = {"X","Y","Z"};
static public string[] MappingCodeNames = {"x","y","z"};

public ShaderVar MixAmount = new ShaderVar();

public ShaderVar UseFadeout = new ShaderVar();
public ShaderVar FadeoutMinL = new ShaderVar();
public ShaderVar FadeoutMaxL = new ShaderVar();
public ShaderVar FadeoutMin = new ShaderVar();
public ShaderVar FadeoutMax = new ShaderVar();

public string[] AStencilChannelNames = {"Red","Green","Blue","Alpha"};
public string[] AStencilChannelCodeNames = {"r","g","b","a"};

static public string[] AVertexTypeNames = {"Normal","Local","World","View Space"};
static public string[] AVertexAxisTypeNames = {"X","Y","Z"};

public ShaderVar MixType = new ShaderVar();

public ShaderVar VertexMask = new ShaderVar();

public bool Initiated = false;

public int SampleCount = 0;
public string ShaderCodeSamplers;
public string ShaderCodeEffects;
public List<string> SpawnedBranches;

//Effects
public List<ShaderEffect> LayerEffects = new List<ShaderEffect>();
public int SelectedEffect = 0;

//Generation Vars
public int InfluenceCount;

public override string ToString(){
	return Name.Text+" (ShaderLayer)";
}
public ShaderLayer(){
Name = new ShaderVar("Layer Name","");
LayerType = new ShaderVar( "Layer Type",new string[] {"Color", "Gradient", "Vertex Color","Texture","Cubemap","Noise","Previous","Literal","Grab/Depth"},new string[] {"Color - A plain color.", "Gradient - A color that fades.", "Vertex Colors - The colors interpolated between each vertex","Texture - A 2d texture.","Cubemap - A 3d reflection map.","Noise - Perlin Noise","Previous - The previous value.","Literal - Uses the value directly from the mapping.","Grab/Depth - Access the entire screen or the screen's depth buffer."},3);
ShaderVars.Add(LayerType);

RealLayerType = new ShaderVar("Real Layer Type","SLTColor");
ShaderVars.Add(RealLayerType);

Color = new ShaderVar("Main Color", new Vector4(160f/255f,204f/255f,225/255f,1f));
ShaderVars.Add(Color);
Color2 = new ShaderVar("Second Color", new Vector4(0.0f,0.0f,0.0f,1f));
ShaderVars.Add(Color2);
Image = new ShaderVar("Main Texture", "Texture2D");ShaderVars.Add(Image);

Cube = new ShaderVar( "NCubemap","Cubemap");
ShaderVars.Add(Cube);
UseAlpha = new ShaderVar("Use Alpha",false);
Stencil = new ShaderVar("Stencil","ListOfObjects");

MixAmount = new ShaderVar( "Mix Amount",1f);ShaderVars.Add(MixAmount);

UseFadeout = new ShaderVar("Use Fadeout",false);
FadeoutMinL = new ShaderVar("Fadeout Limit Min",0f);
FadeoutMaxL = new ShaderVar("Fadeout Limit Max",10f);
FadeoutMin = new ShaderVar("Fadeout Start",3f);
FadeoutMax = new ShaderVar("Fadeout End",5f);

MixType = new ShaderVar("Mix Type", new string[]{"Mix","Add","Subtract","Multiply","Divide","Lighten","Darken","Normal Map Combine","Dot"},new string[]{"","","","","","","","",""},3);ShaderVars.Add(MixType);

MapType = new ShaderVar("UV Map",new string[]{"UV Map","UV Map2","Reflection","Direction","Rim Light","Generate","View","Position"},new string[]{"The first UV Map","The second UV Map (Lightmapping)","The reflection based on the angle of the face.","Simply the angle of the face.","Maps from the edge to the center of the model.","Created the UVMap using tri-planar mapping.(Good for generated meses)","Plaster the layer onto it from whatever view you are facing from.","Maps using the world position."});
MapLocal = new ShaderVar("Map Local",false);

NoiseDim = new ShaderVar("NNoise Dimensions",new string[]{"2D","3D"},new string[]{"",""});
NoiseType = new ShaderVar("Noise Type",new string[]{"Perlin","Cloud","Cubist","Cell","Dot"},new string[]{"","","","",""});
NoiseA = new ShaderVar("Noise A",0f);
NoiseB = new ShaderVar("Noise B",1f);
NoiseC = new ShaderVar("Noise C",false);

LightData = new ShaderVar("Light Data",new string[]{"Light/Direction","Light/Attenuation","View Direction","Channels/Albedo(Diffuse)","Channels/Normal","Channels/Specular","Channels/Emission","Channels/Alpha","Light/Color"},new string[]{"","","","","","","","",""});
//NoiseC.Range0 = 1;
//NoiseC.Range1 = 3;
NoiseC.NoInputs = true;
SpecialType = new ShaderVar("Special Type",new string[]{"Grab","Depth"},new string[]{"",""});
LinearizeDepth = new ShaderVar("Linearize Depth",false);
VertexMask = new ShaderVar("Vertex Mask",2f);

}
public void UpdateShaderVars(bool Link){
	ShaderVars.Clear();
	/*var fieldValues = this.GetType()
						 .GetFields()
						 .Select(field => field.GetValue(this))
						 .ToList();
	foreach(object obj in fieldValues)
	{
		ShaderVar SV = obj as ShaderVar;
		if (SV!=null)
		{
			SV.MyParent = this;
			ShaderVars.Add(SV);
		}
	}*/
	ShaderVar[] fieldValues = new ShaderVar[]{
		LayerType,
		RealLayerType,
		Name,

		Color,
		Color2,
		Image,
		Cube,
		NoiseDim,
		NoiseType,
		NoiseA,
		NoiseB,
		NoiseC,
		LightData,
		SpecialType,
		LinearizeDepth,

		UseAlpha,
		Stencil,
		MapType,
		MapLocal,
		MixAmount,
		UseFadeout,
		FadeoutMinL,
		FadeoutMaxL,
		FadeoutMin,
		FadeoutMax,
		MixType,
		VertexMask
	};
	foreach(ShaderVar obj in fieldValues)
	{
		ShaderVar SV = obj;
		if (SV!=null)
		{
			SV.MyParent = this;
			ShaderVars.Add(SV);
		}
	}

	foreach(var CV in CustomData.D){
		CV.Value.MyParent = this;
		ShaderVars.Add(CV.Value);
	}
	foreach(ShaderEffect SE in LayerEffects){
		foreach (ShaderVar SV in SE.Inputs)
		{
			SV.MyParent = this;
			ShaderVars.Add(SV);
		}
	}
	
}
public string GetLayerCatagory(){
return GetLayerCatagory_Real(true);
}
public string GetLayerCatagory(bool Add){
return GetLayerCatagory_Real(Add);
}
public string BetterLayerCatagory(){
string LC = Parent.LayerCatagory;

if (LC=="Diffuse")
LC = "Texture";
if (LC=="Normals")
LC = "Normal Map";

return LC;
}
public string GetLayerCatagory_Real(bool Add){
	string LC = BetterLayerCatagory();

	if (Add)
		if (Parent.Inputs!=0)
			LC+=""+(Parent.Inputs+1).ToString();

	if (Add)
		Parent.Inputs+=1;
	return LC;
}
public bool BugCheck(){
	if (CustomData==null)
	CustomData = new SVDictionary();
	Stencil.SetToMasks(Parent,0);
	if (IsLighting){
		LayerType.Update(new string[] {"Color", "Gradient", "Light Data","Texture","Cubemap","Noise","Previous","Literal","Grab/Depth"},new string[] {"Color - A plain color.", "Gradient - A color that fades.", "Light Data - Access Lighting layer specific data.","Texture - A 2d texture.","Cubemap - A 3d reflection map.","Noise - Perlin Noise","Previous - The previous value.","Literal - Uses the value directly from the mapping.","Grab/Depth - Access the entire screen or the screen's depth buffer."},3);	
	}
	MixType.Update(new string[]{"Mix","Add","Subtract","Multiply","Divide","Lighten","Darken","Normals Mix","Dot"},new string[]{"","","","","","","","",""},3);

	MapType.Update(new string[]{"UV Map","UV Map2","Reflection","Direction","Rim Light","Generate","View","Position"},new string[]{"The first UV Map","The second UV Map (Lightmapping)","The reflection based on the angle of the face.","Simply the angle of the face.","Maps from the edge to the center of the model, highlighting the rim.","Created the UVMap using tri-planar mapping.(Good for generated meshes)","Plaster the layer onto it from whatever view you are facing from.","Maps using the world position."},3);
	bool RetVal = false;
	if (Color.UpdateToInput())
	RetVal = true;
	if (Color2.UpdateToInput())
	RetVal = true;
	
	return RetVal;
}

public int GetDimensions(){
	return GetDimensions_Real(true);
}
public int GetDimensions(bool O){
	return GetDimensions_Real(O);
}
public bool UsesMap(){
	return (GetDimensions_Real(false)!=0);
}
public int GetDimensions_Real(bool O){
	return ((ShaderLayerType)ShaderSandwich.PluginList["LayerType"][RealLayerType.Text]).GetDimensions(CustomData.D,this);
}

public bool DrawIcon(Rect rect, bool Down){
	return DrawIcon_Real(rect,Down,true);
}
public bool DrawIcon(Rect rect){
	return DrawIcon_Real(rect,false,false);
}
bool DrawIcon_Real(Rect rect,bool Down,bool Button){
	bool ret = false;
	if (Button==true)
	{
		GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
		ButtonStyle.stretchHeight = true;
		ButtonStyle.fixedHeight = 0;
		ButtonStyle.stretchWidth = true;
		ButtonStyle.fixedWidth = 0;
		//if (Down==false){
			if (GUI.Button(rect,"",ButtonStyle)){
				ret=true;
				if (Event.current.button == 1 ){
					GenericMenu toolsMenu = new GenericMenu();
					toolsMenu.AddItem(new GUIContent("Copy"), false, ShaderSandwich.Instance.LayerCopy,this);
					toolsMenu.AddItem(new GUIContent("Paste"), false, ShaderSandwich.Instance.LayerPaste,Parent);
					toolsMenu.DropDown(new Rect(Event.current.mousePosition.x, Event.current.mousePosition.y, 0, 0));
					EditorGUIUtility.ExitGUI();					
				}
			}
		//}
		//else
		if (Down==true)
		if (Event.current.type == EventType.Repaint)
		//ret = GUI.Toggle(rect,Down,"",ButtonStyle);
		ButtonStyle.Draw(rect,false,true,true,true);
	}
	rect.x+=15;
	rect.y+=15;
	rect.width-=30;
	rect.height-=30;
	
	//string mT = MixType.Names[MixType.Type];
	Material mT;
	
	if (ShaderSandwich.Instance.BlendLayers)
	mT = ShaderUtil.GetMaterial(MixType.Names[MixType.Type], new Color(1f,1f,1f,MixAmount.Float),UseAlpha.On);
	else
	mT = ShaderUtil.GetMaterial("Mix", new Color(1f,1f,1f,1f),false);
	
	Texture2D Tex = null;
	Tex = PreviewTex;//GetTexture();
	if (Tex!=null)
	Graphics.DrawTexture( rect ,Tex ,mT);
	//GUI.DrawTexture(rect,Tex);
	GUI.color = new Color(1,1,1,1);
	return ret;
}

public ShaderColor GetSample(float X,float Y){
	return ((ShaderLayerType)ShaderSandwich.PluginList["LayerType"][RealLayerType.Text]).Preview(CustomData.D,this,new Vector2(X,Y));
}
bool MoreOrLess(float A1, float A2, float D){
	if ((A1<A2+D)&&(A1>A2-D))
	return true;
	
	return false;
}
bool MoreOrLess(int A1, int A2, int D){
	if ((A1<A2+D)&&(A1>A2-D))
	return true;
	
	return false;
}
public void DrawGUI(){
	if (CustomData==null)
	CustomData = new SVDictionary();
	
	Color oldCol = GUI.color;
	Color oldColb = GUI.backgroundColor;
	
	Name.Text = GUI.TextField(new Rect(0,0,250,20),Name.Text);
	
	string[] Options = new string[ShaderSandwich.PluginList["LayerType"].Count];
	string[] OptionsNames = new string[ShaderSandwich.PluginList["LayerType"].Count];
	bool[] OptionsEnabled = new bool[ShaderSandwich.PluginList["LayerType"].Count];
	var PVals = ShaderSandwich.PluginList["LayerType"].Values.ToArray();
	for(int i = 0;i<ShaderSandwich.PluginList["LayerType"].Count;i++){
		Options[i] = PVals[i].TypeS;
		OptionsNames[i] = PVals[i].Name;
		OptionsEnabled[i] = PVals[i].AllowInBase;
		if (IsVertex)
			OptionsEnabled[i] = PVals[i].AllowInVertex;
			
		//if (IsLighting)
		//	OptionsEnabled[i] = PVals[i].AllowInLighting;
		if (OptionsEnabled[i]==false)
		OptionsNames[i] = "";
	}
		
	
	
	RealLayerType.Text = Options[EditorGUI.Popup(new Rect(0,20,250,20),"",Mathf.Max(0,Array.IndexOf(Options,RealLayerType.Text)),OptionsNames,GUI.skin.GetStyle("MiniPopup"))];
	
	int YOffset = 40;
	
	GUI.Label(new Rect(0,YOffset,250,20),ShaderSandwich.PluginList["LayerType"][RealLayerType.Text].Description);
	ShaderUtil.SetupCustomData(CustomData,ShaderSandwich.PluginList["LayerType"][RealLayerType.Text].GetInputs());
	
	if (ShaderSandwich.PluginList["LayerType"][RealLayerType.Text].Draw(new Rect(0,YOffset+20,250,200),CustomData.D,this))
	GUI.changed = true;
	
	YOffset+=(ShaderSandwich.PluginList["LayerType"][RealLayerType.Text].GetInputs().Count+1)*20+10;
	
	if (IsVertex){
		VertexMask.Float = (float)(int)(VertexMasks)EditorGUI.EnumPopup(new Rect(0,YOffset,250,20)," ",(VertexMasks)(int)VertexMask.Float,ShaderUtil.EditorPopup);
		GUI.Label(new Rect(0,YOffset,250,20),"Vertex Disp Type: ");
		YOffset+=20;
	}
	YOffset-=100;
	if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
	YOffset-=70;
	else
	YOffset-=20;
	//if (LayerType.Type!=(int)LayerTypes.Previous&&LayerType.Type!=(int)LayerTypes.Literal&&LayerType.Type!=(int)LayerTypes.VertexColors)
	//YOffset+=50;
	
	int MixAmountHeight = 30;
	if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
		MixAmountHeight = 20;
		
	//int MixAmountX = 0;
	//if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
	//	MixAmountX = 20;
		
		if (Event.current.type == EventType.Repaint)
		{
			GUI.skin.GetStyle("Button").Draw(new Rect(0,170+YOffset,250,MixAmountHeight),"",false,true,false,false);
			GUI.skin.label.wordWrap = false;
			//GUI.skin.label.alignment = TextAnchor.UpperCenter;
			if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
				GUI.color = ShaderUtil.SetVal(ShaderSandwich.Instance.InterfaceColor,1f)*ShaderUtil.SetVal(ShaderSandwich.Instance.InterfaceColor,1f);
			else
				GUI.color = new Color(0.3f,0.8f,0.7f,1);
			
			GUI.backgroundColor = new Color(1,1,1,1);
				if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern){
					if (MixAmount.Float>0.01f)
					ShaderSandwich.SCSkin.button.Draw(new Rect(20,170+YOffset,(250-MixAmountHeight)*MixAmount.Float,MixAmountHeight),"",false,true,false,false);
				}
				else
					GUI.skin.GetStyle("ProgressBarBar").Draw(new Rect(0,170+YOffset,(250)*MixAmount.Float,MixAmountHeight),"",false,true,false,false);
				
				GUI.color = new Color(1,1,1,1);
				GUI.Label(new Rect(80,170+YOffset,250,MixAmountHeight),MixType.Names[MixType.Type]+" Amount");
				GUI.color = new Color(0,0,0,1);
				GUI.Label(new Rect(80,170+YOffset,(250-MixAmountHeight)*MixAmount.Float-59,MixAmountHeight),MixType.Names[MixType.Type]+" Amount");
				
			GUI.skin.label.alignment = TextAnchor.UpperLeft;	
			GUI.skin.label.wordWrap = true;	
			//EditorGUI.ProgressBar(new Rect(0,200,250,30),MixAmount.Float,"Mix Amount");	
		}
		MixAmountHeight = 20;
		
		MixAmount.DrawGear(new Rect(-290/2+26,170+YOffset,290,MixAmountHeight));
		GUI.color = new Color(1,1,1,0);
		GUI.backgroundColor = oldColb;
		//	MixAmount.NoInputs = true;
			if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
				MixAmount.Draw(new Rect(-5+20,170+YOffset,295-MixAmountHeight,MixAmountHeight),"");
			else
				MixAmount.Draw(new Rect(-5,170+YOffset,295,MixAmountHeight),"");
			MixAmount.LastUsedRect.x-=110;
			MixAmount.LastUsedRect.y+=10;
		GUI.color = oldCol;
		//MixAmount.NoInputs = false;
		MixAmount.DrawGear(new Rect(-290/2+26,170+YOffset,20,MixAmountHeight));
			
		if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
			YOffset-=10;
	
	MixType.Draw(new Rect(0,200+YOffset,250,20));
	
	//Fadeout
	if (!IsLighting){
	UseFadeout.Draw(new Rect(0,260+YOffset,210,20),"Fadeout: ");
	YOffset+=20;
	if (UseFadeout.On){
		EditorGUI.BeginChangeCheck();
		EditorGUI.MinMaxSlider(new Rect(40,280+YOffset,180,20), ref FadeoutMin.Float, ref FadeoutMax.Float, FadeoutMinL.Float, FadeoutMaxL.Float);
		if (EditorGUI.EndChangeCheck()){
			GUI.changed = true;
			EditorGUIUtility.editingTextField = false;
			FadeoutMin.Float = Mathf.Max(FadeoutMinL.Float,Mathf.Round(FadeoutMin.Float*100)/100);
			FadeoutMax.Float = Mathf.Min(FadeoutMaxL.Float,Mathf.Round(FadeoutMax.Float*100)/100);
			FadeoutMin.UpdateToVar();
			FadeoutMax.UpdateToVar();
		}
		//MinL = EditorGUI.FloatField(new Rect(142,130,40,20),MinL);
		//MaxL = EditorGUI.FloatField(new Rect(BoxSize.x-40,130,40,20),MaxL);
		//FadeoutMin.Float = EditorGUI.FloatField(new Rect(180,240+YOffset,40,20),FadeoutMin.Float);
		FadeoutMax.NoSlider = true;
		FadeoutMax.NoArrows = true;
		
		FadeoutMin.NoSlider = true;
		FadeoutMin.NoArrows = true;
		
		FadeoutMinL.NoSlider = true;
		FadeoutMinL.NoArrows = true;
		
		FadeoutMaxL.NoSlider = true;
		FadeoutMaxL.NoArrows = true;
		
		FadeoutMin.LabelOffset = 70;
		FadeoutMax.LabelOffset = 70;
		
		//EditorGUI.BeginChangeCheck();
		FadeoutMin.Draw(new Rect(0,260+YOffset,120,17),"Start:");
		FadeoutMax.Draw(new Rect(130,260+YOffset,120,17),"End:");
		
		FadeoutMinL.Draw(new Rect(10,280+YOffset,20,17),"");
		FadeoutMaxL.Draw(new Rect(230,280+YOffset,20,17),"");
		//FadeoutMax.Float = EditorGUI.FloatField(new Rect(180,240+YOffset,40,20),FadeoutMax.Float);
		YOffset+=40;
	}
	}else{UseFadeout.On=false;}
	UseAlpha.Draw(new Rect(0,260+YOffset,210,20),"Use Alpha: ");
	
	/*if (Stencil.ObjFieldObject==null)Stencil.ObjFieldObject=new List<object>();
	if (Stencil.ObjFieldImage==null)Stencil.ObjFieldImage=new List<Texture2D>();
	Stencil.ObjFieldObject.Clear();
	Stencil.ObjFieldImage.Clear();
	foreach(ShaderLayerList SLL in ShaderSandwich.Instance.OpenShader.ShaderLayersMasks){
		Stencil.ObjFieldObject.Add(SLL);
		Stencil.ObjFieldImage.Add(SLL.GetIcon());
	}*/
	if (Parent.Parallax||Parent.Name.Text=="Height"){
	GUI.enabled = false;Stencil.Selected = -1;}
	
	
	Stencil.LightingMasks = false;//Parent.IsLighting.On;
	Stencil.Draw(new Rect(0,280+YOffset,250,20),"Mask: ");
	Stencil.NoInputs = true;
	
	GUI.enabled = true;
	
	YOffset+=20;
	if (((ShaderLayerType)ShaderSandwich.PluginList["LayerType"][RealLayerType.Text]).GetDimensions(CustomData.D,this)==0)
	GUI.enabled = false;
	
	MapLocal.LabelOffset = 90;
	MapLocal.Draw(new Rect(169,342+YOffset,120,20),"Local:");
	/*if (IsLighting){
		if (GUI.enabled){
			GUI.enabled = false;
			MapType.Draw(new Rect(0,300+YOffset,250,20));
			GUI.enabled = true;
			if (MapType.Type!=3)
			MapType.Type=3;
			EditorGUI.BeginChangeCheck();
			GUI.Toggle(new Rect(0,300+YOffset-1+22,81,18),MapType.Type==3,"Direction","button");
			if (EditorGUI.EndChangeCheck())
			MapType.Type=3;
		}else{MapType.Draw(new Rect(0,300+YOffset,250,20));}
	}
	else*/
	MapType.Draw(new Rect(0,300+YOffset,250,20));
	GUI.enabled = true;
	
	YOffset+=380;
	YOffset+=15;
	ShaderUtil.DrawEffects(new Rect(10,YOffset,230,10),this,LayerEffects,ref SelectedEffect);
}
public void WarningFixDelegate(int Option,ShaderVar SV){
	if (Option==1){
		AddLayerEffect("SSENormalMap");
		LayerEffects[LayerEffects.Count-1].Inputs[2].Type = 0;
		LayerEffects[LayerEffects.Count-1].AutoCreated = true;
	}
	if (Option==0){
		AddLayerEffect("SSESwizzle");
		LayerEffects[LayerEffects.Count-1].AutoCreated = true;
		LayerEffects[LayerEffects.Count-1].Inputs[0].Type = 3;
		LayerEffects[LayerEffects.Count-1].Inputs[1].Type = 1;
		LayerEffects[LayerEffects.Count-1].Inputs[2].Type = 0;
		LayerEffects[LayerEffects.Count-1].Inputs[3].Type = 0;
	}
	//Image.WarningReset();
}
public void AddTextureOrCubemapInput(int Option,ShaderVar SV){
	if (Option==0){
		if (LayerType.Type==(int)LayerTypes.Texture){
			Image.AddInput();
		}
		if (LayerType.Type==(int)LayerTypes.Cubemap){
			Cube.AddInput();
		}
		Image.WarningReset();
		Cube.WarningReset();
	}
}
public void AddLayerEffect(object TypeName){
		ShaderEffect NewEffect = ShaderEffect.CreateInstance<ShaderEffect>();
		NewEffect.ShaderEffectIn((string)TypeName);//ShaderSandwich.EffectsList[0]);
		LayerEffects.Add(NewEffect);
		if (Parent!=null)
		Parent.UpdateIcon(new Vector2(70,70));
}
static public void DrawGUIGen(bool Text){
	//Color oldCol = GUI.color;
	//Color oldColb = GUI.backgroundColor;
	
	if (Text)
	GUI.Box(new Rect(0,0,250,21),"The layers name");
	else
	GUI.Box(new Rect(0,0,250,21),"");
	
	int YOffset = 20;
	if (Text)
	GUI.Box(new Rect(0,0+YOffset,250,41),"The layer's type. This changes what the layer itself looks like.");
	else
	GUI.Box(new Rect(0,0+YOffset,250,41),"");
	if (Text)
	GUI.Box(new Rect(0,40+YOffset,250,31),"Some layer specific properties, such as the color of the layer or the texture it uses.");else
	GUI.Box(new Rect(0,40+YOffset,250,31),"");
	
	if (Text)
	GUI.Box(new Rect(0,70+YOffset,250,21),"How much the layer overwrites previous layers.");
	else
	GUI.Box(new Rect(0,70+YOffset,250,21),"");
	
	if (Text)
	GUI.Box(new Rect(0,90+YOffset,250,61),"How the layers blend. Mix is standard blending. Add on the other hand, adds the colors different components (Red, Green, Blue, Alpha) seperately.");
	else
	GUI.Box(new Rect(0,90+YOffset,250,61),"");	
	
	
	if (Text)
	GUI.Box(new Rect(0,150+YOffset,250,21),"Fadeout the layer by distance.");
	else
	GUI.Box(new Rect(0,150+YOffset,250,21),"");		
	
	if (Text)
	GUI.Box(new Rect(0,170+YOffset,250,21),"Use the layer's alpha when mixing.");
	else
	GUI.Box(new Rect(0,170+YOffset,250,21),"");		
	
	if (Text)
	GUI.Box(new Rect(0,190+YOffset,250,41),"The mask the layer uses.");
	else
	GUI.Box(new Rect(0,190+YOffset,250,41),"");		
	
	if (Text)
	GUI.Box(new Rect(0,230+YOffset,250,91),"How the layer is placed on the object. The layer needs to know how to choose what colour from it's texture or gradient to put at what point on the model.");
	else
	GUI.Box(new Rect(0,230+YOffset,250,91),"");
	
	if (Text)
	GUI.Box(new Rect(0,320+YOffset,250,91),"Layer effects which can alter what the layer looks like and how it's mapped.");
	else
	GUI.Box(new Rect(0,320+YOffset,250,91),"");

}










////////////////Code Gen Stuff
public string GCUVs(ShaderGenerate SG,string OffsetX,string OffsetY, string OffsetZ){
return GCUVs_Real(SG,OffsetX,OffsetY,OffsetZ,true);
}
public string GCUVs(ShaderGenerate SG){
return GCUVs_Real(SG,"","","",true);
}
public string GCUVs(ShaderGenerate SG,bool UseEffects){
return GCUVs_Real(SG,"","","",UseEffects);
}
public string GCUVs_Real(ShaderGenerate SG,string OffsetX,string OffsetY, string OffsetZ,bool UseEffects){
	//string ad = "IN";
	//string Map1D = "0";
	//string Map2D = "float2(0,0)";
	//string Map3D = "float3(0,0,0)";
	string Map = "float3(0,0,0)";
	
	string LocalStart = "";
	string LocalEnd = "";
	if (MapLocal.On){
		LocalStart = "mul(_World2Object, float4(";
		LocalEnd = ",1)).xyz";
	}
	//string MapZ = "0";
	
	int TypeDimensions = GCTypeDimensions();
	int UVDimensions = GCUVDimensions();
	if (RealLayerType.Text=="SLTTexture")
		UVTexture = CustomData.D["Texture"].Input;
	else
		UVTexture = null;
	if (MapType.Type==(int)ShaderMapType.UVMap1){
		string UV = "";
		
		if (UVTexture==null)
		UV = "d."+SG.GeneralUV;
		else
		UV = "d.uv"+UVTexture.Get();
		
		if (IsVertex||SG.Function == "Vertex")
		UV = "v.texcoord.xyz";
		
		Map = UV+".xy";
		//Map2D = UV+".xy";
		if (LayerType.Type == (int)LayerTypes.Cubemap){
			string MapX = "sin("+UV+".x)";
			string MapY = "cos("+UV+".y)";			
			string MapZ = "sin("+UV+".y)";
			Map = "float3("+MapX+","+MapY+","+MapZ+")";
		}
	}
	if (MapType.Type==(int)ShaderMapType.UVMap2){
		string UV = "";
		
		if (UVTexture==null)
		UV = "d."+SG.GeneralUV;
		else
		UV = "d.uv2"+UVTexture.Get();
		
		if (IsVertex||SG.Function == "Vertex")
		UV = "v.texcoord2.xyz";
		
		Map = UV+".xy";
		if (LayerType.Type == (int)LayerTypes.Cubemap){
			string MapX = "sin("+UV+".x)";
			string MapY = "cos("+UV+".y)";			
			string MapZ = "sin("+UV+".y)";
			Map = "float3("+MapX+","+MapY+","+MapZ+")";
		}
	}
	if (MapType.Type==(int)ShaderMapType.Reflection){
		string oNameWorldRefType = "d.worldRefl";//oNameWorldRef;
		if (SG.UsedWorldNormals==false)
		oNameWorldRefType = LocalStart+"d.worldRefl"+LocalEnd;
		else
		oNameWorldRefType = LocalStart+"WorldReflectionVector(d,d.Normal)"+LocalEnd;
		
		if (IsVertex||SG.Function == "Vertex"){
			if (MapLocal.On)
			oNameWorldRefType = "reflect(-UnityWorldSpaceViewDir(v.vertex.xyz), v.normal)";
			else
			oNameWorldRefType = "reflect(-UnityWorldSpaceViewDir(mul(_Object2World, v.vertex).xyz), UnityObjectToWorldNormal(v.normal))";
		}
		
		Map = oNameWorldRefType;
	}
	if (MapType.Type==(int)ShaderMapType.Direction)
	{
		string oNameNormalType;//oNameNormal;
		oNameNormalType = LocalStart+"d.worldNormal"+LocalEnd;
		if (SG.UsedNormals)
		oNameNormalType = LocalStart+"WorldNormalVector(d, d.Normal)"+LocalEnd;
		if (IsVertex||SG.Function == "Vertex"){
			if (MapLocal.On)
			oNameNormalType = "v.normal";
			else
			oNameNormalType = "UnityObjectToWorldNormal(v.normal)";
		}
		//if (IsLighting){
		//	oNameNormalType = LocalStart+"SSnormal"+LocalEnd;
		//}
		//Debug.Log(MapType.ToString());		
		Map = oNameNormalType;
	}		
	if (MapType.Type==(int)ShaderMapType.RimLight)
	{
		string oNameViewDir="d.viewDir";
		//oNameWorldRefType = "reflect(-UnityWorldSpaceViewDir(mul(_Object2World, v.vertex).xyz), UnityObjectToWorldNormal(v.normal))";
		if (IsVertex||SG.Function == "Vertex")
		Map = "(dot(normalize(UnityWorldSpaceViewDir(mul(_Object2World, v.vertex).xyz)), normalize(UnityObjectToWorldNormal(v.normal))))";
		else
		Map = "(dot(d.Normal, "+oNameViewDir+"))";
	}
	if (MapType.Type==(int)ShaderMapType.View)
	{
		string ScreenPosVar = "d.screenPos";
		if (IsVertex||SG.Function == "Vertex")
		ScreenPosVar = "(ComputeScreenPos(mul (UNITY_MATRIX_MVP, v.vertex))/ComputeScreenPos(mul (UNITY_MATRIX_MVP, v.vertex)).w)";
		Map = "("+ScreenPosVar+".xyw)";
		if (LayerType.Type == (int)LayerTypes.Cubemap){
			string MapX = "sin("+ScreenPosVar+".x)";
			string MapY = "cos("+ScreenPosVar+".y)";			
			string MapZ = "sin("+ScreenPosVar+".y)";
			Map = "float3("+MapX+","+MapY+","+MapZ+")";
		}		
	}	
	if (MapType.Type==(int)ShaderMapType.Position||MapType.Type==(int)ShaderMapType.Generate)
	{
		if (IsVertex||SG.Function == "Vertex"){
			if (MapLocal.On)
			Map = "v.vertex.xyz";
			else
			Map = "mul(_Object2World, v.vertex).xyz";
		}
		else
			Map = LocalStart+"d.worldPos"+LocalEnd;
	}		
	if (MapType.Type==(int)ShaderMapType.Generate)
		TypeDimensions=3;
	
	if (UseEffects){
		LayerEffects.Reverse();
		foreach(ShaderEffect SE in LayerEffects){
			if (SE.Visible){
				var Meth = ShaderEffect.GetMethod(SE.TypeS,"GenerateMap");
				if (Meth!=null){
					object[] Vars = new object[]{SG,SE,this,Map,UVDimensions,TypeDimensions};
					Map = (string)Meth.Invoke(null,Vars);
					UVDimensions = (int)Vars[4];
					TypeDimensions = (int)Vars[5];
				}
			}	
		}
		LayerEffects.Reverse();
	}
	Map  = "("+Map+")";
	
	
	if (TypeDimensions==0)
	{
		Map = "0";
	}
	if (TypeDimensions==1)
	{
		if (UVDimensions == 2)
			Map = Map+".x";//xy";
		if (UVDimensions == 3)
			Map = Map+".x";//xy";
	}
	if (TypeDimensions==2)
	{
		if (UVDimensions == 1)
			Map = "float2("+Map+",0)";//xy";
		if (UVDimensions == 3)
			Map = Map+".xy";//xy";
	}
	if (TypeDimensions==3)
	{
		if (UVDimensions == 1)
			Map = "float3("+Map+",0,0)";//xy";
		if (UVDimensions == 2)
			Map = "float3("+Map+",0)";//xy";
	}
	Map  = "("+Map+")";
	

	
	if (TypeDimensions==1)
	{
		if (OffsetX!="")
		Map+=" + "+OffsetX;
		if (SG.MapDispOn==true)
		Map="("+Map+"+MapDisp.r)";
	}
	if (TypeDimensions==2)
	{
		if (OffsetX!="")
		Map+=" + float2("+OffsetX+", "+OffsetY+")";
		if (SG.MapDispOn==true)
		Map="("+Map+"+MapDisp.rg)";
	}
	if (TypeDimensions==3)
	{
		if (OffsetX!="")
		Map+=" + float3("+OffsetX+", "+OffsetY+", "+OffsetZ+")";
		if (SG.MapDispOn==true)
		Map="("+Map+"+MapDisp.rgb)";			
	}
	Map  = "("+Map+")";
	if (LayerType.Type == (int)LayerTypes.Noise)
	Map  = "("+Map+"*3)";
	if (Parent.Parallax||Parent.Name.Text=="Height"){
		if (GetDimensions()==3)
		Map+="+float3(view*(depth),0)";
		//Map+="+(worldView*(depth))";
		else
		if (GetDimensions()==2)
		Map+="+((view*(depth)).xy)";
		else
		Map+="+((view*(depth)).x)";
	}	
	return Map;
}

public int GCDimensions(){
	return GetDimensions();
}
public int GCTypeDimensions(){
	return GetDimensions();
}
public int GCUVDimensions(){
	int Dim = 2;
	if (MapType.Type==(int)ShaderMapType.UVMap1){
		Dim = 2;
		if (LayerType.Type == (int)LayerTypes.Cubemap)
			Dim = 3;
	}
	if (MapType.Type==(int)ShaderMapType.UVMap2){
		Dim = 2;
		if (LayerType.Type == (int)LayerTypes.Cubemap)
			Dim = 3;
	}
	if (MapType.Type==(int)ShaderMapType.Reflection)
		Dim = 3;
	if (MapType.Type==(int)ShaderMapType.Direction)
		Dim = 3;
	if (MapType.Type==(int)ShaderMapType.RimLight)
		Dim = 1;
	if (MapType.Type==(int)ShaderMapType.View){
		Dim = 3;
		if (LayerType.Type == (int)LayerTypes.Cubemap)
			Dim = 3;
	}	
	if (MapType.Type==(int)ShaderMapType.Position||MapType.Type==(int)ShaderMapType.Generate)
		Dim = 3;
	return Dim;
}
public string GCPixelBase(ShaderGenerate SG,string Map){
	if (MapType.Type==(int)ShaderMapType.Generate){
	if (GetDimensions(false)==1)
	return "("+GCPixelBase_Real(SG,"("+Map+").z")+"*blend.x + "+GCPixelBase_Real(SG,"("+Map+").z")+"*blend.y + "+GCPixelBase_Real(SG,"("+Map+").x")+"*blend.z)";
	if (GetDimensions(false)==2)
	return "("+GCPixelBase_Real(SG,"("+Map+").zy")+"*blend.x + "+GCPixelBase_Real(SG,"("+Map+").zx")+"*blend.y + "+GCPixelBase_Real(SG,"("+Map+").xy")+"*blend.z)";
	}
	
	return GCPixelBase_Real(SG,Map);
}
public string GCPixelBase_Real(ShaderGenerate SG,string Map){
	string PixCol = "";
	PixCol = ((ShaderLayerType)ShaderSandwich.PluginList["LayerType"][RealLayerType.Text]).Generate(CustomData.D, this, SG, Map);
	if ((RealLayerType.Text!="SLTPrevious")&&(!Map.Contains("*(depth)"))){
		if (!SG.UsedBases.ContainsKey(PixCol))
		SG.UsedBases.Add(PixCol,1);
		else
		SG.UsedBases[PixCol]+=1;
	}
	foreach(ShaderEffect SE2 in LayerEffects){
		if (SE2.Visible){
			if (ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase")!=null){
				if (ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase").GetParameters().Length==4)
				PixCol = (string)ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase").Invoke(null,new object[]{SE2,this,PixCol,Map});
				else
				PixCol = (string)ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase").Invoke(null,new object[]{SG,SE2,this,PixCol,Map});
			}
		}
	}
	return PixCol;
}
public string StartNewBranch(ShaderGenerate SG,string Map,int Effect){
	SampleCount+=1;
	int Branch = SampleCount;
	//UnityEngine.Debug.Log(Effect.ToString()+": " + Map);
	for(int i = Effect;i<LayerEffects.Count;i+=1){
		
		ShaderEffect SE = LayerEffects[i];
		//UnityEngine.Debug.Log(Effect.ToString()+": "+SE.TypeS);
		if (!SE.Visible)
		continue;
		
		var Meth = ShaderEffect.GetMethod(SE.TypeS,"Generate");
		var Meth2 = ShaderEffect.GetMethod(SE.TypeS,"GenerateAlpha");
		var Meth3 = ShaderEffect.GetMethod(SE.TypeS,"GenerateWAlpha");
		string EffectString = "";
		int OldShaderCodeEffectsLength = ShaderCodeEffects.Length;
		if (SE.UseAlpha.Float==0&&Meth!=null)
			EffectString = GetSampleName(Branch)+".rgb = "+(string)Meth.Invoke(null,new object[]{SG,SE,this,GetSampleName(Branch)+".rgb",i+1})+";\n";
		if (SE.UseAlpha.Float==1&&Meth3!=null)
			EffectString = GetSampleName(Branch)+" = "+(string)Meth3.Invoke(null,new object[]{SG,SE,this,GetSampleName(Branch),i+1})+";\n";
		if (SE.UseAlpha.Float==2&&Meth2!=null)
			EffectString = GetSampleName(Branch)+".a = "+(string)Meth2.Invoke(null,new object[]{SG,SE,this,GetSampleName(Branch)+".a",i+1})+";\n";
		ShaderCodeEffects = ShaderCodeEffects.Insert(ShaderCodeEffects.Length-OldShaderCodeEffectsLength,EffectString);
	}

	string PixCol = GCPixelBase(SG,Map);

	ShaderCodeSamplers += "				half4 "+GetSampleName(Branch)+" = "+PixCol+";\n";
	return GetSampleName(Branch);
}
public string GetSubPixel(ShaderGenerate SG,string Map,int Effect,int Branch){
	
	ShaderEffect SE = null;
	if (LayerEffects.Count>Effect){
		SE = LayerEffects[Effect];
		if (!SE.Visible)
		return GetSubPixel(SG,Map,Effect+1,Branch);
		
		var Meth = ShaderEffect.GetMethod(SE.TypeS,"Generate");
		var Meth2 = ShaderEffect.GetMethod(SE.TypeS,"GenerateAlpha");
		var Meth3 = ShaderEffect.GetMethod(SE.TypeS,"GenerateWAlpha");
		string EffectString = "";
		if (SE.UseAlpha.Float==0)
			EffectString = GetSampleName(Branch)+".rgb = "+(string)Meth.Invoke(null,new object[]{SG,SE,this,GetSampleName(Branch)+".rgb",Effect+1})+";\n";
		if (SE.UseAlpha.Float==1)
			EffectString = GetSampleName(Branch)+" = "+(string)Meth3.Invoke(null,new object[]{SG,SE,this,GetSampleName(Branch),Effect+1})+";\n";
		if (SE.UseAlpha.Float==2)
			EffectString = GetSampleName(Branch)+".a = "+(string)Meth2.Invoke(null,new object[]{SG,SE,this,GetSampleName(Branch)+".a",Effect+1})+";\n";
		ShaderCodeEffects=ShaderCodeEffects+EffectString;
		return GetSubPixel(SG,Map,Effect+1,Branch);
	}
	if (!SpawnedBranches.Contains(GetSampleName(Branch))){
		//SpawnedBranches.Add(GetSampleName(Branch));

		
		string PixCol = GCPixelBase(SG,Map);
		foreach(ShaderEffect SE2 in LayerEffects){
			if (ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase")!=null){
				if (ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase").GetParameters().Length==4)
					return (string)ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase").Invoke(null,new object[]{SE2,this,PixCol,Map});
				else
					return (string)ShaderEffect.GetMethod(SE2.TypeS,"GenerateBase").Invoke(null,new object[]{SG,SE2,this,PixCol,Map});
			}
		}
		ShaderCodeSamplers = "				half4 "+GetSampleName(Branch)+" = "+PixCol+";\n"+ShaderCodeSamplers;
	}
	string RetName = GetSampleName(Branch);
	return RetName;
}
public string GetSampleName(int Branch){
	return ShaderUtil.CodeName(Name.Text+Parent.NameUnique.Text)+"_Sample"+Branch.ToString();//SampleCount.ToString();
}
public string GetSampleNameFirst(){
	return ShaderUtil.CodeName(Name.Text+Parent.NameUnique.Text)+"_Sample1";
}
public string GCPixel(ShaderGenerate SG,string Map){
	ShaderCodeSamplers = "";
	ShaderCodeEffects = "";
	SampleCount = 0;
	SpawnedBranches = new List<string>();
//	string PixCol;
	//if (UseEffects){
		LayerEffects.Reverse();
		StartNewBranch(SG,Map,0);
		LayerEffects.Reverse();
	//}
	bool NoEffects = true;
	foreach(ShaderEffect SE in LayerEffects){
		if (SE.Visible&&!SE.IsUVEffect)
		NoEffects = false;
	}
	return "		//Generate Layer: "+Name.Text+"\n			//Sample parts of the layer:\n"+ShaderCodeSamplers+(NoEffects?"":"\n			//Apply Effects:\n")+ReplaceLastOccurrence("				"+ShaderCodeEffects.Replace("\n","\n				"),"\n				","\n");
}
public static string ReplaceLastOccurrence(string Source, string Find, string Replace)
{
	int place = Source.LastIndexOf(Find);

	if(place == -1)
	   return string.Empty;

	string result = Source.Remove(place, Find.Length).Insert(place, Replace);
	return result;
}
public string GCCalculateMix(ShaderGenerate SG, string CodeName,string PixelColor,string Function,int ShaderNumber){//NormalDot
	string MixColor = "";
	string NormalsMixAddon1 = "3";
	string NormalsMixAddon2 = "";
	if (Parent.EndTag.Text.Length==4){
	NormalsMixAddon1 = "4";
	NormalsMixAddon2 = ",FSPC.ETFE.w";
	}
	
	//normalize(float3(Tex1.xy + Tex2.xy, Tex1.z*Tex2.z))
	//o.Albedo= ((normalize(float3(((Texture2_Sample1.rgb.xy+o.Albedo.xy)-1)*2,Texture2_Sample1.rgb.z*o.Albedo.z))/2)+0.5);
	string[] UseAlphaFalse = new string[]{"= FSPC.ETFE","+= FSPC.ETFE","-= FSPC.ETFE","*= FSPC.ETFE","/= FSPC.ETFE","= max(CN,FSPC.ETFE)","= min(CN,FSPC.ETFE)","= normalize(float"+NormalsMixAddon1+"(FSPC.ETFE.xy+CN.xy,FSPC.ETFE.z"+NormalsMixAddon2+"))","= dot(CN,FSPC.ETFE)"};//Unfinished
	string[] UseAlphaTrue = new string[]{"= lerp(CN,FSPC.ETFE,PCL)","+= FSPC.ETFE*PCL","-= FSPC.ETFE*PCL","= lerp(CN,CN*FSPC.ETFE,PCL)","= lerp(CN,CN/FSPC.ETFE,PCL)","= lerp(CN,max(CN,FSPC.ETFE),PCL)","= lerp(CN,min(CN,FSPC.ETFE),PCL)","= lerp(CN,normalize(float"+NormalsMixAddon1+"(FSPC.ETFE.xy+CN.xy,FSPC.ETFE.z"+NormalsMixAddon2+")),PCL)","= lerp(CN,dot(CN,FSPC.ETFE),PCL)"};//Unfinished	
	//string[] UseAlphaTrue = new string[]{"= lerp(CN,FSPC.ETFE,PCL)","+= FSPC.ETFE*PCL","-= FSPC.ETFE*PCL","= lerp(CN,CN*FSPC.ETFE,PCL)","/= FEPC.ETFS*PCL","= lerp(CN,max(CN,FSPC.ETFE),PCL)","= lerp(CN,min(CN,FSPC.ETFE),PCL)","= FSPCFE","= FSPCFE"};//Unfinished	
	if ((IsVertex||SG.Function == "Vertex")&&!Parent.IsMask.On){
		if ((VertexMasks)(int)VertexMask.Float==VertexMasks.Normal)
		PixelColor = "(("+PixelColor+")*float4(v.normal.rgb,1))";
		if ((VertexMasks)(int)VertexMask.Float==VertexMasks.Position)
		PixelColor = "(("+PixelColor+")*v.vertex)";
		//if ((VertexMasks)(int)VertexMask.Float==VertexMasks.View)
		//PixelColor = "(("+PixelColor+")*float4(normalize(UnityWorldSpaceViewDir(mul(_Object2World, v.vertex).xyz)),0))";
	}	
	bool Lerp = false;
	if (MixAmount.Get()!="0")
	{
		if (UseAlpha.On)//&&ShaderNumber!=1)
		Lerp = true;
		if (!MixAmount.Safe())
		Lerp = true;
		if (Stencil.Obj!=null)
		Lerp = true;
		if (UseFadeout.On)
		Lerp = true;
		
		
		if (Lerp == false)
			MixColor = UseAlphaFalse[MixType.Type];
		if (Lerp == true)
			MixColor = UseAlphaTrue[MixType.Type];
		
		/*if (MixAmount.Safe()&&UseAlpha.On)
		MixColor = MixColor.Replace("PCLI",PixelColor+".a");
		if (!MixAmount.Safe()&&UseAlpha.On)
		MixColor = MixColor.Replace("PCLI",PixelColor+".a*(1-"+MixAmount.Get()+")");
		if (MixAmount.Safe()&&!UseAlpha.On)
		MixColor = MixColor.Replace("PCLI","(1-"+MixAmount.Get()+")");	*/
		
		string Repl = "";
		string MulAdd = "";
		if (UseAlpha.On){
		Repl+=MulAdd+PixelColor+".a";MulAdd="*";}
		if (!MixAmount.Safe()){
		Repl+=MulAdd+MixAmount.Get();MulAdd="*";}
		if (Stencil.Obj!=null){
		Repl+=MulAdd+(((ShaderLayerList)Stencil.Obj).CodeName+Stencil.MaskColorComponentS);MulAdd="*";}
		if (UseFadeout.On){
		Repl+=MulAdd+("(1-saturate((d.screenPos.z-("+FadeoutMin.Get()+"))/("+FadeoutMax.Get()+"-"+FadeoutMin.Get()+")))");MulAdd="*";}
		
		MixColor = MixColor.Replace("PCL",Repl);
		
		MixColor = MixColor.Replace("CN",CodeName);
		MixColor = MixColor.Replace("PC",PixelColor);	
//		UnityEngine.Debug.Log(Parent.Name.Text+":"+Parent.EndTag.Text);
		if (Parent.EndTag.Text!="")
		MixColor = MixColor.Replace("ET",Parent.EndTag.Text);
		else
		MixColor = MixColor.Replace(".ET","");
		
		if (Function!="")
		MixColor = MixColor.Replace("FS",Function+"(").Replace("FE",")");
		else
		MixColor = MixColor.Replace("FS","").Replace("FE","");
		
		MixColor = CodeName+" "+MixColor;

	}
	else
	return MixColor = "			//The layer has a Mix Amount of 0, which means forget about it :)\n";
	

	if (MixType.Type==0&&!Lerp)
	return "			//Set the "+(Parent.IsMask.On?"mask":"channel")+" to the new color\n				"+MixColor+";";
	return "			//Blend the layer into the channel using the "+MixType.Names[MixType.Type]+" blend mode\n				"+MixColor+";";

}
public Dictionary<string,ShaderVar> GetSaveLoadDict(){
	Dictionary<string,ShaderVar> D = new Dictionary<string,ShaderVar>();

	D.Add(Name.Name,Name);
	D.Add(RealLayerType.Name,RealLayerType);
	D.Add(LayerType.Name,LayerType);
	D.Add(Color.Name,Color);
	D.Add(Color2.Name,Color2);
	D.Add(Image.Name,Image);
	if (ShaderSandwich.Instance.OpenShader.FileVersion<2f)
		D.Add("Cubemap",Cube);
	else
		D.Add(Cube.Name,Cube);
	D.Add(NoiseType.Name,NoiseType);
	if (ShaderSandwich.Instance.OpenShader.FileVersion<2f)
		D.Add("Noise Dimensions",NoiseDim);
	else
		D.Add(NoiseDim.Name,NoiseDim);
	D.Add(NoiseA.Name,NoiseA);
	D.Add(NoiseB.Name,NoiseB);
	D.Add(NoiseC.Name,NoiseC);
	D.Add(LightData.Name,LightData);
	D.Add(SpecialType.Name,SpecialType);
	D.Add(LinearizeDepth.Name,LinearizeDepth);
	
	D.Add(MapType.Name,MapType);
	D.Add(MapLocal.Name,MapLocal);
	
	D.Add(UseAlpha.Name,UseAlpha);
	D.Add(MixAmount.Name,MixAmount);

	D.Add(UseFadeout.Name,UseFadeout);
	D.Add(FadeoutMinL.Name,FadeoutMinL);
	D.Add(FadeoutMaxL.Name,FadeoutMaxL);
	D.Add(FadeoutMin.Name,FadeoutMin);
	D.Add(FadeoutMax.Name,FadeoutMax);
	
	D.Add(MixType.Name,MixType);
	D.Add(Stencil.Name,Stencil);
	Stencil.SetToMasks(Parent,0);
	D.Add(VertexMask.Name,VertexMask);
	if (CustomData!=null&&CustomData.D!=null){
		foreach(var CV in CustomData.D){
			D[CV.Key] = CV.Value;
		}
	}
	return D;
}
public ShaderLayer Copy(){
	return Load(new StringReader(Save()));
}
public string Save(){
	string S = "BeginShaderLayer\n";

	S += ShaderUtil.SaveDict(GetSaveLoadDict());
	foreach(ShaderEffect SE in LayerEffects){
		S += SE.Save();
	}
	S += "EndShaderLayer\n";
	//UnityEngine.Debug.Log(S);
	return S;
}
static public ShaderLayer LoadOld(StringReader S){
	ShaderLayer SL = Load(S);
	if (SL.LayerType.Type==(int)LayerTypes.Color)
		SL.RealLayerType.Text = "SLTColor";
	if (SL.LayerType.Type==(int)LayerTypes.Gradient)
		SL.RealLayerType.Text = "SLTGradient";
	if (SL.LayerType.Type==(int)LayerTypes.VertexColors)
		SL.RealLayerType.Text = "SLTVertexColors";
	if (SL.LayerType.Type==(int)LayerTypes.Texture)
		SL.RealLayerType.Text = "SLTTexture";
	if (SL.LayerType.Type==(int)LayerTypes.Cubemap)
		SL.RealLayerType.Text = "SLTCubemap";
	if (SL.LayerType.Type==(int)LayerTypes.Previous)
		SL.RealLayerType.Text = "SLTPrevious";
	if (SL.LayerType.Type==(int)LayerTypes.Literal)
		SL.RealLayerType.Text = "SLTLiteral";
	if (SL.LayerType.Type==(int)LayerTypes.GrabDepth){
		if (SL.SpecialType.Type==0)
			SL.RealLayerType.Text = "SLTGrabPass";
		else
			SL.RealLayerType.Text = "SLTDepthPass";
	}
	if (SL.LayerType.Type==(int)LayerTypes.Noise){
		if (SL.NoiseType.Type==0)
			SL.RealLayerType.Text = "SLTPerlinNoise";
		else if (SL.NoiseType.Type==1)
			SL.RealLayerType.Text = "SLTCloudNoise";
		else if (SL.NoiseType.Type==2)
			SL.RealLayerType.Text = "SLTCubistNoise";
		else if (SL.NoiseType.Type==3)
			SL.RealLayerType.Text = "SLTCellNoise";
		else if (SL.NoiseType.Type==4)
			SL.RealLayerType.Text = "SLTDotNoise";
	}
	ShaderUtil.SetupCustomData(SL.CustomData,ShaderSandwich.PluginList["LayerType"][SL.RealLayerType.Text].GetInputs());
	/*D.Add(Name.Name,Name);
	D.Add(RealLayerType.Name,RealLayerType);
	D.Add(LayerType.Name,LayerType);
	D.Add(Color.Name,Color);
	D.Add(Color2.Name,Color2);
	D.Add(Image.Name,Image);
	D.Add(Cube.Name,Cube);
	D.Add(NoiseType.Name,NoiseType);
	D.Add(NoiseDim.Name,NoiseDim);
	D.Add(NoiseA.Name,NoiseA);
	D.Add(NoiseB.Name,NoiseB);
	D.Add(NoiseC.Name,NoiseC);
	D.Add(LightData.Name,LightData);
	D.Add(SpecialType.Name,SpecialType);
	D.Add(LinearizeDepth.Name,LinearizeDepth);
	
	D.Add(MapType.Name,MapType);
	D.Add(MapLocal.Name,MapLocal);
	
	D.Add(UseAlpha.Name,UseAlpha);
	D.Add(MixAmount.Name,MixAmount);

	D.Add(UseFadeout.Name,UseFadeout);
	D.Add(FadeoutMinL.Name,FadeoutMinL);
	D.Add(FadeoutMaxL.Name,FadeoutMaxL);
	D.Add(FadeoutMin.Name,FadeoutMin);
	D.Add(FadeoutMax.Name,FadeoutMax);
	
	D.Add(MixType.Name,MixType);
	D.Add(Stencil.Name,Stencil);
	Stencil.SetToMasks(Parent,0);
	D.Add(VertexMask.Name,VertexMask);*/

	Dictionary<string,ShaderVar> NewData = new Dictionary<string,ShaderVar>();
	NewData["Color"] = SL.Color;
	NewData["Color 2"] = SL.Color2;
	NewData["Texture"] = SL.Image;
	NewData["Cubemap"] = SL.Cube;
	NewData["Noise Dimensions"] = SL.NoiseDim;
	NewData["Jitter"] = SL.NoiseA;
	NewData["Fill"] = SL.NoiseA;
	NewData["MinSize"] = SL.NoiseA;
	NewData["Edge"] = SL.NoiseB;
	NewData["MaxSize"] = SL.NoiseB;
	NewData["Square"] = SL.NoiseC;
	ShaderUtil.SetupOldData(SL.CustomData,NewData);
	
	if (SL.MapType.Type==(int)ShaderMapType.RimLight)
		SL.AddLayerEffect("SSEUVFlip");
	return SL;
}
static public ShaderLayer Load(StringReader S){
	ShaderLayer SL = ShaderLayer.CreateInstance<ShaderLayer>();//UpdateGradient
	var D = SL.GetSaveLoadDict();
	
	SL.CustomData = new SVDictionary();
	while(1==1){
		string Line = ShaderUtil.Sanitize(S.ReadLine());

		if (Line!=null){
			if(Line=="EndShaderLayer")break;
			
			if (Line.Contains("#!"))
				ShaderUtil.LoadLine(D,Line,SL.CustomData.D);
			else
			if (Line=="BeginShaderEffect")
				SL.LayerEffects.Add(ShaderEffect.Load(S));
		}
		else
		break;
	}
	ShaderUtil.SetupCustomData(SL.CustomData,ShaderSandwich.PluginList["LayerType"][SL.RealLayerType.Text].GetInputs());
	//SL.GetTexture();
	return SL;
}
}