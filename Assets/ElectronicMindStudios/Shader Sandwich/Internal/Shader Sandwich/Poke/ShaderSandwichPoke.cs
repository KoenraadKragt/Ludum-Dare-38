using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[AddComponentMenu("Shader Sandwich/Poke/Poke Handler")]
public class ShaderSandwichPoke : MonoBehaviour {
	public float MaxPokeLife = 1f;
	public float MaxDistance = 0.5f;
	private List<ShaderSandwichIndividualPoke> Pokes = new List<ShaderSandwichIndividualPoke>();
	private Dictionary<GameObject,Vector3> ObjectDisplacement = new Dictionary<GameObject,Vector3>();
	public enum ShaderSandwichPokeType{
		ManualOnly,
		RaycastClick,
		RaycastClickAndDrag,
		//ObjectContinous,
		CollisionsStable,
		CollisionsAll,
	}
	public enum ShaderSandwichPokeVelocityType{
		Normal,
		ViewDirection,
	}
	public ShaderSandwichPokeType PokeType = ShaderSandwichPokeType.RaycastClickAndDrag;
	public ShaderSandwichPokeVelocityType NormalType = ShaderSandwichPokeVelocityType.Normal;
	public float StrengthFactor = 1f;
	public float DragCatchupSpeed = 0;
	
