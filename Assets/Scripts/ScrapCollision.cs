using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrapCollision  : PoolObject
{

    public int damage = 999;

    void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.tag == "Enemy")
        {
            other.gameObject.SendMessage("ScrapCollision", SendMessageOptions.DontRequireReceiver);
            other.gameObject.SendMessage("TakeDamage", damage, SendMessageOptions.DontRequireReceiver);
            Destroy();
        }
    }
}
