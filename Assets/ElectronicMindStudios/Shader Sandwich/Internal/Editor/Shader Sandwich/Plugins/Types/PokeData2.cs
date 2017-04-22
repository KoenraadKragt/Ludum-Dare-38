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
public class SLTPokeData2 : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTPokeData2";
		Name = "Resources/Poke Data";
		Description = "Access the poke channels.";
		UsesVertexColors = false;
		AllowInBase = true;
		AllowInVertex = true;
		AllowInLighting = true;
		AllowInPoke = false;
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
		Inputs["PokeChannel"] = new ShaderVar("PokeChannel",new string[]{
		"Poke Channel 1",
		"Poke Channel 2"
		},new string[]{"",""});
		return Inputs;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
			string PixCol = "";
			if (SG.RPass.PokeOn.On&&SG.RPass.PokeCustom.On){
				string function = "d, gi,_Poke%Projection, _Poke%LPosition, _Poke%LVelocity, _Poke%Distance, _Poke%LTime, _Poke%LTimeNormalized, _Poke%LMaxDistance";
				for(int i = 0; i<SG.RPass.PokeFloats.Float;i++){
					function+=", float _Poke%CustomF_"+i.ToString();
				}
				for(int i = 0; i<SG.RPass.PokeFloat3s.Float;i++){
					function+=", float3 _Poke%CustomF3_"+i.ToString();
				}
				if (Data["PokeChannel"].Type==0)
					function = "PokeFunction1("+function+")";
				if (Data["PokeChannel"].Type==1)
					function = "PokeFunction2("+function+")";
				
				PixCol += function.Replace("%","0");
				for(int i = 1; i<SG.RPass.PokeCount.Float; i++){
					PixCol += " + "+function.Replace("%",i.ToString());
				}
			}
			else{
				PixCol = "";
			}
			return PixCol;
	}
	override public bool Draw(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		GUI.Label(new Rect(0,rect.y,250,20),"Data:");
		Data["PokeChannel"].Type=EditorGUI.Popup(new Rect(100,rect.y,150,20),Data["PokeChannel"].Type,Data["PokeChannel"].Names,ElectronicMindStudiosInterfaceUtils.EditorPopup);
		
		return false;
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 0;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		if (Data["PokeChannel"].Type==3){
		float Dist = Vector2.Distance(UV,new Vector2(0.5f,0.5f));
		return new ShaderColor(Dist,Dist,Dist,1);
		}
		else
		return new ShaderColor(UV.x,UV.y,0,1);
	}
}