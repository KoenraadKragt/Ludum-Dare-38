using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AimTurret : MonoBehaviour {

    GameObject crosshair;

    void Start()
    {
        crosshair = GameObject.FindGameObjectWithTag("CrossHair");

    }

	void Update () {
        transform.LookAt(crosshair.transform.position);
	}
}
