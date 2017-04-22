#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2
#define PRE_MORESTUPIDUNITYDEPRECATIONS
#endif
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using EMindGUI = ElectronicMindStudiosInterfaceUtils;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Xml;

public enum Frag{Surf, VertFrag};
public enum Vert{Surf, VertFrag};

static public class ShaderUtil{

	static public void TimerDebug(System.Diagnostics.Stopwatch sw){
		string ExecutionTimeTaken = string.Format("Minutes :{0}\nSeconds :{1}\n Mili seconds :{2}",sw.Elapsed.Minutes,sw.Elapsed.Seconds,sw.Elapsed.TotalMilliseconds);
		UnityEngine.Debug.Log(ExecutionTimeTaken);	
	}
	static public void TimerDebug(System.Diagnostics.Stopwatch sw,string Add){
		string ExecutionTimeTaken = string.Format(Add+":\nMinutes :{0}\nSeconds :{1}\n Mili seconds :{2}",sw.Elapsed.Minutes,sw.Elapsed.Seconds,sw.Elapsed.TotalMilliseconds);
		UnityEngine.Debug.Log(ExecutionTimeTaken);	
		//sw.Reset();
	}
	static public int FlatArray(int X,int Y,int W,int H){
		return FlatArray(X,Y,W,H,null);
	}
	static public int FlatArray(int X,int Y,int W,int H,ShaderLayer SL){
		int ArrayPosX=0;
		int ArrayPosY=0;
		if (SL==null||SL.LayerType.Type!=(int)LayerTypes.Gradient){
			if (X!=0&&(W!=0))
			ArrayPosX = Mathf.Abs(X) % (W);//Mathf.Max(0,Mathf.Min(X,W-1));//Mathf.Floor(((float)X));
			if (Y!=0&&(H!=0))
			ArrayPosY = Mathf.Abs(Y) % (H);
		}
		else{
			ArrayPosX = Mathf.Max(0,Mathf.Min(X,W-1));
			ArrayPosY = Mathf.Max(0,Mathf.Min(Y,H-1));
		}

		
		//ArrayPosX = Mathf.Max(0,Mathf.Min(X,W-1));//Mathf.Floor(((float)Y));
		//ArrayPosY = Mathf.Max(0,Mathf.Min(Y,H-1));//Mathf.Floor(((float)Y));
		int ArrayPos = (ArrayPosY*(W))+ArrayPosX;
		return ArrayPos;
	}
	static public List<ShaderVar> GetAllShaderVars(){
		List<ShaderVar> SVs = new List<ShaderVar>();
		foreach (ShaderLayer SL in ShaderUtil.GetAllLayers()){
			SL.UpdateShaderVars(true);
			SVs.AddRange(SL.ShaderVars);
		}
		SVs.AddRange(ShaderBase.Current.GetMyShaderVars());
		return SVs;
	}
	
	static public List<ShaderLayer> GetAllLayers(){
		List<ShaderLayer> tempList = new List<ShaderLayer>();
		foreach (List<ShaderLayer> SLL in ShaderSandwich.Instance.OpenShader.GetShaderLayers())
		tempList.AddRange(SLL);
		
		return tempList;
	}
	static public List<ShaderLayer> GetAllLayers(ShaderPass SP){
		List<ShaderLayer> tempList = new List<ShaderLayer>();
		foreach (List<ShaderLayer> SLL in SP.GetShaderLayers())
			tempList.AddRange(SLL);
		if (ShaderSandwich.Instance!=null){
			foreach(ShaderLayerList SLL in ShaderSandwich.Instance.OpenShader.ShaderLayersMasks)
				tempList.AddRange(SLL.SLs);
		}
		
		return tempList;
	}
	
	static Material MixMaterial;
	static Material AddMaterial;
	static Material SubMaterial;
	static Material MulMaterial;
	static Material DivMaterial;
	static Material DarMaterial;
	static Material LigMaterial;	
	
	public static Material NAMixMaterial;
	static Material NAAddMaterial;
	static Material NASubMaterial;
	static Material NAMulMaterial;
	static Material NADivMaterial;
	static Material NADarMaterial;
	static Material NALigMaterial;
	
	static public string something;
	
