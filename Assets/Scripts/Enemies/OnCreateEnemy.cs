using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnCreateEnemy : MonoBehaviour {

    public float speed;

	// Use this for initialization
	void Update () {
        float step = speed * Time.deltaTime;
        transform.position = Vector3.MoveTowards(transform.position, Camera.main.ViewportToWorldPoint(new Vector3(0.5f, 0.5f,-Camera.main.transform.position.z)),step);
	}
}
