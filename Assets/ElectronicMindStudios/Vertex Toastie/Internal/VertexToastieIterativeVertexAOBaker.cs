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
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.IO;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using UnityEngine.Rendering;
using SRandom = System.Random;

[AddComponentMenu("")]
[DisallowMultipleComponent]
[ExecuteInEditMode]
public class VertexToastieIterativeVertexAOBaker : MonoBehaviour {
	public enum GenerationTypes {AmbientOcclusion,LocalVariationThickness,Both};
	public enum Roles {Baked,Realtime,Collider};
	public GenerationTypes GenerationType = GenerationTypes.AmbientOcclusion;
	public Roles Role = Roles.Baked;
	public enum BakeMode {None,Bake,Update};
	public bool OverrideMaxRays = false;
	public int MaxRays = 100;
	public int EditorDisplayRays = 16;
	
	public int RealtimeRays = 16;
	public int RealtimeRaysPerFrame = 4;
	public int VerticesPerFrame = 500;
	public bool OverrideMaxDist = false;
	public float MaxDist = 100;
	public bool OverrideMaxTranslucencyDist = false;
	public float MaxTranslucencyDist = 100;
	public bool OverrideBias = false;
	public float Bias = 0.01f;
	public BakeMode Cast = BakeMode.None;
	public bool CastCleanup = false;
	public bool CheckSeams = false;
	public bool HasBeenPrepared = false;
	public int LastMatter = 0; // 0 = Nothing, 1 = Cast, 2 = CheckSeams
	public bool StaticMeshOhNo = false;
	
	public int RMaxRays{
		get{
			return OverrideMaxRays?MaxRays:VertexToastieSceneSettings.Instance.Rays;
		}set{}
	}
	public float RMaxDist{
		get{
			return OverrideMaxDist?MaxDist:VertexToastieSceneSettings.Instance.MaxDist;
		}set{}
	}
	public float RTranslucencyMaxDist{
		get{
			return OverrideMaxDist?MaxTranslucencyDist:VertexToastieSceneSettings.Instance.MaxDist;
		}set{}
	}
	public float RBias{
		get{
			return OverrideBias?Bias:VertexToastieSceneSettings.Instance.Bias;
		}set{}
	}
	public int REditorDisplayRays{
		get{
			return VertexToastieSceneSettings.Instance.EditorDisplayRays;
		}set{}
	}
	
	public bool Locked = false;
	
	public Mesh OriginalMesh{
		get{
			//if (OriginalMesh_Real==null){
				Mesh TempMesh = null;
				if (gameObject.GetComponent<MeshFilter>()!=null){
					TempMesh = gameObject.GetComponent<MeshFilter>().sharedMesh;
				}
				else
				if (gameObject.GetComponent<SkinnedMeshRenderer>()!=null){
					TempMesh = gameObject.GetComponent<SkinnedMeshRenderer>().sharedMesh;
				}
				if (OriginalMesh_Real==null||(TempMesh!=null&&TempMesh.name.IndexOf("_BakeVertexAO")<0)){
					OriginalMesh_Real = TempMesh;
					AOBakeMesh = OriginalMesh_Real;
					PrepareAOMeshBlahBlaj();
				}
			//}
			return OriginalMesh_Real;
		}
		set{}
	
	}
	public Mesh OriginalMesh_Real = null;
	public Mesh AOBakeMesh = null;
	public Mesh FlippedOriginalMesh = null;
	public Vector3 Origin;
	public Quaternion Rotation;
	public Vector3 Scale;

	public Color32[] vertColors;
	public Color32[] finalColors;
	public Vector3[] vertPositions;
	public Vector3[] vertNormals;
	
	public int RayCount = 0;
	public int RayGroupCount = 0;
	public int[] occlusionFactors;
	public int[] thicknessFactors;
	public int[] oldOcclusionFactors;
	public GameObject BakeObject = null;
	public GameObject FlippedBakeObject = null;
	public MeshCollider PhysicsObject;
	public MeshCollider FlippedPhysicsObject;
	public Transform GOTransform;
	
