using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnDestroyEnemy : MonoBehaviour {

    void OnDestroy()
    {
        GameObject.Find("WaveManager").SendMessage("ReduceEnemyCount", null, SendMessageOptions.RequireReceiver);
    }
}
