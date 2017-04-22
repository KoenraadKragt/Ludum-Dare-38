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
public class SLTGradient : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTGradient";
		Name = "Procedural/Gradient";
		Description = "An interpolation between two colors.";
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
			Inputs["Color"] = new ShaderVar("Color A",new Vector4(160f/255f,204f/255f,225/255f,1f));
			Inputs["Color 2"] = new ShaderVar("Color B",new Vector4(0,0,0,1f));
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		//Debug.Log(Data["Color 2"].Get());
		//Debug.Log(Data["Color 2"].Get().StartsWith("float4(0, 0, 0"));
		//Debug.Log(Data["Color"].Get());
		if (Data["Color 2"].Get().StartsWith("float4(0, 0, 0")&&Data["Color"].Get().StartsWith("float4(1, 1, 1"))
		return "float4("+Map+","+Map+","+Map+","+Map+")";
		else
		if (Data["Color 2"].Get().StartsWith("float4(1, 1, 1")&&Data["Color"].Get().StartsWith("float4(0, 0, 0"))
		return "float4(1-"+Map+",1-"+Map+",1-"+Map+",1-"+Map+")";
		else
		if (Data["Color 2"].Get()==Data["Color"].Get())
		return Data["Color 2"].Get();
		else
		return "lerp("+Data["Color 2"].Get()+", "+Data["Color"].Get()+", "+Map+")";
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 1;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		return ShaderColor.Lerp(Data["Color 2"].Vector,Data["Color"].Vector,UV.x);
	}
}