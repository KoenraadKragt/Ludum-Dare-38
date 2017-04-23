using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetRotation : MonoBehaviour {

    private GameObject crosshair;

	// Use this for initialization
	void Start () {
        crosshair = GameObject.FindGameObjectWithTag("CrossHair");
        Vector3 direction = crosshair.transform.position - transform.position;
        //Quaternion targetRotation = Quaternion.LookRotation();
        //this.gameObject.transform.rotation = targetRotation;
        transform.up = direction.normalized;
	}
}
