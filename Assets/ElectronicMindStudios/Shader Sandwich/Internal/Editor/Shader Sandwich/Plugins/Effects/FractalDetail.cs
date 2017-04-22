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
public class SSEFractalDetail : ShaderEffect{
	public static void Activate(ShaderEffect SE,bool BInputs){
		SE.TypeS = "SSEFractalDetail";
		SE.Name = "Blur/Fractal Detail";//+UnityEngine.Random.value.ToString();

		if (BInputs==true||SE.Inputs.Count!=3){
			SE.Inputs = new List<ShaderVar>();
			SE.Inputs.Add(new ShaderVar("Count",4f));
			SE.Inputs.Add(new ShaderVar("Scale",0.5f));
			SE.Inputs.Add(new ShaderVar("Weighting",1f));
		} 
		SE.Inputs[0].NoInputs = true;
		SE.Inputs[1].NoSlider = true;
		SE.Inputs[0].Float = Mathf.Round(SE.Inputs[0].Float);
		SE.Inputs[0].Range1 = 10;
		SE.Inputs[1].Range1 = 10f;
		SE.WorldPos = false;
		SE.WorldRefl = false;
		SE.WorldNormals = false;
	}
	public static ShaderColor Preview(ShaderEffect SE,ShaderColor[] OldColors,int X, int Y, int W, int H){
	
		//ShaderColor OldColor = OldColors[ShaderUtil.FlatArray(X,Y,W,H)];
		
		/*ShaderColor NewColor = new ShaderColor(
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[0].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[0].Vector.g)),W,H)].r,
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[1].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[1].Vector.g)),W,H)].g,
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[2].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[2].Vector.g)),W,H)].b,
		OldColors[ShaderUtil.FlatArray(X+((int)Mathf.Round(W*SE.Inputs[3].Vector.r)),Y+((int)Mathf.Round(H*SE.Inputs[3].Vector.g)),W,H)].a
		);*/
		return OldColors[ShaderUtil.FlatArray(X,Y,W,H)];//Mathf.Sqrt(1-(NewColor.x*NewColor.x)-(NewColor.y*NewColor.y)),1);
		//NewColor/=2f;
		//NewColor+= new Color(0.5f,0.5f,0.5f,0f);
		//else
		//NewColor/=(SE.Inputs[3].Float*4f)+1;

		//return NewColor;
	}
	public static string Generate(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		string Line1 = "(";
		if (SE.Inputs[2].Get()=="1"){
			for(int i = 0;i<=SE.Inputs[0].Float;i++){
				Line1 += SL.StartNewBranch(SG,"("+SL.GCUVs(SG)+"*pow("+SE.Inputs[1].Get()+","+i.ToString()+"))",Effect)+((i+1<=SE.Inputs[0].Float)?" + ":"");
			}
			Line1 += ")/"+(SE.Inputs[0].Float+1).ToString();
		}
		else{
			for(int i = 0;i<=SE.Inputs[0].Float;i++){
				Line1 += SL.StartNewBranch(SG,"("+SL.GCUVs(SG)+"*pow("+SE.Inputs[1].Get()+","+i.ToString()+"))",Effect)+"*((1.0/"+(SE.Inputs[0].Float+1).ToString()+")*pow("+SE.Inputs[2].Get()+","+i.ToString()+"))"+((i+1<=SE.Inputs[0].Float)?" + ":"");
			}
			Line1 += ")";
		}
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