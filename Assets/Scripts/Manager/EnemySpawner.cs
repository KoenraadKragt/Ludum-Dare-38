using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

    public EnemyStats[] enemyList;
    public EnemyStats[] currentEnemyList;
    public float spawnCooldown;
    int difficulty;
    int wave;

	public void SpawnWave(int difficultyValue, int wave)
    {
        this.wave = wave;
        SetCurrentEnemies();
        difficulty = difficultyValue;
        StartCoroutine(SpawnCooldown(2));
    }

    public void SetCurrentEnemies()
    {
        EnemyStats[] temp = new EnemyStats[0];
        for(int i = 0; i < enemyList.Length; i++)
        {
            if(enemyList[i].minimumWave <= wave && enemyList[i].maximumWave >= wave)
            {
                EnemyStats[] temp2 = new EnemyStats[temp.Length + 1];
                temp2[temp2.Length-1] = enemyList[i];
                for(int j = 0; j < temp.Length; j++)
                {
                    temp2[j] = temp[j];
                }
                temp = temp2;
            }
        }
        currentEnemyList = temp;
    }

    public void SpawnSelect()
    {
        EnemyStats enemy;


        enemy = currentEnemyList[Random.Range(0, currentEnemyList.Length)];

        Spawn(enemy);

        if (difficulty > 0)
        {
            StartCoroutine(SpawnCooldown(spawnCooldown));
        }

        if (difficulty <= 0)
        {
            this.gameObject.GetComponent<WaveManager>().SpawnDone();
        }
    }
	
    public void Spawn(EnemyStats enemy)
    {
        int spawnDirection = Random.Range(0, 4);
        Vector3 spawnLocation = new Vector3(10, 0, 0);
        switch (spawnDirection)
        {
            case 0:
                spawnLocation = new Vector3(0.0f, Random.Range(0.0f, 1.0f), -Camera.main.transform.position.z);
                break;
            case 1:
                spawnLocation = new Vector3(1.0f, Random.Range(0.0f, 1.0f), -Camera.main.transform.position.z);
                break;
            case 2:
                spawnLocation = new Vector3(Random.Range(0.0f, 1.0f), 0.0f, -Camera.main.transform.position.z);
                break;
            case 3:
                spawnLocation = new Vector3(Random.Range(0.0f, 1.0f), 1.0f, -Camera.main.transform.position.z);
                break;
        }
        GameObject newEnemy = Instantiate(enemy.Enemy, Camera.main.ViewportToWorldPoint(spawnLocation),this.transform.rotation);
        difficulty -= enemy.difficultyValue;
        this.gameObject.GetComponent<WaveManager>().IncreaseEnemyCount();
    }
  
    IEnumerator SpawnCooldown(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        SpawnSelect();
    }
}
