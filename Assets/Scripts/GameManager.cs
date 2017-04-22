using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour {

    public GameObject projectile;

	void Start () {
        PoolManager.instance.CreatePool(projectile, 1024);
	}
}
