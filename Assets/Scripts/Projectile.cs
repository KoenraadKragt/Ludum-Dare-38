using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile : MonoBehaviour {

    public float speed = 5;
    public float destroyTime = 5;

    void Start()
    {
        Destroy(this.gameObject, destroyTime);

    }
	
	void Update () {
        transform.position += transform.forward * Time.deltaTime * speed;
	}
}
