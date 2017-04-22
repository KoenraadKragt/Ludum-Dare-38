using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnTurret : MonoBehaviour {

    public bool isBuying = false;
    public GameObject turretPrefab;
    private GameObject crosshair;
    private float planetRadius;
    public int cost = 1;

    void Start () {

        crosshair = GameObject.FindGameObjectWithTag("CrossHair");
        planetRadius = GetComponent<CircleCollider2D>().radius * transform.localScale.x;
    }
	
	void Update () {

        //if buying:

        if (isBuying)
        {
            Debug.DrawLine(transform.position, crosshair.transform.position, Color.green);
            if (Input.GetButtonDown("Fire1"))
            {
                placeTurret();
                isBuying = false;
                cost += 1;
            }
        }


        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (ResourceManager.instance.removeScrap(cost))
            {
                isBuying = true;
            }
        }
	}

    private void placeTurret()
    {
        Vector3 direction = ( crosshair.transform.position - transform.position ).normalized;
        GameObject turret = (GameObject)Instantiate(turretPrefab);
        turret.transform.parent = transform;
        turret.transform.position = transform.position + direction * planetRadius;
        turret.transform.LookAt(crosshair.transform.position);
    }
}
