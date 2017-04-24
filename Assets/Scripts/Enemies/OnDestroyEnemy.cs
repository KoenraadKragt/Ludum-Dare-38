using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnDestroyEnemy : MonoBehaviour {

    void OnDestroy()
    {
        if (GameObject.FindGameObjectWithTag("Manager"))
        {
            GameObject.FindGameObjectWithTag("Manager").SendMessage("ReduceEnemyCount", null, SendMessageOptions.DontRequireReceiver);
        }
    }
}
