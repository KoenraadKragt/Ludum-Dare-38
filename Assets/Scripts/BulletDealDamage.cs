using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletDealDamage : MonoBehaviour {

    public int damage;

	void OnCollisionEnter2D(Collision2D other)
    {
        other.gameObject.SendMessage("TakeDamage",damage);
    }
}
