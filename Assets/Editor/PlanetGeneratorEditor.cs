using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(PlanetGenerator))]
public class PlanetGeneratorEditor : Editor 
{
	bool showProperties = false;

	public override void OnInspectorGUI()
    {
        PlanetGenerator generator = (PlanetGenerator)target;
        
		showProperties = EditorGUILayout.Foldout(showProperties, "Properties");
        if (showProperties)
		{
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.FloatField("vertexStrengthMin", generator.vertexStrengthMin);
			EditorGUILayout.FloatField("vertexStrengthMax", generator.vertexStrengthMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.FloatField("vertexIntensetyMin", generator.vertexIntensetyMin);
			EditorGUILayout.FloatField("vertexIntensetyMax", generator.vertexIntensetyMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.FloatField("vertexMinHeightMin", generator.vertexMinHeightMin);
			EditorGUILayout.FloatField("vertexMinHeightMax", generator.vertexMinHeightMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.FloatField("vertexMaxHeightMin", generator.vertexMaxHeightMin);
			EditorGUILayout.FloatField("vertexMaxHeightMax", generator.vertexMaxHeightMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			EditorGUILayout.FloatField("vertexScaleMin", generator.vertexScaleMin);
			EditorGUILayout.FloatField("vertexScaleMax", generator.vertexScaleMax);
			EditorGUILayout.EndHorizontal();
			if(generator.planetMaterial != null)
				EditorGUILayout.LabelField("vertexSeed", generator.planetMaterial.material.GetFloat("_SSSVertex_aSeed").ToString());
		}

		if(GUILayout.Button("Generate! [Seed: " + generator.vertexSeed + "]", GUILayout.ExpandWidth(true), GUILayout.Height(25)))
		{
			generator.GeneratePlanet();
		}
    }
}
