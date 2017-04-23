using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoTurretDetector : MonoBehaviour {

    private GameObject target = null;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.gameObject.tag == "Enemy")
        {
            target = collision.gameObject;
            BroadcastMessage("SetTarget", target);
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Enemy")
        {
            target = collision.gameObject;
            BroadcastMessage("ClearTarget", target);
        }
    }    
}
