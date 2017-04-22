using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResetRotation : MonoBehaviour {

	// Use this for initialization
	void Start () {
        this.gameObject.transform.rotation = new Quaternion(0,0,0,0);
	}
}
