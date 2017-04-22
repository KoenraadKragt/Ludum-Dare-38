using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

    public EnemyStats[] easyEnemy, hardEnemy;
    public float spawnCooldown;
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
