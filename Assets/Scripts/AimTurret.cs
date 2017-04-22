using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AimTurret : MonoBehaviour {

    public float maxAngle = 90;
    private GameObject crosshair;
    private Transform turretAnchor;

    void Start()
    {
        crosshair = GameObject.FindGameObjectWithTag("CrossHair");
        turretAnchor = transform.parent;

    }

	void Update () {
        Quaternion targetRot;

        targetRot = Quaternion.LookRotation(crosshair.transform.position);
        if (Vector3.Angle(crosshair.transform.position - transform.position, turretAnchor.forward) < maxAngle)
        {
            transform.rotation = targetRot;
        }
            
	}
}
