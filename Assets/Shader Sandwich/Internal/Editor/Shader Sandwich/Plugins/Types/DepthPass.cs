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
public class SLTDepthPass : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTDepthPass";
		Name = "Screen/Depth";
		Description = "The screen before any objects with this shader is rendered.";
		Function = "//Setup inputs for the depth texture.\n"+
					"sampler2D_float _CameraDepthTexture;\n";
	}
	public Color[] Image;
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		Inputs["Linearize"] = new ShaderVar("Linearize",true);
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		if (Data["Linearize"].On)
			return "(LinearEyeDepth(tex2D(_CameraDepthTexture, "+Map+").r).rrrr)";
		else
			return "(tex2D(_CameraDepthTexture, "+Map+").rrrr)";
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 2;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		return ShaderColor.Lerp(new ShaderColor(0,0,0,0),new ShaderColor(1,1,1,1),UV.x);
	}
}