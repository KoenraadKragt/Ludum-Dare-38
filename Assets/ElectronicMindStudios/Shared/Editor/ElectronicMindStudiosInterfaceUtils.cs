#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2
#define PRE_MORESTUPIDUNITYDEPRECATIONS
#endif
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Xml;

public enum RectDir{Normal,Diag, Bottom,Right,Middle,MiddleTop};

static public class ElectronicMindStudiosInterfaceUtils{
	static public void TrackMouseStuff(){
		mouse.TrackMouseStuff();
	}
	static public void Label(Rect r,string Text,int S){
		SetLabelSize(S);
		
		GUI.skin.label.wordWrap = true;
		GUI.Label(r,Text);
	}
	static public void SetLabelSize(int S){
		GUI.skin.label.fontSize = GetFontSize(S);
	}
	static public int GetFontSize(int S){
		return (int)((S*((float)InterfaceSize/12f)));
	}
	
	static public Rect Rect2(RectDir dir,float x,float y,float width, float height)
	{
		if (dir==RectDir.Middle)
		return new Rect(x-width/2f,y-height/2f,width,height);	
		if (dir==RectDir.MiddleTop)
		return new Rect(x-width/2f,y,width,height);	
		if (dir==RectDir.Diag)
		return new Rect(x-width,y-height,width,height);		
		if (dir==RectDir.Bottom)
		return new Rect(x,y-height,width,height);		
		if (dir==RectDir.Right)
		return new Rect(x-width,y,width,height);
		
		return new Rect(x,y,width,height);	
	}
	
	static public bool MouseDownIn(Rect rect){
		if (Event.current.type == EventType.MouseDown&&(rect.Contains(Event.current.mousePosition))){
		Event.current.Use();
		return true;
		}
		return false;
	}
	static public bool MouseUpIn(Rect rect){
		if (Event.current.type == EventType.MouseUp&&(rect.Contains(Event.current.mousePosition))){
		Event.current.Use();
		return true;
		}
		return false;
	}
	static public bool MouseDownIn(Rect rect,bool Eat){
		if (Event.current.type == EventType.MouseDown&&(rect.Contains(Event.current.mousePosition))){
		if (Eat==true)
		Event.current.Use();
		return true;
		}
		return false;
	}
	static public bool MouseUpIn(Rect rect,bool Eat){
		if (Event.current.type == EventType.MouseUp&&(rect.Contains(Event.current.mousePosition))){
			if (Eat==true)
				Event.current.Use();
			return true;
		}
		return false;
	}
	static public bool MouseHoldIn(Rect rect,bool Eat){
		if (mouse.MouseDrag&&(rect.Contains(Event.current.mousePosition))){
			if (Eat==true)
				Event.current.Use();
			return true;
		}
		return false;
	}
	
	static public void AddProSkin(Vector2 WinSize){
		AddProSkin_Real(true,WinSize);
	}
	
	static public Color InterfaceColor;
	static public Color BaseInterfaceColor;
	static public int InterfaceSize;
	
