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


//delegate ShaderColor ShaderLayerTypePreview(ShaderLayerType SLT,Vector2 UV);
//delegate int ShaderLayerTypeGetDimensions(ShaderGenerate SG,ShaderLayerType SLT, ShaderLayer SL);


public class ShaderLayerType : ShaderPlugin{
	
	//public void Register(Dictionary<string,Delegate> ShaderLayerTypePreviewList, Dictionary<string,Delegate> ShaderLayerTypeGetDimensionsList){
	//	ShaderLayerTypePreviewList[TypeS] =  new ShaderLayerTypePreview(Preview);
	//	ShaderLayerTypeGetDimensionsList[TypeS] = new ShaderLayerTypeGetDimensions(GetDimensions);
	//}
	virtual public ShaderColor Preview(Dictionary<string,ShaderVar> Data, ShaderLayer SL, Vector2 UV){return null;}
	virtual public int GetDimensions(Dictionary<string,ShaderVar> Data, ShaderLayer SL){return 0;}
	virtual public string Generate(Dictionary<string,ShaderVar> Data, ShaderLayer SL, ShaderGenerate SG, string Map){return "";}
	//virtual public List<ShaderVar> Activate(){return null;}
}