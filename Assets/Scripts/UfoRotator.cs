using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UfoRotator : MonoBehaviour {

    public float startRotRange = 10;
    
	void Start () {
        transform.rotation *= Quaternion.Euler(Random.Range(-startRotRange, startRotRange), Random.Range(-startRotRange, startRotRange), Random.Range(-startRotRange, startRotRange));
	}
}
