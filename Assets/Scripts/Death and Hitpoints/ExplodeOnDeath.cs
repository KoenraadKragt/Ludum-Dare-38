using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExplodeOnDeath : MonoBehaviour {

    public GameObject explosion;

	public void Death()
    {
        GameObject.Instantiate(explosion, transform.position, transform.rotation);
    }
}