	static public GUISkin SSSkin{
		get{
			if (SSSkin_Real==null)
				SSSkin_Real = EditorGUIUtility.Load("ElectronicMindStudios/Shared/Interface/MainSkin.guiskin") as GUISkin;
			return SSSkin_Real;
		}
		set{}
	}
	static public GUISkin SCSkin{
		get{
			if (SCSkin_Real==null)
				SCSkin_Real = EditorGUIUtility.Load("ElectronicMindStudios/Shared/Interface/UtilGuiSkin.guiskin") as GUISkin;
			return SCSkin_Real;
		}
		set{}
	}
	static public GUISkin SSSkin_Real;
	static public GUISkin SCSkin_Real;
	static public GUISkin oldskin;
	static public Color EditorLabelNormal;
	static public Color EditorLabelActive;
	static public Color EditorLabelFocused;
	static public Color EditorLabelHover;
	static public GUIStyle EditorLabel;
	static public GUIStyle OldEditorLabel;
	static public GUIStyle EditorFloatInput;
	static public GUIStyle EditorPopup;
	static public bool LightInterface = false;
	static public void Defocus(){
		GUI.FocusControl("");
	}
	static public void AddProSkin_Real(bool FI,Vector2 WinSize){
		//if (SSSkin==null)
		//	SSSkin = EditorGUIUtility.Load("ElectronicMindStudios/Shared/Interface/MainSkin.guiskin") as GUISkin;
		//if (SCSkin==null)
		//	SCSkin = EditorGUIUtility.Load("ElectronicMindStudios/Shared/Interface/UtilGuiSkin.guiskin") as GUISkin;
		oldskin = GUI.skin;
		GUI.skin = SSSkin;
		//InterfaceBackgroundColorDuckups = 0;
		//InterfaceColorDuckups = 0;
		InterfaceColor = new Color(
			EditorPrefs.GetFloat("ElectronicMindStudiosInterfaceColor_R", 0f),
			EditorPrefs.GetFloat("ElectronicMindStudiosInterfaceColor_G", 39f/255f),
			EditorPrefs.GetFloat("ElectronicMindStudiosInterfaceColor_B", 51f/255f),
			EditorPrefs.GetFloat("ElectronicMindStudiosInterfaceColor_A", 1f)
		);
		float Val = GetVal(InterfaceColor);
		BaseInterfaceColor = SetVal(InterfaceColor,1f);
		
		InterfaceSize = EditorPrefs.GetInt("ElectronicMindStudiosInterfaceSize",10);
		
		Color TextColor = new Color(0.8f,0.8f,0.8f,1f);
		Color TextColor2 = new Color(0.8f,0.8f,0.8f,1f);
		Color TextColorA = new Color(1f,1f,1f,1f);

		Color BackgroundColor;
		if (Val<0.5f)
			BackgroundColor = new Color(0.6f*Val,0.6f*Val,0.6f*Val,1);
		else
			BackgroundColor = new Color(1f*Val,1f*Val,1f*Val,1);
		
		SCSkin.window.onNormal.textColor = BaseInterfaceColor;
		
		SCSkin.window.fontSize = InterfaceSize;
		GUI.skin.label.fontSize = InterfaceSize;
		GUI.skin.box.fontSize = InterfaceSize;

		GUI.color = BackgroundColor;
			GUI.DrawTexture( new Rect(0,0,WinSize.x,WinSize.y), EditorGUIUtility.whiteTexture );	
		GUI.color = new Color(1f,1f,1f,1f);
		
		LightInterface = Val>=0.7f;
		
		if (Val<0.7f)
			GUI.contentColor = new Color(1f,1f,1f,1f);
		else
			GUI.contentColor = new Color(0f,0f,0f,1f);
		
		GUI.backgroundColor = new Color(1f*Val,1f*Val,1f*Val,1f);
		
		GUI.skin.button.normal.textColor = TextColor;
		GUI.skin.button.active.textColor = TextColorA;
		GUI.skin.label.normal.textColor = TextColor;
		GUI.skin.box.normal.textColor = TextColorA;
		
		GUI.skin.textField.normal.textColor = TextColor2;
		GUI.skin.textField.active.textColor = TextColor2;
		GUI.skin.textField.focused.textColor = TextColor2;
		GUI.skin.textField.wordWrap = false;
		
		GUI.skin.textArea.normal.textColor = TextColor2;
		GUI.skin.textArea.active.textColor = TextColor2;
		GUI.skin.textArea.focused.textColor = TextColor2;
		
		GUI.skin.GetStyle("ButtonLeft").normal.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonLeft").active.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonLeft").focused.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonLeft").onFocused.textColor = BaseInterfaceColor;
		GUI.skin.GetStyle("ButtonLeft").onNormal.textColor = BaseInterfaceColor;
		GUI.skin.GetStyle("ButtonLeft").onActive.textColor = BaseInterfaceColor;
		
