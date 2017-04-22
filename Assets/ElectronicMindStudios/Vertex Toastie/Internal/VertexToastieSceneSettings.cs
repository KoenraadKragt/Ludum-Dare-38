#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6
#define PRE_UNITY_5
#else
#define UNITY_5
#endif
#if UNITY_4_0 || UNITY_4_0_1 || UNITY_4_1 || UNITY_4_2 || UNITY_4_3 || UNITY_4_4 || UNITY_4_5 || UNITY_4_6 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2
#define PRE_UNITY_5_3
#else
#define UNITY_5_3
#endif
#pragma warning disable 0618
using UnityEngine;
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using UnityEngine.Rendering;
using SRandom = System.Random;

[AddComponentMenu("")]
[DisallowMultipleComponent]
public class VertexToastieSceneSettings : MonoBehaviour {
	[System.NonSerialized]public bool DebugMode = false;
	public static VertexToastieSceneSettings Instance;
	public int Rays = 100;
	public int EditorDisplayRays = 8;
	public float MaxDist = 1;
	public float Bias = 0.05f;
	public float AOStrength = 1f;
	public float AOPower = 1f;
	public bool VisualizeAO = false;
	public bool ApplyAOToDiffuse = false;
	public int AODisplay = 2;
	public bool RealtimeAO = false;
	
	public bool AutoCorrectMaterials = true;
	public bool AutoStartJobs = true;
	
	public List<GameObject> BakedObjects = new List<GameObject>();
	public List<GameObject> RealtimeObjects = new List<GameObject>();
	public List<GameObject> ColliderObjects = new List<GameObject>();
	
	public void Remove(GameObject GO){
		BakedObjects.Remove(GO);
		RealtimeObjects.Remove(GO);
		ColliderObjects.Remove(GO);
	}
	public void ClearAll(){
		BakedObjects.Clear();
		RealtimeObjects.Clear();
		ColliderObjects.Clear();
	}
	public List<GameObject> AllObjects{
		get{
			List<GameObject> asd = new List<GameObject>();
			asd.AddRange(BakedObjects);
			asd.AddRange(RealtimeObjects);
			asd.AddRange(ColliderObjects);
			return asd;
		}
		set{}
	}
	public void Awake(){
		Instance = this;
	}
	public void Update(){
		Instance = this;
	}
}