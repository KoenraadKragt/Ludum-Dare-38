using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Crosshair : MonoBehaviour {

    [Range(-10,10)]
    public float depth;

	void Update () {

        Vector3 v3 = Input.mousePosition;
        v3.z = depth;
        v3 = Camera.main.ScreenToWorldPoint(v3);
        transform.position = v3;
	}
}
