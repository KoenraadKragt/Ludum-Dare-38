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
public class SLTRandomNoise : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTRandomNoise";
		Name = "Procedural/Random Noise";
		Description = "Extremely quick random noise, good for static.";
		
		Function = @"
	float RandomNoise3D(float3 co)
	{
	 return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
	}
	float RandomNoise2D(float2 co)
	{
	 return frac(sin( dot(co.xy ,float2(12.9898,78.233) )) * 43758.5453);
	}
 ";
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
			Inputs["Noise Dimensions"] = new ShaderVar("Noise Dimensions",new string[]{"2D","3D"},new string[]{"",""});
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		string PixCol = "";
		if (Data["Noise Dimensions"].Type==0)
			PixCol = "RandomNoise2D("+Map+")";
		if (Data["Noise Dimensions"].Type==1)
			PixCol = "RandomNoise3D("+Map+")";
		return PixCol;
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		if (Data["Noise Dimensions"].Type==0)
		return 2;
		if (Data["Noise Dimensions"].Type==1)
		return 3;
		return 0;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		float NoiseVal = Mathf.Sin(((UV.x*12.9898f)+(UV.y*78.233f))*43758.5453f);
		NoiseVal = NoiseVal-Mathf.Floor(NoiseVal);
		return new ShaderColor(NoiseVal);
	}
}