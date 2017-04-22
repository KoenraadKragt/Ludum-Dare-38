#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7
#define PRE_UNITY_5
#else
#define UNITY_5
#endif
#pragma warning disable 0618
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using SU = ShaderUtil;
using UEObject = UnityEngine.Object;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Reflection;
using System.Threading;
public enum InterfaceStyle{Old,Flat,Modern};
[System.Serializable]
public class ShaderSandwich : EditorWindow {
	public ShaderBase OpenShader;
	public enum GUIType{Start,Presets,Layers,Configure,Inputs,Preview};
	public GUIType GUIStage = GUIType.Start;
	public int ShaderVarIds = 0;
	
	static public ShaderTransition GUITrans;
	static public ShaderTransition StartNewTrans;
	static public ShaderVar ShaderVarEditing;
	public GUIType GUITransition = GUIType.Start;
	
    public int selGridInt = 0;
	public bool SeeShells = false;
    public string[] selStrings = new string[] {"Diffuse", "Normal Mapped", "Specular", "Normal Mapped Specular"};
	//public ShaderSandwich windowG;
	//Start Specific
	public Vector2 StartScroll;
	public Vector2 ConfigScroll;
	public Vector2 LayerScroll;
	public Vector2 LayerListScroll;
	public Vector2 InputScroll;
	
	
	public Vector2 ShellsScroll;
	
	public Vector2 LayerSelection;
	public string CurrentFilePath = "";
	public int GUIChangedTimer = 5;
	public string OldShaderGenerate = "";
	public static ShaderSandwichSettings SSSettings = null;
	public string StatusReal = "No Shader Loaded";

	public string Status{
		get{return StatusReal;}
		set{
		
		StatusReal = value;
		//Debug.Log(StatusReal);
		//Repaint();
		//Event.current.type=EventType.Layout;
		//DrawMenu();
		//Event.current.type=EventType.Repaint;
		//DrawMenu();
		
		}
	}
	public void SetStatus(string Title, string Stat,float perc){
		Status = Stat;
		//EditorUtility.DisplayProgressBar(Title, Stat, perc);
		//if (perc==1f)
		//EditorUtility.ClearProgressBar();
	}
	static public Texture2D UPArrow;
	static public Texture2D DOWNArrow;
	static public Texture2D LeftArrow;
	static public Texture2D RightArrow;
	static public Texture2D QuestionMarkOff;
	static public Texture2D QuestionMarkOn;
	static public Texture2D LightBulbOff;
	static public Texture2D LightBulbOn;
	static public Texture2D Warning;
	static public Texture2D Plus;
	static public Texture2D ReloadIcon;
	static public Texture2D Tick;
	static public Texture2D Cross;
	static public Texture2D CrossRed;
	static public Texture2D Banner;
	static public Texture2D BannerLight;
	static public Texture2D Literal;
	static public Texture2D PerlNoise;
	static public Texture2D BlockNoise;
	static public Texture2D CubistNoise;
	static public Texture2D CellNoise;
	static public Texture2D DotNoise;
	static public Texture2D GrabPass;
	static public Texture2D DepthPass;
	static public Cubemap KitchenCube;
	static public Cubemap BlackCube;
	static public Cubemap DayCube;
	static public Cubemap SunsetCube;
	static public Texture2D IconShell;
	static public Texture2D IconBase;
	static public Texture2D IconMask;
	static public Texture2D EditableOn;
	static public Texture2D EditableOff;
	static public Texture2D EyeClose;
	static public Texture2D EyeOpen;
	static public Texture2D AlphaOn;
	static public Texture2D AlphaOff;
	static public Texture2D Gear;
	static public Texture2D GearLinked;
	static public GUISkin SCSkin;
	static public GUISkin SSSkin;
	
	public bool RealtimePreviewUpdates = true;
	public bool AnimateInputs = true;
	public bool ViewLayerNames = true;
	public bool ImprovedUpdates = true;
	
	public InterfaceStyle CurInterfaceStyle = InterfaceStyle.Modern;
	//public Color InterfaceColor = new Color(109f/255f,215f/255f,1,1);
	//public Color InterfaceColor = new Color(0f,97f/255f,0.5f,1);
	public Color InterfaceColor = new Color(0f,39f/255f,51f/255f,1);
	public int InterfaceSize = 10;
	public bool BlendLayers = false;
	
	public ShaderLayer ClipboardLayer = null;
	
	static public List<string> EffectsList = new List<string>();
	
	//static public Dictionary<string,Delegate> ShaderLayerTypePreviewList = new Dictionary<string,Delegate>();
	//static public Dictionary<string,Delegate> ShaderLayerTypeGetDimensionsList = new Dictionary<string,Delegate>();
	//static public Dictionary<string,ShaderLayerType> ShaderLayerTypeInstances = new Dictionary<string,ShaderLayerType>();
	static public Dictionary<string,ShaderPlugin> ShaderLayerTypeInstances = new Dictionary<string,ShaderPlugin>();
	static public Dictionary<string,Dictionary<string,ShaderPlugin>> PluginList = new Dictionary<string,Dictionary<string,ShaderPlugin>>();
	static public void LoadPlugins(){
		//Effects
		EffectsList.Clear();
		Assembly targetAssembly = Assembly.GetAssembly(typeof(ShaderEffect));
		foreach(Type Ty in targetAssembly.GetTypes().Where(t => t.IsSubclassOf(typeof(ShaderEffect))))
		EffectsList.Add(Ty.ToString());
		
		//Layer Types
//		ShaderLayerTypePreviewList.Clear();
//		ShaderLayerTypeGetDimensionsList.Clear();
		targetAssembly = Assembly.GetAssembly(typeof(ShaderPlugin));
		foreach(Type Ty in targetAssembly.GetTypes().Where(t => t.IsSubclassOf(typeof(ShaderLayerType)))){
			ShaderPlugin Ins = (ShaderPlugin)Activator.CreateInstance(Ty);
			Ins.Activate();
			if (Ins.TypeS!="Hasn't Activated Correctly"){
				//Ins.Register(ShaderLayerTypePreviewList,ShaderLayerTypeGetDimensionsList);
				ShaderLayerTypeInstances[Ins.TypeS] = Ins;
			}
			else{
				Debug.Log("The plugin "+Ty.ToString()+" is not activated correctly, please check whether it has been overriden.");
			}
			//Ty.GetMethod("Register").Invoke(Ins,new object[]{ShaderLayerTypePreviewList,ShaderLayerTypeGetDimensionsList});
		}
		PluginList["LayerType"] = ShaderLayerTypeInstances;
		string str = "Loading "+ShaderLayerTypeInstances.Count.ToString()+" Layer Types:\n";
		
		foreach(KeyValuePair<string,ShaderPlugin> kv in ShaderLayerTypeInstances){
			str+=kv.Key+"\n";
		}
//		Debug.Log(str);
	}
	public string MOTD = "";
	public static bool ValueChanged = false;
	public int changedTimer = 100;
	public static ShaderSandwich Instance;// {
	//get { return (ShaderSandwich)GetWindow(typeof (ShaderSandwich),false,"",false); }
	//}
	static string getAnswerFromOutside(string url) {
		double Start = EditorApplication.timeSinceStartup;
		WWW www = new WWW(url);
		while (1==1)
		{
			if (www.isDone==true||(EditorApplication.timeSinceStartup-Start>5))
			break;
		}
		if (www.isDone==true)
		return www.text;
		
		return "Unable to connect to www.Electronic-Mind.org for the message of the day, sorry!";
	}
	[MenuItem ("Window/Shader Sandwich")]
	public static void Init () {
		
		ShaderSandwich windowG = (ShaderSandwich)EditorWindow.GetWindow (typeof (ShaderSandwich));
		Instance = windowG;
		LoadPlugins();
		windowG.wantsMouseMove = true;
		//windowG.minSize = new Vector2(950,460);//460
		windowG.minSize = new Vector2(800,450);//460
		//Rect tempPos = windowG.position;
		//Debug.Log(tempPos);
		//tempPos.width = 950;
		//tempPos.height = 460;
		windowG.position = new Rect(200,200,950,460);
		windowG.title = "Shader Sandwich"; 
		
		//LoadAssets();
		windowG.MOTD = getAnswerFromOutside("http://electronic-mind.org/ShaderSandwich/MOTD.txt");
		string tempStr = "";
		bool commentedOut = false;
		foreach (char c in windowG.MOTD)
		{
			if (c.ToString()=="~")
			commentedOut=true;
			
			if (commentedOut==false)
			tempStr+=c;
			
			if (c.ToString()=="~")
			commentedOut=false;			
		}
		windowG.MOTD = tempStr;
		

		//if (windowS.QuestionMarkOff==null)
		//windowG.OnEnable();
		
		//ShaderSandwich.Instance.OpenShader = new ShaderBase();
	}
	public static void LoadAssets(){
	
	if (SSSettings==null){
		SSSettings = (ShaderSandwichSettings)AssetDatabase.LoadAssetAtPath("Assets/Shader Sandwich/Internal/Editor/Shader Sandwich/SSSettings.asset",typeof(ShaderSandwichSettings));
		if (SSSettings==null){
			SSSettings = (ShaderSandwichSettings)ScriptableObject.CreateInstance(typeof(ShaderSandwichSettings));
			AssetDatabase.CreateAsset(SSSettings,"Assets/Shader Sandwich/Internal/Editor/Shader Sandwich/SSSettings.asset");
		}
	}
	
	if (GUITrans==null)
		GUITrans = new ShaderTransition();
	if (StartNewTrans==null)
		StartNewTrans = new ShaderTransition();
	if (SCSkin==null)
		SCSkin = EditorGUIUtility.Load("Shader Sandwich/Misc/UtilGuiSkin.guiskin") as GUISkin;	
	//Debug.Log(SCSkin);
	if (UPArrow==null)
		UPArrow = EditorGUIUtility.Load("Shader Sandwich/Movement/UPArrow.fw.png") as Texture2D;
	//Debug.Log(UPArrow);
	if (DOWNArrow==null)
		DOWNArrow = EditorGUIUtility.Load("Shader Sandwich/Movement/DOWNArrow.fw.png") as Texture2D;
	if (QuestionMarkOff==null)
		QuestionMarkOff = EditorGUIUtility.Load("Shader Sandwich/Icons/QuestionMarkOff.png") as Texture2D;
	if (QuestionMarkOn==null)
		QuestionMarkOn = EditorGUIUtility.Load("Shader Sandwich/Icons/QuestionMarkOn.png") as Texture2D;
	if (LightBulbOff==null)
		LightBulbOff = EditorGUIUtility.Load("Shader Sandwich/Icons/LightBulbOff.fw.png") as Texture2D;
	if (LightBulbOn==null)
		LightBulbOn = EditorGUIUtility.Load("Shader Sandwich/Icons/LightBulbOn.fw.png") as Texture2D;	
	if (Warning==null)
		Warning = EditorGUIUtility.Load("Shader Sandwich/Icons/Warning.fw.png") as Texture2D;	
	if (ReloadIcon==null)
		ReloadIcon = EditorGUIUtility.Load("Shader Sandwich/Icons/Reload.fw.png") as Texture2D;	
	if (Plus==null)
		Plus = EditorGUIUtility.Load("Shader Sandwich/Movement/Plus.fw.png") as Texture2D;	
	if (Tick==null)
		Tick = EditorGUIUtility.Load("Shader Sandwich/Movement/On.fw.png") as Texture2D;
	if (Cross==null)
		Cross = EditorGUIUtility.Load("Shader Sandwich/Movement/Off.fw.png") as Texture2D;	
	if (CrossRed==null)
		CrossRed = EditorGUIUtility.Load("Shader Sandwich/Movement/Cross.fw.png") as Texture2D;	
	if (Banner==null)
		Banner = EditorGUIUtility.Load("Shader Sandwich/Icons/LineBannerPro.fw.png") as Texture2D;
	if (BannerLight==null)
		BannerLight = EditorGUIUtility.Load("Shader Sandwich/Icons/LineBanner.png") as Texture2D;
	if (RightArrow==null)
		RightArrow = EditorGUIUtility.Load("Shader Sandwich/Movement/RightArrow.fw.png") as Texture2D;
	if (LeftArrow==null)
		LeftArrow = EditorGUIUtility.Load("Shader Sandwich/Movement/LEFTArrow.fw.png") as Texture2D;
	if (Literal==null)
		Literal = EditorGUIUtility.Load("Shader Sandwich/Resources/Literal.png") as Texture2D;
	if (PerlNoise==null)
		PerlNoise = EditorGUIUtility.Load("Shader Sandwich/Resources/PerlNoise.png") as Texture2D;
	if (BlockNoise==null)
		BlockNoise = EditorGUIUtility.Load("Shader Sandwich/Resources/BlockNoise.png") as Texture2D;
	if (GrabPass==null)
		GrabPass = EditorGUIUtility.Load("Shader Sandwich/Resources/GrabPass.png") as Texture2D;
	if (DepthPass==null)
		DepthPass = EditorGUIUtility.Load("Shader Sandwich/Resources/DepthPass.png") as Texture2D;
	if (CubistNoise==null)
		CubistNoise = EditorGUIUtility.Load("Shader Sandwich/Resources/CubistNoise.png") as Texture2D;
	if (CellNoise==null)
		CellNoise = EditorGUIUtility.Load("Shader Sandwich/Resources/CellNoise.png") as Texture2D;
	if (DotNoise==null)
		DotNoise = EditorGUIUtility.Load("Shader Sandwich/Resources/DotNoise.png") as Texture2D;
	if (KitchenCube==null)
		KitchenCube = EditorGUIUtility.Load("Shader Sandwich/Resources/KitchenCube.png") as Cubemap;
	if (BlackCube==null)
		BlackCube = EditorGUIUtility.Load("Shader Sandwich/Resources/BlackCube.png") as Cubemap;
	if (DayCube==null)
		DayCube = EditorGUIUtility.Load("Shader Sandwich/Resources/SSDaySky.exr") as Cubemap;
	if (SunsetCube==null)
		SunsetCube = EditorGUIUtility.Load("Shader Sandwich/Resources/SSSunsetSky.exr") as Cubemap;
	if (IconBase==null)
		IconBase = EditorGUIUtility.Load("Shader Sandwich/Icons/IconBase.png") as Texture2D;
	if (IconShell==null)
		IconShell = EditorGUIUtility.Load("Shader Sandwich/Icons/IconShell.png") as Texture2D;
	if (IconMask==null)
		IconMask = EditorGUIUtility.Load("Shader Sandwich/Icons/IconMask.png") as Texture2D;
	if (EditableOn==null)
		EditableOn = EditorGUIUtility.Load("Shader Sandwich/Icons/EditableOn.fw.png") as Texture2D;
	if (EditableOff==null)
		EditableOff = EditorGUIUtility.Load("Shader Sandwich/Icons/EditableOff.fw.png") as Texture2D;
	if (EyeClose==null)
		EyeClose = EditorGUIUtility.Load("Shader Sandwich/Icons/EyeClose.fw.png") as Texture2D;
	if (EyeOpen==null)
		EyeOpen = EditorGUIUtility.Load("Shader Sandwich/Icons/EyeOpen.fw.png") as Texture2D;
	if (AlphaOn==null)
		AlphaOn = EditorGUIUtility.Load("Shader Sandwich/Icons/Alpha.fw.png") as Texture2D;
	if (AlphaOff==null)
		AlphaOff = EditorGUIUtility.Load("Shader Sandwich/Icons/AlphaOff.fw.png") as Texture2D;
	if (Gear==null)
		Gear = EditorGUIUtility.Load("Shader Sandwich/Icons/Gear.fw.png") as Texture2D;
	if (GearLinked==null)
		GearLinked = EditorGUIUtility.Load("Shader Sandwich/Icons/GearLinked.fw.png") as Texture2D;

	//if (ShaderSandwich.Instance.OpenShader==null)
	if (EffectsList.Count==0)
		LoadPlugins();
	}
		//Color TextColor = new Color(0.8f,0.8f,0.8f,1f);
		//Color TextColorA = new Color(1f,1f,1f,1f);
		Color BackgroundColor = new Color(0.18f,0.18f,0.18f,1);
		
