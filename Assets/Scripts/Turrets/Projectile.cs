using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile : PoolObject {

    public float speed = 5;
    public float lifeTime = 5;

    void Start()
    {
        StartCoroutine(DestroyByTime());

    }
	
	void Update () {
        transform.position += transform.forward * Time.deltaTime * speed;
	}

    IEnumerator DestroyByTime()
    {
        yield return new WaitForSecondsRealtime(lifeTime);
        Destroy();

    }
}
