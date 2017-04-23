using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathrattleEnemy : MonoBehaviour {

    public GameObject spawnling;
    public int amount;

    public void Death()
    {
        for(int i = 0; i < amount; i++)
        {
            GameObject newEnemy = Instantiate(spawnling, this.gameObject.transform.position, this.transform.rotation);
            GameObject.FindGameObjectWithTag("Manager").GetComponent<WaveManager>().IncreaseEnemyCount();
        }
    }
}
