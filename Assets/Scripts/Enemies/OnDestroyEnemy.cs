using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnDestroyEnemy : MonoBehaviour {

    void OnDestroy()
    {
        GameObject.FindGameObjectWithTag("Manager").SendMessage("ReduceEnemyCount", null, SendMessageOptions.DontRequireReceiver);
    }
}
