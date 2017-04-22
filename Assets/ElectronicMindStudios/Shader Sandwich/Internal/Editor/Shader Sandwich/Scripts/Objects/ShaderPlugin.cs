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
using System.Xml;
using System.Diagnostics;


public class ShaderPlugin{
	public string TypeS
	{
		get { return TypeS_Real.Text; }
		set { TypeS_Real.Text = value; }
	}
	public ShaderVar TypeS_Real = new ShaderVar("TypeS","Hasn't Activated Correctly");
	public string Name = "";
	public string Description = "";
	public string Function = "";
	public string ExternalFunction = "";
	public bool UsesVertexColors = false;
	
	public bool AllowInBase = true;
	public bool AllowInLighting = true;
	public bool AllowInVertex = true;
	public bool AllowInPoke = true;
	
	public Dictionary<string,ShaderVar> Inputs = new Dictionary<string,ShaderVar>();
	public bool Draw(Rect rect){
		int Y = 0;
		bool update = false;
		foreach(KeyValuePair<string,ShaderVar> SV in Inputs){
			if (SV.Value.Hidden == false){
				if (SV.Value.Draw(new Rect(rect.x+2,rect.y+Y*20,rect.width-4,20),SV.Value.Name))
					update = true;
				Y+=1;
				if (SV.Value.ShowNumbers)
					Y+=1;
			}
		}
		return update;
//		return Draw(rect,Inputs); 
	}
	virtual public bool Draw(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		return DrawVars(rect,Data,SL);
	}
	virtual public bool DrawVars(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		int Y = 0;
		bool update = false;
		foreach(KeyValuePair<string,ShaderVar> SV in GetInputs()){
			if (Data.ContainsKey(SV.Key)){
				ShaderVar RSV = Data[SV.Key];
				if (RSV.Hidden == false){
					if (RSV.Draw(new Rect(rect.x+2,rect.y+Y*20,rect.width-4,20),RSV.Name))
						update = true;
					
					Y+=1;
					if (RSV.ShowNumbers)
						Y+=1;
				}
			}
		}
		return update; 
	}
	
	//public void Register(Dictionary<string,Delegate> ShaderLayerTypePreviewList, Dictionary<string,Delegate> ShaderLayerTypeGetDimensionsList){
	//	ShaderLayerTypePreviewList[TypeS] =  new ShaderLayerTypePreview(Preview);
	//	ShaderLayerTypeGetDimensionsList[TypeS] = new ShaderLayerTypeGetDimensions(GetDimensions);
	//}
	virtual public void Activate(){}
	virtual public Dictionary<string,ShaderVar> GetInputs(){return null;}
	
	
	
	
	
