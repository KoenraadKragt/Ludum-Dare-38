using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RocketHoming : MonoBehaviour {

    public float homingScalar = 3;
    private GameObject target = null;
    

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Enemy" && target == null)
        {
            target = collision.gameObject;
        }
    }

    void Update()
    {
        if (target != null)
        {
            Vector3 targetDir = target.transform.position - transform.position;
            transform.forward = Vector3.Lerp(transform.forward, targetDir, Time.deltaTime * homingScalar);
        }
    }
}
