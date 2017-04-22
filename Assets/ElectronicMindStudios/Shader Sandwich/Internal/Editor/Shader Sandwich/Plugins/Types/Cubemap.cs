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
public class SLTCubemap : ShaderLayerType{
	override public void Activate(){
		TypeS = "SLTCubemap";
		Name = "Resources/Cubemap";
		Description = "A 3D cubemap.";
	}
	public void AddTextureInput(int Option,ShaderVar SV){
		if (Option==0){
				SV.AddInput();
			SV.WarningReset();
		}
	}
	override public Dictionary<string,ShaderVar> GetInputs(){
		Inputs = new Dictionary<string,ShaderVar>();
			Inputs["Cubemap"] = new ShaderVar("Cubemap","Cubemap");
		return Inputs;
	}
	static float ImageRes = 256;
	void UpdateImage(Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		string path = AssetDatabase.GetAssetPath(Inputs["Cubemap"].CubeS());
		TextureImporter ti =  TextureImporter.GetAtPath(path) as TextureImporter;
		bool OldIsReadable = false;
		if (ti!=null){
				OldIsReadable = ti.isReadable;
				ti.isReadable = true;
				AssetDatabase.ImportAsset(path);
		}
		Color32[] colors = new Color32[(int)(ImageRes*ImageRes)];
		Cubemap UseCube = Data["Cubemap"].Cube;
		try {
			Data["Cubemap"].Cube.GetPixel(CubemapFace.PositiveX,0,0);
		}
		catch {
			UseCube = ShaderSandwich.KitchenCube;
		}
		for(int x = 0;x<ImageRes;x++){
			for(int y = 0;y<(int)ImageRes;y++){
				Color LayerPixel;
				LayerPixel = UseCube.GetPixel(CubemapFace.PositiveX,(int)((float)x/ImageRes*UseCube.width),(int)((1-(float)y/ImageRes)*UseCube.height));
				colors[x+((int)(y*ImageRes))] = (Color32)LayerPixel;
			}
		}	
		Data["Cubemap"].ImagePixels = colors;
		if (ti!=null){
			ti.isReadable = OldIsReadable;
			AssetDatabase.ImportAsset(path);
		}
	}
	override public bool Draw(Rect rect,Dictionary<string,ShaderVar> Data,ShaderLayer SL){
		if (DrawVars(rect,Data,SL)){
			GUI.changed = true;
			UpdateImage(Data,SL);
		}
	
		if (Data["Cubemap"].Input==null)
			Data["Cubemap"].WarningSetup("No Input","Textures and cubemaps require an input to function correctly. Would you like to add one automatically?","Yes","No",AddTextureInput);
		else
			Data["Cubemap"].WarningReset();
		Data["Cubemap"].Use = true;
		
		return false;
	}
	override public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){
		if (Data["Cubemap"].Get()!="SSError"){
			if (SL.IsVertex)
			return "texCUBElod("+Data["Cubemap"].Get()+",float4("+Map+",0))";
			else
			return "texCUBE("+Data["Cubemap"].Get()+","+Map+")";
		}
		return "float4(1,1,1,1)";
	}
	override public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){
		return 3;
	}
	override public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL,Vector2 UV){
		if (Data["Cubemap"].Get()!="SSError"&&Data["Cubemap"].ImagePixels!=null&&Data["Cubemap"].Cube!=null)
		return new ShaderColor(Data["Cubemap"].ImagePixels[ShaderUtil.FlatArray((int)(UV.x*ImageRes),(int)(UV.y*ImageRes),(int)ImageRes,(int)ImageRes)]);
		else
		return new ShaderColor(1f,1f,1f,1f);
	}
}