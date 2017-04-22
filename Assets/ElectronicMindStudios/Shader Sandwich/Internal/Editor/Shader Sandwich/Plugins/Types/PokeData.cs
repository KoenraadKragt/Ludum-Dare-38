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
public class SLTPokeData : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTPokeData";
		Name = "Resources/Poke Data";
		Description = "Various bits of information.";
		UsesVertexColors = false;
		AllowInBase = false;
		AllowInVertex = false;
		AllowInLighting = false;
		AllowInPoke = true;
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		Inputs["PokeCustomAttr"] = new ShaderVar("PokeCustomAttr",0f);
		Inputs["PokeData"] = new ShaderVar("PokeData",new string[]{
		"Projection",
		"Position",
		"Velocity",
		"Distance",
		"Time",
		"1-TimeNormalized",
		"Maximum Distance",
		"Custom Float",
		"Custom Float3",
		},new string[]{"","","","","","","","",""});
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
			string PixCol = "";
			if (Data["PokeData"].Type==0)
				PixCol = "_PokeProjection,_PokeProjection,_PokeProjection";
			if (Data["PokeData"].Type==1)
				PixCol = "_PokeLPosition";
			if (Data["PokeData"].Type==2)
				PixCol = "_PokeLVelocity";
			if (Data["PokeData"].Type==3)
				PixCol = "_PokeDistance,_PokeDistance,_PokeDistance";
			if (Data["PokeData"].Type==4)
				PixCol = "_PokeLTime,_PokeLTime,_PokeLTime";
			if (Data["PokeData"].Type==5)
				PixCol = "_PokeLTimeNormalized,_PokeLTimeNormalized,_PokeLTimeNormalized";
			if (Data["PokeData"].Type==6)
				PixCol = "_PokeLMaxDistance,_PokeLMaxDistance,_PokeLMaxDistance";
			if (Data["PokeData"].Type==7)
				PixCol = "_PokeCustomF_"+Data["PokeCustomAttr"].ToString()+", _PokeCustomF_"+Data["PokeCustomAttr"].ToString()+", _PokeCustomF_"+Data["PokeCustomAttr"].ToString();
			if (Data["PokeData"].Type==8)
				PixCol = "_PokeCustomF3_"+Data["PokeCustomAttr"].ToString();
			
			if (SL.MixType.Type==4)
				return "float4("+PixCol+",1)";
		
			return "float4("+PixCol+",0)";
	}
	override public bool Draw(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		GUI.Label(new Rect(0,rect.y,250,20),"Data:");
		Data["PokeData"].Type=EditorGUI.Popup(new Rect(100,rect.y,150,20),Data["PokeData"].Type,Data["PokeData"].Names,ElectronicMindStudiosInterfaceUtils.EditorPopup);
		if (Data["PokeData"].Type>6){
			Data["PokeCustomAttr"].Draw(new Rect(100,rect.y+25,150,20),"Custom Attr:");
		}
		
		return false;
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 0;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		if (Data["PokeData"].Type==3){
		float Dist = Vector2.Distance(UV,new Vector2(0.5f,0.5f));
		return new ShaderColor(Dist,Dist,Dist,1);
		}
		else
		return new ShaderColor(UV.x,UV.y,0,1);
	}
}