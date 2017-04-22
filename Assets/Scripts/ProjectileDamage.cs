using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileDamage : PoolObject {

    public int damage;

	void OnCollisionEnter2D(Collision2D other)
    {
        if(other.gameObject.tag == "Enemy")
        {
            other.gameObject.SendMessage("TakeDamage", damage);
            Destroy();
        }
    }
}
