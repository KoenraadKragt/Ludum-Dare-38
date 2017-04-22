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
public class SSEConvertToRGB : ShaderEffect{
	public static void Activate(ShaderEffect SE,bool BInputs){
		SE.TypeS = "SSEConvertToRGB";
		SE.Name = "Conversion/HSV to RGB";//+UnityEngine.Random.value.ToString();
		SE.Function = @"
float3 hsv2rgb2(float3 c)
{
	c.r = frac(c.r);
	c.gb = saturate(c.gb);
	float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
	float3 pp = c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
	return pp;
}";
		
		SE.WorldPos = false;
		SE.WorldRefl = false;
		SE.WorldNormals = false;	
	
		if (BInputs==true){
			SE.Inputs = new List<ShaderVar>();
			SE.Inputs.Add(new ShaderVar("RGBData",new string[]{"RGB","R","G","B"},new string[]{"","","",""}));
		}
	}
	public static string Generate(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		if (SE.Inputs[0].Type==0)
			return "hsv2rgb2("+Line+")";
		if (SE.Inputs[0].Type==1)
			return "hsv2rgb2("+Line+").rrr";
		if (SE.Inputs[0].Type==2)
			return "hsv2rgb2("+Line+").ggg";
		if (SE.Inputs[0].Type==3)
			return "hsv2rgb2("+Line+").bbb";
			
		return Line;
	}
	public static ShaderColor Preview(ShaderEffect SE,ShaderColor OldColor){
		float R = 0;
		float G = 0;
		float B = 0;
		ShaderColor NewColor = (ShaderColor)ElectronicMindStudiosInterfaceUtils.HSVToRGB(OldColor.r,OldColor.g,OldColor.b);
		R = OldColor.r;
		G = OldColor.g;
		B = OldColor.b;
		if (SE.Inputs[0].Type==0)
			return new ShaderColor(R,G,B,OldColor.a);
		if (SE.Inputs[0].Type==1)
			return new ShaderColor(R,R,R,OldColor.a);
		if (SE.Inputs[0].Type==2)
			return new ShaderColor(G,G,G,OldColor.a);
		if (SE.Inputs[0].Type==3)
			return new ShaderColor(B,B,B,OldColor.a);
		return NewColor;
	}
}

