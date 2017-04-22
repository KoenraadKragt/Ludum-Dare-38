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
//using System.Xml;
[System.Serializable]
public class SLTData : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTData";
		Name = "Resources/Data";
		Description = "Various bits of information.";
		UsesVertexColors = true;
		AllowInBase = true;
		AllowInVertex = false;
		AllowInLighting = true;
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		Inputs["Data"] = new ShaderVar("Data",new string[]{
		"Light/Direction",
		"Light/Attenuation",
		"View Direction",
		"Channels/Albedo(Diffuse)",
		"Channels/Normal",
		"Channels/Specular",
		"Channels/Emission",
		"Channels/Alpha",
		"Channels/Height",
		"Parallax/Depth",
		"Light/Color",
		"Light/NdotL",
		"Parallax/Shadowing"},new string[]{"","","","","","","","","","","","",""});
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
			string PixCol = "";
			if (Data["Data"].Type==0)
				PixCol = "gi.light.dir";
			if (Data["Data"].Type==1)
				PixCol = "(gi.light.color/_LightColor0)";
			if (Data["Data"].Type==2)
				PixCol = "d.worldViewDir";
			if (Data["Data"].Type==3)
				PixCol = "d.Albedo";
			if (Data["Data"].Type==4)
				PixCol = "d.Normal";
			if (Data["Data"].Type==5)
				PixCol = "d.Specular";
			if (Data["Data"].Type==6)
				PixCol = "d.Emission";
			if (Data["Data"].Type==7)
				PixCol = "d.Alpha.rrr";
			if (Data["Data"].Type==8)
				PixCol = "d.Height.rrr";
			if (Data["Data"].Type==9)
				PixCol = "d.Depth.rrr";
			if (Data["Data"].Type==10)
				PixCol = "gi.light.color";
			if (Data["Data"].Type==11)
				PixCol = "gi.light.ndotl.rrr";
			if (Data["Data"].Type==12)
				PixCol = "d.ShadowFactor.rrr";
			
			return "float4("+PixCol+",0)";
	}
	override public bool Draw(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		GUI.Label(new Rect(0,rect.y,250,20),"Data:");
		Data["Data"].Type=EditorGUI.Popup(new Rect(100,rect.y,150,20),Data["Data"].Type,Data["Data"].Names,ShaderUtil.EditorPopup);
		
		return false;
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 0;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		return new ShaderColor(UV.x,UV.y,0,1);
	}
}