	public SRandom random;
	
	public Mesh GetMesh(){
		if (gameObject.GetComponent<MeshFilter>()!=null)
			return gameObject.GetComponent<MeshFilter>().sharedMesh;
		else
		if (gameObject.GetComponent<SkinnedMeshRenderer>()!=null)
			return gameObject.GetComponent<SkinnedMeshRenderer>().sharedMesh;
			
		return null;
	}	
	public void SetMesh(Mesh mesh){
		if (gameObject.GetComponent<MeshFilter>()!=null)
			gameObject.GetComponent<MeshFilter>().sharedMesh = mesh;
		else
		if (gameObject.GetComponent<SkinnedMeshRenderer>()!=null)
			gameObject.GetComponent<SkinnedMeshRenderer>().sharedMesh = mesh;
	}
	public void OnEnable(){
		if (GetMesh()==null&&OriginalMesh!=null){
			Color32[] finalColors2 = finalColors;
			PrepareAOMesh();
			finalColors = finalColors2;
			AOBakeMesh.colors32 = finalColors;
			SetMesh(AOBakeMesh);
			Debug.Log("Fuc");
		}
	}
	public void Start(){
		if (!Application.isPlaying) return;
		//if (Role == Roles.Realtime){
			if (VertexToastieSceneSettings.Instance==null){//||!VertexToastieSceneSettings.Instance.RealtimeAO){
				Destroy(this);
				return;
			}
			if (VertexToastieSceneSettings.Instance.RealtimeAO){
				UpdateSelfTracker();
				PrepareColliders();
			}
		//}
	}
	public void Update(){
		if (!Application.isPlaying) return;
		if (Role == Roles.Realtime&&VertexToastieSceneSettings.Instance.RealtimeAO){
			BakeVertexAO();
			if (SmoothAOTransition&&InNeedOfTransition){
				InNeedOfTransition = false;
				Color32[] PreColors = AOBakeMesh.colors32;
				for(int i = 0; i < PreColors.Length; i ++){
					Color32 col = PreColors[i];
					//byte avg = (byte)(((float)col.a+(float)vertColors[i].a)/2f);
					byte avg = (byte)((Mathf.Lerp((float)col.a,(float)vertColors[i].a,0.2f)));
					if (col.a!=avg)
						InNeedOfTransition = true;
					col.a = avg;
					PreColors[i] = col;
				}
				AOBakeMesh.colors32 = PreColors;
			}
		}
	}
	
	public void StartJob(){
		//if (Locked)
		//	return;
		if (Cast != BakeMode.Bake){
			PrepareColliders();
			if (!Locked){
				PrepareAOMesh();
				PrepareRays();
				StartBake();
			}
		}
	}
	public List<GameObject> ReactionCalls = new List<GameObject>();
	public void ActionRebake(){
		if (Locked)
			return;
		PrepareColliders(false);
		PrepareRays();
		StartUpdate();
		
		UpdateSelfTracker();
		UpdateBakeObjects();
		ReactionCalls = new List<GameObject>();
	}
	public void ReactionRebake(){
		if (Locked)
			return;
		
		PrepareColliders(false);
		UpdateSelfTracker();
		UpdateBakeObjects();
		PrepareRays();
		StartBake();
	}
	
