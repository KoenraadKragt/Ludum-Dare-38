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
public class SSEGeometryLineDistance : ShaderEffect{
	public static void Activate(ShaderEffect SE,bool BInputs){
		SE.TypeS = "SSEGeometryLineDistance";
		SE.Name = "Geometry/Distance To Line";//+UnityEngine.Random.value.ToString();
		
		SE.Function = @"
			float LineDistance(float P1, float P2, float pos){
				float direction = normalize(P2-P1);
				float startDirection = pos-P1;
				float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
				float NearestPoint = P2 * Projection + P1 * (1 - Projection);
				return distance(pos,NearestPoint);
			}
			float LineDistance(float2 P1, float2 P2, float2 pos){
				float2 direction = normalize(P2-P1);
				float2 startDirection = pos-P1;
				float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
				float2 NearestPoint = P2 * Projection + P1 * (1 - Projection);
				return distance(pos,NearestPoint);
			}
			float LineDistance(float3 P1, float3 P2, float3 pos){
				float3 direction = normalize(P2-P1);
				float3 startDirection = pos-P1;
				float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
				float3 NearestPoint = P2 * Projection + P1 * (1 - Projection);
				return distance(pos,NearestPoint);
			}
			float LineDistance(float4 P1, float4 P2, float4 pos){
				float4 direction = normalize(P2-P1);
				float4 startDirection = pos-P1;
				float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
				float4 NearestPoint = P2 * Projection + P1 * (1 - Projection);
				return distance(pos,NearestPoint);
			}
			";
		SE.LinePre = "";
		if (BInputs==true||SE.Inputs.Count!=3){
			SE.Inputs = new List<ShaderVar>();
			SE.Inputs.Add(new ShaderVar("Dimensions",new string[]{"1D","2D","3D","4D"},new string[]{"","","",""},new string[]{"1D","2D","3D","4D"}));
			SE.Inputs[0].Type = 1;
			SE.Inputs.Add(new ShaderVar("Line Start",new ShaderColor(0,0,0,1)));
			SE.Inputs.Add(new ShaderVar("Line End",new ShaderColor(1,1,0,1)));
		} 
		SE.Inputs[1].ShowNumbers = true;
		SE.Inputs[2].ShowNumbers = true;
		SE.CustomHeight = 20*5;
		if (SE.Inputs[0].Type==3)
		SE.UseAlpha.Float=1f;
		if (SE.UseAlpha.Float==2f)
		SE.UseAlpha.Float=0f;
		SE.WorldPos = false;
		SE.WorldRefl = false;
		SE.WorldNormals = false;		
	}
	public static string GenerateGeneric(ShaderEffect SE,string line){
		string Grey = line;
		if (SE.Inputs[0].Type==0)
		Grey = "LineDistance("+SE.Inputs[1].Get()+".x,"+SE.Inputs[2].Get()+".x,"+line+".x)";
		if (SE.Inputs[0].Type==1)
		Grey = "LineDistance("+SE.Inputs[1].Get()+".xy,"+SE.Inputs[2].Get()+".xy,"+line+".xy)";
		if (SE.Inputs[0].Type==2)
		Grey = "LineDistance("+SE.Inputs[1].Get()+".xyz,"+SE.Inputs[2].Get()+".xyz,"+line+".xyz)";
		if (SE.Inputs[0].Type==3)
		Grey = "LineDistance("+SE.Inputs[1].Get()+".xyzw,"+SE.Inputs[2].Get()+".xyzw,"+line+".xyzw)";
		//if (SE.Inputs[0].Type==2)
		//Grey = "LineDistance("+line+".xyz,float3("+SE.Inputs[1].Get()+","+SE.Inputs[2].Get()+","+SE.Inputs[3].Get()+"))";
		//if (SE.Inputs[0].Type==3)
		//Grey = "LineDistance("+line+",float4("+SE.Inputs[1].Get()+","+SE.Inputs[2].Get()+","+SE.Inputs[3].Get()+","+SE.Inputs[4].Get()+"))";
		return "(("+Grey+").rrrr)";	
	}
	public static string Generate(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		return GenerateGeneric(SE,Line);
	}
	public static string GenerateAlpha(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		return GenerateGeneric(SE,Line);
	}
	public static string GenerateWAlpha(ShaderGenerate SG,ShaderEffect SE, ShaderLayer SL,string Line,int Effect){
		return GenerateGeneric(SE,Line);
	}
	public static float distance(Float4 asd,Float4 asd2){
		return Vector4.Distance(new Vector4(asd.x,asd.y,asd.z,asd.w),new Vector4(asd2.x,asd2.y,asd2.z,asd2.w));
	}
	public static float distance(Float3 asd,Float3 asd2){
		return Vector3.Distance(new Vector3(asd.x,asd.y,asd.z),new Vector3(asd2.x,asd2.y,asd2.z));
	}
	public static float distance(Float2 asd,Float2 asd2){
		return Vector2.Distance(new Vector2(asd.x,asd.y),new Vector2(asd2.x,asd2.y));
	}
	public static float distance(float asd,float asd2){
		return Mathf.Max(asd2,asd)-Mathf.Min(asd2,asd);
	}
	public static Float4 saturate(Float4 asd){
		asd.x = Mathf.Clamp(asd.x,0,1);
		asd.y = Mathf.Clamp(asd.y,0,1);
		asd.z = Mathf.Clamp(asd.z,0,1);
		asd.w = Mathf.Clamp(asd.w,0,1);
		return asd;
	}
	public static Float3 saturate(Float3 asd){
		asd.x = Mathf.Clamp(asd.x,0,1);
		asd.y = Mathf.Clamp(asd.y,0,1);
		asd.z = Mathf.Clamp(asd.z,0,1);
		return asd;
	}
	public static Float2 saturate(Float2 asd){
		asd.x = Mathf.Clamp(asd.x,0,1);
		asd.y = Mathf.Clamp(asd.y,0,1);
		return asd;
	}
	public static float saturate(float asd){
		asd = Mathf.Clamp(asd,0,1);
		return asd;
	}
	public static Float dot(Float4 asd,Float4 asd2){
		return asd.x*asd2.x+asd.y*asd2.y+asd.z*asd2.z+asd.w*asd2.w;
	}
	public static Float dot(Float3 asd,Float3 asd2){
		return asd.x*asd2.x+asd.y*asd2.y+asd.z*asd2.z;
	}
	public static Float dot(Float2 asd,Float2 asd2){
		return asd.x*asd2.x+asd.y*asd2.y;
	}
	public static Float dot(float asd,float asd2){
		return asd*asd2;
	}
	public static Float4 normalize(Float4 asd){
		return new Float4(new Vector4(asd.x,asd.y,asd.z,asd.w).normalized);
	}
	public static Float3 normalize(Float3 asd){
		return new Float3(new Vector3(asd.x,asd.y,asd.z).normalized);
	}
	public static Float2 normalize(Float2 asd){
		return new Float2(new Vector2(asd.x,asd.y).normalized);
	}
	public static float normalize(float asd){
		return 1;
	}
	public static float LineDistance(Float4 P1, Float4 P2, Float4 pos){
		Float4 direction = normalize(P2-P1);
		Float4 startDirection = pos-P1;
		float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
		Float4 NearestPoint = P2 * Projection + P1 * (1f - Projection);
		return distance(pos,NearestPoint);	
	}
	public static float LineDistance(Float3 P1, Float3 P2, Float3 pos){
		Float3 direction = normalize(P2-P1);
		Float3 startDirection = pos-P1;
		float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
		Float3 NearestPoint = P2 * Projection + P1 * (1f - Projection);
		return distance(pos,NearestPoint);	
	}
	public static float LineDistance(Float2 P1, Float2 P2, Float2 pos){
		Float2 direction = normalize(P2-P1);
		Float2 startDirection = pos-P1;
		float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
		Float2 NearestPoint = P2 * Projection + P1 * (1f - Projection);
		return distance(pos,NearestPoint);	
	}
	public static float LineDistance(float P1, float P2, float pos){
		float direction = 1;
		float startDirection = pos-P1;
		float Projection = saturate(dot(startDirection,direction)/distance(P1,P2));
		float NearestPoint = P2 * Projection + P1 * (1f - Projection);
		return distance(pos,NearestPoint);	
	}
	public static ShaderColor Preview(ShaderEffect SE,ShaderColor OldColor){
		//ShaderColor NewColor = OldColor*new ShaderColor(SE.Inputs[0].Float,SE.Inputs[1].Float,SE.Inputs[2].Float,SE.Inputs[3].Float);// = new ShaderColor(OldColor.r+SE.Inputs[0].Float,OldColor.g+SE.Inputs[0].Float,OldColor.b+SE.Inputs[0].Float,OldColor.a+SE.Inputs[0].Float);
		float Grey = 0;
		if (SE.Inputs[0].Type==0)
		Grey = LineDistance(SE.Inputs[1].Vector.r,SE.Inputs[2].Vector.r,OldColor.r);
		if (SE.Inputs[0].Type==1)
		Grey = LineDistance(new Float2(SE.Inputs[1].Vector),new Float2(SE.Inputs[2].Vector),new Float2(OldColor.r,OldColor.g));
		//Grey = Vector2.Distance(new Vector2(OldColor.r,OldColor.g),new Vector2(SE.Inputs[1].Float,SE.Inputs[2].Float));
		if (SE.Inputs[0].Type==2)
		Grey = LineDistance(new Float3(SE.Inputs[1].Vector),new Float3(SE.Inputs[2].Vector),new Float3(OldColor.r,OldColor.g,OldColor.b));
		if (SE.Inputs[0].Type==3)
		Grey = LineDistance(new Float4(SE.Inputs[1].Vector),new Float4(SE.Inputs[2].Vector),new Float4(OldColor));
		
		
		ShaderColor NewColor = new ShaderColor(Grey,Grey,Grey,Grey);
		return NewColor;
	}
}

