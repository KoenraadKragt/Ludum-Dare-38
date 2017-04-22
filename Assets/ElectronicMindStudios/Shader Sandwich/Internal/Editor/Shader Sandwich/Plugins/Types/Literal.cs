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
public class SLTLiteral : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTLiteral";
		Name = "Basic/Literal";
		Description = "The UV map.";
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		return "float4("+Map+",1)";
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 3;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		return new ShaderColor(UV.x,UV.y,0,1);
	}
}