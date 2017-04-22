using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class WaveManager : MonoBehaviour {

    public bool isSpawning = false;
    int enemyCount = 0;
    int difficulty = 0;
    int wave = 0;
	
	// Update is called once per frame
	void Update () {
	    if(!isSpawning && enemyCount <= 0)
        {
            wave += 1;
            difficulty += Mathf.FloorToInt((wave + 1)/2);
            isSpawning = true;
            StartCoroutine(NextWave(5));
        }
	}

    public void SpawnDone()
    {
        isSpawning = false;
    }

    public int GetCurrentWave()
    {
        return wave;
    }

    public void IncreaseEnemyCount()
    {
        enemyCount += 1;
    }

    public void ReduceEnemyCount()
    {
        enemyCount -= 1;
    }

    IEnumerator NextWave(int waitTime)
    {
        if (GameObject.FindGameObjectWithTag("WaveUI"))
        {
            GameObject.FindGameObjectWithTag("WaveUI").GetComponent<WaveUIPopUp>().PopUp(wave);
        }
        yield return new WaitForSeconds(waitTime);
        this.gameObject.GetComponent<EnemySpawner>().SpawnWave(difficulty);
    }
}
