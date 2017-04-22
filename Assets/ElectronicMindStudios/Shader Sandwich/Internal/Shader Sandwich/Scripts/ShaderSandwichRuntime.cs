using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
	using UnityEditor;
#endif

[ExecuteInEditMode]
[AddComponentMenu("Shader Sandwich/Base/Shader Sandwich Runtime")]
public class ShaderSandwichRuntime : MonoBehaviour {
	public Texture2D PerlinNoise;
	public bool ForceRefresh = false;
	void Awake () {
		#if UNITY_EDITOR
			PerlinNoise = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/ElectronicMindStudios/Shader Sandwich/Internal/Shader Sandwich/Textures/ShaderSandwichPerlinNoise.png",typeof(Texture2D));
		#endif
		Shader.SetGlobalTexture("_ShaderSandwichPerlinTexture",PerlinNoise);
	}
	void Update () {
		#if UNITY_EDITOR
			if (!Application.isPlaying){
				if (PerlinNoise==null)
				PerlinNoise = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/ElectronicMindStudios/Shader Sandwich/Internal/Shader Sandwich/Textures/ShaderSandwichPerlinNoise.png",typeof(Texture2D));
				ForceRefresh = true;
			}
		#endif
		if (ForceRefresh)
			Shader.SetGlobalTexture("_ShaderSandwichPerlinTexture",PerlinNoise);
	
		ForceRefresh = false;
	}
}
