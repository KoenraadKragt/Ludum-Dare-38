using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatePlanet : MonoBehaviour {

    public float rotateSpeed = 30;

	void Update () {
        transform.Rotate(0, 0, rotateSpeed * Time.deltaTime);
	}
}
