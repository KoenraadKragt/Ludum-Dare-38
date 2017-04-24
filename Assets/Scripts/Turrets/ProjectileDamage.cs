using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileDamage : PoolObject {

    public int damage;
    public GameObject explosion;

	void OnCollisionEnter2D(Collision2D other)
    {
        if(other.gameObject.tag == "Enemy")
        {
            other.gameObject.SendMessage("TakeDamage", damage);
            if(explosion != null)
            {
                GameObject.Instantiate(explosion, transform.position, transform.rotation);
            }
            Destroy();
        }
    }
}
