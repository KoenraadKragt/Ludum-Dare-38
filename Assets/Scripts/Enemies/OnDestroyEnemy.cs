using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnDestroyEnemy : MonoBehaviour {

    public int scoreValue;

    void OnDestroy()
    {
        if (GameObject.FindGameObjectWithTag("Manager"))
        {
            GameObject.FindGameObjectWithTag("Manager").SendMessage("ReduceEnemyCount", null, SendMessageOptions.DontRequireReceiver);
            GameObject.FindGameObjectWithTag("Manager").GetComponent<ScoreManager>().IncreaseScore(scoreValue * GameObject.FindGameObjectWithTag("Manager").GetComponent<WaveManager>().GetCurrentWave());
        }
    }
}