    void OnGUI() {
		//if(Event.current.type==EventType.Repaint)
		ValueChanged = false;
		RunHotkeys();
		ShaderUtil.Rects.Clear();
		//ShaderSandwich windowG = this;//(ShaderSandwich)EditorWindow.GetWindow (typeof (ShaderSandwich),false,"",false);
		Instance = this;
		int MenuPad = 15;
		
		Vector2 WinSize = new Vector2(position.width,position.height);
		Vector2 WinSize2 = new Vector2(position.width,position.height-MenuPad);
		
		GUIMouseDown = false;
		GUIMouseUp = false;
		
		if ((Event.current.type == EventType.MouseDown))
		GUIMouseDown = true;
		if ((Event.current.type == EventType.MouseUp))
		GUIMouseUp = true;
		
		if (GUIMouseDown)
		GUIMouseHold = true;		
		if (GUIMouseUp)
		GUIMouseHold = false;
		
		LoadAssets();
		SSSettings.CurPath = CurrentFilePath;
		GUISkin oldskin = GUI.skin;
		if(Event.current.type==EventType.Repaint)
		ShaderUtil.AddProSkin(WinSize);

		if (ShaderVarEditing!=null)
		ShaderVarEditing.UseEditingMouse(false);
		
		bool SVMD = false;
		if (ShaderVarEditing!=null&&(Event.current.type!=EventType.Repaint))//.type== EventType.MouseDown))
		SVMD = true;
		
		if (SVMD)
		ShaderUtil.BeginGroup(new Rect(0,0,0,0));
		if (OpenShader!=null&&AnimateInputs&&Event.current.type==EventType.Repaint){
			foreach(ShaderInput SI in OpenShader.ShaderInputs)
			SI.Update();
		}		
			//if (EditorWindow.focusedWindow==this)
			Repaint();
			//TransitionTime = Mathf.Min(TransitionTime,1);
			if (GUITrans.DoneHit())
			{
				GUIStage = GUITransition;
			}

			if (OpenShader!=null&&OpenShader.ShaderPasses!=null&&OpenShader.ShaderPasses.Count>0&&CurInterfaceStyle==InterfaceStyle.Modern){
				GUIStyle ButtonStyle;
				if(CurInterfaceStyle==InterfaceStyle.Flat||CurInterfaceStyle==InterfaceStyle.Modern){
					ButtonStyle = new GUIStyle(GUI.skin.box);
					ButtonStyle.alignment = TextAnchor.MiddleCenter;
				}
				else
					ButtonStyle = new GUIStyle(GUI.skin.button);
				
				ButtonStyle.fontSize = 15;	
				
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,58,30),"Home",ButtonStyle)&&GUIStage!=GUIType.Start)
					Goto(GUIType.Start,ShaderTransition.TransDir.Backward);
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,58,WinSize.y,68,30),"Layers",ButtonStyle)&&GUIStage!=GUIType.Layers)
					Goto(GUIType.Layers,(GUITransition>GUIType.Layers)?ShaderTransition.TransDir.Backward:ShaderTransition.TransDir.Forward);	
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,58+68,WinSize.y,72,30),"Settings",ButtonStyle)&&GUIStage!=GUIType.Configure)
					Goto(GUIType.Configure,(GUITransition>GUIType.Configure)?ShaderTransition.TransDir.Backward:ShaderTransition.TransDir.Forward);	
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,58+68+72,WinSize.y,67,30),"Inputs",ButtonStyle)&&GUIStage!=GUIType.Inputs)
					Goto(GUIType.Inputs,ShaderTransition.TransDir.Forward);
			}
			if (OpenShader==null||OpenShader.ShaderPasses==null||OpenShader.ShaderPasses.Count==0){
				if (OpenShader!=null)
				EditorUtility.DisplayDialog("Error!","The currently open shader has no passes! This is only caused by loading a buggy file or some really bad internal error, I'm really sorry :(","Ok");
				GUIStage = GUIType.Start;
			}
			
			float Movement = 0f;
			if (GUITrans.Transitioning==ShaderTransition.TransDir.Backward)
			Movement = WinSize.x;
			
			if (GUIStage==GUIType.Start)
				GUIStart(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
			else if (GUIStage==GUIType.Presets)
				GUIPresets(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
			else if (GUIStage==GUIType.Configure)
				GUIConfigure(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
			else if (GUIStage==GUIType.Layers)
				GUILayers(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
			else if (GUIStage==GUIType.Inputs)
				GUIInputs(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
			
			if (GUITrans.Done()!=true)
			{
				Movement = WinSize2.x;
				if (GUITrans.Transitioning==ShaderTransition.TransDir.Backward)
				Movement = 0*WinSize2.x;
				
				if (GUITransition==GUIType.Start)
					GUIStart(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
				else if (GUITransition==GUIType.Presets)
					GUIPresets(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
				else if (GUITransition==GUIType.Configure)
					GUIConfigure(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
				else if (GUITransition==GUIType.Layers)
					GUILayers(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
				else if (GUITransition==GUIType.Inputs)
					GUIInputs(WinSize2,new Vector2(-GUITrans.Get()*WinSize.x+Movement,MenuPad));
			}
			//if (GUIStage!=GUIType.Start){
			if (OpenShader!=null&&CurInterfaceStyle==InterfaceStyle.Modern){
				GUIStyle ButtonStyle;
				if(CurInterfaceStyle==InterfaceStyle.Flat||CurInterfaceStyle==InterfaceStyle.Modern){
					ButtonStyle = new GUIStyle(ShaderSandwich.SCSkin.window);
					ButtonStyle.alignment = TextAnchor.MiddleCenter;
				}
				else
					ButtonStyle = new GUIStyle(GUI.skin.button);
				
				ButtonStyle.fontSize = 15;	
				
				GUI.Toggle( ShaderUtil.Rect2(RectDir.Bottom,1,WinSize.y,66,30),GUITransition==GUIType.Start,"Home",ButtonStyle);
				GUI.Toggle( ShaderUtil.Rect2(RectDir.Bottom,67,WinSize.y,66,30),GUITransition==GUIType.Layers,"Layers",ButtonStyle);
				GUI.Toggle( ShaderUtil.Rect2(RectDir.Bottom,67+66,WinSize.y,66,30),GUITransition==GUIType.Configure,"Passes",ButtonStyle);
				GUI.Toggle( ShaderUtil.Rect2(RectDir.Bottom,67+66+66,WinSize.y,66,30),GUITransition==GUIType.Inputs,"Inputs",ButtonStyle);
			}
			DrawMenu();
		
		if (SVMD)
		ShaderUtil.EndGroup();
		
		if (ShaderVarEditing!=null)
		ShaderVarEditing.UseEditingMouse(true);
		
		

		//Debug.Log(GUI.tooltip=="");
		//Debug.Log(TooltipAlpha);
		//GUI.color = new Color(GUI.color.r,GUI.color.g,GUI.color.b,TooltipAlpha);

		GUI.skin = oldskin;
		ShaderUtil.DrawTooltip(0,WinSize);
		if (GUI.changed==true){
			changedTimer = 100;
		}
		changedTimer -=1;
		/*if (changedTimer>-100&&changedTimer<=0)
		{
			if (OpenShader!=null)
			OpenShader.RecalculateAutoInputs();
			changedTimer = -200;
		}*/
		if (PleaseReimport!=""&&Event.current.type==EventType.Repaint){
			GiveMeAFrame+=1;
			if (GiveMeAFrame==4){
				AssetDatabase.ImportAsset(PleaseReimport,ImportAssetOptions.ForceSynchronousImport);
				UpdateShaderPreview();
				SetStatus("Updating Preview Window","Preview Updated.",1f);
				PleaseReimport = "";
				GiveMeAFrame = 0;
			}
		}
		
    }
	Vector2 GUIConfigureBoxStart(string Name,ShaderVar Tickbox,Vector2 WinSize,float X,float Y){
		float BoxWidth = (WinSize.x-15f)/2f;
		float BoxHeight = 190f;	
		Vector2 RetHW = new Vector2(BoxWidth-15f,BoxHeight-15f);
		
		if (Name!="")
		{
		if (CurInterfaceStyle==InterfaceStyle.Flat)
		ShaderUtil.BeginGroup(new Rect((int)((BoxWidth)*(float)X+15f),(BoxHeight)*(float)Y+15f+144f,BoxWidth-15f,BoxHeight-15f),GUI.skin.box);
		else
		ShaderUtil.BeginGroup(new Rect((int)((BoxWidth)*(float)X+15f),(BoxHeight)*(float)Y+15f+144f,BoxWidth-15f,BoxHeight-15f),GUI.skin.button);
		
		
		BoxWidth-=15f;
		BoxHeight-=15f;
		GUI.skin.label.alignment = TextAnchor.UpperLeft;
		GUI.skin.label.fontSize = 20;
		GUI.Label(new Rect(10,4,BoxWidth,50),Name);
		
		if (Tickbox!=null){
		if (Tickbox.On)
		{
			Tickbox.On = GUI.Toggle(new Rect(BoxWidth-34,4,30,30),Tickbox.On,new GUIContent(Tick),"Button");
		}
		else
		{
			Tickbox.On = GUI.Toggle(new Rect(BoxWidth-34,4,30,30),Tickbox.On,new GUIContent(Cross),"Button");
		}
		GUI.enabled = true;
		if (!Tickbox.On)
		GUI.enabled = false;
		}
		}
		return RetHW;//new Vector2(BoxWidth,BoxHeight);
	}
	void GUIConfigureBoxEnd(){
		GUI.enabled = true;
		ShaderUtil.EndGroup();
	}
	void OnSceneGUI(){
		RunHotkeys();
	}
	void RunHotkeys(){
		/*if ( Event.current.type == EventType.keyDown )
		{
			if ( Event.current.isKey && Event.current.control)
			{
				if (Event.current.keyCode == KeyCode.S){
					Save();
					Event.current.Use();
				}
			}
		}*/
	}
				/*float Min = 2;
			float Max = 5;
				float MinL = 0;
			float MaxL = 10;*/
	void GUIConfigure(Vector2 WinSize,Vector2 Position)
	{
		RunHotkeys();
		ShaderBase SSIO = OpenShader;

		if (SSIO==null)
		{
			GUIStage = GUIType.Start;
			GUITrans.Reset();
		}
		else
		{
			if (ShaderLayerTab<0)
				ShaderLayerTab = 0;
			if (ShaderLayerTab>SSIO.ShaderPasses.Count-1)
				ShaderLayerTab = SSIO.ShaderPasses.Count-1;
			ShaderPass SP = SSIO.ShaderPasses[ShaderLayerTab];
			ShaderUtil.BeginGroup(new Rect(Position.x,Position.y,WinSize.x,WinSize.y));
			GUIStyle ButtonStyle;
			if (CurInterfaceStyle==InterfaceStyle.Flat){
				ButtonStyle = new GUIStyle(GUI.skin.box);
				ButtonStyle.alignment = TextAnchor.MiddleCenter;
			}
			else
			ButtonStyle = new GUIStyle(GUI.skin.button);
			
			ButtonStyle.fontSize = 20;
			if (CurInterfaceStyle!=InterfaceStyle.Modern)
			if (GUI.Button( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),"Layers",ButtonStyle))
			Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
			
			Vector2 BoxSize = GUIConfigureBoxStart("",SP.DiffuseOn,WinSize,0,0);
			
			ConfigScroll = ShaderUtil.BeginScrollView(new Rect(0,0,WinSize.x,WinSize.y),ConfigScroll,new Rect(0,0,WinSize.x-16,BoxSize.y*5+58f),false,true);

			if (CurInterfaceStyle==InterfaceStyle.Flat)
			GUI.Box(new Rect(0,0,WinSize.x,100),"");
			else
			GUI.Box(new Rect(0,0,WinSize.x,100),"","button");
			GUI.skin.label.fontSize = 18;
			GUI.Label(new Rect(15,30,200,40),"Shader Name: ");
			
			GUIStyle TextFieldStyle = new GUIStyle(GUI.skin.textField);
			TextFieldStyle.fontSize = 18;
			SSIO.ShaderName.Text = GUI.TextField(new Rect(160,30,400,30),SSIO.ShaderName.Text,TextFieldStyle);
			
			SSIO.TechLOD.NoInputs = true;
			SSIO.TechLOD.Range0 = 0;
			SSIO.TechLOD.Range1 = 1000;
			SSIO.TechLOD.Float = Mathf.Round(SSIO.TechLOD.Float);
			SSIO.TechLOD.LabelOffset = 50;
			SSIO.TechLOD.Draw(new Rect(WinSize.x-220,30,220-16,20),"LOD: ");
			
			//SSIO.TechQueue.Draw(new Rect(WinSize.x-220,30+25,220-16,20),"Queue: ");
			GUI.Label(new Rect(WinSize.x-220,30+25,220-16,20),"Queue:");
			GUI.enabled = !SSIO.TechQueueAuto.On;
			SSIO.TechQueue.Type=EditorGUI.Popup(new Rect(WinSize.x-220+45,30+25,220-16-45-32,20),SSIO.TechQueue.Type,SSIO.TechQueue.Names,ShaderUtil.EditorPopup);
			GUI.enabled = true;
			SSIO.TechQueueAuto.Draw(new Rect(WinSize.x-16,30+25,220-16,20),"");

			int X = 16;
			int i = -1;
			GUIStyle style = GUI.skin.GetStyle("ButtonLeft");
			int MoveID = -1;
			int DeleteID = -1;
			int MoveDir = 0;
			foreach (ShaderPass SPd in OpenShader.ShaderPasses){
				i++;
				if (ShaderLayerTab != i){
					if (GUI.Button(new Rect(X,75,100,25),new GUIContent(SPd.Name.Text,SPd.Visible.On?(SPd.ShellsOn.On?IconShell:IconBase):CrossRed),style))
						ShaderLayerTab = i;
				}
				else{
					GUI.Toggle(new Rect(X,75,100,25),true,new GUIContent(SPd.Name.Text,SPd.Visible.On?(SPd.ShellsOn.On?IconShell:IconBase):CrossRed),style);
				}
				if (i==ShaderLayerTab){
					GUI.enabled = i>0;
					if (GUI.Button(new Rect(X+100-50,60,25,15),LeftArrow)){
						MoveID = i;
						MoveDir = -1;
					}
					GUI.enabled = i<SSIO.ShaderPasses.Count-1;
					if (GUI.Button(new Rect(X+100-25,60,25,15),RightArrow)){
						MoveID = i;
						MoveDir = 1;
					}
					GUI.enabled = SSIO.ShaderPasses.Count>1;
					if (GUI.Button(new Rect(X+100-75,60,25,15),CrossRed)){
						if (EditorUtility.DisplayDialog("Delete Pass \""+SPd.Name.Text+"\"?", "Are you sure you want to delete this entire pass? It can't be undone!", "Yes", "No"))
						DeleteID = i;
					}
					//GUI.enabled = true;
					if (GUI.Button(new Rect(X,60,25,15),SPd.Visible.On?EyeOpen:EyeClose)){
						SPd.Visible.On = !SPd.Visible.On;
					}
					if (SSIO.ShaderPasses.Count==1)
					SPd.Visible.On = true;
				}
				GUI.enabled = true;
				X += 100;
				style = GUI.skin.GetStyle("ButtonMid");
			}
			if (MoveID!=-1){
				ShaderUtil.MoveItem(ref SSIO.ShaderPasses,MoveID,MoveID+MoveDir);
				ShaderLayerTab = SSIO.ShaderPasses.IndexOf(SP);
			}
			if (DeleteID!=-1){
				SSIO.ShaderPasses.RemoveAt(DeleteID);
			}
			if (GUI.Button(new Rect(X,75,25,25),new GUIContent("",Plus),GUI.skin.GetStyle("ButtonRight"))){
				ShaderPass SPn = ScriptableObject.CreateInstance<ShaderPass>();
				SPn.Name.Text = "Pass "+(OpenShader.ShaderPasses.Count+1).ToString();
				OpenShader.ShaderPasses.Add(SPn);
			}
			GUI.Box(new Rect(15,115,WinSize.x-25,45),"","button");
			GUI.skin.label.fontSize = 18;
			GUI.Label(new Rect(25,125,WinSize.x-25,25),"Pass Group Name: ");
			TextFieldStyle.fontSize = 18;
			
			SP.Name.Text = GUI.TextField(new Rect(200,125,150,25),SP.Name.Text,TextFieldStyle);
			GUIConfigureBoxStart("Diffuse (Lighting)",SP.DiffuseOn,WinSize,0,0);
			
			SP.DiffuseLightingType.Draw(new Rect(2,30,120,120));
			
			SU.Label(new Rect(122,30,BoxSize.x-124,70),SP.DiffuseLightingType.Descriptions[SP.DiffuseLightingType.Type],12);
			
			if (SP.DiffuseLightingType.Type==0){
				GUI.Label(new Rect(122,105,BoxSize.x-124,20),"Quality: ");
				SP.PBRQuality.Draw(new Rect(122+49,105,BoxSize.x-124-49,20),"Quality: ");
			}
				
			if (SP.DiffuseLightingType.Type==1)
				SP.DiffuseNormals.Draw(new Rect(122,105,BoxSize.x-124,20),"Disable Normals: ");
			
			if (SP.DiffuseLightingType.Type==2)
				SP.DiffuseSetting1.Draw(new Rect(122,105,BoxSize.x-124,20),"Roughness: ");
				
			if (SP.DiffuseLightingType.Type==3){
				SP.DiffuseSetting1.Draw(new Rect(122,105,BoxSize.x-124,20),"Light Wrap: ");
				SP.DiffuseSetting2.Draw(new Rect(122,130,BoxSize.x-124,20),"Color: ");
			}
			
			GUIConfigureBoxEnd();
			GUI.enabled = true;
			if (SP.IsPBR){
				GUI.enabled = false;
				SP.SpecularOn.On = true;
			}
			
			GUIConfigureBoxStart("Specular (Shine)",SP.SpecularOn,WinSize,1,0);
			
			if (SP.SpecularOn.On==true)
			{
			
			if (SP.IsPBR){
				GUI.enabled = false;
				SP.SpecularLightingType.Type = 0;
			}
			SP.SpecularLightingType.Draw(new Rect(2,30,120,120));
			SU.Label(new Rect(122,30,BoxSize.x-124,70),SP.SpecularLightingType.Descriptions[SP.SpecularLightingType.Type],12);
			if (SP.IsPBR)
				GUI.enabled = true;
			}
			else
			SP.SpecularLightingType.DrawPicType(new Rect(2,30,120,120),SP.DiffuseLightingType.GetImage(0),"Off");
			
			
			SP.SpecularHardness.Range0 = 0.0001f;
			SP.SpecularHardness.Draw(new Rect(122,80,BoxSize.x-124,20),"Size: ");
			if (SP.IsPBR){
				GUI.enabled = false;
				SP.SpecularEnergy.On = true;
			}
			SP.SpecularOffset.Draw(new Rect(122,105,BoxSize.x-124,20),"Offset: ");
			SP.SpecularEnergy.Draw(new Rect(122,130,BoxSize.x-124,20),"Conserve Energy: ");
			if (SP.IsPBR)
				GUI.enabled = true;
			GUIConfigureBoxEnd();
			
			GUIConfigureBoxStart("Emission (Glow)",SP.EmissionOn,WinSize,0,1);

			if (SP.EmissionOn.On){
			SP.EmissionType.Draw(new Rect(2,30,120,120));
			SU.Label(new Rect(122,30,BoxSize.x-124,70),SP.EmissionType.Descriptions[SP.EmissionType.Type],12);
			}
			else
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(3),"Off");
			
			
			
			GUIConfigureBoxEnd();		
			float AThird = (BoxSize.x-122)/3;
			float AHalf = (BoxSize.x-122)/2;			
			GUIConfigureBoxStart("Transparency (See Through)",SP.TransparencyOn,WinSize,1,1);
			
			
			if (SP.TransparencyOn.On){
			SP.TransparencyType.Draw(new Rect(2,30,120,120));
			SU.Label(new Rect(122,30,BoxSize.x-124,70),SP.TransparencyType.Descriptions[SP.TransparencyType.Type],12);
			}
			else
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(2),"Off");

			if (SP.TransparencyType.Type==0)//||(SP.TransparencyZWrite.On&&SP.TransparencyZWriteType.Type==1))
			SP.TransparencyAmount.Draw(new Rect(122,100,BoxSize.x-124,20),"Cutoff: ");
			if (SP.TransparencyType.Type==1)//&&!(SP.TransparencyZWrite.On&&SP.TransparencyZWriteType.Type==1))
			SP.TransparencyAmount.Draw(new Rect(122,100,BoxSize.x-124,20),"Transparency: ");
			
			if (SP.TransparencyZWrite.On&&SP.TransparencyZWriteType.Type==1)
			SP.TransparencyZWriteAmount.Draw(new Rect(122,80,BoxSize.x-124,20),"Cutoff: ");
			
			bool OldGUIEnabled = GUI.enabled;
			
			if (SP.TransparencyType.Type==0){
			GUI.enabled = false;
			SP.TransparencyZWrite.On = false;
			}
			
			SP.TransparencyZWrite.Draw(new Rect(122,125,BoxSize.x-124,20),"Z Write: ");
			
			if (!SP.TransparencyZWrite.On)
			GUI.enabled = false;
			
			SP.TransparencyZWriteType.Draw(new Rect(122+150,125,BoxSize.x-124-150,20),"");
			
			GUI.enabled = OldGUIEnabled;
			
			if (!(SP.IsPBR)||!(SP.TransparencyType.Type==1))
			GUI.enabled = false;
			
			SP.TransparencyPBR.Draw(new Rect(122,150,BoxSize.x-124,20),"Use PBR: ");
			
			GUI.enabled = OldGUIEnabled;
			
			if (!(SP.TransparencyType.Type==1))
			GUI.enabled = false;
			
			GUI.Label(new Rect(122+150,150,AHalf,20),"Blend: ");
			SP.BlendMode.Draw(new Rect(122+200,150,BoxSize.x-(122+202),20),"Blend Modes: ");
			
			GUI.enabled = OldGUIEnabled;
			//SP.TransparencyReceive.Draw(new Rect(122+150,125,BoxSize.x-124,20),"Recieve Shadows: ");
			//if (SP.TransparencyReceive.On)
			//SP.TransparencyPBR.On = false;
			
			GUIConfigureBoxEnd();
			
			GUIConfigureBoxStart("Shells (Fur/Grass)",SP.ShellsOn,WinSize,0,2);
			
			if (SP.ShellsOn.On){
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(5),"On",false);
			//SU.Label(new Rect(122,30,BoxSize.x-124,70),SP.TransparencyType.Descriptions[SP.TransparencyType.Type],12);
			}
			else
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(4),"Off",false);		

			//ShellsScroll = ShaderUtil.BeginScrollView(new Rect(122,30,BoxSize.x-122,BoxSize.y-30),ShellsScroll,new Rect(122,30,BoxSize.x-122-15,BoxSize.y-30+50),false,false);
			//BoxSize.x-=15;
			ShaderUtil.BeginGroup(new Rect(0,-20,BoxSize.x,BoxSize.y+50));
			SP.ShellsCount.Draw(new Rect(122,70,BoxSize.x-124,20),"Shell Count: ");
			SP.ShellsCount.NoInputs=true;
			SP.ShellsDistance.Draw(new Rect(122,95,BoxSize.x-124,20),"Distance: ");
			SP.ShellsCount.Float = Mathf.Round(SP.ShellsCount.Float);
			SP.ShellsEase.Draw(new Rect(122,120,BoxSize.x-124,20),"Ease: ");
			SP.ShellsEase.Range0 = 0f;
			SP.ShellsEase.Range1 = 3f;
			

			//SP.ShellsZWrite.LabelOffset = (int)AThird;
			//SP.ShellsFront.LabelOffset = (int)AThird;
			//SP.ShellsZWrite.Draw(new Rect(122+AThird,125,AThird,20),"Z Write: ");
			SP.ShellsFront.Draw(new Rect(122,145,BoxSize.x-124,20),"In-Front: ");
			SP.ShellsSkipFirst.Draw(new Rect(122,170,BoxSize.x-124,20),"Skip First: ");
			ShaderUtil.EndGroup();
			//ShaderUtil.EndScrollView();
			//BoxSize.x+=15;
			GUIConfigureBoxEnd();
			
			GUIConfigureBoxStart("POM (Fake Parallax)",SP.ParallaxOn,WinSize,1,2);
			
			//Debug.Log(SP.OtherTypes.GetImage(0));
			if (SP.ParallaxOn.On==true&&SP.ParallaxHeight.Float>0)
			{
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(1),"On");
			}
			else
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(0),"Off");
			
			SP.ParallaxHeight.Range1 = 0.4f;
			SP.ParallaxHeight.Draw(new Rect(122,40,BoxSize.x-124,20),"Height: ");
			SP.ParallaxBinaryQuality.NoInputs = true;
			SP.ParallaxBinaryQuality.Draw(new Rect(122,65,BoxSize.x-124,20),"Quality: ");
			SP.ParallaxBinaryQuality.Float = Mathf.Round(SP.ParallaxBinaryQuality.Float);
			SP.ParallaxSilhouetteClipping.Draw(new Rect(122,90,BoxSize.x-124,20),"Edge Clipping: ");
			
			GUI.Box(new Rect(120,110,BoxSize.x-120,BoxSize.y-112),"");
			SP.ParallaxShadows.Draw(new Rect(122,112,BoxSize.x-124,20),"Shadows: ");
			OldGUIEnabled = GUI.enabled;
			GUI.enabled = SP.ParallaxShadows.On;
			SP.ParallaxShadowStrength.Draw(new Rect(142,132,BoxSize.x-144,20),"Strength: ");
			SP.ParallaxShadowSize.Draw(new Rect(142,152,BoxSize.x-144,20),"Size: ");
			GUI.enabled = OldGUIEnabled;
			//GUI.Label(new Rect(2,100,BoxSize.x-4,20),"Silhouette Clipping: ");		
			//SP.ParallaxSilhouetteClipping = GUI.Toggle(new Rect(162,100,BoxSize.x-164,20),SP.ParallaxSilhouetteClipping,"");		
			
			GUIConfigureBoxEnd();
			EditorGUI.BeginChangeCheck ();
			if (SP.TechShaderTarget.Float<=4)
			SP.TessellationOn.On = false;
			
			GUIConfigureBoxStart("Tessellation (Subdivision-ish)",SP.TessellationOn,WinSize,0,3);
			if (EditorGUI.EndChangeCheck ()&&SP.TechShaderTarget.Float<=4){
				if (SP.TessellationOn.On){
					if (!EditorUtility.DisplayDialog("Enable Shader Model 5?","Tessellation requires Shader Model 5. Turning this on will force the Shader Model to 5, however to see it work you'll need to enable DX11; you can do this from the Unity Player Settings. As this is a DX11 only feature it will limit what computers your shaders work on (including possibly your own). You can lower the Shader Model within the Misc settings.","Ok, enable it!","Oh, ok don't.")){
						PlayerSettings.useDirect3D11 = true;
						SP.TessellationOn.On = false;
					}else{
						SP.TechShaderTarget.Float = 5;
					}
				}
			}
			
			//Debug.Log(SP.OtherTypes.GetImage(0));
			if (SP.TessellationOn.On==true&&SP.TessellationQuality.Float>0)
			{
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(7),"On");
			}
			else
			SP.OtherTypes.DrawPicType(new Rect(2,30,120,120),SP.OtherTypes.GetImage(6),"Off");
			
			SP.TessellationQuality.Draw(new Rect(122,30,BoxSize.x-124,20),"Quality: ");
			
			OldGUIEnabled = GUI.enabled;
			
			if (SP.TessellationType.Type<1)
			GUI.enabled = false;
			SP.TessellationFalloff.Draw(new Rect(122,55,BoxSize.x-124,20),"Falloff: ");
			
			GUI.enabled = OldGUIEnabled;
			
			EditorGUI.BeginChangeCheck();
			SP.TessellationType.Draw(new Rect(122,105,BoxSize.x-124,20),"Type: ");
			if (EditorGUI.EndChangeCheck()){
				if (SP.TessellationType.Type==0)
				SP.TessellationQuality.Float = 3;
			}
			//SP.ParallaxBinaryQuality.Draw(new Rect(122,75,BoxSize.x-124,20),"Quality: ");
			//SP.ParallaxBinaryQuality.Float = Mathf.Round(SP.ParallaxBinaryQuality.Float);
			SP.TessellationSmoothingAmount.Draw(new Rect(122,80,BoxSize.x-124,20),"Smoothing: ");
			
			SP.TessellationTopology.Draw(new Rect(122,155,BoxSize.x-124,20),"Topology: ");
			//GUI.Label(new Rect(2,100,BoxSize.x-4,20),"Silhouette Clipping: ");		
			//SP.ParallaxSilhouetteClipping = GUI.Toggle(new Rect(162,100,BoxSize.x-164,20),SP.ParallaxSilhouetteClipping,"");		
			
			GUIConfigureBoxEnd();
			AThird = (BoxSize.x-10)/3;
			AHalf = (BoxSize.x-10)/2;
			GUIConfigureBoxStart("Misc",null,WinSize,1,3);
			
			SP.TechZTest.Draw(new Rect(10,50,BoxSize.x-20,20),"ZTest: ");
			
			SP.TechShaderTarget.NoInputs = true;
			SP.TechShaderTarget.Range0 = 2;
			SP.TechShaderTarget.Range1 = 5;
			SP.TechShaderTarget.Float = Mathf.Round(SP.TechShaderTarget.Float);
			SP.TechShaderTarget.LabelOffset = 100;
			SP.TechShaderTarget.Draw(new Rect(20+AHalf,25,AHalf-20,20),"Shader Model: ");
			
			SP.MiscAmbient.LabelOffset = (int)AThird;
			SP.MiscVertexLights.LabelOffset = (int)AThird;
			SP.MiscLightmap.LabelOffset = (int)AThird;
			SP.MiscFog.LabelOffset = (int)AThird;
			SP.MiscFullShadows.LabelOffset = (int)AThird;
			SP.MiscInterpolateView.LabelOffset = (int)AThird;
			SP.MiscRecalculateAfterVertex.LabelOffset = (int)AThird;
			SP.MiscShadows.LabelOffset = (int)AThird;
			SP.MiscForwardAdd.LabelOffset = (int)AThird;
			
			SP.TechCull.Draw(new Rect(10,75,BoxSize.x-20,20),"Cull: ");
			SP.MiscAmbient.Draw(new Rect(10,100,AThird,20),"Ambient: ");
			SP.MiscVertexLights.Draw(new Rect(10,125,AThird,20),"Vertex Lights: ");
			SP.MiscLightmap.Draw(new Rect(10+AThird,100,AThird,20),"Lightmaps: ");
			SP.MiscFog.Draw(new Rect(10+AThird,125,AThird,20),"Fog: ");
			SP.MiscInterpolateView.Draw(new Rect(10+AThird*2,100,AThird,20),"Interpolate View: ");
			SP.MiscRecalculateAfterVertex.Draw(new Rect(10+AThird*2,125,AThird,20),"Recalc after Vertex: ");
			
			SP.MiscShadows.Draw(new Rect(10,150,AThird,20),"Shadows: ");
			
			OldGUIEnabled = GUI.enabled;
			GUI.enabled = SP.MiscShadows.On;
			if (!SP.MiscShadows.On)
			SP.MiscFullShadows.On = false;
			
			SP.MiscFullShadows.Draw(new Rect(10+AThird,150,AThird,20),"Forward Shadows: ");
			GUI.enabled = OldGUIEnabled;
			SP.MiscForwardAdd.Draw(new Rect(10+AThird*2,150,AThird,20),"Forward Add: ");
			GUIConfigureBoxEnd();
			
			//GUIConfigureBoxStart("Misc",ref ShaderSandwich.Instance.OpenShader.SpecularOn,WinSize,0,3);
			
			//GUIConfigureBoxEnd();
			
			ShaderUtil.EndScrollView();
			
			//GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
			//ButtonStyle.fontSize = 20;
			//if ((Event.current.type == EventType.MouseMove))
			//Debug.Log((Event.current.type == EventType.MouseMove));
			
			if (CurInterfaceStyle!=InterfaceStyle.Modern){
				if ((Event.current.type == EventType.MouseMove))
				GUI.Toggle( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),true,"Layers",ButtonStyle);
				else
				GUI.Toggle( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),false,"Layers",ButtonStyle);
			}
			//GUI.Toggle( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),GUIMouseHold&&(ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30).Contains(Event.current.mousePosition)),"Layers",ButtonStyle);
			
			//(ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30).Contains(Event.current.mousePosition))
			//Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);				
			ShaderUtil.EndGroup();	
			
			ChangeSaveTemp(null);
		}
	}
	static public bool GUIMouseDown = false;
	static public bool GUIMouseUp = false;
	static public bool GUIMouseHold = false;
	void GUIStart(Vector2 WinSize,Vector2 Position)
	{
		ShaderVarEditing = null;
		ShaderUtil.BeginGroup(new Rect(Position.x,Position.y,WinSize.x,WinSize.y));
		float BannerHeight = (144f/1006f)*WinSize.x;
		if (CurInterfaceStyle==InterfaceStyle.Modern){
			if (ShaderUtil.GetVal(InterfaceColor)<0.5)
			GUI.DrawTexture(new Rect(00,0,WinSize.x,BannerHeight), Banner, ScaleMode.ScaleToFit);
			else
			GUI.DrawTexture(new Rect(00,0,WinSize.x,BannerHeight), BannerLight, ScaleMode.ScaleToFit);
		}
		else{
			GUI.DrawTexture(new Rect(00,20,WinSize.x,BannerHeight), Banner, ScaleMode.ScaleToFit);
			BannerHeight+=20;
			BannerHeight+=24;
		}
		BannerHeight+=8;
		
		GUIStyle LabelStyle = new GUIStyle(GUI.skin.box);
		LabelStyle.alignment = TextAnchor.UpperLeft;
		LabelStyle.richText = true;
		GUIStyle ButtonStyle2;
		if (CurInterfaceStyle==InterfaceStyle.Modern){
			ButtonStyle2 = new GUIStyle(ShaderSandwich.SCSkin.window);
			ButtonStyle2.alignment = TextAnchor.UpperLeft;
		}
		else{
			ButtonStyle2 = new GUIStyle(GUI.skin.button);
			ButtonStyle2.alignment = TextAnchor.MiddleLeft;
		}
		
		if (CurInterfaceStyle==InterfaceStyle.Modern){
			ButtonStyle2.fontSize = (int)((float)ShaderSandwich.Instance.InterfaceSize*1.4f);
			float RecentlyOpenedSize = WinSize.x/2;//-300;
			GUI.Box(new Rect(0,BannerHeight,RecentlyOpenedSize,WinSize.y-BannerHeight),"");
			
			ShaderUtil.SetLabelSize(14);
			int BoxHeight = ButtonStyle2.fontSize+GUI.skin.label.fontSize+10;
			int Y = 0;
			
			GUI.Box(new Rect(WinSize.x-(WinSize.x-RecentlyOpenedSize+1),BannerHeight+BoxHeight,WinSize.x-RecentlyOpenedSize+1,WinSize.y-BannerHeight-BoxHeight),MOTD,LabelStyle);
			
			ButtonStyle2.alignment = TextAnchor.MiddleLeft;
			//if (GUI.Button(new Rect(0,(BannerHeight)+Y,RecentlyOpenedSize,BoxHeight),"New Shader!",ButtonStyle2 )){
			//	NewAdvanced();
			//}
			GUI.Box(new Rect(-1,BannerHeight+Y,WinSize.x+2,BoxHeight),"","box");
			
			int MenuWidth = 150;
			int MenuItemWidth = 75;
			int MenuCenter = (int)(WinSize.x/2);
			//MenuCenter = (int)((WinSize.x-300)/2);
			
			ButtonStyle2.normal.textColor = ShaderUtil.SetVal(InterfaceColor,1f);
			ButtonStyle2.active.textColor = ShaderUtil.SetVal(InterfaceColor,1f);
			ButtonStyle2.hover.textColor = ShaderUtil.SetVal(InterfaceColor,1f);
			if (GUI.Button(new Rect(MenuCenter-MenuWidth-MenuItemWidth/2,BannerHeight+Y+5,MenuItemWidth,BoxHeight-10),new GUIContent("New!",Plus),ButtonStyle2)){
				NewAdvanced();
			}
			if (GUI.Button(new Rect(MenuCenter-MenuItemWidth/2,BannerHeight+Y+5,MenuItemWidth,BoxHeight-10),new GUIContent("Open",ReloadIcon),ButtonStyle2)){
				Load();
				Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
			}
			if (GUI.Button(new Rect(MenuCenter+MenuWidth-MenuItemWidth/2,BannerHeight+Y+5,MenuItemWidth,BoxHeight-10),new GUIContent("Help!",Warning),ButtonStyle2)){
				OpenHelp();
			}
			
			ButtonStyle2.alignment = TextAnchor.UpperLeft;
						
			Y += BoxHeight;
			
			//if (GUI.Button(new Rect(0,(BannerHeight)+Y,RecentlyOpenedSize,BoxHeight),"Continue",ButtonStyle2 ))
			//Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
			
			//Y += BoxHeight;
			int Count = 0;
			foreach(string File in SSSettings.RecentFilesList){
				if (File!=""&&File!=null){
					Shader TheActualFile = null;
					//try{
						TheActualFile = ((Shader)AssetDatabase.LoadAssetAtPath(File,typeof(Shader)));
					//}catch{};
					if (TheActualFile!=null){
						FileInfo file = new FileInfo(Application.dataPath+File);
						string ShortPath = TheActualFile.name.Substring(Math.Max(0,TheActualFile.name.LastIndexOf("/")+1));
						if (GUI.Button(new Rect(0,(BannerHeight)+Y,RecentlyOpenedSize,BoxHeight),ShortPath,ButtonStyle2 )){
							Load(File);
							Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
						}
						
						ShaderUtil.Label(new Rect(10,(BannerHeight)+Y+BoxHeight-GUI.skin.label.fontSize-5,RecentlyOpenedSize,BoxHeight),TheActualFile.name+" - "+file.Name,14);
						Y+=BoxHeight;
						Count++;
					}
				}
			}
			if (Count==0){
				GUI.Button(new Rect(0,(BannerHeight)+Y,RecentlyOpenedSize,BoxHeight),"No Recent Files!",ButtonStyle2 );
				
				ShaderUtil.Label(new Rect(10,(BannerHeight)+Y+BoxHeight-GUI.skin.label.fontSize-5,RecentlyOpenedSize,BoxHeight),"Come on, get to it! :)",14);
			}
			GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
			ButtonStyle.fontSize = 20;
			if (CurInterfaceStyle!=InterfaceStyle.Modern)
			if (OpenShader!=null)
			if (GUI.Button( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),"Layers",ButtonStyle))
			Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
		}
		else{
		int RecentlyOpenedSize = (int)(WinSize.x/3.5714f);//210;
		if (!SSSettings.HasAny())
			GUI.Box(ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,RecentlyOpenedSize,WinSize.y-(BannerHeight)),"Recently Opened\n__________________________\n - None, get to it already! :)",LabelStyle);
		else{
			GUI.Box(ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,RecentlyOpenedSize,WinSize.y-(BannerHeight)),"Recently Opened\n__________________________",LabelStyle);
			int Y = 0;
			foreach(string File in SSSettings.RecentFilesList){
				if (File!=""&&File!=null){
					Shader TheActualFile = null;
					//try{
						TheActualFile = ((Shader)AssetDatabase.LoadAssetAtPath(File,typeof(Shader)));
					//}catch{};
					if (TheActualFile!=null){
						FileInfo file = new FileInfo(Application.dataPath+File);
						if (GUI.Button(new Rect(10,(BannerHeight)+Y+30,RecentlyOpenedSize-10,20),TheActualFile.name+"("+file.Name+")",ButtonStyle2 )){
							Load(File);
							Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
						}
						Y+=20;
					}
				}
			}
			if (GUI.Button(ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,RecentlyOpenedSize,20),"Clear"))
			SSSettings.RecentFiles = null;
		}
		
		
		GUI.Box(ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,RecentlyOpenedSize,WinSize.y-(BannerHeight)),MOTD,LabelStyle);
		
		float ButtonOrder = 0;
		int ButtonWidth = (int)((float)RecentlyOpenedSize*0.85f);
		if (OpenShader!=null)
		{
			if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+ButtonOrder*28f,ButtonWidth,24),"Continue"))
			Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
			
			ButtonOrder+=1;
			
			if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+ButtonOrder*28f,ButtonWidth,24),"Save As"))
			{
				SaveAs();
			}
			ButtonOrder+=2;
		}
		
		if(StartNewTrans.Get()!=0)
		{
			GUI.color = new Color(GUI.color.r,GUI.color.g,GUI.color.b,StartNewTrans.Get());
			if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+(StartNewTrans.Get()*28f)+ButtonOrder*28f,ButtonWidth/1.25f,24),"Start from Scratch!"))
			{
				NewAdvanced();
			}
			
			if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+(StartNewTrans.Get()*56f)+ButtonOrder*28f,ButtonWidth/1.25f,24),"Start from a Preset!"))
			{
				NewSimple();
			}
			
			GUI.color = new Color(GUI.color.r,GUI.color.g,GUI.color.b,1);
		}
		
		
		if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+ButtonOrder*28f,ButtonWidth,24),"New Shader"))
		//NewAdvanced();
		StartNewTrans.Start(ShaderTransition.TransDir.Reverse);
		
		ButtonOrder+=1;
		if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+ButtonOrder*28f+(StartNewTrans.Get()*56f),ButtonWidth,24),"Open Shader"))
		{
			Load();
			Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
		}
		
		ButtonOrder+=1;
		//GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+ButtonOrder*28f+(StartNewTrans.Get()*56f),ButtonWidth,24),"Get Shaders");
		
		ButtonOrder=8;
		if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+ButtonOrder*28f,ButtonWidth,24),"Help!")){
			OpenHelp();
		}
		//if (GUI.Button( ShaderUtil.Rect2(RectDir.MiddleTop,WinSize.x/2f,BannerHeight+84f+(StartNewTrans.Get()*56f),150,24),"Temp Config"))
		//Goto(GUIType.Configure,ShaderTransition.TransDir.Forward);
		
		GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
		ButtonStyle.fontSize = 30;
		}
		//if (GUI.Button( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,210,50),"New Shader",ButtonStyle))
		//Goto(GUIType.Presets,ShaderTransition.TransDir.Forward);
		
		ShaderUtil.EndGroup();	
	}
	void Goto(GUIType GUI,ShaderTransition.TransDir dir)
	{
		//if (GUI==GUIType.Presets)
		//GUI = GUIType.Layers;
		GUITrans.Start(dir);
		GUITransition = GUI;
		if (GUI == GUIType.Start)
		{
			StartNewTrans.Reset();
		}
	}
	public void CorrectAllLayers(){
		foreach(ShaderLayer SL in ShaderUtil.GetAllLayers()){
			SL.BugCheck();
		}
	}

	bool GUILayersBox(ShaderLayerList list, int X,Vector2 WinSize,GUIStyle ButtonStyle){
		list.FixParents();
		WinSize.y-=30;
		int HeightOfLayerName = 48;
		if (CurInterfaceStyle==InterfaceStyle.Modern)
			HeightOfLayerName = 26;
			
		int WidthOfAdd = 32;
		if (CurInterfaceStyle==InterfaceStyle.Modern)
			WidthOfAdd = 24;
		
		ShaderUtil.BeginGroup(new Rect(150*X,30,150,WinSize.y));
		GUI.Box(new Rect(0,0,150,WinSize.y),"",ButtonStyle);
		list.Scroll = ShaderUtil.BeginScrollView(new Rect(0,HeightOfLayerName,150,WinSize.y-HeightOfLayerName-100-WidthOfAdd),list.Scroll,new Rect(0,0,130,list.Count*110-10),false,false);

			
			
			int Pos = -1;

			bool Hit = false;
			list.LayerCatagory = list.Name.Text;
			foreach(ShaderLayer SL in list)
			{
				//if (Event.current.type==EventType.Repaint)
				//ShaderUtil.BeginGroup(new Rect(-9000,0,0,0));
				//SL.DrawGUI();
				//ShaderUtil.EndGroup();
				
				if (SL.Name.Text=="")
				SL.Name.Text = SL.GetLayerCatagory();
				if (SL.BugCheck())
				ChangeSaveTemp(SL);
				Pos+=1;
				bool OldGUIChanged = GUI.changed;
				
				if ((Pos*110+80-list.Scroll.y)>0&&(Pos*110-list.Scroll.y<(WinSize.y-150))){
					if ((X)==LayerSelection.x&&(Pos)==LayerSelection.y)
					{
						SL.DrawIcon(new Rect(30-(15),Pos*110,90,90),true);
						
					}
					else
					{
						if (SL.DrawIcon(new Rect(30-(15),Pos*110,90,90),false)){
							LayerSelection = new Vector2(X,Pos);
							ShaderUtil.Defocus();
						}
					}
				}
				GUI.skin.label.alignment = TextAnchor.LowerCenter;
				if (ViewLayerNames)
				ShaderUtil.Label(new Rect(30-(15),Pos*110,90,90),SL.Name.Text,11);
				GUI.skin.label.alignment = TextAnchor.UpperLeft;
				GUI.changed = OldGUIChanged;
				if (Event.current.type == EventType.MouseDown && new Rect(30-(15),Pos*110,90,90).Contains(Event.current.mousePosition))
				Hit = true;
				
				if (Pos==0)
				GUI.enabled = false;
				ShaderUtil.MakeTooltip(0,new Rect(120-(15),Pos*110,30,30),"Move Layer Up");
				if (GUI.Button(new Rect(120-(15),Pos*110,30,30),new GUIContent(UPArrow)))
				{
					list.MoveItem(Pos,Pos-1);//MoveLayerUp = Pos;
					list.UpdateIcon(new Vector2(70,70));
					ChangeSaveTemp(null);
					//RegenShaderPreview();
					EditorGUIUtility.ExitGUI();
				}
				GUI.enabled = true;
				ShaderUtil.MakeTooltip(0,new Rect(120-(15),Pos*110+30,30,30),"Delete Layer");
				if (GUI.Button(new Rect(120-(15),Pos*110+30,30,30),new GUIContent(CrossRed)))
				{
					list.RemoveAt(Pos);
					UEObject.DestroyImmediate(SL,false);
					list.UpdateIcon(new Vector2(70,70));
					ChangeSaveTemp(null);
					//RegenShaderPreview();
					EditorGUIUtility.ExitGUI();
				}
				if (Pos>=list.Count-1)
				GUI.enabled = false;
				ShaderUtil.MakeTooltip(0,new Rect(120-(15),Pos*110+60,30,30),"Move Layer Down");
				if (GUI.Button(new Rect(120-(15),Pos*110+60,30,30),new GUIContent(DOWNArrow,"Move Layer Down")))
				{
					//Pos2+=1;	
					list.MoveItem(Pos,Pos+1);//MoveLayerDown = Pos;
					list.UpdateIcon(new Vector2(70,70));
					ChangeSaveTemp(null);
					//RegenShaderPreview();
					EditorGUIUtility.ExitGUI();
				}
				GUI.enabled = true;
				
				//GUI.Label(new Rect(30,48+Pos*110+75,60,30),"Editor: ");
				//GUI.color = new Color(1f,1f,1f,1f);
				//GUI.backgroundColor = new Color(1f,1f,1f,1f);
				//SL.LayerType.UseInput = GUI.Toggle(new Rect(80,48+Pos*110+75,30,30),SL.LayerType.UseInput,"");
				
				//GUI.color = oldCol;
				//GUI.backgroundColor = oldColB;
			}

			
			
			

			
		ShaderUtil.EndScrollView();
			
			GUI.Box(new Rect(0,0,150,HeightOfLayerName),"",ButtonStyle);
			if (OpenShader.ShaderLayersMasks.Contains(list)){
				if(CurInterfaceStyle==InterfaceStyle.Modern)
				list.Name.Text = GUI.TextField(new Rect(10,0,150-20,HeightOfLayerName),list.Name.Text,ButtonStyle);
				else
				list.Name.Text = GUI.TextField(new Rect(10,10,150-20,HeightOfLayerName-20),list.Name.Text,ButtonStyle);
			}
			else
			GUI.Label(new Rect(0,0,150,HeightOfLayerName),list.Name.Text,ButtonStyle);
			
			if (list.Count==0){
				if(CurInterfaceStyle==InterfaceStyle.Modern)
					ShaderUtil.Label(new Rect(5,24,150,100),list.Description,12);
				else
					ShaderUtil.Label(new Rect(5,48,150,100),list.Description,12);
			}
			
			GUI.Box(ShaderUtil.Rect2(RectDir.Diag,150,WinSize.y-100,150,WidthOfAdd),"");
			ShaderUtil.MakeTooltip(0,ShaderUtil.Rect2(RectDir.Diag,150,WinSize.y-100,WidthOfAdd,WidthOfAdd),"Add Layer");
			if (GUI.Button(ShaderUtil.Rect2(RectDir.Diag,150,WinSize.y-100,WidthOfAdd,WidthOfAdd),new GUIContent(Plus,"Add Layer"))){
				ShaderLayer Sl = ShaderLayer.CreateInstance<ShaderLayer>();
				list.Add(Sl);
				if (list.CodeName == "d.Normal"){
					//ShaderUtil.SetupCustomData(Sl.CustomData,ShaderSandwich.PluginList["LayerType"][Sl.RealLayerType.Text].GetInputs());
					Sl.CustomData.D["Color"] = new ShaderVar("Color",new Vector4(0f,0f,1f,1f));
				}
				LayerSelection = new Vector2(X,list.Count-1);
			}
			if (OpenShader.ShaderLayersMasks.Contains(list)||list==OpenShader.ShaderLayersMaskTemp){
				int ColorSelection = 0;
				if (list.EndTag.Text=="r")
				ColorSelection = 0;
				if (list.EndTag.Text=="g")
				ColorSelection = 1;
				if (list.EndTag.Text=="b")
				ColorSelection = 2;
				if (list.EndTag.Text=="a")
				ColorSelection = 3;
				if (list.EndTag.Text=="rgba")
				ColorSelection = 4;
				string[] ColorTag = new string[]{"Red","Green","Blue",
				"Alpha","RGBA"};
				string[] ColorTag2 = new string[]{"r","g","b",
				"a","rgba"};
					/*if (GUI.Button(ShaderUtil.Rect2(RectDir.Bottom,1,WinSize.y-100,(150-33)/2,32),ColorTag[ColorSelection],"button")){
						GenericMenu toolsMenu = new GenericMenu();
						toolsMenu.AddItem(new GUIContent("Red"), false, MashMakeRed,list);
						toolsMenu.AddItem(new GUIContent("Green"), false, MashMakeGreen,list);
						toolsMenu.AddItem(new GUIContent("Blue"), false, MashMakeBlue,list);
						toolsMenu.AddItem(new GUIContent("Alpha"), false, MashMakeAlpha,list);
						toolsMenu.AddItem(new GUIContent("RGBA"), false, MashMakeRGBA,list);
						toolsMenu.DropDown(new Rect(Event.current.mousePosition.x, Event.current.mousePosition.y, 0, 0));
						list.UpdateIcon(new Vector2(70,70));
						ChangeSaveTemp(null);
						EditorGUIUtility.ExitGUI();
					}*/
					//VertexMask.Float = (float)(int)(VertexMasks)EditorGUI.EnumPopup(new Rect(0,YOffset,250,20)," ",(VertexMasks)(int)VertexMask.Float,ShaderUtil.EditorPopup);
					EditorGUI.BeginChangeCheck();
					ShaderUtil.MakeTooltip(0,new Rect(23+26+26,WinSize.y-124,100-23-26-26+28,24),"The channel the mask uses.");
					ColorSelection = EditorGUI.IntPopup(new Rect(23+26+26,WinSize.y-124,100-23-26-26+28,24),ColorSelection,ColorTag,new int[]{0,1,2,3,4},"button");
					if (EditorGUI.EndChangeCheck()){
						list.UpdateIcon(new Vector2(70,70));
						ChangeSaveTemp(null);
						list.EndTag.Text = ColorTag2[ColorSelection];
					}
					/*ShaderUtil.MakeTooltip(0,new Rect(0,WinSize.y-132,32,32),"Set the mask to be a lighting mask.");
					EditorGUI.BeginChangeCheck();
					GUI.Toggle(new Rect(0,WinSize.y-132,32,32),list.IsLighting.On,list.IsLighting.On?LightBulbOn:LightBulbOff,ButtonStyle);
					if (EditorGUI.EndChangeCheck())
					{
						if (EditorUtility.DisplayDialog(list.IsLighting.On?"Switch back to normal mask?":"Switch to lighting mask?", "Switching between normal and lighting masks will remove all layers within the mask. Are you sure you want to do this?", "Yes", "No")){
							list.SLs.Clear();
							list.IsLighting.On = !list.IsLighting.On;
							//OpenShader.ShaderLayersMasks.Remove(list);
							CorrectAllLayers();
							list.UpdateIcon(new Vector2(70,70));
							ChangeSaveTemp(null);
							EditorGUIUtility.ExitGUI();
						}
					}*/
					ShaderUtil.MakeTooltip(0,new Rect(0,WinSize.y-124,24,24),"Delete the Mask (You can't undo this!).");
					if (GUI.Button(new Rect(0,WinSize.y-124,24,24),CrossRed))
					{
						if (EditorUtility.DisplayDialog("Delete Mask?", "Are you sure you want to delete this mask? It can't be undone!", "Yes", "No")){
							OpenShader.ShaderLayersMasks.Remove(list);
							CorrectAllLayers();
							ChangeSaveTemp(null);
							EditorGUIUtility.ExitGUI();
						}
					}
					ShaderUtil.MakeTooltip(0,new Rect(23,WinSize.y-124,27,24),"Move the mask to the left.");
					if (GUI.Button(new Rect(23,WinSize.y-124,27,24),LeftArrow))
					{
						ShaderUtil.MoveItem(ref OpenShader.ShaderLayersMasks,OpenShader.ShaderLayersMasks.IndexOf(list),OpenShader.ShaderLayersMasks.IndexOf(list)-1);
						CorrectAllLayers();
						ChangeSaveTemp(null);
						EditorGUIUtility.ExitGUI();
					}
					ShaderUtil.MakeTooltip(0,new Rect(23+26,WinSize.y-124,27,24),"Move the mask to the right.");
					if (GUI.Button(new Rect(23+26,WinSize.y-124,27,24),RightArrow))
					{
						ShaderUtil.MoveItem(ref OpenShader.ShaderLayersMasks,OpenShader.ShaderLayersMasks.IndexOf(list),OpenShader.ShaderLayersMasks.IndexOf(list)+1);
						CorrectAllLayers();
						ChangeSaveTemp(null);
						EditorGUIUtility.ExitGUI();
					}
			}
			else
			if (list.EndTag.Text.Length==1){//||OpenShader.ShaderLayersMasks.Contains(list)){
				int ColorSelection = 0;
				if (list.EndTag.Text=="r")
				ColorSelection = 0;
				if (list.EndTag.Text=="g")
				ColorSelection = 1;
				if (list.EndTag.Text=="b")
				ColorSelection = 2;
				if (list.EndTag.Text=="a")
				ColorSelection = 3;
				string[] ColorTag = new string[]{"r","g","b",
				"a"};
				string OldEndTag = list.EndTag.Text;
				if (CurInterfaceStyle == InterfaceStyle.Modern)
				list.EndTag.Text = ColorTag[GUI.SelectionGrid(ShaderUtil.Rect2(RectDir.Bottom,1,WinSize.y-100,150-33,24),ColorSelection,new string[]{"R","G","B","A"},4)];
				else
				list.EndTag.Text = ColorTag[GUI.SelectionGrid(ShaderUtil.Rect2(RectDir.Bottom,1,WinSize.y-100,150-33,32),ColorSelection,new string[]{"R","G","B","A"},4)];
				
				if (list.EndTag.Text!=OldEndTag)
					list.UpdateIcon(new Vector2(70,70));
			}

		if (CurInterfaceStyle==InterfaceStyle.Flat)
		GUI.Box(ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,150,100),"");//,ButtonStyle);
		else
		GUI.Box(ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,150,100),"",ButtonStyle);
		if (CurInterfaceStyle==InterfaceStyle.Modern)
		ShaderUtil.MakeTooltip(0,new Rect(150-16,WinSize.y-16,16,16),"Reload layer preview (In case it hasn't updated).");
		else
		ShaderUtil.MakeTooltip(0,new Rect(150-16,WinSize.y-100,16,16),"Reload layer preview (In case it hasn't updated).");
		GUIStyle ButtonStyle2 = new GUIStyle(ButtonStyle);
		ButtonStyle2.padding = new RectOffset(2,2,2,2);
		ButtonStyle2.margin = new RectOffset(2,2,2,2);
		if (CurInterfaceStyle==InterfaceStyle.Modern){
			if (GUI.Button(new Rect(150-16,WinSize.y-16,16,16),ReloadIcon,ButtonStyle2))
				GUI.changed = true;
		}
		else
		if (GUI.Button(new Rect(150-16,WinSize.y-100,16,16),ReloadIcon,ButtonStyle2))
			GUI.changed = true;
			
		list.DrawIcon(ShaderUtil.Rect2(RectDir.Bottom,25+15,WinSize.y-15,100-30,100-30),GUI.changed);
		if (Event.current.button == 1&&ShaderUtil.MouseDownIn(new Rect(0,0,ShaderUtil.GetGroupRect().width,ShaderUtil.GetGroupRect().height-100-30)) ){
			GenericMenu toolsMenu = new GenericMenu();
			toolsMenu.AddItem(new GUIContent("Paste"), false, LayerPaste,list);
			toolsMenu.DropDown(new Rect(Event.current.mousePosition.x, Event.current.mousePosition.y, 0, 0));
			EditorGUIUtility.ExitGUI();					
		}							
		ShaderUtil.EndGroup();

		return Hit;
	}
	public void MashMakeRed(object List){((ShaderLayerList)List).EndTag.Text = "r";}
	public void MashMakeGreen(object List){((ShaderLayerList)List).EndTag.Text = "g";}
	public void MashMakeBlue(object List){((ShaderLayerList)List).EndTag.Text = "b";}
	public void MashMakeAlpha(object List){((ShaderLayerList)List).EndTag.Text = "a";}
	public void MashMakeRGBA(object List){((ShaderLayerList)List).EndTag.Text = "rgba";}
	Dictionary<string,bool> InputSwitch;
	void GUIInputs(Vector2 WinSize,Vector2 Position)
	{
		ShaderUtil.BeginGroup(new Rect(Position.x,Position.y,WinSize.x,WinSize.y));
		if (OpenShader==null)
		{
			GUIStage = GUIType.Start;
			GUITrans.Reset();
		}
		else
		{
		if (InputSwitch==null||InputSwitch.Count!=6){
			InputSwitch = new Dictionary<string,bool>();
			InputSwitch.Add("Type",false);
			InputSwitch.Add("Type2",false);
			InputSwitch.Add("Name",false);
			InputSwitch.Add("In Editor",false);
			InputSwitch.Add("Replacement",false);
			InputSwitch.Add("Value",false);
		}
		
		
		GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
		ButtonStyle.fontSize = 20;
		if (CurInterfaceStyle!=InterfaceStyle.Modern)
		if (GUI.Button( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),"Layers",ButtonStyle))
			Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
		
//		int XX;
//		int YY;
		int X = -1;
//		int PerWidth = 3;
		GUI.skin.GetStyle("ButtonLeft").alignment = TextAnchor.MiddleLeft;
		GUI.skin.GetStyle("ButtonRight").alignment = TextAnchor.MiddleLeft;
		GUI.skin.GetStyle("ButtonMid").alignment = TextAnchor.MiddleLeft;
		
		//SeeShells = !GUI.Toggle(new Rect(251,10,100,25),!SeeShells,new GUIContent("Base",IconBase),GUI.skin.GetStyle("ButtonLeft"));
		//bool GUIChanged = GUI.changed;
		if (GUI.Button(new Rect(20,6,100,25),new GUIContent("Type"),GUI.skin.GetStyle("ButtonLeft"))){
			if (!InputSwitch["Type"])
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderBy(o=>o.Type).ToList();
			else
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderByDescending(o=>o.Type).ToList();
			InputSwitch["Type"] = !InputSwitch["Type"];
		}
		if (GUI.Button(new Rect(120,6,90,25),new GUIContent("Fallback"),GUI.skin.GetStyle("ButtonMid"))){
			if (!InputSwitch["Type2"])
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderBy(o=>o.Type).ToList();
			else
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderByDescending(o=>o.Type).ToList();
			InputSwitch["Type2"] = !InputSwitch["Type2"];
		}
		if (GUI.Button(new Rect(210,6,150,25),new GUIContent("Name"),GUI.skin.GetStyle("ButtonMid"))){
			if (!InputSwitch["Name"])
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderBy(o=>o.VisName).ToList();
			else
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderByDescending(o=>o.VisName).ToList();
			InputSwitch["Name"] = !InputSwitch["Name"];
		}
		if (GUI.Button(new Rect(360,6,60,25),new GUIContent("Visible"),GUI.skin.GetStyle("ButtonMid"))){
			if (!InputSwitch["In Editor"])
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderBy(o=>o.InEditor).ToList();
			else
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderByDescending(o=>o.InEditor).ToList();
			InputSwitch["In Editor"] = !InputSwitch["In Editor"];
		}
		if (GUI.Button(new Rect(420,6,140,25),new GUIContent("Replacement"),GUI.skin.GetStyle("ButtonRight"))){
			if (!InputSwitch["Replacement"])
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderBy(o=>o.SpecialType).ToList();
			else
			OpenShader.ShaderInputs = OpenShader.ShaderInputs.OrderByDescending(o=>o.SpecialType).ToList();
			InputSwitch["Replacement"] = !InputSwitch["Replacement"];
		}
		if (GUI.Button(new Rect(WinSize.x-160,6,140,25),"Clean Inputs")){
			List<ShaderVar> SVs = new List<ShaderVar>();
			foreach (ShaderLayer SL in ShaderUtil.GetAllLayers()){
				SL.UpdateShaderVars(true);
				SVs.AddRange(SL.ShaderVars);
			}
			SVs.AddRange(OpenShader.GetMyShaderVars());
			foreach(ShaderInput SI in OpenShader.ShaderInputs){
				SI.UsedCount = 0;
				foreach(ShaderVar SV in SVs){
					if (SV.Input==SI)
						SI.UsedCount+=1;
				}
			}
			for (int i = OpenShader.ShaderInputs.Count-1;i>-1;i--){
				ShaderInput SI = OpenShader.ShaderInputs[i];
				if (SI.UsedCount==0){
					OpenShader.ShaderInputs.Remove(SI);
					foreach(ShaderVar SV in SVs){
						if (SV.Input==SI)
							SV.Input = null;
					}
				}
			}
			EditorGUIUtility.ExitGUI();
		}
	//	GUI.changed = GUIChanged;
		ButtonStyle = new GUIStyle(GUI.skin.button);
		ButtonStyle.padding = new RectOffset(0,0,0,0);
		ButtonStyle.margin = new RectOffset(0,0,0,0);
		if ((OpenShader.ShaderInputs.Count*50+36)>WinSize.y)
		InputScroll = ShaderUtil.BeginScrollView(new Rect(0,36,WinSize.x,WinSize.y-36),InputScroll,new Rect(0,0,230,OpenShader.ShaderInputs.Count*50),false,true);
		else
		ShaderUtil.BeginGroup(new Rect(0,36,WinSize.x,WinSize.y-36));
		foreach(ShaderInput SI in OpenShader.ShaderInputs){
			X++;//5
			//XX = X % PerWidth;//1 0,1,2,0,1
			//YY = (int)Mathf.Floor((float)X/(float)PerWidth);//1
			//ShaderUtil.DrawEffects(new Rect(0,0,350,350),SI.InputEffects,SelectedEffect);
			//if (SI.AutoCreated)
			//GUI.enabled = false;
			ShaderUtil.BeginGroup(new Rect(20,X*50,WinSize.x-40,40),"button");
				if (SI.Type!=3&&SI.Type!=4){
				GUI.enabled = false;
				SI.Type = EditorGUI.IntPopup(new Rect(10,10,80,20),SI.Type,new string[]{"Color","Image","Cubemap","Float","Range"},new int[]{1,0,2,3,4},GUI.skin.GetStyle("MiniPopup"));
				GUI.enabled = true;
				}
				else{
				SI.Type = EditorGUI.IntPopup(new Rect(10,10,80,20),SI.Type,new string[]{"Float","Range"},new int[]{3,4},GUI.skin.GetStyle("MiniPopup"));
				}
				//None,MainColor,MainTexture,BumpMap,MainCubemap,SpecularColor,Shininess,ReflectColor,Parallax,ParallaxMap
				string[] SInputTypes = new string[0];
				InputMainTypes[] EInputTypes = new InputMainTypes[0];
				SInputTypes = new string[]{"None","Custom"};
				EInputTypes = new InputMainTypes[]{InputMainTypes.None,InputMainTypes.Custom};
				if (SI.Type==0){
					SInputTypes = new string[]{"None","Custom","Main Texture","Normal Map","Parallax Map","Terrain/Control","Terrain/Splat 0","Terrain/Splat 1","Terrain/Splat 2","Terrain/Splat 3","Terrain/Normal 0","Terrain/Normal 1","Terrain/Normal 2","Terrain/Normal 3"};
					EInputTypes = new InputMainTypes[]{InputMainTypes.None,InputMainTypes.Custom,InputMainTypes.MainTexture,InputMainTypes.BumpMap,InputMainTypes.ParallaxMap,InputMainTypes.TerrainControl,InputMainTypes.TerrainSplat0,InputMainTypes.TerrainSplat1,InputMainTypes.TerrainSplat2,InputMainTypes.TerrainSplat3,InputMainTypes.TerrainNormal0,InputMainTypes.TerrainNormal1,InputMainTypes.TerrainNormal2,InputMainTypes.TerrainNormal3};
				}
				if (SI.Type==1){
					SInputTypes = new string[]{"None","Custom","Main Color","Specular Color","Reflect Color"};
					EInputTypes = new InputMainTypes[]{InputMainTypes.None,InputMainTypes.Custom,InputMainTypes.MainColor,InputMainTypes.SpecularColor,InputMainTypes.ReflectColor};
				}
				if (SI.Type==2){
					SInputTypes = new string[]{"None","Custom","Main Cubemap"};
					EInputTypes = new InputMainTypes[]{InputMainTypes.None,InputMainTypes.Custom,InputMainTypes.MainCubemap};
				}
				if (SI.Type==3||SI.Type==4){
					SInputTypes = new string[]{"None","Custom","Shininess","Parallax","Cutoff","Shell Distance"};
					EInputTypes = new InputMainTypes[]{InputMainTypes.None,InputMainTypes.Custom,InputMainTypes.Shininess,InputMainTypes.Parallax,InputMainTypes.Cutoff,InputMainTypes.ShellDistance};
				}
				int IndexOfType=0;
				if (Array.IndexOf(EInputTypes,SI.MainType)!=-1)
				IndexOfType = Array.IndexOf(EInputTypes,SI.MainType);
				
				if (SI.MainType == InputMainTypes.Custom){
					SI.MainType = EInputTypes[EditorGUI.Popup(new Rect(100,10,20,20),"",IndexOfType,SInputTypes,GUI.skin.GetStyle("MiniPopup"))];
					SI.CustomFallback.Text = GUI.TextField(new Rect(120,10,60,20),SI.CustomFallback.Text);
				}
				else{
					SI.MainType = EInputTypes[EditorGUI.Popup(new Rect(100,10,80,20),"",IndexOfType,SInputTypes,GUI.skin.GetStyle("MiniPopup"))];
				}
				//SI.MainType = (InputMainTypes)EditorGUI.EnumPopup(new Rect(100,10,80,20),"",SI.MainType);
				SI.VisName = GUI.TextField(new Rect(190,10,140,20),SI.VisName);
				//if (Event.current.type==EventType.Repaint){
				if (SI.Type==0||SI.Type==2){
				SI.InEditor = true;
				GUI.enabled = false;
				}
					if (SI.InEditor)
						SI.InEditor = GUI.Toggle(new Rect(340,10,20,20),SI.InEditor,ShaderSandwich.Tick,ButtonStyle);
					else
						SI.InEditor = GUI.Toggle(new Rect(340,10,20,20),SI.InEditor,ShaderSandwich.Cross,ButtonStyle);
				if (SI.Type==0||SI.Type==2){
					GUI.enabled = true;
				}
				//None,Time,TimeFast,TimeSlow,SinTime,SinTimeFast,SinTimeSlow,CosTime,CosTimeFast,CosTimeSlow
				InputSpecialTypes[] EInputTypes2 = new InputSpecialTypes[0];
				SInputTypes = new string[]{"None","Custom"};
				EInputTypes2 = new InputSpecialTypes[]{InputSpecialTypes.None,InputSpecialTypes.Custom};
				if (SI.Type==3||SI.Type==4){
					SInputTypes = new string[]{"None","Custom","Time/Basic/Standard","Time/Basic/Fast","Time/Basic/Slow","Time/Basic/Very Slow","Time/Sine/Standard","Time/Sine/Fast","Time/Sine/Slow","Time/Cosine/Standard","Time/Cosine/Fast","Time/Cosine/Slow","Time/Clamped Sine/Standard","Time/Clamped Sine/Fast","Time/Clamped Sine/Slow","Time/Clamped Cosine/Standard","Time/Clamped Cosine/Fast","Time/Clamped Cosine/Slow","Depth/Shell","Depth/Parallax Occlusion Mapping"};
					EInputTypes2 = new InputSpecialTypes[]{InputSpecialTypes.None,InputSpecialTypes.Custom,InputSpecialTypes.Time,InputSpecialTypes.TimeFast,InputSpecialTypes.TimeSlow,InputSpecialTypes.TimeVerySlow,InputSpecialTypes.SinTime,InputSpecialTypes.SinTimeFast,InputSpecialTypes.SinTimeSlow,InputSpecialTypes.CosTime,InputSpecialTypes.CosTimeFast,InputSpecialTypes.CosTimeSlow, InputSpecialTypes.ClampedSinTime,InputSpecialTypes.ClampedSinTimeFast,InputSpecialTypes.ClampedSinTimeSlow,InputSpecialTypes.ClampedCosTime,InputSpecialTypes.ClampedCosTimeFast,InputSpecialTypes.ClampedCosTimeSlow,InputSpecialTypes.ShellDepth,InputSpecialTypes.ParallaxDepth};
				}
				
				IndexOfType=0;
				if (Array.IndexOf(EInputTypes2,SI.SpecialType)!=-1)
				IndexOfType = Array.IndexOf(EInputTypes2,SI.SpecialType);
				
				if (SI.InEditor){
					SI.SpecialType = InputSpecialTypes.None;
					GUI.enabled = false;
					EditorGUI.Popup(new Rect(400,10,140,20),"",IndexOfType,SInputTypes,GUI.skin.GetStyle("MiniPopup"));
					GUI.enabled = true;
				}
				else{
					if (SI.SpecialType == InputSpecialTypes.Custom){
						SI.SpecialType = EInputTypes2[EditorGUI.Popup(new Rect(400,10,20,20),"",IndexOfType,SInputTypes,GUI.skin.GetStyle("MiniPopup"))];
						SI.CustomSpecial.Text = GUI.TextField(new Rect(420,10,120,20),SI.CustomSpecial.Text);
					}
					else{
						SI.SpecialType = EInputTypes2[EditorGUI.Popup(new Rect(400,10,140,20),"",IndexOfType,SInputTypes,GUI.skin.GetStyle("MiniPopup"))];
					}
					
				}
				
				GUI.enabled = true;
				
				if (SI.Type==3){//Float
					SI.Number = EditorGUI.FloatField(new Rect(550,10,120,20),"",SI.Number,GUI.skin.textField);
				}
				if (SI.Type==4){//Range
					SI.Range0 = EditorGUI.FloatField(new Rect(550,10,30,20),"",SI.Range0,GUI.skin.textField);
					SI.Number = GUI.HorizontalSlider(new Rect(590,10,40,20),SI.Number,SI.Range0,SI.Range1);
					SI.Range1 = EditorGUI.FloatField(new Rect(640,10,30,20),"",SI.Range1,GUI.skin.textField);
				}
				Color OldColor = GUI.backgroundColor;
				//GUI.color = new Color(1,1,1,1);
				GUI.backgroundColor = new Color(1,1,1,1);
				if (SI.Type==0){//Image
					SI.Image = (Texture2D) EditorGUI.ObjectField (new Rect(550,10,120,20),SI.ImageS(), typeof (Texture2D),false);
				}
				if (SI.Type==1){//Color
					SI.Color = (ShaderColor)EditorGUI.ColorField(new Rect(550,10,140,20),"",(Color)SI.Color);
				}
				if (SI.Type==2){//Cubemap
					SI.Cube = (Cubemap) EditorGUI.ObjectField (new Rect(550,10,120,20),SI.CubeS(), typeof (Cubemap),false);
				}
				GUI.backgroundColor = OldColor;
				
				
				if (SI.Type==0){
					GUI.Label(new Rect(680,10,200,20),"Normal Map: ");
						if (SI.NormalMap)
						SI.NormalMap = GUI.Toggle(new Rect(770,10,20,20),SI.NormalMap,ShaderSandwich.Tick,ButtonStyle);
					else
						SI.NormalMap = GUI.Toggle(new Rect(770,10,20,20),SI.NormalMap,ShaderSandwich.Cross,ButtonStyle);				
				}
				//InputSpecialTypes
				//UnityEngine.Debug.Log("ASD");
				if (X==0)
				GUI.enabled = false;
				if (GUI.Button(new Rect(WinSize.x-40-75,10,20,20),UPArrow,ButtonStyle))
				{
					ShaderUtil.MoveItem(ref OpenShader.ShaderInputs,X,X-1);//MoveLayerUp = Pos;
					EditorGUIUtility.ExitGUI();
				}
				GUI.enabled = true;
				if (GUI.Button(new Rect(WinSize.x-40-50,10,20,20),CrossRed,ButtonStyle))
				{
					OpenShader.ShaderInputs.RemoveAt(X);
					List<ShaderVar> SVs = new List<ShaderVar>();
					foreach (ShaderLayer SL in ShaderUtil.GetAllLayers()){
						SL.UpdateShaderVars(true);
						SVs.AddRange(SL.ShaderVars);
					}
					SVs.AddRange(OpenShader.GetMyShaderVars());
					foreach(ShaderVar SV in SVs){
						if (SV.Input==SI)
						SV.Input = null;
					}
					//UEObject.DestroyImmediate(SL,false);
					EditorGUIUtility.ExitGUI();
				}
				if (X>=OpenShader.ShaderInputs.Count-1)
				GUI.enabled = false;
				if (GUI.Button(new Rect(WinSize.x-40-25,10,20,20),DOWNArrow,ButtonStyle))
				{
					//Pos2+=1;	
					ShaderUtil.MoveItem(ref OpenShader.ShaderInputs,X,X+1);//MoveLayerDown = Pos;
					EditorGUIUtility.ExitGUI();
				}
				GUI.enabled = true;				
				//SI.InEditor = GUI.Toggle(new Rect(250,10,20,20),SI.InEditor);
			ShaderUtil.EndGroup();
			GUI.enabled = true;
		}
		if ((OpenShader.ShaderInputs.Count*50+36)>WinSize.y)
		ShaderUtil.EndScrollView();
		else
		ShaderUtil.EndGroup();
		/*Features:
		Editor Inputs
		Inputs: (Composed of editor inputs and custom values)
			Can apply effects to inputs
			
		Interface:
		Two Tabs: Primary and secondary inputs.
		
		*/
		ChangeSaveTemp(null,true);
		ButtonStyle.fontSize = 20;
		if (CurInterfaceStyle!=InterfaceStyle.Modern)
		if (GUI.Button( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),"Layers",ButtonStyle))
			Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
		//GUI.Toggle( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),GUIMouseHold&&(ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30).Contains(Event.current.mousePosition)),"Layers",ButtonStyle);
		}
		ShaderUtil.EndGroup();
	}
	
	static public int ShaderLayerTab = 0;
	
	//public ShaderSource SourceTest
	//void GUISourceEditor(Vector2 WinSize,Vector2 Position){
		
	//}
	
	
	
	void GUILayers(Vector2 WinSize,Vector2 Position)
	{
		RunHotkeys();
		ShaderBase SSIO = OpenShader;
		if (SSIO==null)
		{
			GUIStage = GUIType.Start;
			GUITrans.Reset();
		}
		else
		{
			ShaderUtil.BeginGroup(new Rect(Position.x,Position.y,WinSize.x,WinSize.y));

			int ListCount = 1;
			ShaderPass SP = null;
			if (ShaderLayerTab > SSIO.ShaderPasses.Count-1)
			ShaderLayerTab = SSIO.ShaderPasses.Count-1;
			if (ShaderLayerTab > -1&&SSIO.ShaderPasses.Count>ShaderLayerTab)
			SP = SSIO.ShaderPasses[ShaderLayerTab];
			if (SP!=null)
			{
				ListCount+=1;
				if (SP.SpecularOn.On==true)
					ListCount+=1;
				if (SP.EmissionOn.On==true)
					ListCount+=1;
				if (SP.TransparencyOn.On==true)
					ListCount+=1;
				if (SP.ParallaxOn.On==true)
					ListCount+=1;
				ListCount+=1;
				
				ListCount+=1;
				ListCount+=1;
				ListCount+=1;
				ListCount+=1;
			}
			if (ShaderLayerTab == -1)
			{
				//foreach(ShaderLayerList SLL in SSIO.ShaderLayersMasks){
				//	ListCount+=1;
				//}
				ListCount += SSIO.ShaderLayersMasks.Count;
				ListCount+=1;
			}			
			LayerListScroll = ShaderUtil.BeginScrollView(new Rect(264,0,WinSize.x-264,WinSize.y),LayerListScroll,new Rect(0,0,ListCount*150,WinSize.y-20),false,false);
			GUIStyle ButtonStyle;
			if(CurInterfaceStyle==InterfaceStyle.Flat||CurInterfaceStyle==InterfaceStyle.Modern){
				ButtonStyle = new GUIStyle(GUI.skin.box);
				ButtonStyle.alignment = TextAnchor.MiddleCenter;
			}
			else
				ButtonStyle = new GUIStyle(GUI.skin.button);
			
			ButtonStyle.fontSize = 20;	
			
			List<List<ShaderLayer>> SLList = new List<List<ShaderLayer>>();
			GUI.color = BackgroundColor;
			//GUI.DrawTexture( new Rect(264,30,300,25), EditorGUIUtility.whiteTexture );
			GUI.color = new Color(1f,1f,1f,1f);
			
			int Pos = 0;
			bool Hit = false;
			if (SP!=null)
			{
				if(GUILayersBox(SP.ShaderLayersDiffuse,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersDiffuse.SLs);
				
				Pos+=1;
				if(GUILayersBox(SP.ShaderLayersNormal,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersNormal.SLs);
				
				if (SP.SpecularOn.On==true){
					Pos+=1;
					if(GUILayersBox(SP.ShaderLayersSpecular,Pos,WinSize,ButtonStyle))Hit = true;
					SLList.Add(SP.ShaderLayersSpecular.SLs);
				}		
				if (SP.EmissionOn.On==true){
					Pos+=1;
					if(GUILayersBox(SP.ShaderLayersEmission,Pos,WinSize,ButtonStyle))Hit = true;
					SLList.Add(SP.ShaderLayersEmission.SLs);
				}
				if (SP.TransparencyOn.On==true){
					Pos+=1;
					if(GUILayersBox(SP.ShaderLayersAlpha,Pos,WinSize,ButtonStyle))Hit = true;
					SLList.Add(SP.ShaderLayersAlpha.SLs);
				}
				if (SP.ParallaxOn.On==true){
					Pos+=1;
					if(GUILayersBox(SP.ShaderLayersHeight,Pos,WinSize,ButtonStyle))Hit = true;
					SLList.Add(SP.ShaderLayersHeight.SLs);
				}
				Pos+=1;
				if(GUILayersBox(SP.ShaderLayersVertex,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersVertex.SLs);
				
				Pos+=1;
				if(GUILayersBox(SP.ShaderLayersLightingAll,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersLightingAll.SLs);
				Pos+=1;
				if(GUILayersBox(SP.ShaderLayersLightingDiffuse,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersLightingDiffuse.SLs);
				Pos+=1;
				if(GUILayersBox(SP.ShaderLayersLightingSpecular,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersLightingSpecular.SLs);
				Pos+=1;
				if(GUILayersBox(SP.ShaderLayersLightingAmbient,Pos,WinSize,ButtonStyle))Hit = true;
				SLList.Add(SP.ShaderLayersLightingAmbient.SLs);
			}
			if (ShaderLayerTab == -1)
			{
				if ((Event.current.type == EventType.MouseDown&&new Rect(150*(Pos+SSIO.ShaderLayersMasks.Count),30,150,WinSize.y).Contains(Event.current.mousePosition)))
				OpenShader.AddMask();
				foreach(ShaderLayerList SLL in SSIO.ShaderLayersMasks)
				{
					if(GUILayersBox(SLL,Pos,WinSize,ButtonStyle))Hit = true;
					SLList.Add(SLL.SLs);
					
					Pos+=1;
				}
				if (!(Event.current.type == EventType.Repaint&&new Rect(150*Pos,30,150,WinSize.y).Contains(Event.current.mousePosition)))GUI.enabled = false;
				GUILayersBox(SSIO.ShaderLayersMaskTemp,Pos,WinSize,ButtonStyle);

				GUI.Label(new Rect(150*Pos+18,120,150,WinSize.y),"Click to Add Mask");
				
				GUI.enabled = true;
				Pos+=1;
			}
			ShaderUtil.EndScrollView();
			GUI.skin.GetStyle("ButtonLeft").alignment = TextAnchor.MiddleLeft;
			GUI.skin.GetStyle("ButtonRight").alignment = TextAnchor.MiddleLeft;
			GUI.skin.GetStyle("ButtonMid").alignment = TextAnchor.MiddleLeft;
			
			float Val = ShaderUtil.GetVal(InterfaceColor);
			Color BackgroundColor2;
			if (CurInterfaceStyle==InterfaceStyle.Modern){
				if (Val<0.5f)
					BackgroundColor2 = new Color(0.6f*Val,0.6f*Val,0.6f*Val,1);
				else
					BackgroundColor2 = new Color(1f*Val,1f*Val,1f*Val,1);
			}
			else
			BackgroundColor2 = new Color(0.18f,0.18f,0.18f,1);
			Color GUIColor = GUI.color;
			GUI.color = BackgroundColor2;
			GUI.DrawTexture( new Rect(250+16,0,WinSize.x-250-16,32), EditorGUIUtility.whiteTexture );
			GUI.color = GUIColor;
			int X = 265;
			int i = -1;
			foreach (ShaderPass SPd in OpenShader.ShaderPasses){
				i++;
				if (ShaderLayerTab != i){
					if (GUI.Button(new Rect(X,6,100,25),new GUIContent(SPd.Name.Text,SPd.Visible.On?(SPd.ShellsOn.On?IconShell:IconBase):CrossRed),GUI.skin.GetStyle("ButtonMid")))ShaderLayerTab = i;
				}
				else{
					GUI.Toggle(new Rect(X,6,100,25),true,new GUIContent(SPd.Name.Text,SPd.Visible.On?(SPd.ShellsOn.On?IconShell:IconBase):CrossRed),GUI.skin.GetStyle("ButtonMid"));
				}
				X += 100;
			}
			
			GUI.enabled = true;
			
			if (ShaderLayerTab != -1){
				if (GUI.Button(new Rect(X,6,100,25),new GUIContent("Mask",IconMask),GUI.skin.GetStyle("ButtonRight")))ShaderLayerTab = -1;
			}
			else{
				GUI.Toggle(new Rect(X,6,100,25),true,new GUIContent("Mask",IconMask),GUI.skin.GetStyle("ButtonRight"));
			}
			GUI.enabled = true;
			
			GUI.Box(new Rect(0,0,264,WinSize.y),"",ButtonStyle);
			
			
			if (Hit==false&&Event.current.type == EventType.MouseDown&&!(new Rect(0,0,264,WinSize.y).Contains(Event.current.mousePosition)))
			LayerSelection = new Vector2(20,20);
			
			ShaderLayer DrawLayer = null;
			//if (LayerSelection.x==0)
			//{
				if (LayerSelection.x<SLList.Count)
				if (LayerSelection.y<SLList[(int)LayerSelection.x].Count)
				if (SLList[(int)LayerSelection.x][(int)LayerSelection.y]!=null)
				DrawLayer = SLList[(int)LayerSelection.x][(int)LayerSelection.y];
			//}
			
			int LayerSettingsHeight = 48;
			if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern)
				LayerSettingsHeight = 31;
			GUI.Box(new Rect(0,0,265,LayerSettingsHeight),"Layer Settings",ButtonStyle);
			int ScrollHeight = 660;
			
			ShaderUtil.BeginGroup(new Rect(0,LayerSettingsHeight,264,WinSize.y-LayerSettingsHeight));
			if (!((WinSize.y-LayerSettingsHeight-30)>ScrollHeight))
			LayerScroll = ShaderUtil.BeginScrollView(new Rect(0,0,264,WinSize.y-LayerSettingsHeight-30),LayerScroll,new Rect(0,0,230,ScrollHeight),false,true);
			else{
			ShaderUtil.BeginScrollView(new Rect(0,0,264,WinSize.y-LayerSettingsHeight-30),new Vector2(0,0),new Rect(0,0,230,ScrollHeight),false,true);
			ShaderUtil.EndScrollView();
			}
			
			
			if (AnimateInputs&&Event.current.type==EventType.Repaint&&DrawLayer!=null){
				foreach(ShaderLayer SL in DrawLayer.Parent.SLs){
					SL.UpdateShaderVars(true);
					foreach(ShaderVar SV in SL.ShaderVars)
					SV.UpdateToInput(true);
				}
			}
			
			if (DrawLayer!=null)
				DrawLayer.DrawGUI();
			else
				ShaderLayer.DrawGUIGen(true);
			//if ((WinSize.y-48)<=ScrollHeight)
			if (!((WinSize.y-LayerSettingsHeight-30)>ScrollHeight))
			ShaderUtil.EndScrollView();
			ShaderUtil.EndGroup();
			ChangeSaveTemp(DrawLayer);
			
			if (CurInterfaceStyle!=InterfaceStyle.Modern){
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,64,30),"Back",ButtonStyle))
					Goto(GUIType.Start,ShaderTransition.TransDir.Backward);
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,64,WinSize.y,110,30),"Settings",ButtonStyle))
					Goto(GUIType.Configure,ShaderTransition.TransDir.Backward);	
				if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,174,WinSize.y,100-24,30),"Inputs",ButtonStyle))
					Goto(GUIType.Inputs,ShaderTransition.TransDir.Backward);
			}
			
			ShaderUtil.EndGroup();
		}
		
	}
	public void ChangeSaveTemp(ShaderLayer Up){
		ChangeSaveTemp_Real(Up,true);
	}
	public void ChangeSaveTemp(ShaderLayer Up,bool UpdateInputs){
		ChangeSaveTemp_Real(Up,UpdateInputs);
	}
	public void RegenShaderPreview(){
		if (ShaderPreview.Instance!=null&&RealtimePreviewUpdates)
			SaveTemp();
	}
	public void UpdateShaderPreview(){
		if (ShaderPreview.Instance!=null&&ShaderPreview.Instance.previewMat!=null&&RealtimePreviewUpdates&&OpenShader!=null){
//			Debug.Log("Updating Inputs");
			
			ShaderPreview.Instance.previewMat.SetTexture("_Cube",ShaderPreview.Instance.CurCube);
			if (ShaderPreview.Instance.previewMat2!=null)
				ShaderPreview.Instance.previewMat2.SetTexture("_Cube",ShaderPreview.Instance.CurCube);
			foreach(ShaderInput SI in OpenShader.ShaderInputs){
				if (SI.Type==0)
				ShaderPreview.Instance.previewMat.SetTexture(SI.Get(),SI.ImageS());
				if (SI.Type==1)
				ShaderPreview.Instance.previewMat.SetColor(SI.Get(),SI.Color.ToColor());
				if (SI.Type==2)
				ShaderPreview.Instance.previewMat.SetTexture(SI.Get(),SI.CubeS());
				if (SI.Type==3||SI.Type==4)
				ShaderPreview.Instance.previewMat.SetFloat(SI.Get(),SI.Number);
				if (ShaderPreview.Instance.previewMat2!=null){
					if (SI.Type==0)
					ShaderPreview.Instance.previewMat2.SetTexture(SI.Get(),SI.ImageS());
					if (SI.Type==1)
					ShaderPreview.Instance.previewMat2.SetColor(SI.Get(),SI.Color.ToColor());
					if (SI.Type==2)
					ShaderPreview.Instance.previewMat2.SetTexture(SI.Get(),SI.CubeS());
					if (SI.Type==3||SI.Type==4)
					ShaderPreview.Instance.previewMat2.SetFloat(SI.Get(),SI.Number);
				}
			}
			if (ShaderSandwich.Instance.ImprovedUpdates){
				foreach(ShaderVar SV in ShaderUtil.GetAllShaderVars()){
					if (SV.Input==null){
						//Debug.Log(SV.Name);
						if (SV.CType == Types.Vec)
						ShaderPreview.Instance.previewMat.SetColor("SSTEMPSV"+SV.GetID().ToString(),(Color)SV.Vector);
						if (SV.CType == Types.Float&&!SV.NoInputs)
						ShaderPreview.Instance.previewMat.SetFloat("SSTEMPSV"+SV.GetID().ToString(),SV.Float);
						if (ShaderPreview.Instance.previewMat2!=null){
							if (SV.CType == Types.Vec)
							ShaderPreview.Instance.previewMat2.SetColor("SSTEMPSV"+SV.GetID().ToString(),(Color)SV.Vector);
							if (SV.CType == Types.Float)
							ShaderPreview.Instance.previewMat2.SetFloat("SSTEMPSV"+SV.GetID().ToString(),SV.Float);
						}
					}
				}
			}
		}
		if (ShaderPreview.Instance!=null&&RealtimePreviewUpdates&&OpenShader!=null&&OpenShader.TransparencyType.Type==1&&OpenShader.TransparencyOn.On&&ShaderPreview.Instance.previewMatW!=null){
//			Debug.Log("Updating Inputs");
			foreach(ShaderInput SI in OpenShader.ShaderInputs){
				if (SI.Type==0)
				ShaderPreview.Instance.previewMatW.SetTexture(SI.Get(),SI.ImageS());
				if (SI.Type==1)
				ShaderPreview.Instance.previewMatW.SetColor(SI.Get(),SI.Color.ToColor());
				if (SI.Type==2)
				ShaderPreview.Instance.previewMatW.SetTexture(SI.Get(),SI.CubeS());
				if (SI.Type==3||SI.Type==4)
				ShaderPreview.Instance.previewMatW.SetFloat(SI.Get(),SI.Number);
			}
		}
	}
	public void ChangeSaveTemp_Real(ShaderLayer Up,bool UpdateInputs){
		if (GUI.changed)
		ValueChanged = true;
		if (ValueChanged&&OpenShader!=null){//DrawLayer!=null&&
			if (Up!=null){
			Up.Parent.UpdateIcon(new Vector2(70,70));
			//Debug.Log("UpdatedIcon");
			}
			
			if (UpdateInputs){
			OpenShader.RecalculateAutoInputs();}
			
			UpdateShaderPreview();
		}
		if (!GUI.changed&&OpenShader!=null){
			GUIChangedTimer-=1;
			if (GUIChangedTimer==0){
				RegenShaderPreview();
			}
		}
		else{
			GUIChangedTimer=20;
		}
	}
	List<GUIContent> PresetsGUIContents;
	List<string> PresetsPaths;
	void GUIPresets(Vector2 WinSize,Vector2 Position)
	{
		ShaderVarEditing = null;
		ShaderUtil.BeginGroup(new Rect(Position.x,Position.y,WinSize.x,WinSize.y));
		/*GUILayout.BeginVertical(SCSkin.box,GUILayout.Height(200));
		
		GUILayout.EndVertical();*/
		
		//string[] BaseVarients = {"Plain","Plant","Fur","Grass","Skin"};
		//string[] ExtraVarients = {"","Specular","Normal Mapped","Specular Normal Mapped","Rim Lit","Normal Mapped Rim Lit","POM","Specular POM","Normal Mapped POM","Specular Normal Mapped POM"};
		/*string[] selStrings = new string[BaseVarients.Length*ExtraVarients.Length];
		int i = 0;
		foreach (string Var2 in ExtraVarients)
		{
			foreach (string Var in BaseVarients)
			{
				selStrings[i] = Var+" "+Var2;
				i+=1;
			}
		}*/
		if (PresetsGUIContents==null||PresetsGUIContents.Count==0||PresetsPaths==null||PresetsPaths.Count==0){
			PresetsGUIContents = new List<GUIContent>(); 
			PresetsPaths = new List<string>();
			//DirectoryInfo info = null;
			//try{
				//---------info = new DirectoryInfo(Application.dataPath+"/Shader Sandwich/Internal/Editor/Shader Sandwich/Presets/");//ScriptFileFolder);
			//}catch{}
			/*if (info!=null&&info.Exists){
				FileInfo[] fileInfo = info.GetFiles();
				//List<GUIContent> selStrings = new List<GUIContent>();
				//List<Texture2D> selImages = new List<Texture2D>();
				foreach (FileInfo file in fileInfo){
					//List<string> FileText = new List<string>();
					if (file.Extension==".shader"){
						//StreamReader theReader = new StreamReader(file.ToString());
						//Debug.Log(file.Name);
						
						//Debug.Log(file.FullName);
						if (System.IO.File.Exists(file.DirectoryName+"\\"+file.Name.Replace(".shader",".png").Substring(1))){
						var bytes = System.IO.File.ReadAllBytes(file.DirectoryName+"\\"+file.Name.Replace(".shader",".png").Substring(1));
						var tex = new Texture2D(1, 1);
						tex.LoadImage(bytes);
						//PresetsGUIContents.Add(new GUIContent(tex));
						PresetsGUIContents.Add(new GUIContent(file.Name.Replace(".shader","").Substring(1),tex));
						PresetsPaths.Add(file.DirectoryName+"\\"+file.Name);
						//selStrings.Add(new GUIContent(tex));
						}
					}
				}
			}*/
			string[] guids2 = AssetDatabase.FindAssets ("t:Shader", new string[]{"Assets/Shader Sandwich/Internal/Editor/Shader Sandwich/Presets"});
			//for (string guid in guids2)
				//Debug.Log (AssetDatabase.GUIDToAssetPath(guid));
			//FileInfo[] fileInfo = info.GetFiles();
			//List<GUIContent> selStrings = new List<GUIContent>();
			//List<Texture2D> selImages = new List<Texture2D>();
			foreach (string guid in guids2){
				//Debug.Log (AssetDatabase.GUIDToAssetPath(guid));
				string ImgPath = AssetDatabase.GUIDToAssetPath(guid).Replace(".shader",".png");
				ImgPath = ImgPath.Remove(ImgPath.LastIndexOf("/")+1,1);
				//Debug.Log(ImgPath);
				Texture2D tex = (Texture2D)AssetDatabase.LoadAssetAtPath(ImgPath,typeof(Texture2D));
				if (tex!=null){
					PresetsGUIContents.Add(new GUIContent(new FileInfo(AssetDatabase.GUIDToAssetPath(guid)).Name.Replace(".shader","").Substring(1),tex));
					PresetsPaths.Add(AssetDatabase.GUIDToAssetPath(guid));
				}
				//Debug.Log("YAY!");
				/*if (System.IO.File.Exists(file.DirectoryName+"\\"+file.Name.Replace(".shader",".png").Substring(1))){
					var bytes = System.IO.File.ReadAllBytes(file.DirectoryName+"\\"+file.Name.Replace(".shader",".png").Substring(1));
					var tex = new Texture2D(1, 1);
					tex.LoadImage(bytes);
					//PresetsGUIContents.Add(new GUIContent(tex));
					PresetsGUIContents.Add(new GUIContent(file.Name.Replace(".shader","").Substring(1),tex));
					PresetsPaths.Add(file.DirectoryName+"\\"+file.Name);
				}	*/
			}
		}
		//List<string> selStrings = new string[]{"Legacy Diffuse","PBR Diffuse","PBR Normal Mapped","PBR Height Mapped","Parallax Occlusion Mapped","Displacement Mapped","Glow","Cartoon"};
		int XCount = (int)Mathf.Floor((WinSize.x-120f)/192f);
		Rect gridRect = new Rect(0, 0, XCount*192, Mathf.Ceil(PresetsGUIContents.Count/Mathf.Floor((WinSize.x-120f)/256f))*192);
		GUI.Box(new Rect(100,32,XCount*192+20,WinSize.y-64),"",GUI.skin.button);
		StartScroll = ShaderUtil.BeginScrollView(new Rect(100,32,XCount*192+20,WinSize.y-64),StartScroll,new Rect(0,0,gridRect.width,Mathf.Max((int)(PresetsGUIContents.Count/XCount)*192,gridRect.height-180)),false,false);
		
		GUIStyle GridStyle = new GUIStyle(GUI.skin.button);
		//GridStyle.margin = new RectOffset(GridStyle.margin.left+20,GridStyle.margin.right+20,GridStyle.margin.top+20,GridStyle.margin.bottom+20); 
		GridStyle.wordWrap = true;
		GridStyle.imagePosition = ImagePosition.ImageAbove;
		GridStyle.fixedHeight =192;
		
		foreach(GUIContent GC in PresetsGUIContents){
			if (GUI.skin.label.CalcHeight(new GUIContent(GC.text), 192)<20){
				GC.text+="\n";
			}
		}
		
		selGridInt = GUI.SelectionGrid(gridRect, selGridInt, PresetsGUIContents.ToArray(), XCount,GridStyle);
		if (PresetsGUIContents.Count==0)
		GUI.Label(new Rect(20,20,500,300),"Sorry, the presets can't be loaded. Make sure Shader Sandwich has been imported properly, and if it has, please file a bug report :).");
		ShaderUtil.EndScrollView();
		
		GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
		ButtonStyle.fontSize = 20;		
		if (GUI.Button( ShaderUtil.Rect2(RectDir.Bottom,0,WinSize.y,100,30),"Back",ButtonStyle))
			Goto(GUIType.Start,ShaderTransition.TransDir.Backward);	
		if (PresetsGUIContents.Count>0){
			if (GUI.Button( ShaderUtil.Rect2(RectDir.Diag,WinSize.x,WinSize.y,100,30),"Next",ButtonStyle)||Event.current.clickCount==2){
				//Debug.Log(PresetsPaths[selGridInt]);
				SimpleLoad(PresetsPaths[selGridInt]);
				OpenShader.ShaderName.Text = "Untitled Shader";
				Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
			}
		}
		
		ShaderUtil.EndGroup();		
	}
	
	void DrawMenu() {
		//if (GUILayout.Button("Create...", EditorStyles.toolbarButton))
		Color OldColor = GUI.backgroundColor;
		GUI.backgroundColor = new Color(1,1,1,1);
		GUILayout.BeginHorizontal(GUI.skin.GetStyle("Toolbar"));
		if (GUILayout.Button("File", GUI.skin.GetStyle("ToolbarDropDown")))
		{
			GenericMenu toolsMenu = new GenericMenu();

			//if (Selection.activeGameObject != null)
			//toolsMenu.AddItem(new GUIContent("New/Simple"), false, NewSimple);
			toolsMenu.AddItem(new GUIContent("New"), false, NewAdvanced);
			toolsMenu.AddItem(new GUIContent("Open"), false, Load);
			toolsMenu.AddSeparator("");
			if (CurrentFilePath!="")
			toolsMenu.AddItem(new GUIContent("Save"), false, Save);
			else
			toolsMenu.AddDisabledItem(new GUIContent("Save"));
			toolsMenu.AddItem(new GUIContent("Save as..."), false, SaveAs);

			toolsMenu.AddSeparator("");
			toolsMenu.AddItem(new GUIContent("Help"), false, OpenHelp);
			toolsMenu.AddSeparator("");
			//List<string> lst = new List<string>();
			/*lst.AddRange(GlobalSettings.RecentFiles);
			string[] lstArray = lst.Distinct().ToArray();
			for(int i=0;i<(lstArray.Length);i+=1)
			{
				toolsMenu.AddItem(new GUIContent("Open Recent/"+Path.GetFileName(lstArray[i])), false, Nothing,i);
			}*/
			//else
			//toolsMenu.AddDisabledItem(new GUIContent("Optimize Selected"));

			//toolsMenu.AddSeparator("");

			//toolsMenu.AddItem(new GUIContent("Help..."), false, Nothing);

			// Offset menu from right of editor window
			toolsMenu.DropDown(new Rect(5, 0, 0, 16));
			EditorGUIUtility.ExitGUI();
		}
		if (GUILayout.Button("View", GUI.skin.GetStyle("ToolbarDropDown")))
		{
			GenericMenu toolsMenu = new GenericMenu();

			//if (Selection.activeGameObject != null)
			//toolsMenu.AddItem(new GUIContent("New/Simple"), false, NewSimple);
			toolsMenu.AddItem(new GUIContent("Layer Names"), ViewLayerNames, SetViewLayerNames);
			toolsMenu.AddItem(new GUIContent("Improved Updates"), ImprovedUpdates, SetImprovedUpdates);
			//
			toolsMenu.AddItem(new GUIContent("Blend Layer Icons"), BlendLayers, SetBlendLayers);
			
			toolsMenu.AddItem(new GUIContent("Interface/Original"), CurInterfaceStyle==InterfaceStyle.Old, SetInterfaceOriginal);
			toolsMenu.AddItem(new GUIContent("Interface/Flat"), CurInterfaceStyle==InterfaceStyle.Flat, SetInterfaceFlat);
			toolsMenu.AddItem(new GUIContent("Interface/New"), CurInterfaceStyle==InterfaceStyle.Modern, SetInterfaceNew);
			toolsMenu.DropDown(new Rect(41, 0, 0, 16));
			EditorGUIUtility.ExitGUI();
		}
		if (GUILayout.Button("Previews",GUI.skin.GetStyle("ToolbarDropDown")))
		{
			GenericMenu toolsMenu = new GenericMenu();

			//if (Selection.activeGameObject != null)
			toolsMenu.AddItem(new GUIContent("Open Preview Window"), false, OpenPreview);
			toolsMenu.AddItem(new GUIContent("Realtime Preview Updates"), RealtimePreviewUpdates, SetRealtimePreviewUpdates);
			toolsMenu.AddItem(new GUIContent("Animate Layer Previews"), AnimateInputs, SetAnimateInputs);

			toolsMenu.DropDown(new Rect(83, 0, 0, 16));
			EditorGUIUtility.ExitGUI();
		}
		if (GUILayout.Button("Help",GUI.skin.GetStyle("ToolbarDropDown")))
		{
			GenericMenu toolsMenu = new GenericMenu();
			toolsMenu.AddItem(new GUIContent("Open Online Documentation"), false, OpenHelp);
			toolsMenu.AddItem(new GUIContent("Report Bug or Suggest Feature!"), false, SendFeedback);
			toolsMenu.AddItem(new GUIContent("See Bug and Feature Reports"), false, OpenFeedback);

			toolsMenu.DropDown(new Rect(146, 0, 0, 17));
			EditorGUIUtility.ExitGUI();
		}
//		Debug.Log("DrawMenu:"+Status);
		GUILayout.Button("Status: "+Status,GUI.skin.GetStyle("ToolbarButton"));
		
		//GUILayout.Label(Path.GetFileName(AssetDatabase.GetAssetPath(OpenShader)));
		GUILayout.FlexibleSpace();
		if (ShaderSandwich.Instance.CurInterfaceStyle==InterfaceStyle.Modern){
			//InterfaceSize = EditorGUILayout.IntField(new GUIContent(""),InterfaceSize,GUILayout.Width(24));
			InterfaceSize = EditorGUILayout.IntSlider(new GUIContent(""),InterfaceSize,8,14,GUILayout.Width(140));
			Color newCol = EditorGUILayout.ColorField(new GUIContent(""),InterfaceColor,GUILayout.Width(100));
			if (newCol!=InterfaceColor){
				if (ShaderUtil.GetVal(newCol)>0)
				InterfaceColor = newCol;
			}
		}
		GUILayout.EndHorizontal();
		GUI.backgroundColor = OldColor;
	}	
	//void OpenOnlineDocumentation(){
	//	Help.BrowseURL("http://electronic-mind.org/pages/things/SSDoc/Main.html");
	//}
	void OpenHelp(){
		int option = EditorUtility.DisplayDialogComplex(
				"Online Help",
				"Hi! Do you want to open the online help, or just copy the link to your clipboard?",
				"Open Online Help",
				"Copy to Clipboard",
				"Do Nothing");
		switch (option) {
			// Save Scene
			case 0:
				Help.BrowseURL("http://electronic-mind.org/Pages/Things/SSDoc/Main.html");
				break;
			// Quit Without saving.
			case 1:
				EditorGUIUtility.systemCopyBuffer = "http://electronic-mind.org/Pages/Things/SSDoc/Main.html";
				EditorUtility.DisplayDialog("Copied!", "The URL:\nhttp://electronic-mind.org/Pages/Things/SSDoc/Main.html has been copied!", "Ok");
				break;
		}
	
	}
	void OpenFeedback(){
		int option = EditorUtility.DisplayDialogComplex(
				"Bug/Feature Suggestion Tracker",
				"Hello :). Do you want to open the Bug/Feature Suggestion tracker in your browser, or just have a link to it copied to your clipboard?",
				"Open Tracker",
				"Copy to Clipboard",
				"Do Nothing");
		switch (option) {
			// Save Scene
			case 0:
				Help.BrowseURL("http://electronic-mind.org/pages/ShaderSandwichFeedback.html");
				break;
			// Quit Without saving.
			case 1:
				EditorGUIUtility.systemCopyBuffer = "http://electronic-mind.org/pages/ShaderSandwichFeedback.html";
				EditorUtility.DisplayDialog("Copied!", "The URL:\nhttp://electronic-mind.org/pages/ShaderSandwichFeedback.html has been copied!", "Ok");
				break;
		}
	}
	void SendFeedback(){
		ShaderBugReport.Init();
	}
	void OpenPreview(){
		ShaderPreview.Init();
		ChangeSaveTemp(null,true);
		UpdateShaderPreview();
	}
	void SetRealtimePreviewUpdates(){
		RealtimePreviewUpdates = !RealtimePreviewUpdates;
		ChangeSaveTemp(null,true);
		UpdateShaderPreview();
	}
	void SetViewLayerNames(){
		ViewLayerNames = !ViewLayerNames;
	}
	void SetImprovedUpdates(){
		ImprovedUpdates = !ImprovedUpdates;
	}
	void SetInterfaceOriginal(){
		CurInterfaceStyle = InterfaceStyle.Old;
	}
	void SetInterfaceFlat(){
		CurInterfaceStyle = InterfaceStyle.Flat;
	}
	void SetInterfaceNew(){
		CurInterfaceStyle = InterfaceStyle.Modern;
	}
	void SetBlendLayers(){
		BlendLayers = !BlendLayers;
	}
	void SetAnimateInputs(){
		AnimateInputs = !AnimateInputs;
		ChangeSaveTemp(null,true);
	}
	void NewAdvanced(){
		if (OpenShader!=null)
			OpenShader.CleanUp();
		OpenShader = ShaderBase.CreateInstance<ShaderBase>();
		ShaderSandwich.ShaderLayerTab = 0;
		Goto(GUIType.Layers,ShaderTransition.TransDir.Forward);
		ChangeSaveTemp(null);
		CurrentFilePath = "";
	}
	void NewSimple(){
		if (OpenShader!=null)
			OpenShader.CleanUp();
		OpenShader = ShaderBase.CreateInstance<ShaderBase>();
		ShaderSandwich.ShaderLayerTab = 0;
		Goto(GUIType.Presets,ShaderTransition.TransDir.Forward);
		ChangeSaveTemp(null);
		CurrentFilePath = "";
	}
	void SaveAs(){
		string path = EditorUtility.SaveFilePanelInProject("Save Shader",//"/Assets/ASD123.asset";//
								"",
								"shader",
								"Please enter a file name to save the shader to");
		if (path!="")
		{
			CurrentFilePath = path;
			//if (OpenShader.ShaderName.Text == "Untitled Shader")
			OpenShader.ShaderName.Text = (new FileInfo(CurrentFilePath)).Name.Replace(".shader","").Replace(".Shader","");
			Save();
		}
		
	}
	void Save(){
		if (CurrentFilePath=="")
		SaveAs();
		else{
			Status = "Saving Shader Code...";
			ShaderUtil.SaveString(CurrentFilePath,OpenShader.GenerateCode()+"\n\n/*\n"+OpenShader.Save()+"\n*/");
			//AssetDatabase.Refresh();
			//Debug.Log(CurrentFilePath);
			//Debug.Log(Application.dataPath);
			Status = "Compiling Shader Code...";
			AssetDatabase.ImportAsset(CurrentFilePath,ImportAssetOptions.ForceSynchronousImport);
			Status = "Shader Saved.";
			SSSettings.AddNew(CurrentFilePath);
			UpdateShaderPreview();
		}
	}
	string PleaseReimport = "";
	int GiveMeAFrame = 0;
	void SaveTemp(){
		string NewGenerateCode = OpenShader.GenerateCode(true);
		if (OldShaderGenerate!=NewGenerateCode){
			SetStatus("Updating Preview Window","Saving Shader Code...",0.1f);
			
			ShaderUtil.SaveString(Application.dataPath+"/Shader Sandwich/Internal/Shader Sandwich/SSTemp.shader",NewGenerateCode+"\n\n/*\n"+OpenShader.Save()+"\n*/");
			OldShaderGenerate = NewGenerateCode;
			SetStatus("Updating Preview Window","Compiling Shader Code...",0.3f);

			PleaseReimport = "Assets/Shader Sandwich/Internal/Shader Sandwich/SSTemp.shader";
			if (OpenShader.TransparencyType.Type==1&&OpenShader.TransparencyOn.On){
				Status = "Saving Shader Code...";
				ShaderUtil.SaveString(Application.dataPath+"/Shader Sandwich/Internal/Shader Sandwich/SSTempWireframe.shader",OpenShader.GenerateCode(true,true));
				Status = "Compiling Shader Code...";
				AssetDatabase.ImportAsset("Assets/Shader Sandwich/Internal/Shader Sandwich/SSTempWireframe.shader",ImportAssetOptions.ForceSynchronousImport);
				Status = "Preview Updated.";
			}
			//EditorGUIUtility.ExitGUI();
		}
		else{
			SetStatus("Updating Preview Window","No Code Change, Stopping Update.",1f);
		}
	}
	void Load(){
		
		Load(EditorUtility.OpenFilePanel("Open Shader",
								"Assets/",
								"shader"));
	}
	void SimpleLoad(string path){
		SetStatus("Loading File","Loading Shader...",0.1f);
		string line = "";
		string FileString = "";
		

		StreamReader theReader = new StreamReader(path);

		//using (theReader)
		//{
			bool inParse = false;
			bool didParse = false;
			while(true==true)
			{
				line = theReader.ReadLine();
				//Debug.Log(line);
				if (line != null)
				{
					line = line.Trim();
					if (line.Contains("BeginShaderParse"))
					{
						inParse = true;
						didParse = true;
					}
					if (line.IndexOf("#?")>=0)
					line = line.Substring(0,line.IndexOf("#?"));
					if (inParse==true&&(line!=""))
						FileString+=line+"\n";
					
					if (line.Contains("EndShaderParse"))
						inParse = false;
				}
				else{
				break;
				}
			}
			//Debug.Log(FileString);
			theReader.Close();
			if (didParse){
				OpenShader = ShaderBase.Load(new StringReader(FileString));
				RegenShaderPreview();
				GUI.changed = true;
				ChangeSaveTemp(null);
			}else{
				EditorUtility.DisplayDialog("Oh no!","Sorry, the shader you chose wasn't made with Shader Sandwich, so it can't be opened :(.","Ok");
			}
			SetStatus("Loading File","Shader Loaded.",1f);
	}
	void Load(string path){
		
		if (path!="")
		{
			if (path.StartsWith(Application.dataPath))
			path = "Assets"+path.Substring(Application.dataPath.Length);
			AssetDatabase.Refresh();
			CurrentFilePath = path;
			SSSettings.AddNew(CurrentFilePath);
			SimpleLoad(path);
		}
	}
	void Nothing(){}
	public void LayerCopy(object SL){ClipboardLayer = ((ShaderLayer)SL).Copy();}
	public void LayerPaste(object SLL){
		if (ClipboardLayer!=null){
			ShaderLayer SL = ClipboardLayer.Copy();
			SL.Name.Text+=" Copy";
			((ShaderLayerList)SLL).AddC(SL);
		}
		RegenShaderPreview();
		((ShaderLayerList)SLL).UpdateIcon(new Vector2(70,70));
	}
}