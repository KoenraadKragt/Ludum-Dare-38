using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RocketSpinning : MonoBehaviour {

    public float rotationSpeed;

	void Update () {
        transform.RotateAround(transform.forward, rotationSpeed * Time.deltaTime);
	}
}