	public Float2 floor(Float2 s,bool SpawnNew){
		if (SpawnNew)
			s = new Float2(s.x,s.y);
		s.x = Mathf.Floor(s.x);
		s.y = Mathf.Floor(s.y);
		return s;
	}
	public Float4 floor(Float4 s,bool SpawnNew){
		if (SpawnNew)
			s = new Float4(s.x,s.y,s.z,s.w);
		s.x = Mathf.Floor(s.x);
		s.y = Mathf.Floor(s.y);
		s.z = Mathf.Floor(s.z);
		s.w = Mathf.Floor(s.w);
		return s;
	}
	public Float2 min(Float2 s,Float2 ss,bool SpawnNew){
		if (SpawnNew){
		s = new Float2(s.x,s.y);
		ss = new Float2(ss.x,ss.y);
		}
		s.x = Mathf.Min(s.x,ss.x);
		s.y = Mathf.Min(s.y,ss.y);
		return s;
	}
	public Float min(float s,float ss,bool SpawnNew){
		s = Mathf.Min(s,ss);
		return s;
	}
	public Float2 max(Float2 s,Float2 ss,bool SpawnNew){
		if (SpawnNew){
		s = new Float2(s.x,s.y);
		ss = new Float2(ss.x,ss.y);
		}
		s.x = Mathf.Max(s.x,ss.x);
		s.y = Mathf.Max(s.y,ss.y);
		return s;
	}
	public Float max(float s,float ss,bool SpawnNew){
		s = Mathf.Max(s,ss);
		return s;
	}
	public Float2 frac(Float2 s,bool SpawnNew){
		if (SpawnNew)
		return s-floor(s,true);
		else
		return s.Sub(floor(s,true));
	}
	public Float4 frac(Float4 s,bool SpawnNew){
		if (SpawnNew)
		return s-floor(s,true);
		else
		return s.Sub(floor(s,true));
	}
	public Float4 sign(Float4 s,bool SpawnNew){
		if (SpawnNew)
		s = new Float4(s.x,s.y,s.z,s.w);
		if (s.x>0)s.x = 1;
		if (s.x<0)s.x = -1;
		if (s.x==0)s.x = 0;
		if (s.y>0)s.y = 1;
		if (s.y<0)s.y = -1;
		if (s.y==0)s.y = 0;
		if (s.z>0)s.z = 1;
		if (s.z<0)s.z = -1;
		if (s.z==0)s.z = 0;
		if (s.w>0)s.w = 1;
		if (s.w<0)s.w = -1;
		if (s.w==0)s.w = 0;
		return s;
	}
	public Float4 rsqrt(Float4 asd){
		asd.x = Mathf.Pow(asd.x,-1f/2f);
		asd.y = Mathf.Pow(asd.y,-1f/2f);
		asd.z = Mathf.Pow(asd.z,-1f/2f);
		asd.w = Mathf.Pow(asd.w,-1f/2f);
		return asd;
	}
	public Float2 pow(Float2 asd,Float p){
		asd.x = Mathf.Pow(asd.x,p);
		asd.y = Mathf.Pow(asd.y,p);
		return asd;
	}
	public Float4 pow(Float4 asd,Float p){
		asd.x = Mathf.Pow(asd.x,p);
		asd.y = Mathf.Pow(asd.y,p);
		asd.z = Mathf.Pow(asd.z,p);
		asd.w = Mathf.Pow(asd.w,p);
		return asd;
	}
	public float distance(Float4 asd,Float4 asd2){
		return Vector4.Distance(new Vector4(asd.x,asd.y,asd.z,asd.w),new Vector4(asd2.x,asd2.y,asd2.z,asd2.w));
	}
	public float distance(Float3 asd,Float3 asd2){
		return Vector3.Distance(new Vector3(asd.x,asd.y,asd.z),new Vector3(asd2.x,asd2.y,asd2.z));
	}
	public float distance(Float2 asd,Float2 asd2){
		return Vector2.Distance(new Vector2(asd.x,asd.y),new Vector2(asd2.x,asd2.y));
	}
	public float distance(float asd,float asd2){
		return Mathf.Max(asd2,asd)-Mathf.Min(asd2,asd);
	}
	public ShaderColor pow(ShaderColor asd,float p){
		asd = asd.Copy();
		asd.r = Mathf.Pow(asd.r,p);
		asd.g = Mathf.Pow(asd.g,p);
		asd.b = Mathf.Pow(asd.b,p);
		asd.a = Mathf.Pow(asd.a,p);
		return asd;
	}
	public Float4 clamp(Float4 asd,float mi,float ma){
		asd.x = Mathf.Clamp(asd.x,mi,ma);
		asd.y = Mathf.Clamp(asd.y,mi,ma);
		asd.z = Mathf.Clamp(asd.z,mi,ma);
		asd.w = Mathf.Clamp(asd.w,mi,ma);
		return asd;
	}
	public float clamp(float asd,float mi,float ma){
		asd = Mathf.Clamp(asd,mi,ma);
		return asd;
	}
	public Float dot(Float4 asd,Float4 asd2){
		return asd.x*asd2.x+asd.y*asd2.y+asd.z*asd2.z+asd.w*asd2.w;
	}
	public Float dot(Float2 asd,Float2 asd2){
		return asd.x*asd2.x+asd.y*asd2.y;
	}
	public Float GammaToLinear(Float asd){
		if (ShaderSandwich.Instance.OpenShader.MiscColorSpace.Type == 1&&QualitySettings.activeColorSpace == ColorSpace.Linear){
			return Mathf.Pow(asd,2.2f);
		}
		return asd;
	}
	public Float4 GammaToLinear(Float4 asd){
		if (ShaderSandwich.Instance.OpenShader.MiscColorSpace.Type == 1&&QualitySettings.activeColorSpace == ColorSpace.Linear){
			pow(asd,2.2f);
		}
		return asd;
	}
	public ShaderColor GammaToLinear(ShaderColor asd){
		if (ShaderSandwich.Instance.OpenShader.MiscColorSpace.Type == 1&&QualitySettings.activeColorSpace == ColorSpace.Linear){
			asd = pow(asd,2.2f);
		}
		return asd;
	}
	
	
	public Float LinearToGamma(Float asd){
		if (ShaderSandwich.Instance.OpenShader.MiscColorSpace.Type == 2&&QualitySettings.activeColorSpace == ColorSpace.Linear){
			return Mathf.Pow(asd,1f/2.2f);
		}
		return asd;
	}
	public Float4 LinearToGamma(Float4 asd){
		if (ShaderSandwich.Instance.OpenShader.MiscColorSpace.Type == 2&&QualitySettings.activeColorSpace == ColorSpace.Linear){
			pow(asd,1f/2.2f);
		}
		return asd;
	}
	public ShaderColor LinearToGamma(ShaderColor asd){
		if (ShaderSandwich.Instance.OpenShader.MiscColorSpace.Type == 2&&QualitySettings.activeColorSpace == ColorSpace.Linear){
			asd = pow(asd,1f/2.2f);
		}
		return asd;
	}
}