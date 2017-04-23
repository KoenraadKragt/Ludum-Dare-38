using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomRotator : MonoBehaviour {

    public float rotationRange = 30;
    private Vector3 rotationAngles;

	void Start () {
        rotationAngles.x = Random.Range(-rotationRange, rotationRange);
        rotationAngles.y = Random.Range(-rotationRange, rotationRange);
        rotationAngles.z = Random.Range(-rotationRange, rotationRange);
    }
	
	// Update is called once per frame
	void Update () {
        transform.rotation = Quaternion.Euler( transform.rotation.eulerAngles + rotationAngles * Time.deltaTime );
	}
}