	static public Material GetMaterial(string S,Color col,bool UseAlpha){
		if (MixMaterial==null||AddMaterial==null||SubMaterial==null||NASubMaterial==null||NASubMaterial==null)
		{
			AddMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Additive") );
			LigMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Lighten") );
			DarMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Darken") );	
			SubMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Subtract") );	
			MulMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Multiply") );
			DivMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Divide") );
			MixMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Alpha Standard") );
			
			NAAddMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Additive") );
			NALigMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Lighten") );
			NADarMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Darken") );	
			NASubMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Subtract") );
			NAMulMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Multiply") );
			NADivMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Divide") );
			NAMixMaterial = new Material( Shader.Find("Hidden/ShaderSandwich/Standard") );
		}
		Material ReturnMat = null;
		if (UseAlpha){
			switch (S){
				case "Add":
					ReturnMat = AddMaterial;AddMaterial.SetColor("_Color",col);break;
				case "Mix":
					ReturnMat = MixMaterial;MixMaterial.SetColor("_Color",col);break;
				case "Subtract":
					ReturnMat = SubMaterial;SubMaterial.SetColor("_Color",col);break;
				case "Multiply":
					ReturnMat = MulMaterial;MulMaterial.SetColor("_Color",new Color(col.r,col.g,col.b,1f-col.a));break;
				case "Divide":
					ReturnMat = DivMaterial;DivMaterial.SetColor("_Color",col);break;
				case "Lighten":
					ReturnMat = LigMaterial;LigMaterial.SetColor("_Color",col);break;
				case "Darken":
					ReturnMat = DarMaterial;DarMaterial.SetColor("_Color",col);break;
				case "Normals Mix":
					ReturnMat = LigMaterial;LigMaterial.SetColor("_Color",col);break;
			}
		}
		else{
			switch (S){
				case "Add":
					ReturnMat = NAAddMaterial;NAAddMaterial.SetColor("_Color",col);break;
				case "Mix":
					ReturnMat = NAMixMaterial;NAMixMaterial.SetColor("_Color",col);break;
				case "Subtract":
					ReturnMat = NASubMaterial;NASubMaterial.SetColor("_Color",col);break;
				case "Multiply":
					ReturnMat = NAMulMaterial;NAMulMaterial.SetColor("_Color",new Color(col.r,col.g,col.b,1f-col.a));break;
				case "Divide":
					ReturnMat = NADivMaterial;NADivMaterial.SetColor("_Color",col);break;
				case "Lighten":
					ReturnMat = NALigMaterial;NALigMaterial.SetColor("_Color",col);	break;
				case "Darken":
					ReturnMat = NADarMaterial;NADarMaterial.SetColor("_Color",col);break;
				case "Normals Mix":
					ReturnMat = NALigMaterial;NALigMaterial.SetColor("_Color",col);	break;
			}
		}
		return ReturnMat;
	}
	

	static public ShaderInput GetShaderInput(ShaderInput SI){
	return new ShaderInput();//GetShaderInput(SI];
	}
	static public int InputSelection(int Type, int In)
	{
		int[] tempdropnumb = GenShaderInputArray(Type,true);
		string[] tempdropname= ShaderInputArrayToNames(tempdropnumb,true);

		return EditorGUILayout.IntPopup(In,tempdropname,tempdropnumb,GUILayout.Width(100));
	}
	
