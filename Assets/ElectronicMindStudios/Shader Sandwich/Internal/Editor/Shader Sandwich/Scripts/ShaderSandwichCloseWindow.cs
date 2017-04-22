#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6
#define PRE_UNITY_5
#else
#define UNITY_5
#endif
#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2
#define PRE_MORESTUPIDUNITYDEPRECATIONS
#endif
#pragma warning disable 0618
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System;
using SU = ShaderUtil;
using EMindGUI = ElectronicMindStudiosInterfaceUtils;
using UnityEngine.Rendering;
using System.Linq;
[System.Serializable]
public class ShaderSandwichCloseWindow : EditorWindow {
	
	[MenuItem ("Help/Shader Sandwich/Force Close Window")]
	public static void Init () {
		if (ShaderSandwich.Instance!=null)
			ShaderSandwich.Instance.Close();
	}
}