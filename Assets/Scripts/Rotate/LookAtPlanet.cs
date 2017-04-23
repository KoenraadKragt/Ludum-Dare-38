using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtPlanet : MonoBehaviour {
    
	void Start () {
        transform.up = GameObject.FindGameObjectWithTag("Planet").transform.position - transform.position;
	}
}