	static public int[] GenShaderInputArray( int Type)
	{
		return GenShaderInputArray_Real(ShaderSandwich.Instance.OpenShader, Type,false);
	}
	static public int[] GenShaderInputArray(int Type, bool NoOption)
	{
		return GenShaderInputArray_Real(ShaderSandwich.Instance.OpenShader,Type,NoOption);
	}
	static public int[] GenShaderInputArray_Real(ShaderBase OpenShader,int Type,bool NoOption)
	{
		List<int> RetArray =  new List<int>();
		//int InCount = 0;
		if (NoOption==true)
		RetArray.Add(-1);

		if (Type==3)
		{
			RetArray.Add(100);//Time
			RetArray.Add(101);//SinTime
			RetArray.Add(102);//ClampedSinTime
			RetArray.Add(103);//ClampedSinTime
			RetArray.Add(104);//ClampedSinTime
			RetArray.Add(105);//ClampedSinTime
			RetArray.Add(106);//ClampedSinTime
			RetArray.Add(107);//ClampedSinTime
			RetArray.Add(108);//ClampedSinTime
			if (ShaderSandwich.Instance.OpenShader.ParallaxOn.On)
			RetArray.Add(109);//ClampedSinTime
			if (ShaderSandwich.Instance.OpenShader.ShellsOn.On)
			RetArray.Add(110);//ClampedSinTime
		}

		for (int i = 0;i<=ShaderSandwich.Instance.OpenShader.ShaderInputCount;i++)
		{
			ShaderInput SI = ShaderSandwich.Instance.OpenShader.ShaderInputs[i];
			if (SI!=null)
			{
				if (SI.Type==Type||(Type==3&&(SI.Type==3||SI.Type==4)))
				{
					RetArray.Add(i);
					//InCount+=1;
				}
			}
		}



		return RetArray.ToArray();
	}
	static public string[] ShaderInputArrayToNames(int[] Arr)
	{
		return ShaderInputArrayToNames_Real(Arr,false);
	}
	static public string[] ShaderInputArrayToNames(int[] Arr,bool NoOption)
	{
		return ShaderInputArrayToNames_Real(Arr,NoOption);
	}
	static public string[] ShaderInputArrayToNames_Real(int[] Arr,bool NoOption)
	{
		string[] RetArray = new string[Arr.Length];
		int ia = 0;
		if (NoOption==true)
		{
			ia = 1;
			RetArray[0]="\n";
		}
		else
		{
			ia = 0;
		}

		for (int i = ia;i<Arr.Length;i++)
		{
			/*if (Arr[i]==-10)//Time
			RetArray[i] = ShaderInputs[100].VisName;
			else if (Arr[i]==-11)//SinTime
			RetArray[i] = ShaderInputs[101].VisName;
			else if (Arr[i]==-12)//ClampedSinTime
			RetArray[i] = ShaderInputs[102].VisName;
			else*/
			RetArray[i] = ShaderSandwich.Instance.OpenShader.ShaderInputs[Arr[i]].VisName;
		}
		return RetArray;
	}
	static public void MoveItem<T>(ref List<T> list,int OldIndex,int NewIndex){
	if (NewIndex<list.Count&&NewIndex>=0)
	{
		T item = list[OldIndex];
		list.RemoveAt(OldIndex);
		//if (NewIndex > OldIndex)
		//	NewIndex -= 1;
		
		list.Insert(NewIndex,item);
	}
	}
	static public string Ser<T>(T obj2){
	//Debug.Log(obj2);
		//XmlSerializer xsSubmit = new XmlSerializer(typeof(T));
		
		
		DataContractSerializer serializer = new DataContractSerializer(typeof(T), null, 
		2000, //maxItemsInObjectGraph
		false, //ignoreExtensionDataObject
		true, //preserveObjectReferences : this is where the magic happens 
		null); //dataContractSurrogate
			
		
		
		/*StringWriter sww = new StringWriter();
		XmlWriter writer = new XmlTextWriter(sww);//.Create(sww);
		serializer.WriteObject(writer, obj2);	
		//xsSubmit.Serialize(sww, obj2);
		return sww.GetStringBuilder().ToString();//.Replace("<?xml version=\"1.0\" encoding=\"utf-16\"?>",""); // Your xml	*/
		using (StringWriter output = new StringWriter())
		using (XmlTextWriter writer = new XmlTextWriter(output) {Formatting = Formatting.Indented})
		{
			serializer.WriteObject(writer, obj2);
			//Debug.Log(output.GetStringBuilder().ToString());
			return output.GetStringBuilder().ToString();
		}		
	}
	static public void SaveString(string fileName,string text){
		StreamWriter  sr = File.CreateText(fileName);
		sr.NewLine = "\n";
        sr.WriteLine (text);
        sr.Close();
	}
	static public List<Rect> Rects = new List<Rect>();
	static public void BeginGroup(Rect rect, GUIStyle GS){
		GUI.BeginGroup(rect,GS);
		Rects.Add(rect);
	}
	static public void BeginGroup(Rect rect){
		GUI.BeginGroup(rect);
		Rects.Add(rect);
	}
	static public void EndGroup(){
		if (Rects.Count>0){
			GUI.EndGroup();
			
			Rects.RemoveAt(Rects.Count-1);
		}
	}
	static public Vector2 BeginScrollView(Rect rect,Vector2 vec,Rect rect2,bool bo1,bool bo2){
		vec = GUI.BeginScrollView(rect,vec,rect2,bo1,bo2);
		Rects.Add(new Rect(-vec.x,-vec.y,100,100));
		return vec;
	}
	static public void EndScrollView(){
		if (Rects.Count>0){
			GUI.EndScrollView();
			
			Rects.RemoveAt(Rects.Count-1);
		}
	}	
	static public Rect GetGroupRect(){
		float x = 0;
		float y = 0;
		float w = 0;
		float h = 0;
		foreach(Rect rect in Rects){
			x+=rect.x;
			y+=rect.y;
			w=rect.width;
			h=rect.height;
		}
		return new Rect(x,y,w,h);
	}
	static public Vector2 GetGroupVector(){
		float x = 0;
		float y = 0;
		float w = 0;
		float h = 0;
		foreach(Rect rect in Rects){
			x+=rect.x;
			y+=rect.y;
			w+=rect.width;
			h+=rect.height;
		}
		return new Vector2(x,y);
	}
	static public Rect AddRect(Rect rect,Rect rect2){
		return new Rect(rect.x+rect2.x,rect.y+rect2.y,rect.width+rect2.width,rect.height+rect2.height);
	}
	static public Rect AddRectVector(Rect rect,Vector2 rect2){
		return new Rect(rect.x+rect2.x,rect.y+rect2.y,rect.width,rect.height);
	}
	static public string SaveDict(Dictionary<string,ShaderVar> D){
		string S = "";
		foreach(KeyValuePair<string, ShaderVar> entry in D){
			S += entry.Key+"#!"+entry.Value.Save();
		}
		return S;
	}
	static public void LoadLine(Dictionary<string,ShaderVar> D,string Line){
		string[] parts = Line.Replace("#^CC0","").Replace(" #^ CC0","").Split(new string[] { "#!" },StringSplitOptions.None);
		if (D.ContainsKey(parts[0].Trim()))
		D[parts[0].Trim()].Load(parts[1].Trim());
	}
	static public void LoadLine(Dictionary<string,ShaderVar> D,string Line,Dictionary<string,ShaderVar> CD){
		string[] parts = Line.Replace("#^CC0","").Replace(" #^ CC0","").Split(new string[] { "#!" },StringSplitOptions.None);
//		Debug.Log(parts[0].Trim());
		if (D.ContainsKey(parts[0].Trim()))
		D[parts[0].Trim()].Load(parts[1].Trim());
		else
		{//if (CD.ContainsKey(parts[0].Trim())){
			CD[parts[0].Trim()] = new ShaderVar(parts[0].Trim(),false);
			CD[parts[0].Trim()].Load(parts[1].Trim());
		}
	}
	static public string[] LoadLineExplode(string Line){
		return LoadLineExplode(Line,true);
	}
	static public string[] LoadLineExplode(string Line,bool RemoveCC){
		if (RemoveCC)
		return Line.Replace("#^CC0","").Split(new string[] { "#!" },StringSplitOptions.None);
		else
		return Line.Split(new string[] { "#!" },StringSplitOptions.None);
	}
	static public string GetValueFromExplode(string Line){
		return Line.Split(new string[] { "#^" },StringSplitOptions.None)[2];
	}
	static public string GetValueFromExplodeOld(string Line){
		return Line.Split(new string[] { "#^" },StringSplitOptions.None)[0].Trim();
	}
	static public string Sanitize(string S){
		if (S.IndexOf("#?")>=0)
		S = S.Substring(0,S.IndexOf("#?"));	
		
		return S;
	}
	
