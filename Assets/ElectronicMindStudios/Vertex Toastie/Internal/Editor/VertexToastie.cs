#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6
#define PRE_UNITY_5
#else
#define UNITY_5
#endif
#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2
#define PRE_MORESTUPIDUNITYDEPRECATIONS
#endif

#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2
#define PRE_UNITY_5_3
#else
#define POST_UNITY_5_3
#endif

#pragma warning disable 0618
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using SU = ShaderUtil;
using EMindGUI = ElectronicMindStudiosInterfaceUtils;
using UnityEngine.Rendering;
using System.Linq;
[System.Serializable]
public class VertexToastie : EditorWindow {
	
	static public VertexToastie Instance;
	
	[MenuItem ("Window/Vertex Toastie")]
	public static void Init () {
		Selection.objects = new UnityEngine.Object[0];
		VertexToastie windowG = (VertexToastie)EditorWindow.GetWindow (typeof (VertexToastie));
		//VertexToastie windowG = ScriptableObject.CreateInstance<VertexToastie>();
		Instance = windowG;
		//ShaderToaster windowG = (ShaderToaster)EditorWindow.GetWindow (typeof (ShaderToaster));
		windowG.Show();
		windowG.wantsMouseMove = true;
		windowG.minSize = new Vector2(300,536);
		//windowG.maxSize = new Vector2(541,441);
		//windowG.maxSize = new Vector2(400,400);
		//windowG.title = "Toast That Sandwich!";
		windowG.title = "Vertex Toastie!";
		windowG.GetSceneSettings();
		//windowG.IterativeVertexAOJobs.Clear();
		//windowG.Meshes = null;
		windowG.IterativeVertexAOJobs = new GOVBDictionary();
		List<GameObject> allobjects = windowG.SceneSettings.AllObjects;
		foreach (GameObject GO in allobjects){
			if (GO!=null&&GO.GetComponent<VertexToastieIterativeVertexAOBaker>()!=null)
			windowG.IterativeVertexAOJobs.D[GO] = GO.GetComponent<VertexToastieIterativeVertexAOBaker>();
			else
			windowG.SceneSettings.Remove(GO);
		}
		foreach (VertexToastieIterativeVertexAOBaker baker in UnityEngine.Object.FindObjectsOfType<VertexToastieIterativeVertexAOBaker>()){
			if (!allobjects.Contains(baker.gameObject)){
				baker.ClearBake();
				DestroyImmediate(baker);
			}
		}
	}
	#if POST_UNITY_5_3
		UnityEngine.SceneManagement.Scene CurrentScene;
	#endif
	public void GetSceneSettings(){
	#if POST_UNITY_5_3
		if (SceneSettings == null||CurrentScene!=UnityEngine.SceneManagement.SceneManager.GetActiveScene()){
	#else
		if (SceneSettings == null){
	#endif
			#if POST_UNITY_5_3
				CurrentScene = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
			#endif
			GameObject vtss = null;
			
			#if POST_UNITY_5_3
				foreach(GameObject GO in SceneRoots()){
					if (GO.name=="VertexToastieSceneSettings23")
						vtss = GO;
				}
			#else
				vtss = GameObject.Find("VertexToastieSceneSettings23");
			#endif
			if (vtss!=null){
				SceneSettings = vtss.GetComponent<VertexToastieSceneSettings>();
				if (SceneSettings == null){
					SceneSettings = vtss.AddComponent<VertexToastieSceneSettings>();
				}
			}
			else{
				GameObject temp = new GameObject();
				temp.name = "VertexToastieSceneSettings23";
				
				SceneSettings = temp.AddComponent<VertexToastieSceneSettings>();
			}
			if (SceneSettings == null)
				Debug.LogError("Vertex Toastie can't create or load a gameObject to save the scene's settings! I'm really sorry but I'm not sure why this has happened, please file a bug report with as much info as possible (maybe even a project file), thanks! :)");
		}
		VertexToastieSceneSettings.Instance = SceneSettings;
		SceneSettings.gameObject.hideFlags = SceneSettings.DebugMode?HideFlags.None:HideFlags.HideInHierarchy;
	}
	int Existence = 0;
	VertexToastieSceneSettings SceneSettings;
	
	public bool JobsDirty = false;
	public bool BehavioursDirty = false;
	
	public GOVBDictionary IterativeVertexAOJobs = new GOVBDictionary();
	
	public Vector2 WinSize;
	//Hierarchy Handling Variables
	Vector2 HierarchyScroll = new Vector2(0,0);
	int HierarchyItemCount = 0;
	
	int HierarchySelectedID = -1;
	int HierarchyHeight = 200;
	
	bool SettingsScope = false;
	
	bool CollidersGenerated = false;
	
	int ObjectRoles = 0;
	int RoleBaked = 0;
	int RoleRealtime = 1;
	int RoleCollider = 2;
	
	public int InterfaceSize = 10;
	void OnGUI(){
		GetSceneSettings();
		EMindGUI.TrackMouseStuff();
		Existence++;
		
		WinSize = new Vector2(position.width,position.height);
		HierarchyHeight = (int)WinSize.y-(536-200);
		GUI.BeginGroup(new Rect(0,17, WinSize.x,WinSize.y));
		Rect WinRect = new Rect(0,0,position.width,position.height);
		
		Instance = this;
		EditorStyles.textField.wordWrap = true;
		Repaint();
//		GUISkin oldskin = GUI.skin;
		LoadStuff();
		if(Event.current.type==EventType.Repaint)
			EMindGUI.AddProSkin(WinSize);
		
		//EMindGUI.InterfaceBackgroundColorDuckups = 0;
		//EMindGUI.InterfaceColorDuckups = 0;
		
		GUI.Box(new Rect(25,25,WinSize.x-50,HierarchyHeight),"");
		EMindGUI.SetGUIColor(new Color(1,1,1,1));
		
		//ObjectRoles = GUI.SelectionGrid(new Rect(25,5,100*3,20),ObjectRoles,new string[]{"Baked","Realtime", "Collider"},3,EMindGUI.SCSkin.window);
		if (ObjectRoles != 0){
			if (GUI.Button(new Rect(25,5,100,20),new GUIContent("Baked"),GUI.skin.GetStyle("ButtonMid")))ObjectRoles = 0;
		}
		else{
			GUI.Toggle(new Rect(25,5,100,20),true,new GUIContent("Baked"),GUI.skin.GetStyle("ButtonMid"));
		}
		GUI.enabled = LayerMask.NameToLayer("VertexToastie")>0;
		if (ObjectRoles != 1){
			if (GUI.Button(new Rect(125,5,100,20),new GUIContent("Realtime"),GUI.skin.GetStyle("ButtonMid")))ObjectRoles = 1;
		}
		else{
			GUI.Toggle(new Rect(125,5,100,20),true,new GUIContent("Realtime"),GUI.skin.GetStyle("ButtonMid"));
		}
		GUI.enabled = true;
		if (ObjectRoles != 2){
			if (GUI.Button(new Rect(225,5,100,20),new GUIContent("Collider"),GUI.skin.GetStyle("ButtonRight")))ObjectRoles = 2;
		}
		else{
			GUI.Toggle(new Rect(225,5,100,20),true,new GUIContent("Collider"),GUI.skin.GetStyle("ButtonRight"));
		}
		GUI.enabled = true;
		int i = 0;
		int TotalRays = 0;
		int ExpectedRays = 0;
		HierarchyScroll = GUI.BeginScrollView(new Rect(25,25,WinSize.x-50,HierarchyHeight), HierarchyScroll, new Rect(0,0,WinSize.x-100,HierarchyItemCount*16+8));
		EMindGUI.ResetGUIColor();
		EditorGUI.BeginChangeCheck();
		//foreach (GameObject GO in SceneRoots()){
		DrawHierarchy(SceneRoots(), false, ref i, 0, ref TotalRays, ref ExpectedRays, WinRect);
		if (i==0){
			if (ObjectRoles==RoleBaked)
				GUI.Label(new Rect(16,16,WinSize.x,16),"There aren't any meshes in the scene!");
			if (ObjectRoles==RoleRealtime)
				GUI.Label(new Rect(16,16,WinSize.x,16),"Realtime bakers must still be selected in baked :)");
			if (ObjectRoles==RoleCollider)
				GUI.Label(new Rect(16,16,WinSize.x,16),"Colliders can only be selected from objects with meshes that aren't already being baked (they're automatically colliders) :)");
		}
		GUI.EndScrollView();
		//if (HierarchyItemCount!=i)
		//	SceneSettings.BakedObjects.Clear();
		HierarchyItemCount = i;
		
		TotalRays = 0;
		ExpectedRays = 0;
		foreach(GameObject GO in SceneSettings.BakedObjects){
			if (GO!=null&&IterativeVertexAOJobs.D.ContainsKey(GO)){
				VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[GO];
				if (baker!=null){
					if (baker.Cast != VertexToastieIterativeVertexAOBaker.BakeMode.None){
						TotalRays += baker.RayCount;
						ExpectedRays += baker.RMaxRays;
					}
					//else{
					//	TotalRays += baker.SeamVertexCount;
					//	ExpectedRays += baker.AOBakeMesh.vertexCount;
					//}
				}
			}
		}
		//GUI.backgroundColor = new Color(GUI.backgroundColor.r,GUI.backgroundColor.g,GUI.backgroundColor.b,0.5f);
		//GUI.skin.verticalScrollbarThumb.Draw(new Rect(WinSize.x-50,25+16,16,16), bool isHover, bool isActive, bool on, bool hasKeyboardFocus);
		EMindGUI.VerticalScrollbar(new Rect(25,25,WinSize.x-50,HierarchyHeight), HierarchyScroll, new Rect(0,0,WinSize.x-100,HierarchyItemCount*16+8));
//		Debug.Log(HierarchyScroll.y);
		
		
		
		HierarchyHeight+=25;
		EMindGUI.SetGUIBackgroundColor(new Color(0,0,0,0.5f));
		Rect tempRect = new Rect(25,HierarchyHeight,(WinSize.x-50),8);
		GUI.Box(tempRect,"");
		EMindGUI.ResetGUIBackgroundColor();
		EMindGUI.SetGUIBackgroundColor(EMindGUI.BaseInterfaceColor);
			Rect tempRect2;
			
			tempRect2 = new Rect(25+2,HierarchyHeight,(WinSize.x-50)*((float)(TotalRays)/(float)ExpectedRays)-4,8);
			if (ExpectedRays>0)
				GUI.Box(tempRect2,"","ObjectPickerToolbar");
		EMindGUI.ResetGUIBackgroundColor();
		HierarchyHeight+=8;
		//CurrentObject = (GameObject)EditorGUI.ObjectField(new Rect(25,50,WinSize.x-50,20), "Object: ", CurrentObject, typeof(GameObject), true);
		//GUI.DrawTexture(new Rect(25,HierarchyHeight,12,12), GUI.skin.horizontalSliderThumb.normal.background, ScaleMode.StretchToFill, false);
		//ProgressBarStyle = EditorGUI.TextField(new Rect(25,HierarchyHeight,WinSize.x-50,20), "Style: ", ProgressBarStyle,"TextField");
		GUI.Box(new Rect(25,HierarchyHeight+25,WinSize.x-50,10*25),"","button");
		EMindGUI.BoldText();
		EMindGUI.SCSkin.window.fontSize = EMindGUI.GetFontSize(16);
		GameObject[] selection = Selection.gameObjects;
		SettingsScope = (selection.Length>0);//GUI.SelectionGrid(new Rect(25,HierarchyHeight+25,WinSize.x-50,25),SettingsScope,new string[]{"Global","Local"},2,EMindGUI.SCSkin.window);
		EMindGUI.SCSkin.window.fontSize = EMindGUI.GetFontSize(12);
		string Local = "Local";
		
		if (SettingsScope){
			Local += " - "+selection[0].name;
			if (selection.Length>1)
				Local += ", "+selection[1].name;
			if (selection.Length>2)
				Local += ", "+selection[2].name;
			if (selection.Length>3)
				Local += ", "+selection[3].name;
			if (selection.Length>4)
				Local += ", "+selection[4].name;
			if (selection.Length>5)
				Local += ", "+selection[5].name;
		}
		EMindGUI.SetLabelSize(16);
		EMindGUI.Label(new Rect(25,HierarchyHeight+25,WinSize.x-50,7*25),SettingsScope?EMindGUI.StringLimit(Local,GUI.skin.label,WinSize.x-50):"Global",16);
		EMindGUI.SetLabelSize(12);
		
		EMindGUI.Label(new Rect(25+8,HierarchyHeight+25+20,WinSize.x-55,7*25),"Bake Settings",12);
		EMindGUI.UnboldText();
		EMindGUI.SetLabelSize(12);
		
		if (SettingsScope==false){
			SceneSettings.Rays = (int)EMindGUI.Slider(new Rect(25+16,HierarchyHeight+65,WinSize.x-55-16,20), "Rays Per Vertex: ", SceneSettings.Rays,1,1000);
			
			SceneSettings.MaxDist = EMindGUI.Slider(new Rect(25+16,HierarchyHeight+85,WinSize.x-55-16,20), "Ray Distance: ", SceneSettings.MaxDist,0.01f,100f);
			SceneSettings.Bias = EMindGUI.Slider(new Rect(25+16,HierarchyHeight+105,WinSize.x-55-16,20), "Bias: ", SceneSettings.Bias,0,0.1f);
		}
		else{
			int RaySetting = -1;
			float MaxDistSetting = -1;
			float BiasSetting = -1;
			
			bool RaySettingMultiple = false;
			bool MaxDistSettingMultiple = false;
			bool BiasSettingMultiple = false;
			
			bool RaySettingOverride = false;
			bool MaxDistSettingOverride = false;
			bool BiasSettingOverride = false;
			
			bool RaySettingOverrideYes = false;
			bool MaxDistSettingOverrideYes = false;
			bool BiasSettingOverrideYes = false;
			
			bool RaySettingOverrideNo = false;
			bool MaxDistSettingOverrideNo = false;
			bool BiasSettingOverrideNo = false;
			List<VertexToastieIterativeVertexAOBaker> tempSelected = new List<VertexToastieIterativeVertexAOBaker>();
			for (int ii = 0;ii<selection.Length;ii++){
				if (IterativeVertexAOJobs.D.ContainsKey(selection[ii])){
					VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[selection[ii]];
					tempSelected.Add(baker);
					if (RaySetting!=-1){
						if (RaySetting!=baker.MaxRays)
							RaySettingMultiple = true;
						if (MaxDistSetting!=baker.MaxDist)
							MaxDistSettingMultiple = true;
						if (BiasSetting!=baker.Bias)
							BiasSettingMultiple = true;
					}
					RaySetting = baker.MaxRays;
					MaxDistSetting = baker.MaxDist;
					BiasSetting = baker.Bias;
					if (baker.OverrideMaxRays)
						RaySettingOverrideYes = true;
					else
						RaySettingOverrideNo = true;
					
					if (baker.OverrideMaxDist)
						MaxDistSettingOverrideYes = true;
					else
						MaxDistSettingOverrideNo = true;
						
					if (baker.OverrideBias)
						BiasSettingOverrideYes = true;
					else
						BiasSettingOverrideNo = true;
				}
			}
			//Debug.Log(RaySettingOverrideYes.ToString()+", "+RaySettingOverrideNo.ToString());
			RaySettingOverride = RaySettingOverrideYes;
			MaxDistSettingOverride = MaxDistSettingOverrideYes;
			BiasSettingOverride = BiasSettingOverrideYes;
			
			EditorGUI.BeginChangeCheck();
				GUI.enabled = true;
				EditorGUI.showMixedValue = RaySettingOverrideYes&&RaySettingOverrideNo;
				RaySettingOverride = EMindGUI.Toggle(new Rect(25,HierarchyHeight+65,16,16), RaySettingOverride);
			if (EditorGUI.EndChangeCheck())
				foreach(VertexToastieIterativeVertexAOBaker baker in tempSelected)
					baker.OverrideMaxRays = RaySettingOverride;
			
			EditorGUI.BeginChangeCheck();
				GUI.enabled = RaySettingOverrideYes;
				EditorGUI.showMixedValue = RaySettingMultiple;
				RaySetting = (int)EMindGUI.Slider(new Rect(25+16,HierarchyHeight+65,WinSize.x-55-16,20), "Rays Per Vertex: ", RaySetting,1,1000);
			if (EditorGUI.EndChangeCheck())
				foreach(VertexToastieIterativeVertexAOBaker baker in tempSelected)
					baker.MaxRays = RaySetting;
			
			EditorGUI.BeginChangeCheck();
				GUI.enabled = true;
				EditorGUI.showMixedValue = MaxDistSettingOverrideYes&&MaxDistSettingOverrideNo;
				MaxDistSettingOverride = EMindGUI.Toggle(new Rect(25,HierarchyHeight+85,16,16), MaxDistSettingOverride);
			if (EditorGUI.EndChangeCheck())
				foreach(VertexToastieIterativeVertexAOBaker baker in tempSelected)
					baker.OverrideMaxDist = MaxDistSettingOverride;
			
			EditorGUI.BeginChangeCheck();
				GUI.enabled = MaxDistSettingOverrideYes;
				EditorGUI.showMixedValue = MaxDistSettingMultiple;
				MaxDistSetting = EMindGUI.Slider(new Rect(25+16,HierarchyHeight+85,WinSize.x-55-16,20), "Ray Distance: ", MaxDistSetting,0.01f,100f);
			if (EditorGUI.EndChangeCheck())
				foreach(VertexToastieIterativeVertexAOBaker baker in tempSelected)
					baker.MaxDist = MaxDistSetting;
			
			EditorGUI.BeginChangeCheck();
				GUI.enabled = true;
				EditorGUI.showMixedValue = BiasSettingOverrideYes&&BiasSettingOverrideNo;
				BiasSettingOverride = EMindGUI.Toggle(new Rect(25,HierarchyHeight+105,16,16), BiasSettingOverride);
			if (EditorGUI.EndChangeCheck())
				foreach(VertexToastieIterativeVertexAOBaker baker in tempSelected)
					baker.OverrideBias = BiasSettingOverride;
			
			EditorGUI.BeginChangeCheck();
				GUI.enabled = BiasSettingOverrideYes;
				EditorGUI.showMixedValue = BiasSettingMultiple;
				BiasSetting = EMindGUI.Slider(new Rect(25+16,HierarchyHeight+105,WinSize.x-55-16,20), "Bias: ", BiasSetting,0,0.1f);
			if (EditorGUI.EndChangeCheck())
				foreach(VertexToastieIterativeVertexAOBaker baker in tempSelected)
					baker.Bias = BiasSetting;
			
			EditorGUI.showMixedValue = false;
			GUI.enabled = true;
		}
		if (EditorGUI.EndChangeCheck()){
			if (Application.isPlaying){
				#if !PRE_MORESTUPIDUNITYDEPRECATIONS
					UnityEditor.SceneManagement.EditorSceneManager.MarkAllScenesDirty();
				#else
					EditorUtility.SetDirty(EditorApplication.currentScene);
				#endif
			}
			if (ObjectRoles==RoleBaked||ObjectRoles==RoleCollider){
				FixBehaviours();
				RestartJobs();
			}
		}
		if (ExpectedRays>0&&TotalRays<ExpectedRays){
			if (GUI.Button(new Rect(25,HierarchyHeight,WinSize.x-50-100,20),"Stop Baking :(")){
				foreach(KeyValuePair<GameObject,VertexToastieIterativeVertexAOBaker> bakerPair in IterativeVertexAOJobs.D){
					VertexToastieIterativeVertexAOBaker baker = bakerPair.Value;
					if (baker!=null){
						baker.StopBake();
						baker.DestroyColliders();
					}
				}
				//IterativeVertexAOJobs.Clear();
			}
		}
		else if (ExpectedRays>0){
			if (GUI.Button(new Rect(25,HierarchyHeight,WinSize.x-50-100,20),"Re-Bake!")){
				FixBehaviours();
				RestartJobs(true);
			}
		}
		else{
			if (GUI.Button(new Rect(25,HierarchyHeight,WinSize.x-50-100,20),"Start Baking!")){
				FixBehaviours();
				RestartJobs(true);
			}
		}
		int tempAuto = SceneSettings.AutoStartJobs?1:0;
		tempAuto = GUI.SelectionGrid(new Rect(WinSize.x-50-100+25,HierarchyHeight,100,20),tempAuto,new string[]{"Manual","Auto"},2,EMindGUI.SCSkin.window);
		SceneSettings.AutoStartJobs = tempAuto==1;
		
		int y = 0;
		i = 0;
		int VertCount = 0;
		
		bool AllDone = true;
		bool AllDoneCleaned = true;
		if (!BehavioursDirty&&!JobsDirty){
			//foreach(KeyValuePair<GameObject,VertexToastieIterativeVertexAOBaker> bakerPair in IterativeVertexAOJobs.D){
			foreach(GameObject GO in SceneSettings.BakedObjects){
				if (GO!=null&&IterativeVertexAOJobs.D.ContainsKey(GO)){
					VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[GO];
					if (baker != null){
							baker.BakeVertexAO();
							if (baker.GenerateColliders==true){
								baker.GenerateColliders = false;
								GenerateColliders();
							}
							//baker.FixSeams();
						
						if ((baker.Cast!=VertexToastieIterativeVertexAOBaker.BakeMode.None||baker.CheckSeams)&&baker.Role!=VertexToastieIterativeVertexAOBaker.Roles.Collider){
							VertCount += baker.OriginalMesh.vertexCount;
							i++;
							AllDone = false;
						}
						if (!baker.CastCleanup)
							AllDoneCleaned = false;
						
						//if (VertCount>1000)
						//break;
					}
				}
				//y+=25;
			}
		}
		if (AllDone==true&&AllDoneCleaned==false){
			foreach(KeyValuePair<GameObject,VertexToastieIterativeVertexAOBaker> bakerPair in IterativeVertexAOJobs.D){
				VertexToastieIterativeVertexAOBaker baker = bakerPair.Value;
				baker.DestroyColliders();
			}		
			CollidersGenerated = false;
		}
		//y = IterativeVertexAOJobs.D.Count*25;
		EMindGUI.BoldText();
		EMindGUI.Label(new Rect(25+8,HierarchyHeight+125,WinSize.x-50,7*25),"Display Settings",12);
		EMindGUI.UnboldText();
		EMindGUI.SetLabelSize(12);
		
		EditorGUI.BeginChangeCheck();
		SceneSettings.AOStrength = EMindGUI.Slider(new Rect(25+16,HierarchyHeight+145,WinSize.x-55-16,20), "Strength: ", SceneSettings.AOStrength,0,3);
		SceneSettings.AOPower = EMindGUI.Slider(new Rect(25+16,HierarchyHeight+165,WinSize.x-55-16,20), "Thinness: ", SceneSettings.AOPower,0,4);
		SceneSettings.AODisplay = GUI.SelectionGrid(new Rect(25+16,HierarchyHeight+185,WinSize.x-55-16,40),SceneSettings.AODisplay,new string[]{"None","AO Only", "Ambient","Ambient+Diffuse"},2,EMindGUI.SCSkin.window);
		SceneSettings.VisualizeAO = SceneSettings.AODisplay==1;
		SceneSettings.ApplyAOToDiffuse = SceneSettings.AODisplay==3;
		
		float realstrength = SceneSettings.AOStrength;
		if (SceneSettings.AODisplay==0)
			realstrength = 0f;
		//VisualizeAO = EditorGUI.Toggle(new Rect(25,HierarchyHeight+225,WinSize.x-50,20), "Visualize AO: ", VisualizeAO);
		//ApplyAOToDiffuse = EditorGUI.Toggle(new Rect(25,HierarchyHeight+250,WinSize.x-50,20), "Diffuse AO: ", ApplyAOToDiffuse);
		if (EditorGUI.EndChangeCheck()){
			if (SceneSettings.VisualizeAO)
				Shader.EnableKeyword("Visualize_AO");
			else
				Shader.DisableKeyword("Visualize_AO");
			if (SceneSettings.ApplyAOToDiffuse)
				Shader.EnableKeyword("ApplyAOToDiffuse");
			else
				Shader.DisableKeyword("ApplyAOToDiffuse");
			SceneView.RepaintAll(); 
			foreach(GameObject CurrentObject in SceneSettings.BakedObjects){
				if (CurrentObject!=null){
					if (SceneSettings.AutoCorrectMaterials){
						Material[] mats;
						if (CurrentObject.GetComponent<MeshRenderer>()!=null)
							mats = CurrentObject.GetComponent<MeshRenderer>().sharedMaterials;
						else
							mats = CurrentObject.GetComponent<SkinnedMeshRenderer>().sharedMaterials;
							
						foreach (Material mat in mats){
							if (mat.HasProperty("_AOStrength"))
								mat.SetFloat("_AOStrength",realstrength);
							if (mat.HasProperty("_AOPower"))
								mat.SetFloat("_AOPower",SceneSettings.AOPower);
							if (Shader.Find("Vertex Toastie/"+mat.shader.name)!=null)
								mat.shader = Shader.Find("Vertex Toastie/"+mat.shader.name);
						}
					}					
				}
			}
		}
		//AutoStartJobs = EditorGUI.Toggle(new Rect(25,HierarchyHeight+200,WinSize.x-50,20), "Auto Start: ", AutoStartJobs);
		y+=75+50+50;
		/*if (GUI.Button(new Rect(25,HierarchyHeight+100+y,WinSize.x-50,20),"Fix Seams")){
			foreach(KeyValuePair<GameObject,VertexToastieIterativeVertexAOBaker> bakerPair in IterativeVertexAOJobs.D){
				VertexToastieIterativeVertexAOBaker baker = bakerPair.Value;
				if (baker!=null)
					baker.StartFixingSeams();
			}
		}
		y += 25;*/
		/*if (GUI.Button(new Rect(25,HierarchyHeight+100+y,WinSize.x-50,20),"Clear Bake")){
			foreach(KeyValuePair<GameObject,VertexToastieIterativeVertexAOBaker> bakerPair in IterativeVertexAOJobs.D){
				VertexToastieIterativeVertexAOBaker baker = bakerPair.Value;
				if (baker!=null)
					baker.ClearBake();
			}
		}*/
		if (JobsDirty==true){
			FixBehaviours();
			RestartJobs();
		}
		else
		if (BehavioursDirty==true){
			FixBehaviours();
		}
		GUI.EndGroup();
		//if (GUILayout.Button("Create...", EditorStyles.toolbarButton))
		Color OldColor = GUI.backgroundColor;
		GUI.backgroundColor = new Color(1,1,1,1);
		GUILayout.BeginHorizontal(GUI.skin.GetStyle("Toolbar"));
		/*if (GUILayout.Button("File", GUI.skin.GetStyle("ToolbarDropDown")))
		{
			GenericMenu toolsMenu = new GenericMenu();
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
		}*/
		if (GUILayout.Button("Help",GUI.skin.GetStyle("ToolbarDropDown")))
		{
			GenericMenu toolsMenu = new GenericMenu();
			toolsMenu.AddItem(new GUIContent("Open Online Documentation"), false, OpenHelp);

			toolsMenu.DropDown(new Rect(146, 0, 0, 17));
			EditorGUIUtility.ExitGUI();
		}
		
		//GUILayout.Label(Path.GetFileName(AssetDatabase.GetAssetPath(OpenShader)));
		GUILayout.FlexibleSpace();
		//InterfaceSize = EditorGUILayout.IntField(new GUIContent(""),InterfaceSize,GUILayout.Width(24));
		EditorGUI.BeginChangeCheck();
			EMindGUI.InterfaceSize = EditorPrefs.GetInt("ElectronicMindStudiosInterfaceSize", 10);
		EMindGUI.InterfaceSize = EditorGUILayout.IntSlider(new GUIContent(""),EMindGUI.InterfaceSize,8,14,GUILayout.Width(140));
		if (EditorGUI.EndChangeCheck()){
			EditorPrefs.SetInt("ElectronicMindStudiosInterfaceSize", EMindGUI.InterfaceSize);
		}
		Color newCol = EditorGUILayout.ColorField(new GUIContent(""),EMindGUI.InterfaceColor,GUILayout.Width(100));
		if (newCol!=EMindGUI.InterfaceColor){
			if (EMindGUI.GetVal(newCol)>0){
				EMindGUI.InterfaceColor = newCol;
				
				EditorPrefs.SetFloat("ElectronicMindStudiosInterfaceColor_R", EMindGUI.InterfaceColor.r);
				EditorPrefs.SetFloat("ElectronicMindStudiosInterfaceColor_G", EMindGUI.InterfaceColor.g);
				EditorPrefs.SetFloat("ElectronicMindStudiosInterfaceColor_B", EMindGUI.InterfaceColor.b);
				EditorPrefs.SetFloat("ElectronicMindStudiosInterfaceColor_A", EMindGUI.InterfaceColor.a);
			}
		}
		GUILayout.EndHorizontal();
		GUI.backgroundColor = OldColor;
		
		
		if(Event.current.type==EventType.Repaint)
			EMindGUI.EndProSkin();
		//EditorGUI.DrawTextureAlpha(new Rect(20,WinSize.y-20,13,13),GUI.skin.GetStyle("IN Foldout").normal.background,ScaleMode.ScaleToFit);
		//EditorGUI.DrawTextureAlpha(new Rect(40,WinSize.y-20,13,13),GUI.skin.GetStyle("IN Foldout").active.background,ScaleMode.ScaleToFit);
		
		//EditorGUI.DrawTextureAlpha(new Rect(60,WinSize.y-20,13,13),GUI.skin.GetStyle("IN Foldout").onNormal.background,ScaleMode.ScaleToFit);
		//EditorGUI.DrawTextureAlpha(new Rect(80,WinSize.y-20,13,13),GUI.skin.GetStyle("IN Foldout").onActive.background,ScaleMode.ScaleToFit);
	}
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
				EditorGUIUtility.systemCopyBuffer = "http://electronic-mind.org/Pages/VertexToastie/Main.html";
				EditorUtility.DisplayDialog("Copied!", "The URL:\nhttp://electronic-mind.org/Pages/VertexToastie/Main.html has been copied!", "Ok");
				break;
		}
	
	}
	public void GenerateColliders(){
		if (!CollidersGenerated){
			CollidersGenerated = true;
			foreach(GameObject GO in SceneSettings.AllObjects){
				if (GO!=null&&IterativeVertexAOJobs.D.ContainsKey(GO)){
					VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[GO];
					if (baker != null){
						if (!baker.HasBeenPrepared){
							baker.PrepareColliders();
						}
					}
				}
			}
		}
	}
	public void RestartJobs(){
		RestartJobs(false);
	}
	public void RestartJobs(bool Force){
		JobsDirty = false;
		//Debug.Log(!SceneSettings.AutoStartJobs&&!Force&&Existence>200);
		if (!SceneSettings.AutoStartJobs&&!Force&&Existence>200)
		return;
		foreach(GameObject CurrentObject in SceneSettings.ColliderObjects){
			if (CurrentObject!=null){
				VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[CurrentObject];
				baker.enabled = true;
				baker.StartJob();
			}
		}
		foreach(GameObject CurrentObject in SceneSettings.BakedObjects){
			if (CurrentObject!=null){
				VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[CurrentObject];
				baker.enabled = true;
				baker.StartJob();
			}
		}
	}
	public void FixBehaviours(){
		BehavioursDirty = false;
		//if (Existence>200)
		//return;
		foreach(GameObject CurrentObject in SceneSettings.AllObjects){
			if (CurrentObject!=null){
				VertexToastieIterativeVertexAOBaker baker;
				if (IterativeVertexAOJobs.D.ContainsKey(CurrentObject)&&IterativeVertexAOJobs.D[CurrentObject]!=null){
					baker = IterativeVertexAOJobs.D[CurrentObject];
				}
				else if (CurrentObject.GetComponent<VertexToastieIterativeVertexAOBaker>() != null){
					baker = CurrentObject.GetComponent<VertexToastieIterativeVertexAOBaker>();
					IterativeVertexAOJobs.D[CurrentObject] = baker;
				}
				else{
					baker = CurrentObject.AddComponent<VertexToastieIterativeVertexAOBaker>();
					IterativeVertexAOJobs.D[CurrentObject] = baker;
				}
				baker.hideFlags = SceneSettings.DebugMode?HideFlags.None:HideFlags.HideInInspector;
				if (SceneSettings.BakedObjects.Contains(CurrentObject)){
					baker.Role = VertexToastieIterativeVertexAOBaker.Roles.Baked;
					if (SceneSettings.RealtimeObjects.Contains(CurrentObject))
						baker.Role = VertexToastieIterativeVertexAOBaker.Roles.Realtime;
					if (SceneSettings.ColliderObjects.Contains(CurrentObject))
						SceneSettings.ColliderObjects.Remove(CurrentObject);
				}
				else if (SceneSettings.ColliderObjects.Contains(CurrentObject)){
					baker.Role = VertexToastieIterativeVertexAOBaker.Roles.Collider;
					if (SceneSettings.BakedObjects.Contains(CurrentObject))
						SceneSettings.BakedObjects.Remove(CurrentObject);
				}
				baker.UpdateSelfTracker();
			}
		}
	}
	public Texture2D IconLocked;
	public Texture2D IconUnlocked;
	public Texture2D IconPlay;
	public Texture2D IconPause;
	public Texture2D IconStop;
	static public string ProgressBarStyle = "ChannelStripAttenuationBar";
	
	public IntBoolDictionary FoldOuts = new IntBoolDictionary();
	public void DrawHierarchy(IEnumerable<GameObject> GameObjects, bool Hidden, ref int i,int depth, ref int TotalRays, ref int ExpectedRays, Rect WinRect){
		foreach (GameObject GO in GameObjects){
			if (GO==null)
				continue;
			
			if (GO.hideFlags == (HideFlags.HideInHierarchy))
				continue;
			
			if (Hidden)
				continue;
			
			if (!FoldOuts.D.ContainsKey(GO.GetInstanceID()))
				FoldOuts.D[GO.GetInstanceID()] = true;
			
			bool ObjectHasMesh = !(GO.GetComponent<MeshFilter>()==null&&GO.GetComponent<SkinnedMeshRenderer>()==null);
			bool ChildHasMesh = (GO.GetComponentsInChildren<MeshFilter>().Length>(ObjectHasMesh?1:0)||GO.GetComponentsInChildren<SkinnedMeshRenderer>().Length>(ObjectHasMesh?1:0));
			
			bool ObjectHasBaker = false;
			bool ChildHasBaker = false;
			if (ObjectRoles == RoleRealtime||ObjectRoles == RoleCollider){
				if (SceneSettings.BakedObjects.Contains(GO))
					ObjectHasBaker = true;
				if (!ObjectHasBaker){
					foreach(VertexToastieIterativeVertexAOBaker baker in GO.GetComponentsInChildren<VertexToastieIterativeVertexAOBaker>()){
						if (SceneSettings.BakedObjects.Contains(baker.gameObject)){
							ChildHasBaker = true;
							break;
						}
					}
				}
				if (ObjectRoles == RoleRealtime){
					ChildHasMesh = ChildHasMesh&&ChildHasBaker;
					ObjectHasMesh = ObjectHasMesh&&ObjectHasBaker;
				}
				if (ObjectRoles == RoleCollider){
					ChildHasMesh = ChildHasMesh&&!ChildHasBaker;
					ObjectHasMesh = ObjectHasMesh&&!ObjectHasBaker;
				}
			}
			
			Rect tempRect = new Rect(16,i*16+8,WinRect.width-50-32,16);
			//Debug.Log(GO.name+", "+ChildHasMesh.ToString()+", "+ObjectHasMesh.ToString());
			if (ObjectHasMesh||ChildHasMesh){
				if (ObjectHasMesh){
					List<GameObject> HierarchyList;
					if (ObjectRoles == RoleBaked)
						HierarchyList = SceneSettings.BakedObjects;
					else if (ObjectRoles == RoleRealtime)
						HierarchyList = SceneSettings.RealtimeObjects;
					else//collider
						HierarchyList = SceneSettings.ColliderObjects;
					tempRect.x-=16;
					tempRect.width+=16;
					if (HierarchyList.IndexOf(GO)>-1){
						EMindGUI.SetGUIBackgroundColor(new Color(0,0,0,0.5f));
						tempRect.y-=1;
						
						GUI.Box(tempRect,"");
						EMindGUI.ResetGUIBackgroundColor();
//						Debug.Log(GO.name+", "+IterativeVertexAOJobs.D.ContainsKey(GO).ToString());
						if (IterativeVertexAOJobs.D.ContainsKey(GO)&&IterativeVertexAOJobs.D[GO]!=null){
							VertexToastieIterativeVertexAOBaker baker = IterativeVertexAOJobs.D[GO];
							EMindGUI.SetGUIBackgroundColor(new Color(1,1,1,1f));
							EMindGUI.SetGUIColor(EMindGUI.BaseInterfaceColor);
							if (baker!=null&&baker.Cast != VertexToastieIterativeVertexAOBaker.BakeMode.None){
								Rect tempRect2;
								
								if (baker.LastMatter == 1){
									tempRect2 = new Rect(16,i*16-1+8,(WinRect.width-50-32)*((float)(baker.RayCount)/(float)baker.RMaxRays),16);
									TotalRays += baker.RayCount;
									ExpectedRays += baker.RMaxRays;
								}
								else{
									tempRect2 = new Rect(16,i*16-1+8,(WinRect.width-50-32)*((float)(baker.SeamVertexCount)/(float)baker.AOBakeMesh.vertexCount),16);
									TotalRays += baker.SeamVertexCount;
									ExpectedRays += baker.AOBakeMesh.vertexCount;
								}
								tempRect2.y+=15;
								tempRect2.height = 0;
								GUI.Box(tempRect2,"",EMindGUI.SCSkin.GetStyle("minibutton"));
							}
							bool ogc = GUI.changed;
							
							
							baker.Locked = GUI.Toggle(new Rect(tempRect.x+tempRect.width-16,tempRect.y,16,16),baker.Locked, new GUIContent(baker.Locked?IconLocked:IconUnlocked),GUI.skin.label);
							if (baker.Cast != VertexToastieIterativeVertexAOBaker.BakeMode.None){
								if (GUI.Button(new Rect(tempRect.x+tempRect.width-32,tempRect.y,16,16),new GUIContent(IconStop),GUI.skin.label)){
									baker.StopBake();
									baker.DestroyColliders();
								}
							}
							else{
								if (GUI.Button(new Rect(tempRect.x+tempRect.width-32,tempRect.y,16,16),new GUIContent(IconPlay),GUI.skin.label)){
									GenerateColliders();
									baker.StartJob();
								}
							}
							
							
							GUI.changed = ogc;
							EMindGUI.ResetGUIColor();
							EMindGUI.ResetGUIBackgroundColor();
								//EditorGUI.ProgressBar(tempRect, (float)(baker.RayCount)/(float)baker.MaxRays, "Iterations: "+(baker.RayCount).ToString()+"/"+baker.MaxRays.ToString());
						}
						tempRect.y+=1;
						
						GUI.color = new Color(EMindGUI.BaseInterfaceColor.r,EMindGUI.BaseInterfaceColor.g,EMindGUI.BaseInterfaceColor.b,1f);
						
					}
					tempRect.x+=16+16*depth;
					tempRect.width-=16;
					tempRect.width-=48+16*depth;
					if (new Rect(25,25,WinSize.x-50-16,HierarchyHeight+25).Contains(EMindGUI.mouse.DragStartPos)&&(EMindGUI.MouseDownIn(tempRect,false)||(EMindGUI.MouseHoldIn(tempRect,false)&&EMindGUI.mouse.MouseDown&&HierarchySelectedID!=i))){
						if (HierarchyList.IndexOf(GO)<0){
							if (ObjectRoles == RoleBaked||ObjectRoles == RoleCollider){
								JobsDirty = true;
							}
							BehavioursDirty = true;
							HierarchyList.Add(GO);
							
							if (SceneSettings.AutoCorrectMaterials){
								float realstrength = SceneSettings.AOStrength;
								if (SceneSettings.AODisplay==0)
									realstrength = 0f;
								Material[] mats;
								if (GO.GetComponent<MeshRenderer>()!=null)
									mats = GO.GetComponent<MeshRenderer>().sharedMaterials;
								else
									mats = GO.GetComponent<SkinnedMeshRenderer>().sharedMaterials;
									
								foreach (Material mat in mats){
									if (mat.HasProperty("_AOStrength"))
										mat.SetFloat("_AOStrength",realstrength);
									if (mat.HasProperty("_AOPower"))
										mat.SetFloat("_AOPower",SceneSettings.AOPower);
									if (Shader.Find("Vertex Toastie/"+mat.shader.name)!=null)
										mat.shader = Shader.Find("Vertex Toastie/"+mat.shader.name);
								}
							}
						}
						else{
							HierarchyList.Remove(GO);
							VertexToastieIterativeVertexAOBaker baker = null;
							if (HierarchyList == SceneSettings.BakedObjects&&SceneSettings.RealtimeObjects.IndexOf(GO)>-1){
								SceneSettings.RealtimeObjects.Remove(GO);
							}
							if (!(SceneSettings.BakedObjects.Contains(GO)||SceneSettings.RealtimeObjects.Contains(GO)||SceneSettings.ColliderObjects.Contains(GO))){
								if (IterativeVertexAOJobs.D.ContainsKey(GO)){
									baker = IterativeVertexAOJobs.D[GO];
									IterativeVertexAOJobs.D.Remove(GO);
								}
								else
								if (GO.GetComponent<VertexToastieIterativeVertexAOBaker>() != null)
									baker = GO.GetComponent<VertexToastieIterativeVertexAOBaker>();
								
								if (baker!=null){
									baker.StopBake();
									baker.DestroyColliders();
									baker.ClearBake();
									DestroyImmediate(baker);
									//baker.enabled = false;
								}
							}
							if (ObjectRoles == RoleBaked||ObjectRoles == RoleCollider){
								JobsDirty = true;
							}
							BehavioursDirty = true;
						}
						HierarchySelectedID = i;
						
					}
					if (EMindGUI.MouseUpIn(tempRect,false))
						GUI.changed = true;
					tempRect.x -= 16*depth;
					
				}else{
					GUI.color *= 0.5f;
				}
				tempRect.x += 16*depth;
				GUI.Label(tempRect,GO.name);
				tempRect.x -= 16;
				if (GO.transform.childCount>0){
					bool ogc2 = GUI.changed;
					EMindGUI.SetGUIBackgroundColor(new Color(1,1,1,1f));
					EMindGUI.SetGUIColor(EMindGUI.BaseInterfaceColor);
						FoldOuts.D[GO.GetInstanceID()] = EditorGUI.Foldout(tempRect,FoldOuts.D[GO.GetInstanceID()],"",GUI.skin.GetStyle("IN Foldout"));
					EMindGUI.ResetGUIBackgroundColor();
					EMindGUI.ResetGUIColor();
					GUI.changed = ogc2;
					//Debug.Log(GUI.color);
				}
				
				tempRect.x -= 16*depth-16;
				
				GUI.color = new Color(1,1,1,1);
				i+=1;
			}

			List<GameObject> children = new List<GameObject>();
			foreach(Transform child in GO.GetComponent<Transform>())
				children.Add(child.gameObject);
			
			if (Selection.gameObjects.Contains(GO)&&(ChildHasMesh||ObjectHasMesh)){
				EMindGUI.SetGUIBackgroundColor(EMindGUI.BaseInterfaceColor);
				EMindGUI.SetGUIColor(EMindGUI.BaseInterfaceColor);
				tempRect.width = 1;
				tempRect.y -= 1;
				GUI.Box(tempRect,"",EMindGUI.SCSkin.GetStyle("ObjectPickerPreviewBackground"));
				EMindGUI.ResetGUIColor();
				EMindGUI.ResetGUIBackgroundColor();
				//Debug.Log(GUI.color);
			}
			DrawHierarchy(children,!FoldOuts.D[GO.GetInstanceID()], ref i, depth+1, ref TotalRays, ref ExpectedRays, WinRect);
		}
	}
	public static IEnumerable<GameObject> SceneRoots(){
		#if PRE_UNITY_5_3
			HierarchyProperty prop = new HierarchyProperty(HierarchyType.GameObjects);
			int[] expanded = new int[0];
			while (prop.Next(expanded)){
				yield return prop.pptrValue as GameObject;
			}
		#else	
			return UnityEngine.SceneManagement.SceneManager.GetActiveScene().GetRootGameObjects();
		#endif
	}
	
	public void LoadStuff(){
		//if (SSSkin==null)
		//	SSSkin = EditorGUIUtility.Load("Vertex Toastie/Misc/MainSkin.guiskin") as GUISkin;
		//if (SCSkin==null)
		//	SCSkin = EditorGUIUtility.Load("Vertex Toastie/Misc/UtilGuiSkin.guiskin") as GUISkin;
		if (IconLocked==null)
			IconLocked = EditorGUIUtility.Load("ElectronicMindStudios/Vertex Toastie/Misc/LockClosed.fw.png") as Texture2D;
		if (IconUnlocked==null)
			IconUnlocked = EditorGUIUtility.Load("ElectronicMindStudios/Vertex Toastie/Misc/LockOpen.fw.png") as Texture2D;
		if (IconPlay==null)
			IconPlay = EditorGUIUtility.Load("ElectronicMindStudios/Vertex Toastie/Misc/Play.fw.png") as Texture2D;
		if (IconPause==null)
			IconPause = EditorGUIUtility.Load("ElectronicMindStudios/Vertex Toastie/Misc/Pause.fw.png") as Texture2D;
		if (IconStop==null)
			IconStop = EditorGUIUtility.Load("ElectronicMindStudios/Vertex Toastie/Misc/Stop.fw.png") as Texture2D;
	}

}