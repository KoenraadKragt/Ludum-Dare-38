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
public class SSEMathStretch : ShaderEffect{
	public static void Activate(ShaderEffect SE,bool BInputs){
		SE.TypeS = "SSEMathStretch";
		SE.Name = "Maths/Stretch";//+UnityEngine.Random.value.ToString();
		
		SE.Function = "";
		SE.LinePre = "";
		if (BInputs==true){
			SE.Inputs = new List<ShaderVar>();
			SE.Inputs.Add(new ShaderVar("From: Start",0));
			SE.Inputs.Add(new ShaderVar("From: End",1));
			SE.Inputs.Add(new ShaderVar("To: Start",-1));
			SE.Inputs.Add(new ShaderVar("To: End",1));
		} 
		SE.Inputs[0].NoSlider = true;
		SE.Inputs[1].NoSlider = true;
		SE.Inputs[2].NoSlider = true;
		SE.Inputs[3].NoSlider = true;
		SE.WorldPos = false;
		SE.WorldRefl = false;
		SE.WorldNormals = false;		
	}
	public static string Generate(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		if (SE.Inputs[0].Get()=="0"&&SE.Inputs[1].Get()=="1")
		return "("+Line+"*("+SE.Inputs[3].Get()+"-("+SE.Inputs[2].Get()+"))+"+SE.Inputs[2].Get()+")";
		else
		return "((("+Line+"-("+SE.Inputs[0].Get()+"))/("+SE.Inputs[1].Get()+"-("+SE.Inputs[0].Get()+")))*("+SE.Inputs[3].Get()+"-("+SE.Inputs[2].Get()+"))+"+SE.Inputs[2].Get()+")";
	}
	public static string GenerateAlpha(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		if (SE.Inputs[0].Get()=="0"&&SE.Inputs[1].Get()=="1")
		return "("+Line+"*("+SE.Inputs[3].Get()+"-("+SE.Inputs[2].Get()+"))+"+SE.Inputs[2].Get()+")";
		else
		return "((("+Line+"-("+SE.Inputs[0].Get()+"))/("+SE.Inputs[1].Get()+"-("+SE.Inputs[0].Get()+")))*("+SE.Inputs[3].Get()+"-("+SE.Inputs[2].Get()+"))+"+SE.Inputs[2].Get()+")";
	}
	public static string GenerateWAlpha(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		if (SE.Inputs[0].Get()=="0"&&SE.Inputs[1].Get()=="1")
		return "("+Line+"*("+SE.Inputs[3].Get()+"-("+SE.Inputs[2].Get()+"))+"+SE.Inputs[2].Get()+")";
		else
		return "((("+Line+"-("+SE.Inputs[0].Get()+"))/("+SE.Inputs[1].Get()+"-("+SE.Inputs[0].Get()+")))*("+SE.Inputs[3].Get()+"-("+SE.Inputs[2].Get()+"))+"+SE.Inputs[2].Get()+")";
	}
	public static float stretch(ShaderEffect SE, float f){
		return ((f - SE.Inputs[0].Float)/(SE.Inputs[1].Float-SE.Inputs[0].Float))*(SE.Inputs[3].Float-SE.Inputs[2].Float)+SE.Inputs[2].Float;
	}
	public static ShaderColor Preview(ShaderEffect SE,ShaderColor OldColor){
		ShaderColor NewColor = new ShaderColor(stretch(SE, OldColor.r),stretch(SE, OldColor.g),stretch(SE, OldColor.b),stretch(SE, OldColor.a));
		return NewColor;
	}
}