	public void PrepareRays(){
		random = new SRandom(69);
		if (!Locked){
			RayCount = 0;
			RayGroupCount = 0;
			VertexSplitNumber = 0;
		}
		LastMatter = 1;
		if (AOBakeMesh==null)
			PrepareAOMesh();
		occlusionFactors = new int[AOBakeMesh.vertexCount];
		thicknessFactors = new int[AOBakeMesh.vertexCount];
	}
	public void PrepareAOMesh(){
		AOBakeMesh = OriginalMesh;
		if (AOBakeMesh.name.IndexOf("_BakeVertexAO")<0){
			string newName = AOBakeMesh.name+"_BakeVertexAO";
			AOBakeMesh = (Mesh)Mesh.Instantiate(AOBakeMesh);
			AOBakeMesh.name = newName;
		}
		
		vertColors = AOBakeMesh.colors32;
		finalColors = new Color32[AOBakeMesh.vertexCount];
		vertPositions = AOBakeMesh.vertices;
		vertNormals = AOBakeMesh.normals;
	}
	public void PrepareAOMeshBlahBlaj(){
		if (AOBakeMesh.name.IndexOf("_BakeVertexAO")<0){
			string newName = AOBakeMesh.name+"_BakeVertexAO";
			AOBakeMesh = (Mesh)Mesh.Instantiate(AOBakeMesh);
			AOBakeMesh.name = newName;
		}
		
		vertColors = AOBakeMesh.colors32;
		finalColors = new Color32[AOBakeMesh.vertexCount];
		vertPositions = AOBakeMesh.vertices;
		vertNormals = AOBakeMesh.normals;
	}
	public void PrepareColliders(){
		PrepareColliders(true);
	}
	public void PrepareColliders(bool EnsureCorrect){
		if (EnsureCorrect)
			DestroyColliders();
		
		if (BakeObject==null){
			BakeObject = new GameObject();
			if (LayerMask.NameToLayer("VertexToastie")>0)
				BakeObject.layer = LayerMask.NameToLayer("VertexToastie");
			PhysicsObject = BakeObject.AddComponent<MeshCollider>();
			
			//if (GenerationType == GenerationTypes.AmbientOcclusion){
			if (OriginalMesh.name.IndexOf("Combined Mesh")<0){
				
				FlippedOriginalMesh = (Mesh)Mesh.Instantiate(OriginalMesh);
				FlippedOriginalMesh.triangles = FlippedOriginalMesh.triangles.Reverse().ToArray();
				FlippedBakeObject = new GameObject();
				if (LayerMask.NameToLayer("VertexToastie")>0)
					FlippedBakeObject.layer = LayerMask.NameToLayer("VertexToastie");
				FlippedPhysicsObject = FlippedBakeObject.AddComponent<MeshCollider>();
			//}
			}
			else{
				Debug.LogWarning(gameObject.name+" wasn't able to set up its colliders properly due to it being merged with others as a static mesh.\nPlease unmark the object as static thanks :)",gameObject);
				StaticMeshOhNo = true;
			}
		}
		UpdateSelfTracker();
		UpdateBakeObjects();
		HasBeenPrepared = true;
		CastCleanup = false;
	}
	public void UpdateSelfTracker(){
		Origin = gameObject.GetComponent<Transform>().position;
		Rotation = gameObject.GetComponent<Transform>().rotation;
		Scale = gameObject.GetComponent<Transform>().lossyScale;
	}
	public void UpdateBakeObjects(){
		//if (Locked)
		//	return;
		BakeObject.hideFlags = VertexToastieSceneSettings.Instance.DebugMode?HideFlags.None:HideFlags.HideAndDontSave;
		GOTransform = BakeObject.GetComponent<Transform>();
		GOTransform.position = Origin;
		GOTransform.rotation = Rotation;
		GOTransform.parent = gameObject.transform;
		GOTransform.localScale = new Vector3(1,1,1);
		//if (GenerationType == GenerationTypes.AmbientOcclusion){
		if (!StaticMeshOhNo){
			FlippedBakeObject.hideFlags = VertexToastieSceneSettings.Instance.DebugMode?HideFlags.None:HideFlags.HideAndDontSave;
			GOTransform = FlippedBakeObject.GetComponent<Transform>();
			GOTransform.position = Origin;
			GOTransform.rotation = Rotation;
			GOTransform.parent = gameObject.transform;
			GOTransform.localScale = new Vector3(1,1,1);
		}
		//}
		
		//if (GenerationType == GenerationTypes.AmbientOcclusion)
			PhysicsObject.sharedMesh = OriginalMesh;
		//else
		//	PhysicsObject.sharedMesh = FlippedOriginalMesh;

		PhysicsObject.convex = false;
		
		//if (GenerationType == GenerationTypes.AmbientOcclusion){
		if (!StaticMeshOhNo){
			FlippedPhysicsObject.sharedMesh = FlippedOriginalMesh;
			FlippedPhysicsObject.convex = false;
		}
		//}
	}
	public void StopBake(){
		Cast = BakeMode.None;
	}
	public void StartBake(){
		Cast = BakeMode.Bake;
	}
	public void StartUpdate(){
		Cast = BakeMode.Update;
	}
	public void DestroyColliders(){
		if (PhysicsObject!=null)
			DestroyImmediate(PhysicsObject);
		if (BakeObject!=null)
			DestroyImmediate(BakeObject);
		if (FlippedBakeObject!=null)
			DestroyImmediate(FlippedPhysicsObject);
		if (FlippedBakeObject!=null)
			DestroyImmediate(FlippedBakeObject);
		CastCleanup = true;
		HasBeenPrepared = false;
	}
	//Modified - Credit to Symphonic of http://www.gamedev.net/
	Vector2 RandomDirection2D(SRandom random)
	{
		float azimuth = (float)random.NextDouble() * 2f * Mathf.PI;
		return new Vector2(Mathf.Cos(azimuth), Mathf.Sin(azimuth));
	}
	Vector3 RandomDirection3D(SRandom random)
	{
		float z = (2f*(float)random.NextDouble()) - 1f; // z is in the range [-1,1]
		Vector2 planar = RandomDirection2D(random) * Mathf.Sqrt(1f-z*z);
		return new Vector3(planar.x, planar.y, z);
	}
	public bool SmoothAOTransition = false;
	public bool InNeedOfTransition = false;
	public int VertexSplitNumber = 0;
	public bool GenerateColliders = false;
	public void BakeVertexAO(){
		//if (Locked)
		//	return;
		//I'VE REMOVED CHECKING THE ANGLE DUE TO FLOATING POINT ERRORS - PLEASE FIX LATER!!!!
		//Debug.Log(((Quaternion.Angle(Rotation,gameObject.GetComponent<Transform>().rotation))));
		//if (((Vector3.Distance(Origin,gameObject.GetComponent<Transform>().position)+(Quaternion.Angle(Rotation,gameObject.GetComponent<Transform>().rotation)))>0.001f&&(!Application.isPlaying||RayCount>=RealtimeRays))&&!Locked){
		//if (((Vector3.Distance(Origin,gameObject.GetComponent<Transform>().position))>0.001f&&(!Application.isPlaying||RayCount>=RealtimeRays))&&!Locked){
		
		Quaternion newrot = gameObject.GetComponent<Transform>().rotation;
		if (Vector3.Distance(Origin,gameObject.GetComponent<Transform>().position)>0.001f||Vector3.Distance(Scale,gameObject.GetComponent<Transform>().lossyScale)>0.001f||Rotation.x!=newrot.x||Rotation.y!=newrot.y||Rotation.z!=newrot.z||Rotation.w!=newrot.w){
			GenerateColliders = true;
			ActionRebake();
			return;
		}
//		Debug.Log("GAAAAAAHHHH222");
		if (Locked)
			Cast = BakeMode.None;
		
		if (Cast==BakeMode.None||Role == Roles.Collider)
		return;
		
		if (GOTransform==null)
		return;
		
		if (AOBakeMesh==null)
		return;
		
		#if UNITY_EDITOR
			#if UNITY_5_3
				if (!Application.isPlaying)
				UnityEditor.SceneManagement.EditorSceneManager.MarkAllScenesDirty();
			#else
				if (!Application.isPlaying)
				EditorUtility.SetDirty(EditorApplication.currentScene);
			#endif
		#endif

		BakeVertexAO_Internal();
	}
	public void BakeVertexAO_Internal(){

		//Setup Settings
		int _RMaxRays = RMaxRays;
		float _RMaxDist = RMaxDist;
		float _RTranslucencyMaxDist = RTranslucencyMaxDist;
		float _RBias = RBias;
		int _REditorDisplayRays = REditorDisplayRays;
		
		MaxRays = RMaxRays;
		MaxDist = RMaxDist;
		Bias = RBias;
		
		int mask = Physics.DefaultRaycastLayers;
			if (LayerMask.NameToLayer("VertexToastie")>0)
				mask = LayerMask.GetMask("VertexToastie");
		
		InNeedOfTransition = true;
		RayCount++;
		RayGroupCount++;

		random = new SRandom(69+RayCount);
		Vector3 randomDir = RandomDirection3D(random);
		randomDir.y = Mathf.Abs(randomDir.y);
		
		for (int i = VertexSplitNumber; i < AOBakeMesh.vertexCount; i++){
			VertexSplitNumber = i;
			Color32 currentCol;
			
			if (vertColors.Length>i)
				currentCol = vertColors[i];
			else
				currentCol = new Color32(255,0,255,255);
				
			Vector3 currentPos = vertPositions[i];
			Vector3 rotatedRandomDir = Quaternion.FromToRotation(Vector3.up, vertNormals[i]) * randomDir;
			
			Vector3 point;
			if (GenerationType == GenerationTypes.LocalVariationThickness||GenerationType == GenerationTypes.Both){
				Vector3 tempRotatedRandomDir = -1f*rotatedRandomDir;
			
				point = GOTransform.TransformPoint(currentPos+tempRotatedRandomDir*_RBias);
				RaycastHit hit = new RaycastHit();
				if (Physics.Raycast(new Ray(point,GOTransform.TransformDirection(tempRotatedRandomDir)),out hit, _RTranslucencyMaxDist,mask)){
					thicknessFactors[i]++;
				}
					
				float AO = 1f;
				
				AO = Mathf.Max(0f,Mathf.Min(1f,((float)thicknessFactors[i]/(float)(RayCount))));
				
				if (GenerationType == GenerationTypes.Both)
					currentCol.b = (byte)(System.Math.Min(255,(int)(AO*255f)));
				else
					currentCol.a = (byte)(System.Math.Min(255,(int)(AO*255f)));
			}
			
			if (GenerationType == GenerationTypes.AmbientOcclusion||GenerationType == GenerationTypes.Both){
				point = GOTransform.TransformPoint(currentPos+rotatedRandomDir*_RBias);
				RaycastHit hit = new RaycastHit();
				if (Physics.Raycast(new Ray(point,GOTransform.TransformDirection(rotatedRandomDir)),out hit, _RMaxDist,mask)){
					if (Cast == BakeMode.Update&&hit.collider.transform.parent!=null&&hit.collider.transform.parent.gameObject.GetComponent<VertexToastieIterativeVertexAOBaker>() != null){
						if (!ReactionCalls.Contains(hit.collider.transform.parent.gameObject)){
							hit.collider.transform.parent.gameObject.GetComponent<VertexToastieIterativeVertexAOBaker>().ReactionRebake();
							ReactionCalls.Add(hit.collider.transform.parent.gameObject);
						}
					}
					occlusionFactors[i]++;
				}
					
				float AO = 1f;
				
				AO = Mathf.Max(0f,Mathf.Min(1f,1f-((float)occlusionFactors[i]/(float)(RayCount))));
				
				currentCol.a = (byte)(System.Math.Min(255,(int)(AO*255f)));
			}
			
			
			finalColors[i] = currentCol;
			
			if (i%VerticesPerFrame==0&&i>0&&AOBakeMesh.vertexCount>i+20){
				VertexSplitNumber++;
				RayCount--;
				break;
			}
		}
		if (VertexSplitNumber==AOBakeMesh.vertexCount-1){
			VertexSplitNumber = 0;
			if (RayCount>=RealtimeRays||(!Application.isPlaying&&RayCount>=_REditorDisplayRays)){
				if (!SmoothAOTransition||!Application.isPlaying){
					if (RayGroupCount>=RealtimeRaysPerFrame){
						AOBakeMesh.colors32 = finalColors;
						if (gameObject.GetComponent<MeshFilter>()!=null)
							gameObject.GetComponent<MeshFilter>().sharedMesh = AOBakeMesh;
						if (gameObject.GetComponent<SkinnedMeshRenderer>()!=null)
							gameObject.GetComponent<SkinnedMeshRenderer>().sharedMesh = AOBakeMesh;
					}
				}
			}
			
		}
			if (RayCount>=_RMaxRays){
				Cast = BakeMode.None;
				vertColors = (Color32[])finalColors.Clone();
			}
			else if (RayGroupCount<RealtimeRaysPerFrame){
				bool First = BakeVertexAOFirst;
				BakeVertexAOFirst = false;
				
				BakeVertexAO_Internal();
				if (First){
			
				}
				BakeVertexAOFirst = true;
			}
				
			RayGroupCount = 0;
	}
	public bool BakeVertexAOFirst = true;
	public int SeamVertexCount = 0;
	public void StartFixingSeams(){
		if (Locked)
			return;
		SeamVertexCount = 0;
		CheckSeams = true;
		LastMatter = 2;
		//Debug.Log("StartedFixingSeams");
	}
	public void FixSeams(){
		if (Locked)
			return;
		if (CheckSeams!=true)
		return;
		for (int i = 0; (i < 50)&&(SeamVertexCount<AOBakeMesh.vertexCount); i++){
			//EditorUtility.DisplayProgressBar("Fixing Seams", "Sorry for the wait!", (float)SeamVertexCount/(float)AOBakeMesh.vertexCount);
			List<int> CloseThings = new List<int>();
			CloseThings.Add(SeamVertexCount);
			for (int ii = 0; ii < AOBakeMesh.vertexCount; ii++){
				if (SeamVertexCount==ii)
				break;
				
				if ((Vector3.Distance(vertPositions[SeamVertexCount],vertPositions[ii])<0.0001f)){//&&
					//(Vector3.Distance(vertNormals[SeamVertexCount],vertNormals[ii])<0.1f)){
					CloseThings.Add(ii);
				}
			}
			float r = 0;
			float g = 0;
			float b = 0;
			float a = 0;
			foreach(int ii in CloseThings){
				Color32 currentCol;
				
				if (vertColors.Length>ii)
				currentCol = vertColors[ii];
				else
				currentCol = new Color32(176,0,216,129);
				//Debug.Log((float)currentCol.a);
				r += currentCol.r;
				g += currentCol.g;
				b += currentCol.b;
				a += currentCol.a;
			}
			
			foreach(int ii in CloseThings){
				Color32 currentCol = new Color32((byte)(r/CloseThings.Count),(byte)(g/CloseThings.Count),(byte)(b/CloseThings.Count),(byte)(a/CloseThings.Count));
				finalColors[ii] = currentCol;
			}
			SeamVertexCount++;
		}
		AOBakeMesh.colors32 = finalColors;
		if (SeamVertexCount>=AOBakeMesh.vertexCount)
			CheckSeams = false;
		//EditorUtility.ClearProgressBar();
	}
	public void ClearBake(){
		if (Locked)
			return;
		//for (int i = 0; i < AOBakeMesh.vertexCount; i++){
		//	finalColors[i] = new Color(1f,1f,1f,1f);
		//}
		//AOBakeMesh.colors32 = null;
		if (OriginalMesh != null){
			SetMesh(OriginalMesh);
			if (AOBakeMesh!=null){
				if (Application.isPlaying)
					Destroy(AOBakeMesh);
				else
					DestroyImmediate(AOBakeMesh);
			}
		}
		//EditorUtility.ClearProgressBar();
	}
}