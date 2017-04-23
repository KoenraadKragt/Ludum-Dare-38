using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateLight : MonoBehaviour {
    
	void Update () {
        transform.RotateAround(Vector3.zero, Vector3.up, Time.deltaTime * 30);
	}
}