		GUI.skin.GetStyle("ButtonRight").normal.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonRight").active.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonRight").focused.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonRight").onFocused.textColor = BaseInterfaceColor;
		GUI.skin.GetStyle("ButtonRight").onNormal.textColor = BaseInterfaceColor;
		GUI.skin.GetStyle("ButtonRight").onActive.textColor = BaseInterfaceColor;
		
		GUI.skin.GetStyle("ButtonMid").normal.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonMid").active.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonMid").focused.textColor = TextColor2;
		GUI.skin.GetStyle("ButtonMid").onFocused.textColor = BaseInterfaceColor;
		GUI.skin.GetStyle("ButtonMid").onNormal.textColor = BaseInterfaceColor;
		GUI.skin.GetStyle("ButtonMid").onActive.textColor = BaseInterfaceColor;

		GUI.skin.GetStyle("MiniPopup").normal.textColor = TextColor2;
		GUI.skin.GetStyle("MiniPopup").active.textColor = TextColor2;
		GUI.skin.GetStyle("MiniPopup").focused.textColor = TextColor2;
		
		if (EditorFloatInput==null&&FI==true){
			EditorFloatInput = new GUIStyle(EditorStyles.numberField);
				EditorFloatInput.normal.textColor = TextColor2;
				EditorFloatInput.active.textColor = TextColor2;
				EditorFloatInput.focused.textColor = TextColor2;
				EditorFloatInput.hover.textColor = TextColor2;
				EditorFloatInput.onNormal.textColor = TextColor2;
				EditorFloatInput.onActive.textColor = TextColor2;
				EditorFloatInput.onFocused.textColor = TextColor2;
				EditorFloatInput.onHover.textColor = TextColor2;
				EditorFloatInput.wordWrap = false;
		}
		if (EditorPopup==null&&FI==true){
			EditorPopup = new GUIStyle(EditorStyles.popup);
				EditorPopup.normal.textColor = TextColor2;
				EditorPopup.active.textColor = TextColor2;
				EditorPopup.focused.textColor = TextColor2;
				EditorPopup.hover.textColor = TextColor2;
		}
		//if (EditorLabel==null&&FI==true){
			EditorLabel = EditorStyles.label;//new GUIStyle(EditorStyles.label);
				EditorLabelNormal = EditorLabel.normal.textColor;
				EditorLabelActive = EditorLabel.active.textColor;
				EditorLabelFocused = EditorLabel.focused.textColor;
				EditorLabelHover = EditorLabel.hover.textColor;
				
				EditorStyles.label.normal.textColor = TextColor2;
				//EditorStyles.label.active.textColor = TextColor2;
				//EditorStyles.label.focused.textColor = TextColor2;
				//EditorStyles.label.hover.textColor = TextColor2;
			//OldEditorLabel = EditorStyles.label;
			//EditorStyles.label = EditorLabel;
		//}
		GUI.skin.GetStyle("Toolbar").normal.textColor = TextColor2;
		GUI.skin.GetStyle("Toolbar").active.textColor = TextColor2;
		GUI.skin.GetStyle("Toolbar").focused.textColor = TextColor2;
	}
	static public void EndProSkin(){
		EditorStyles.label.normal.textColor = new Color(0,0,0,1);
		EditorStyles.label.active.textColor = new Color(0,0,0,1);
		EditorStyles.label.focused.textColor = new Color(0,0,0,1);
		EditorStyles.label.hover.textColor = new Color(0,0,0,1);
		GUI.skin = oldskin;
	}
	
	public static void RGBToHSV(Color col,out float Hue, out float Sat, out float Val){
		#if PRE_MORESTUPIDUNITYDEPRECATIONS
			EditorGUIUtility.RGBToHSV(col,out Hue,out Sat,out Val);
		#else
			Color.RGBToHSV(col,out Hue,out Sat,out Val);
		#endif
	}
	public static Color HSVToRGB(float Hue, float Sat, float Val){
		#if PRE_MORESTUPIDUNITYDEPRECATIONS
			return EditorGUIUtility.HSVToRGB(Hue,Sat,Val);
		#else
			return Color.HSVToRGB(Hue,Sat,Val);
		#endif
	}
	public static Color SetVal(Color col,float Val){
		float hue = 0f;
		float sat = 0f;
		float val = 0f;
		RGBToHSV(col, out hue, out sat, out val);
		return HSVToRGB(hue,sat,Val);
	}
	public static float GetVal(Color col){
		float hue = 0f;
		float sat = 0f;
		float val = 0f;
		RGBToHSV(col, out hue, out sat, out val);
		return val;
	}
	public static Color SetSat(Color col,float Sat){
		float hue = 0f;
		float sat = 0f;
		float val = 0f;
		RGBToHSV(col, out hue, out sat, out val);
		return HSVToRGB(hue,Sat,val);
	}
	
	static public void BoldText(){
			GUI.skin.label.fontStyle = FontStyle.Bold;
	}
	static public void UnboldText(){
			GUI.skin.label.fontStyle = FontStyle.Normal;
	}
	static public ElectronicMindStudiosWindowInterfaceUtils mouse = new ElectronicMindStudiosWindowInterfaceUtils();
	static public bool Toggle(Rect position, bool toggle){
		SetGUIColor(BaseInterfaceColor);
		SetGUIBackgroundColor(Color.white);
		toggle = EditorGUI.Toggle(position,toggle);
		ResetGUIBackgroundColor();
		ResetGUIColor();
		return toggle;
	}
	static public float Slider(Rect position, string label, float value, float leftValue, float rightValue){
		SetGUIColor(Color.white);
		SetGUIBackgroundColor(Color.white);
			//142x20
			GUI.Label(position, label);
			//5padding
		ResetGUIBackgroundColor();
		ResetGUIColor();
		
		int TextSpace = 100;//142 for the same as Unity
		position.x+=TextSpace+5;
		position.width-=TextSpace+5+50+5;
		EditorGUI.BeginChangeCheck();
		value = GUI.HorizontalSlider(position,value,leftValue,rightValue);
		if (EditorGUI.EndChangeCheck())
			GUIUtility.keyboardControl = -1;

		if (position.Contains(Event.current.mousePosition)||(mouse.MouseDrag&&position.Contains(mouse.DragStartPos))){
			SetGUIColor(BaseInterfaceColor);
			if (Event.current.type==EventType.Repaint)
				GUI.DrawTexture(new Rect(position.x+((position.width-8)*((Mathf.Min(rightValue,Mathf.Max(leftValue,value))-leftValue)/(rightValue-leftValue)))-8,position.y-2,24,24),GUI.skin.GetStyle("CustomThumb").hover.background);
			ResetGUIColor();
		}
		if (mouse.MouseDrag&&position.Contains(mouse.DragStartPos))
			SetGUIColor(new Color(1,1,1,0.8f));
		else
			SetGUIColor(new Color(1,1,1,0.5f));
		if (Event.current.type==EventType.Repaint)
			GUI.DrawTexture(new Rect(position.x+((position.width-8)*((Mathf.Min(rightValue,Mathf.Max(leftValue,value))-leftValue)/(rightValue-leftValue)))-8,position.y-2,24,24),GUI.skin.GetStyle("CustomThumb").normal.background);
		ResetGUIColor();
		
		position.x+=position.width+5;
		position.width = 50;
		
		value = EditorGUI.FloatField(position,value,"textfield");
		return value;
	}
	static public float Slider(Rect position, float value, float leftValue, float rightValue){
		EditorGUI.BeginChangeCheck();
		value = GUI.HorizontalSlider(position,value,leftValue,rightValue);
		if (EditorGUI.EndChangeCheck())
			GUIUtility.keyboardControl = -1;

		if (position.Contains(Event.current.mousePosition)||(mouse.MouseDrag&&position.Contains(mouse.DragStartPos))){
			SetGUIColor(BaseInterfaceColor*GUI.color);
			if (Event.current.type==EventType.Repaint)
				GUI.DrawTexture(new Rect(position.x+((position.width-8)*((Mathf.Min(rightValue,Mathf.Max(leftValue,value))-leftValue)/(rightValue-leftValue)))-8,position.y-2,24,24),GUI.skin.GetStyle("CustomThumb").hover.background);
			ResetGUIColor();
		}
		if (mouse.MouseDrag&&position.Contains(mouse.DragStartPos))
		SetGUIColor(new Color(1,1,1,0.8f)*GUI.color);
		else
		SetGUIColor(new Color(1,1,1,0.5f)*GUI.color);
		if (Event.current.type==EventType.Repaint)
			GUI.DrawTexture(new Rect(position.x+((position.width-8)*((Mathf.Min(rightValue,Mathf.Max(leftValue,value))-leftValue)/(rightValue-leftValue)))-8,position.y-2,24,24),GUI.skin.GetStyle("CustomThumb").normal.background);
		ResetGUIColor();
		return value;
	}
	//static public int InterfaceColorDuckups = 0;
	//static public int InterfaceBackgroundColorDuckups = 0;
	
	static public Color oldGUIColor;
	
	static public void SetGUIColor(Color a){
		oldGUIColor = GUI.color;
		GUI.color = a;
		//InterfaceColorDuckups+=1;
		//if (InterfaceColorDuckups!=1)
		//Debug.Log("Awwww scheeeeeiiit!" + InterfaceColorDuckups.ToString());
	}
	static public void ResetGUIColor(){
		GUI.color = oldGUIColor;
		//InterfaceColorDuckups-=1;
		//if (InterfaceColorDuckups!=0)
		//Debug.Log("Awwww hell naawwh!" + InterfaceColorDuckups.ToString());
	}	
	static public Color oldGUIBackgroundColor;
	
	static public void SetGUIBackgroundColor(Color a){
		oldGUIBackgroundColor = GUI.backgroundColor;
		GUI.backgroundColor = a;
		//InterfaceBackgroundColorDuckups+=1;
		//if (InterfaceBackgroundColorDuckups!=1)
		//Debug.Log("Awwww scheeeeeiiit!" + InterfaceBackgroundColorDuckups.ToString());
	}
	static public void ResetGUIBackgroundColor(){
		GUI.backgroundColor = oldGUIBackgroundColor;
		//InterfaceBackgroundColorDuckups-=1;
		//if (InterfaceBackgroundColorDuckups!=0)
		//Debug.Log("Awwww hell naawwh!" + InterfaceBackgroundColorDuckups.ToString());
	}
	static public void VerticalScrollbar(Rect WindowSize, Vector2 ScrollArea, Rect ContentSize){
		if (LightInterface)
		return;
		if (ContentSize.height>WindowSize.height){
			SetGUIColor(new Color(1f,1f,1f,1f));
			float Ratio = ((WindowSize.height-32f-20f)/ContentSize.height);
			float Ratio2 = ((WindowSize.height-32f-20f)/ContentSize.height);
			
			Rect ScrollAreaRect = new Rect(WindowSize.x+WindowSize.width-16,WindowSize.y,16,WindowSize.height);
			Rect ScrollThumbRect = new Rect(WindowSize.x+WindowSize.width-15,WindowSize.y+16+(Ratio2*ScrollArea.y),16,Ratio*(float)(WindowSize.height)+20);
			if (Event.current.type==EventType.Repaint){
				if (mouse.MouseDrag&&ScrollAreaRect.Contains(mouse.DragStartPos)){
					SetGUIBackgroundColor(SetSat(BaseInterfaceColor,0.8f));
					SCSkin.verticalScrollbarThumb.Draw(ScrollThumbRect, true, true, true, false);
				}
				else if (ScrollThumbRect.Contains(Event.current.mousePosition)){
					SetGUIBackgroundColor(SetSat(BaseInterfaceColor,0f));
					SCSkin.verticalScrollbarThumb.Draw(ScrollThumbRect, false, false, true, false);
					
					ResetGUIColor();
					ResetGUIBackgroundColor();
					SetGUIBackgroundColor(SetSat(BaseInterfaceColor,0.8f));
					SetGUIColor(new Color(1f,1f,1f,0.3f));
					SCSkin.verticalScrollbarThumb.Draw(ScrollThumbRect, false, false, true, false);
				}
				else{
					SetGUIBackgroundColor(SetSat(BaseInterfaceColor,0f));
					SCSkin.verticalScrollbarThumb.Draw(ScrollThumbRect, false, false, true, false);
				}
				ResetGUIBackgroundColor();
			}
			ResetGUIColor();
		}
	}
	
	static public string[] OldTooltip = new string[]{"",""};
	static public string[] Tooltip = new string[]{"",""};
	static public Vector2[] TooltipPos = new Vector2[]{new Vector2(0,0),new Vector2(0,0)};
	static public float[] TooltipAlpha = new float[]{0f,0f};
	static public double[] TooltipLastUpdate = new double[]{0f,0f};
	static public void MakeTooltip(int ID,Rect rect,string tool){
		if (rect.Contains(Event.current.mousePosition))
		Tooltip[ID] = tool;
	}
	static public void DrawTooltip(int ID,Vector2 WinSize){
		if (Event.current.type==EventType.Repaint){
			GUI.color = new Color(1,1,1,Mathf.Max(0,TooltipAlpha[ID]));
			GUI.backgroundColor = new Color(1,1,1,Mathf.Max(0,TooltipAlpha[ID]));
			if (OldTooltip[ID]!=Tooltip[ID]){
				TooltipAlpha[ID] = -5f;
			}
			if (ID==2){
				//Debug.Log(ID);
				//Debug.Log(Tooltip[ID]);
				//Debug.Log(TooltipAlpha[ID]);
				//TooltipAlpha[ID] = 1;
			}
			OldTooltip[ID] = Tooltip[ID];
			
				TooltipPos[ID] = new Vector2(Event.current.mousePosition.x,Event.current.mousePosition.y);
				float delta = 300*((float)((EditorApplication.timeSinceStartup-TooltipLastUpdate[ID])));
//				Debug.Log(delta);
				TooltipAlpha[ID] += ((Tooltip[ID]=="")?-0.03f:0.03f)*delta;
				TooltipLastUpdate[ID] = EditorApplication.timeSinceStartup;
				TooltipAlpha[ID] = Mathf.Max(Mathf.Min(TooltipAlpha[ID],1f),-5f);
			
			Vector2 MinSize = GUI.skin.GetStyle("Tooltip").CalcSize(new GUIContent(Tooltip[ID]));
			Rect MinSize2 = new Rect(TooltipPos[ID].x,TooltipPos[ID].y-MinSize.y,MinSize.x,MinSize.y);
			//GUI.Box(MinSize2,"","Tooltip");
			if (WinSize.x<MinSize2.x+MinSize2.width&&(MinSize2.x-MinSize2.width+20>0)){
				MinSize2.x-=MinSize2.width;
			}
			GUI.Label(MinSize2,Tooltip[ID],"Tooltip");
			Tooltip[ID] = "";
		}
	}
	static public string StringLimit(string str, int lim){
		if (str.Length>lim){
			str = str.Substring(0,lim-3);
			str += "…";
		}
		return str;
	}
	static public string StringLimit(string str, GUIStyle style, float lim){
		string retStr = "";
		bool OldWordWrap = style.wordWrap;
		style.wordWrap = false;
		GUIContent asd = new GUIContent("…");
		float asdgtrds = style.CalcSize(asd).x+10;
		for(int i = 0;i<str.Length;i++){
			asd.text = retStr;
			if (style.CalcSize(asd).x+asdgtrds<lim)
				retStr+=str[i];
			else
				break;
		}
		if (str!=retStr)
		retStr += "…";
		style.wordWrap = OldWordWrap;
		return retStr;
	}
}