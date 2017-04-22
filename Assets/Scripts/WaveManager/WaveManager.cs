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
            UpdateStats();
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
        UpdateStats();
    }

    public void ReduceEnemyCount()
    {
        enemyCount -= 1;
        UpdateStats();
    }

    public void UpdateStats()
    {
        if(enemyCount > 1 || enemyCount == 0)
        {
            GameObject.Find("WaveInfo").GetComponent<Text>().text = "Wave " + wave + " - " + enemyCount + " Enemies remaining";
        }
        else
        {
            GameObject.Find("WaveInfo").GetComponent<Text>().text = "Wave " + wave + " - " + enemyCount + " Enemy remaining";
        }
    }

    IEnumerator NextWave(int waitTime)
    {
        GameObject.Find("WavePopUpUI").GetComponent<WaveUIPopUp>().PopUp(wave);
        yield return new WaitForSeconds(waitTime);
        //GameObject.Find("Spawners").SendMessage("SpawnWave", difficulty,SendMessageOptions.RequireReceiver);
        this.gameObject.GetComponent<EnemySpawner>().SpawnWave(difficulty);
    }
}
