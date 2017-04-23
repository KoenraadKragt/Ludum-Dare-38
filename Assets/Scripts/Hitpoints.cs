using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hitpoints : MonoBehaviour {

    public int hitpoints;

    public void SetHitpoints(int hitpoints)
    {
        this.hitpoints = hitpoints;
    }

	public void TakeDamage(int damage)
    {
        hitpoints -= damage;
        if (hitpoints <= 0)
        {
            this.gameObject.SendMessage("Death", SendMessageOptions.DontRequireReceiver);
            Destroy(this.gameObject);
        }
    }
}
