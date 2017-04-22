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
public class SLTGrabPass : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTGrabPass";
		Name = "Screen/Grab";
		Description = "The screen before any objects with this shader is rendered.";
		Function = @"		//Setup inputs for the grab pass texture and some meta information about it.
				sampler2D _GrabTexture;
				float4 _GrabTexture_TexelSize;";
		ExternalFunction = "GrabPass {}";
	}
	public Color[] Image;
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		return "tex2D( _GrabTexture, "+Map+")";
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 2;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		if (Image!=null)
			return (ShaderColor)Image[ShaderUtil.FlatArray((int)(UV.x*70),(int)(UV.y*70),70,70)];
		if (ShaderSandwich.GrabPass!=null)
			Image = ShaderSandwich.GrabPass.GetPixels(0);
		
		return new ShaderColor(0,0,0,1);
	}
}