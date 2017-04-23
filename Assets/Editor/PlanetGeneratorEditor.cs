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
        

		generator.generatePlanetOnStart = EditorGUILayout.Toggle("generatePlanetOnStart", generator.generatePlanetOnStart, GUILayout.Height(25));

		showProperties = EditorGUILayout.Foldout(showProperties, "Properties");
        if (showProperties)
		{
			EditorGUILayout.BeginHorizontal();
			generator.vertexStrengthMin = EditorGUILayout.FloatField("vertexStrengthMin", generator.vertexStrengthMin);
			generator.vertexStrengthMax = EditorGUILayout.FloatField("vertexStrengthMax", generator.vertexStrengthMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			generator.vertexIntensetyMin = EditorGUILayout.FloatField("vertexIntensetyMin", generator.vertexIntensetyMin);
			generator.vertexIntensetyMax = EditorGUILayout.FloatField("vertexIntensetyMax", generator.vertexIntensetyMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			generator.vertexMinHeightMin = EditorGUILayout.FloatField("vertexMinHeightMin", generator.vertexMinHeightMin);
			generator.vertexMinHeightMax = EditorGUILayout.FloatField("vertexMinHeightMax", generator.vertexMinHeightMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			generator.vertexMaxHeightMin = EditorGUILayout.FloatField("vertexMaxHeightMin", generator.vertexMaxHeightMin);
			generator.vertexMaxHeightMax = EditorGUILayout.FloatField("vertexMaxHeightMax", generator.vertexMaxHeightMax);
			EditorGUILayout.EndHorizontal();
			EditorGUILayout.BeginHorizontal();
			generator.vertexScaleMin = EditorGUILayout.FloatField("vertexScaleMin", generator.vertexScaleMin);
			generator.vertexScaleMax = EditorGUILayout.FloatField("vertexScaleMax", generator.vertexScaleMax);
			EditorGUILayout.EndHorizontal();
			if(generator.planetMaterial != null)
				EditorGUILayout.LabelField("vertexSeed", generator.planetMaterial.sharedMaterial.GetFloat("_SSSVertex_aSeed").ToString());
		}

		if(GUILayout.Button("Generate! [Seed: " + generator.vertexSeed + "]", GUILayout.ExpandWidth(true), GUILayout.Height(25)))
		{
			generator.GeneratePlanet();
		}
    }
}
