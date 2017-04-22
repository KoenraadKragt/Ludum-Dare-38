using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Kamikaze : MonoBehaviour {

    public int damage;

    void OnCollisionEnter2D(Collision2D other)
    {
        if (other.gameObject.tag == "Planet")
        {
            other.gameObject.SendMessage("TakeDamage", damage);
            this.SendMessage("TakeDamage", 999);
        }
    }
}
