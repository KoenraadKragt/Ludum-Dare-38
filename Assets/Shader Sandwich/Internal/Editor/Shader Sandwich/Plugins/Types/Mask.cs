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
public class SLTMask : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTMask";
		Name = "Resources/Mask";
		Description = "An RGB mask.";
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		Inputs["RGBMask"] = new ShaderVar("RGBA Mask","ListOfObjects");
		return Inputs;
	}
	override public bool Draw(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		if (SL!=null)
		Data["RGBMask"].LightingMasks = SL.IsLighting;
		
		Data["RGBMask"].SetToMasks(null,0);
		Data["RGBMask"].NoInputs = true;
		Data["RGBMask"].RGBAMasks = true;
		if (DrawVars(rect,Data,SL)){
			GUI.changed = true;
		}
	
		return false;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		return "("+Data["RGBMask"].GetMaskName()+")";
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 4;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		ShaderColor Col = new ShaderColor(0.5f,0.5f,0.5f,0.5f);
		if (Data["RGBMask"].Obj!=null)
		Col = (ShaderColor)((ShaderLayerList)(Data["RGBMask"].Obj)).GetImagePixels()[ShaderUtil.FlatArray((int)(UV.x*70),(int)(UV.y*70),(int)70,(int)70)];//GetIcon().GetPixel((int)(UV.x*70f),(int)(UV.y*70f));
		return Col;
	}
}