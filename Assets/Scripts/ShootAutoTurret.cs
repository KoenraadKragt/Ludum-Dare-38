using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootAutoTurret : MonoBehaviour {

    public GameObject projectile;
    public float fireDelta = 0.5F;
    public float spawnOffset;

    private float nextFire = 0.5F;
    private GameObject newProjectile;
    private float myTime = 0.0F;

    private AutoTurretAim2000 aim;

    void Start()
    {
        aim = gameObject.GetComponent<AutoTurretAim2000>();
    }

    void Update()
    {
        myTime = myTime + Time.deltaTime;

        if (myTime > nextFire && aim.HasTarget())
        {
            nextFire = myTime + fireDelta;
            PoolManager.instance.ReuseObject(projectile, transform.position + transform.forward * spawnOffset, transform.rotation);

            // create code here that animates the newProjectile

            nextFire = nextFire - myTime;
            myTime = 0.0F;
        }
    }
}
