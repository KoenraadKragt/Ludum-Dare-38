using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class ShaderSandwichIndividualPoke{
	public float Time;
	public float NormalizedTime;
	public float MaxPokeLife;
	public float MaxDistance;
	public Vector3 Position;
	public Vector3 Velocity;
	public Vector3 Direction;
	
	public float PreviousTime;
	public float PreviousNormalizedTime;
	public float PreviousMaxDistance;
	public Vector3 PreviousPosition;
	public Vector3 PreviousVelocity;
	
	public bool Drag;
	public float DragCatchupSpeed;
	public bool Ticked = false;
	
	
	public void UpdatePoke(Vector3 point, Vector3 velocity, float maxDistance, float time){
		if (Direction==new Vector3(0f,0f,0f))
			Direction = (point-Position).normalized;
		Position = point;
		Velocity = velocity;
		MaxDistance = maxDistance;
		Time = time;
		NormalizedTime = 1f-(time/MaxPokeLife);
	}
	public void UpdatePoke(Vector3 point, Vector3 velocity, float maxDistance){
		if (Direction==new Vector3(0f,0f,0f))
			Direction = (point-Position).normalized;
		Position = point;
		Velocity = velocity;
		MaxDistance = maxDistance;
	}
	public void Tick(){
		Ticked = true;
		Time+=UnityEngine.Time.deltaTime;
		NormalizedTime = 1f-(Time/MaxPokeLife);
		
		if (!Drag){
			PreviousTime=Time;
			PreviousNormalizedTime = NormalizedTime;
			
			PreviousVelocity = Velocity;
			PreviousPosition = Position;
			PreviousMaxDistance = MaxDistance;
		}
		else{
			PreviousTime=Mathf.Min(MaxPokeLife,PreviousTime+UnityEngine.Time.deltaTime);
			PreviousNormalizedTime = 1f-(PreviousTime/MaxPokeLife);
			
			PreviousVelocity = Vector3.Lerp(PreviousVelocity,Velocity,DragCatchupSpeed);
			PreviousPosition = Vector3.Lerp(PreviousPosition,Position,DragCatchupSpeed);
			PreviousMaxDistance = Mathf.Lerp(PreviousMaxDistance,MaxDistance,DragCatchupSpeed);
			PreviousTime = Mathf.Lerp(PreviousTime,Time,DragCatchupSpeed);
		}
	}
}