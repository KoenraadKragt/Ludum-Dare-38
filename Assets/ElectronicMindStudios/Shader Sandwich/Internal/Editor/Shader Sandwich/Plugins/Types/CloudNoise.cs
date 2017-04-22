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
public class SLTCloudNoise : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTCloudNoise";
		Name = "Procedural/Cloud Noise";
		Description = "Blocky noise (slow, not recommended).";
		
		Function = @"
float Unique1D(float t){
	//return frac(sin(floor(t.x))*43558.5453);
	return frac(sin(dot(t ,12.9898)) * 43758.5453);
	//return frac(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//return frac(sin(n)*43758.5453);
}
void Unique1DFastHasRewrite(float2 Pos,out float4 hash_0){
	float2 Offset = float2(26,161);
	float4 P = float4(Pos.xy,Pos.xy+1);
	P = P-floor(P*(1.0/71))*71;
	P += Offset.xyxy;
	P *= P;
	P = P.xzxz*P.yyww;
	hash_0 = frac(P*(1/951.135664));
}
float Lerpify(float P){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return f;
}
float D1Lerp(float P, float Col1,float Col2){
	float ft = P * 3.1415927;
	float f = (1 - cos(ft)) * 0.5;
	return Col1+((Col2-Col1)*f);//(Col1*P)+(Col2*(1-P));
}
float Unique2D(float2 t){
	float x = frac(sin(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453);
	//float x = frac(frac(tan(dot(floor(t) ,float2(12.9898,78.233))) * 43758.5453)*7.35);
	return x;
}
float Lerp2D(float2 P, float Col1,float Col2,float Col3,float Col4){
	float2 ft = P * 3.1415927;
	float2 f = (1 - cos(ft)) * 0.5;
	P = f;
	float S1 = lerp(Col1,Col2,P.x);
	float S2 = lerp(Col3,Col4,P.x);
	float L = lerp(S1,S2,P.y);
	return L;
}
float NoiseCloud2D(float2 P)
{
	float4 HashX;
	Unique1DFastHasRewrite(floor(P),HashX);
	float xx = Lerp2D(frac(P),HashX.x,HashX.y,HashX.z,HashX.w);
	return xx;
}

float NoiseCloud1D(float P)
{
	float SS = Unique1D(P);
	float SE = Unique1D(P+1);
	float xx = D1Lerp(frac(P),SS,SE);
	return xx;
}
float Unique3D(float3 t){
	float x = frac(tan(dot(tan(floor(t)),float3(12.9898,78.233,35.344))) * 9.5453);
	return x;
}

float Lerp3D(float3 P, float SSS,float SES,float ESS,float EES, float SSE,float SEE,float ESE,float EEE){
	float3 ft = P * 3.1415927;
	float3 f = (1 - cos(ft)) * 0.5;
	float S1 = lerp(SSS,SES,f.x);
	float S2 = lerp(ESS,EES,f.x);
	float F1 = lerp(S1,S2,f.y);
	float S3 = lerp(SSE,SEE,f.x);
	float S4 = lerp(ESE,EEE,f.x);
	float F2 = lerp(S3,S4,f.y);
	float L = lerp(F1,F2,f.z);//F1;
	return L;
}
float NoiseCloud3D(float3 P)
{
	float SSS = Unique3D(P+float3(0,0,0));
	float SES = Unique3D(P+float3(1,0,0));
	float ESS = Unique3D(P+float3(0,1,0));
	float EES = Unique3D(P+float3(1,1,0));
	float SSE = Unique3D(P+float3(0,0,1));
	float SEE = Unique3D(P+float3(1,0,1));
	float ESE = Unique3D(P+float3(0,1,1));
	float EEE = Unique3D(P+float3(1,1,1));
	float xx = Lerp3D(frac(P),SSS,SES,ESS,EES,SSE,SEE,ESE,EEE);
	return xx;
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
			PixCol = "NoiseCloud2D("+Map+"*3*1)";
		if (Data["Noise Dimensions"].Type==1)
			PixCol = "NoiseCloud3D("+Map+"*3*1)";
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
		return new ShaderColor(BlockNoise(UV.x*3f,UV.y*3f));
	}
	float Frac(float F){
		return (F-Mathf.Floor(F));
	}
	float Lerp2D(Vector2 P,float Col1, float Col2, float Col3, float Col4){
		Vector2 ft = P * 3.1415927f;
		Vector2 f = new Vector2(1f - Mathf.Cos(ft.x),1f - Mathf.Cos(ft.y)) * 0.5f;
		P = f;
		float S1 = Mathf.Lerp(Col1,Col2,P.x);
		float S2 = Mathf.Lerp(Col3,Col4,P.x);
		float L = Mathf.Lerp(S1,S2,P.y);
		return L;
	}
	float BlockNoise(float X,float Y){
		float XX = Mathf.Floor(X);
		float YY = Mathf.Floor(Y);
		float SS = Frac(Frac(Mathf.Tan(Vector2.Dot(new Vector2(XX,YY),new Vector2(12.9898f,78.233f))) * 43758.5453f)*7.35f);
		float SE = Frac(Frac(Mathf.Tan(Vector2.Dot(new Vector2(XX+1,YY+0),new Vector2(12.9898f,78.233f))) * 43758.5453f)*7.35f);
		float ES = Frac(Frac(Mathf.Tan(Vector2.Dot(new Vector2(XX+0,YY+1),new Vector2(12.9898f,78.233f))) * 43758.5453f)*7.35f);
		float EE = Frac(Frac(Mathf.Tan(Vector2.Dot(new Vector2(XX+1,YY+1),new Vector2(12.9898f,78.233f))) * 43758.5453f)*7.35f);
		return Lerp2D(new Vector2(Frac(X),Frac(Y)),SS,SE,ES,EE);
	}
}