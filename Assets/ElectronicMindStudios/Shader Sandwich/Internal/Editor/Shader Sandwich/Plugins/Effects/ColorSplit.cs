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
public class SSEColorSplit : ShaderEffect{
	public static void Activate(ShaderEffect SE,bool BInputs){
		SE.TypeS = "SSEColorSplit";
		SE.Name = "Color/Split";//+UnityEngine.Random.value.ToString();

		if (BInputs==true||SE.Inputs.Count!=6){
			SE.Inputs = new List<ShaderVar>();
			SE.Inputs.Add(new ShaderVar("R Vector",new ShaderColor(0.6f,0.1f,0,0f)));
			SE.Inputs.Add(new ShaderVar("G Vector",new ShaderColor(1f,0,-0.4f,0f)));
			SE.Inputs.Add(new ShaderVar("B Vector",new ShaderColor(-0.3f,1f,0,0f)));
			SE.Inputs.Add(new ShaderVar("A Vector",new ShaderColor(1f,1f,0,0f)));
			SE.Inputs.Add(new ShaderVar("Advanced",false));
			SE.Inputs.Add(new ShaderVar("Factor",0.2f));
		} 
		SE.Inputs[0].ShowNumbers = true;
		SE.Inputs[1].ShowNumbers = true;
		SE.Inputs[2].ShowNumbers = true;
		SE.Inputs[3].ShowNumbers = true;
		
		if (!SE.Inputs[4].On){
			SE.Inputs[0].Hidden = true;
			SE.Inputs[1].Hidden = true;
			SE.Inputs[2].Hidden = true;
			SE.Inputs[3].Hidden = true;
			SE.Inputs[5].Hidden = false;
			SE.Inputs[0].Vector = new ShaderColor(SE.Inputs[5].Float,SE.Inputs[5].Float,0f,0f);
			SE.Inputs[1].Vector = new ShaderColor(0f,SE.Inputs[5].Float,0f,0f);
			SE.Inputs[2].Vector = new ShaderColor(SE.Inputs[5].Float,0f,0f,0f);
			SE.Inputs[3].Vector = new ShaderColor(0f,-SE.Inputs[5].Float,0f,0f);
		}
		else{
			SE.Inputs[0].Hidden = false;
			SE.Inputs[1].Hidden = false;
			SE.Inputs[2].Hidden = false;
			SE.Inputs[3].Hidden = false;
			SE.Inputs[5].Hidden = true;
		}
		
		SE.CustomHeight = 20*10;
		
		SE.WorldPos = false;
		SE.WorldRefl = false;
		SE.WorldNormals = false;		
	}
	public static ShaderColor Preview(ShaderEffect SE,ShaderColor[] OldColors,int X, int Y, int W, int H){
	
		//ShaderColor OldColor = OldColors[ShaderUtil.FlatArray(X,Y,W,H)];
		
		ShaderColor NewColor = new ShaderColor(
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[0].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[0].Vector.g)),W,H)].r,
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[1].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[1].Vector.g)),W,H)].g,
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[2].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[2].Vector.g)),W,H)].b,
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[3].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[3].Vector.g)),W,H)].a
		);
		return NewColor;//Mathf.Sqrt(1-(NewColor.x*NewColor.x)-(NewColor.y*NewColor.y)),1);
		//NewColor/=2f;
		//NewColor+= new Color(0.5f,0.5f,0.5f,0f);
		//else
		//NewColor/=(SE.Inputs[3].Float*4f)+1;

		//return NewColor;
	}
	public static string Generate(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
//		string[] Colors = new string[]{"r","g","b","a"};
		string Line1 = "(float3("+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[0].Get()+".r",SE.Inputs[0].Get()+".g",SE.Inputs[0].Get()+".b"),Effect)+".r,0,0)+float3(0,"+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[1].Get()+".r",SE.Inputs[1].Get()+".g",SE.Inputs[1].Get()+".b"),Effect)+".g,0)+float3(0,0,"+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[2].Get()+".r",SE.Inputs[2].Get()+".g",SE.Inputs[2].Get()+".b"),Effect)+".b))";
		//string retVal = "(float3("+Line1+","+Line2+","+"sqrt((1-pow("+Line1+",2)-pow("+Line2+",2)))))";///2+0.5)";
		//string retVal = Line1;///2+0.5)";
		return Line1;
	}
	public static string GenerateWAlpha(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
	//	string[] Colors = new string[]{"r","g","b","a"};
		string Line1 = "(float4("+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[0].Get()+".r",SE.Inputs[0].Get()+".g",SE.Inputs[0].Get()+".b"),Effect)+".r,0,0,0)+float4(0,"+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[1].Get()+".r",SE.Inputs[1].Get()+".g",SE.Inputs[1].Get()+".b"),Effect)+".g,0,0)+float4(0,0,"+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[2].Get()+".r",SE.Inputs[2].Get()+".g",SE.Inputs[2].Get()+".b"),Effect)+".b,0)+float4(0,0,0,"+SL.StartNewBranch(SG,SL.GCUVs(SG,SE.Inputs[3].Get()+".r",SE.Inputs[3].Get()+".g",SE.Inputs[3].Get()+".b"),Effect)+".b))";
		//string retVal = "(float3("+Line1+","+Line2+","+"sqrt((1-pow("+Line1+",2)-pow("+Line2+",2)))))";///2+0.5)";
		//string retVal = Line1;///2+0.5)";
		return Line1;
	}
}