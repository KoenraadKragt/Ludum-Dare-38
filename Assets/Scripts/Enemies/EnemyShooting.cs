using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyShooting : MonoBehaviour {

    public GameObject projectile;
    private float nextFire = 2.5F;
    private float myTime = 0.0F;
    public float fireDelta = 2.5F;


    void Update()
    {
        myTime = myTime + Time.deltaTime;

        if (myTime > nextFire)
        {
            nextFire = myTime + fireDelta;
            GameObject newEnemy = Instantiate(projectile, this.gameObject.transform.position, this.transform.rotation);
            GameObject.FindGameObjectWithTag("Manager").GetComponent<WaveManager>().IncreaseEnemyCount();
        }
    }
}