	static public void DrawEffects(Rect rect,ShaderLayer SL,List<ShaderEffect> LayerEffects,ref int SelectedEffect){
		
		int SEBoxHeight = 60;
		foreach(ShaderEffect SE in LayerEffects){
			if (SEBoxHeight<(SE.Inputs.Count*20+20))
			SEBoxHeight = (SE.Inputs.Count*20+20);
			if (SE.CustomHeight>=0)
				if (SEBoxHeight<(SE.CustomHeight+20))
					SEBoxHeight = (SE.CustomHeight+20);
		}
		SEBoxHeight+=(LayerEffects.Count*15);
		rect.height = SEBoxHeight;
		ShaderUtil.BeginGroup(rect);
		int YOffset = 0;
		GUI.Box(new Rect(0,YOffset,rect.width,rect.height),"","button");
		GUI.Box(new Rect(0,YOffset,rect.width,20),"Effects");
		YOffset+=20;
		
		GUIStyle ButtonStyle = new GUIStyle(GUI.skin.button);
		ButtonStyle.padding = new RectOffset(2,2,2,2);
		ButtonStyle.margin = new RectOffset(2,2,2,2);
		
		ShaderEffect Delete = null;
		ShaderEffect MoveUp = null;
		ShaderEffect MoveDown = null;
		SelectedEffect = Mathf.Max(0,SelectedEffect);
		int y = -1;
		foreach(ShaderEffect SE in LayerEffects){
			SE.Update();
			y+=1;
			bool Selected = false;
			if (SelectedEffect<LayerEffects.Count&&LayerEffects[SelectedEffect]==SE)
			Selected = true;
			
			Selected = GUI.Toggle(new Rect(0,YOffset+y*15,rect.width-90,15),Selected,SE.Name,GUI.skin.button);
			if (Selected==true){
				if (SelectedEffect!=y)
					EMindGUI.Defocus();
				SelectedEffect = y;
			}
			///////////////////////////////////////
			bool GUIEN = GUI.enabled;
			GUI.enabled = false;
			//UnityEngine.Debug.Log(SE.TypeS+":"+SE.HandleAlpha.ToString());
			if (SE.HandleAlpha==true&&SL.LayerType.Type!=(int)LayerTypes.Previous)
			GUI.enabled = GUIEN;
			if(Event.current.type==EventType.Repaint){
			GUI.Toggle(new Rect(rect.width-90,YOffset+y*15,15,15),SE.UseAlpha.Float==1||SE.UseAlpha.Float==2,(SE.UseAlpha.Float==1) ? ShaderSandwich.AlphaOn: ShaderSandwich.AlphaOff,ButtonStyle);
			GUI.Button(new Rect(rect.width-90+100,YOffset+y*15,15,15),"");
			}
			else {
				GUI.Toggle(new Rect(rect.width-90+100,YOffset+y*15,15,15),false,"");
				if (GUI.Button(new Rect(rect.width-90,YOffset+y*15,15,15),""))
				SE.UseAlpha.Float+=1;
				if (SE.UseAlpha.Float>2)
				SE.UseAlpha.Float = 0;
				
			}
			GUI.enabled = GUIEN;
			////////////////////////////////////////
			SE.Visible = GUI.Toggle(new Rect(rect.width-75,YOffset+y*15,30,15),SE.Visible,SE.Visible ? ShaderSandwich.EyeOpen: ShaderSandwich.EyeClose,ButtonStyle);
			if (GUI.Button(new Rect(rect.width-45,YOffset+y*15,15,15),ShaderSandwich.UPArrow,ButtonStyle))
			MoveUp = SE;
			if (GUI.Button(new Rect(rect.width-30,YOffset+y*15,15,15),ShaderSandwich.DOWNArrow,ButtonStyle))
			MoveDown = SE;
			if (GUI.Button(new Rect(rect.width-15,YOffset+y*15,15,15),ShaderSandwich.CrossRed,ButtonStyle))
			Delete = SE;
		}
		if (Delete!=null){
			if (LayerEffects.IndexOf(Delete)<SelectedEffect)
			SelectedEffect-=1;
			LayerEffects.Remove(Delete);
		}
		if (MoveUp!=null){
			if (LayerEffects.IndexOf(Delete)<SelectedEffect)
			SelectedEffect-=1;
			
			ShaderUtil.MoveItem(ref LayerEffects,LayerEffects.IndexOf(MoveUp),LayerEffects.IndexOf(MoveUp)-1);
		}
		if (MoveDown!=null){
			if (LayerEffects.IndexOf(Delete)<SelectedEffect)
			SelectedEffect+=1;
			
			ShaderUtil.MoveItem(ref LayerEffects,LayerEffects.IndexOf(MoveDown),LayerEffects.IndexOf(MoveDown)+1);
		}
		y+=1;
		if (GUI.Button(EMindGUI.Rect2(RectDir.Right,rect.width,YOffset-20,20,20),ShaderSandwich.Plus,ButtonStyle)){
			GenericMenu toolsMenu = new GenericMenu();
			foreach(string Ty in ShaderSandwich.EffectsList){
				ShaderEffect SE = ShaderEffect.CreateInstance<ShaderEffect>();
				SE.ShaderEffectIn(Ty,SL);
				toolsMenu.AddItem(new GUIContent(SE.Name), false, SL.AddLayerEffect,Ty);
			}
			toolsMenu.DropDown(EMindGUI.Rect2(RectDir.Right,rect.width,YOffset-20,20,20));
			//EditorGUIUtility.ExitGUI();
		}
		SelectedEffect = Mathf.Max(0,SelectedEffect);
		if (SelectedEffect<LayerEffects.Count&&LayerEffects[SelectedEffect]!=null)
		LayerEffects[SelectedEffect].Draw(new Rect(0,YOffset+y*15,rect.width,SEBoxHeight));
		ShaderUtil.EndGroup();
	}
	public static string CodeName(string NewName){
		NewName = NewName.Replace(" ","_");
		NewName = Regex.Replace(NewName, "[^a-zA-Z0-9_]","");
		NewName = NewName.Replace("__","_a");
		NewName = NewName.Replace("__","_a");
		NewName = NewName.Replace("__","_a");
		NewName = NewName.Replace("__","_a");
		return NewName;
	}
	public static string Pad(int Amount){
		return Pad(Amount,"	");
	}
	public static string Pad(int Amount,string Pad){
		string Tot = "";
		for (int i = 0;i<Amount;i++)
		Tot+=Pad;
		return Tot;
	}
	public static string RegexKeywordMatch(string[] Keywords){
		return RegexKeywordMatch(Keywords,false,false);
	}
	public static string RegexKeywordMatch(string[] Keywords,bool CaseSensitive){
		return RegexKeywordMatch(Keywords,CaseSensitive,false);
	}
	public static string RegexKeywordMatch(string[] Keywords,bool CaseSensitive,bool CheckComments){
		string Reg = "";
		string Start = "";
		if (CheckComments)
		Start+="(?<!\\/.*?)";
		//Start+="(?<!\\/\\/(.{0,1}))";
		//Start+="(?<!\\/.*?)";
		if (!CaseSensitive)
		Start+="(?i)";
		
		Reg = "("+Start+Keywords[0];
		foreach(string k in Keywords){
			Reg+="|"+Start+k;
		}
		Reg+=")";
		
		return Reg;
	}
	public static string RandomString(string[] Keywords){
		return Keywords[(int)Mathf.Round(UnityEngine.Random.Range(0f,Keywords.Length-1))];
	}