	[HideInInspector]public ShaderSandwichIndividualPoke ActivePoke = null;
	public void OnCollisionEnter(Collision col){
		if (PokeType!=ShaderSandwichPokeType.CollisionsAll&&PokeType!=ShaderSandwichPokeType.CollisionsStable)
			return;
		//Debug.Log("Entered");
		BeginPoke(
			col.contacts[0].point,
			col.contacts[0].normal*StrengthFactor,
			MaxDistance,
			MaxPokeLife
		);
		if (PokeType==ShaderSandwichPokeType.CollisionsStable){
			ObjectDisplacement[col.gameObject] = col.contacts[0].point-col.transform.position;
		}
	}
	public void OnCollisionStay(Collision col){
		if (PokeType!=ShaderSandwichPokeType.CollisionsAll&&PokeType!=ShaderSandwichPokeType.CollisionsStable)
			return;
		
		if (ActivePoke==null){
			BeginPoke(
				col.contacts[0].point,
				col.contacts[0].normal*StrengthFactor,
				MaxDistance,
				MaxPokeLife
			);
		}
		Vector3 p = col.contacts[0].point;
		Vector3 n = col.contacts[0].normal*StrengthFactor;
		if (PokeType==ShaderSandwichPokeType.CollisionsStable&&ObjectDisplacement.ContainsKey(col.gameObject)){
			p = col.transform.position+ObjectDisplacement[col.gameObject];
			//Debug.Log(p);
			n = ActivePoke.Velocity;
		}
		ActivePoke.UpdatePoke(
			p,
			n,
			MaxDistance
		);
		if (ActivePoke.Ticked){
			ActivePoke.Ticked = false;
			if (ActivePoke.NormalizedTime<0.6f){
				ActivePoke.MaxPokeLife += Time.deltaTime;
			}else{
				ActivePoke.Time = Mathf.Lerp(ActivePoke.Time,ActivePoke.MaxPokeLife/2f,Mathf.Min(0.05f,col.impulse.magnitude));
				ActivePoke.NormalizedTime = 1f-(ActivePoke.Time/ActivePoke.MaxPokeLife);
				ActivePoke.PreviousTime = Mathf.Lerp(ActivePoke.PreviousTime,ActivePoke.MaxPokeLife/2f,Mathf.Min(0.05f,col.impulse.magnitude));
				ActivePoke.PreviousNormalizedTime = 1f-(ActivePoke.PreviousTime/ActivePoke.MaxPokeLife);
			}
		}
		//Debug.Log(ActivePoke.Direction);
		//Debug.Log((col.contacts[0].point-ActivePoke.PreviousPosition).normalized);
		//Debug.Log(Vector3.Distance(ActivePoke.PreviousVelocity.normalized, col.contacts[0].normal.normalized));
		//Debug.Log(Vector3.Distance(ActivePoke.Direction, (col.contacts[0].point-ActivePoke.PreviousPosition).normalized));
		//Debug.Log(ActivePoke.Direction);
		//Debug.Log((col.contacts[0].point-ActivePoke.PreviousPosition).normalized);
		//Debug.Log(col.impulse.magnitude);
		if ((
		Vector3.Distance(ActivePoke.PreviousVelocity.normalized, col.contacts[0].normal.normalized)>0.6f||
		Vector3.Distance(ActivePoke.Direction, (col.contacts[0].point-ActivePoke.PreviousPosition).normalized)>0.6f)
		&&(PokeType==ShaderSandwichPokeType.CollisionsAll||!ObjectDisplacement.ContainsKey(col.gameObject))){
			BeginPoke(
				col.contacts[0].point,
				col.contacts[0].normal*StrengthFactor,
				MaxDistance,
				MaxPokeLife
			);
			ObjectDisplacement[col.gameObject] = col.contacts[0].point-col.transform.position;
		}
	}
	public void OnCollisionExit(Collision col){
		if (PokeType!=ShaderSandwichPokeType.CollisionsAll&&PokeType!=ShaderSandwichPokeType.CollisionsStable)
			return;
		
		ActivePoke = null;
		
		if (ObjectDisplacement.ContainsKey(col.gameObject)){
			ObjectDisplacement.Remove(col.gameObject);
		}
	}
	public void Start () {
		Material[] MatList = null;
		if (gameObject.GetComponent<MeshRenderer>()!=null)
			MatList = gameObject.GetComponent<MeshRenderer>().materials;
		if (gameObject.GetComponent<SkinnedMeshRenderer>()!=null)
			MatList = gameObject.GetComponent<SkinnedMeshRenderer>().materials;
		
		bool HasPokeShader = false;
		if (MatList!=null){
			foreach(Material material in MatList){
				if (material.GetTag("SSPoke",true,"")!=""){
					HasPokeShader = true;
				}
			}
		}
		if (!HasPokeShader)
			Debug.LogWarning("Shader Sandwich Poke attached to an object that doesn't have any materials that support poking!",this);
	}
	public void Update () {
		if (PokeType==ShaderSandwichPokeType.RaycastClick){
			if (Input.GetMouseButtonDown(0)){
				RaycastHit hitInfo = new RaycastHit();
				//Ray ray = Camera.main.ViewportPointToRay(new Vector3(0.5f,0.5f,0));
				Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
				if (Physics.Raycast(ray,out hitInfo)){
					if (hitInfo.transform.gameObject==gameObject){
						BeginPoke(
							hitInfo.point,
							NormalType==ShaderSandwichPokeVelocityType.Normal?-hitInfo.normal*StrengthFactor:ray.direction*StrengthFactor,
							MaxDistance,
							MaxPokeLife
						);
					}
				}
			}
		}
		if (PokeType==ShaderSandwichPokeType.RaycastClickAndDrag){
			if (Input.GetMouseButtonUp(0)){
				ActivePoke = null;
			}
			if (Input.GetMouseButton(0)){
				RaycastHit hitInfo = new RaycastHit();
				//Ray ray = Camera.main.ViewportPointToRay(new Vector3(0.5f,0.5f,0));
				Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
				if (Physics.Raycast(ray,out hitInfo)){
					if (hitInfo.transform.gameObject==gameObject){
						if (ActivePoke==null)
							BeginPoke(
								hitInfo.point,
								NormalType==ShaderSandwichPokeVelocityType.Normal?-hitInfo.normal*StrengthFactor:ray.direction*StrengthFactor,
								MaxDistance,
								MaxPokeLife
							);
						ActivePoke.UpdatePoke(
							hitInfo.point,
							NormalType==ShaderSandwichPokeVelocityType.Normal?-hitInfo.normal*StrengthFactor:ray.direction*StrengthFactor,
							MaxDistance
						);
					}
				}
			}
		}
		
		int ii = -1;
		for(int i = Pokes.Count-1;i>=0;i--){
			ii++;
			string si = ii.ToString();
			ShaderSandwichIndividualPoke Poke = Pokes[i];
			Poke.Tick();
			
			Material[] MatList = null;
			if (gameObject.GetComponent<MeshRenderer>()!=null)
				MatList = gameObject.GetComponent<MeshRenderer>().materials;
			if (gameObject.GetComponent<SkinnedMeshRenderer>()!=null)
				MatList = gameObject.GetComponent<SkinnedMeshRenderer>().materials;
			
			if (MatList!=null){
				foreach(Material material in MatList){
					material.SetVector("_Poke"+si+"PreviousPosition",Poke.PreviousPosition);
					material.SetVector("_Poke"+si+"Position",Poke.Position);
					material.SetVector("_Poke"+si+"Velocity",Poke.Velocity);
					material.SetVector("_Poke"+si+"PreviousVelocity",Poke.PreviousVelocity);
					material.SetFloat("_Poke"+si+"Time",Poke.Time);
					material.SetFloat("_Poke"+si+"TimeNormalized",Poke.NormalizedTime);
					material.SetFloat("_Poke"+si+"PreviousTime",Poke.PreviousTime);
					material.SetFloat("_Poke"+si+"PreviousTimeNormalized",Poke.PreviousNormalizedTime);
					material.SetFloat("_Poke"+si+"PreviousMaxDistance",Poke.PreviousMaxDistance);
					material.SetFloat("_Poke"+si+"MaxDistance",Poke.MaxDistance);
				}
			}
			if (Poke.Time>=Poke.MaxPokeLife)
				Pokes.Remove(Poke);
		}
	}
	public ShaderSandwichIndividualPoke BeginPoke(Vector3 point, Vector3 velocity){
		return BeginPoke(point, velocity, MaxDistance, MaxPokeLife, true);
	}
	public ShaderSandwichIndividualPoke BeginPoke(Vector3 point, Vector3 velocity, float maxDistance, float time){
		return BeginPoke(point, velocity, maxDistance, time, true);
	}
	public ShaderSandwichIndividualPoke BeginPoke(Vector3 point, Vector3 velocity, float maxDistance, float time,bool setActivePoke){
		ShaderSandwichIndividualPoke Poke = new ShaderSandwichIndividualPoke();
		
		Poke.PreviousPosition = point;
		Poke.PreviousVelocity = velocity;
		Poke.PreviousTime = 0f;
		Poke.PreviousNormalizedTime = 1f;
		Poke.PreviousMaxDistance = maxDistance;
		
		Poke.Position = point;
		Poke.Velocity = velocity;
		Poke.Time = 0f;
		Poke.NormalizedTime = 1f;
		Poke.MaxDistance = maxDistance;
		
		Poke.MaxPokeLife = time;
		
		Poke.Drag = PokeType!=ShaderSandwichPokeType.RaycastClick;
		Poke.DragCatchupSpeed = DragCatchupSpeed;
		
		Pokes.Add(Poke);
		
		if (setActivePoke)
			ActivePoke = Poke;
		
		return Poke;
	}
}

