using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyByTime : MonoBehaviour {

    public float LifeTime = 1;

	void Start () {
        Destroy(gameObject, LifeTime);
	}
}
