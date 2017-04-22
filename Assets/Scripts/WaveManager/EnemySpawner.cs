using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

    public EnemyStats[] easyEnemy, hardEnemy;
    public GameObject[] spawns;
    int difficulty;

	public void SpawnWave(int difficultyValue)
    {
        difficulty = difficultyValue;
        StartCoroutine(SpawnCooldown(2));
    }

    public void SpawnSelect()
    {
        EnemyStats enemy;
        if (difficulty > 10)
        {
            if (Random.Range(0, 10) < 3)
            {
                enemy = easyEnemy[Random.Range(0, easyEnemy.Length)];
            }
            else
            {
                enemy = hardEnemy[Random.Range(0, hardEnemy.Length)];
            }
        }
        else
        {
            enemy = easyEnemy[Random.Range(0, easyEnemy.Length)];
        }

        Spawn(enemy);

        if (difficulty > 0)
        {
            StartCoroutine(SpawnCooldown(2));
        }

        if (difficulty <= 0)
        {
            this.gameObject.GetComponent<WaveManager>().SpawnDone();
        }
    }
	
    public void Spawn(EnemyStats enemy)
    {
        GameObject spawnLocation = spawns[Random.Range(0, spawns.Length)];
        GameObject newEnemy = Instantiate(enemy.Enemy, spawnLocation.transform.position,this.transform.rotation);
        difficulty -= enemy.difficultyValue;
        this.gameObject.GetComponent<WaveManager>().IncreaseEnemyCount();
    }
  
    IEnumerator SpawnCooldown(int waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        SpawnSelect();
    }
}
