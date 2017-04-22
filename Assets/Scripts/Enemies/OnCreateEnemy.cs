using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnCreateEnemy : MonoBehaviour {

    public float speed;

	// Use this for initialization
	void Update () {
        float step = speed * Time.deltaTime;
        transform.position = Vector3.MoveTowards(transform.position, GameObject.Find("PlanetBase_01").transform.position,step);
	}
}
