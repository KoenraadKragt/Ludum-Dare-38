using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour {

    public GameObject projectile;
    public GameObject scrap;

	void Start () {
        PoolManager.instance.CreatePool(projectile, 1024);
        PoolManager.instance.CreatePool(scrap, 1024);
    }
}