	public static void SetupCustomData(SVDictionary CustomData,Dictionary<string,ShaderVar> Inputs){
		if (CustomData!=null){
			foreach(KeyValuePair<string,ShaderVar> Input in Inputs){
				if (Input.Value!=null){
					if (!CustomData.D.ContainsKey(Input.Key)){
						CustomData.D[Input.Key] = Input.Value.Copy();
					}
					CustomData.D[Input.Key].TakeMeta(Input.Value);
				}
			}
		}
		//else{
		//	Debug.Log("Custom Data is NULL aahhh!!!");
		//}
		//Debug.Log("Setting up Custom Data");
	}
	public static void SetupOldData(SVDictionary CustomData,Dictionary<string,ShaderVar> Inputs){
		if (CustomData!=null){
			foreach(KeyValuePair<string,ShaderVar> Input in Inputs){
				if (Input.Value!=null){
					if (!CustomData.D.ContainsKey(Input.Key)){
						CustomData.D[Input.Key] = Input.Value.Copy();
					}
					CustomData.D[Input.Key].TakeValues(Input.Value);
				}
			}
		}
	}
	static public bool MoreOrLess(float A1, float A2, float D){
		if ((A1<A2+D)&&(A1>A2-D))
		return true;
		
		return false;
	}
	static public bool MoreOrLess(int A1, int A2, int D){
		if ((A1<A2+D)&&(A1>A2-D))
		return true;
		
		return false;
	}
}