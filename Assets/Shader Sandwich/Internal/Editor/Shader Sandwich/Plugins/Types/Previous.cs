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
public class SLTPrevious : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTPrevious";
		Name = "Basic/Previous";
		Description = "The previous layers.";
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		string PixCol;
		
		if (SL.Parent.EndTag.Text.Length==1)
			PixCol = "float4("+SL.Parent.CodeName+".rrr,1)";
		else
		if (SL.Parent.EndTag.Text.Length==4)
			PixCol = SL.Parent.CodeName;
		else
			PixCol = "float4("+SL.Parent.CodeName+",0)";
		
		return PixCol;
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 0;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		return null;
	}
}