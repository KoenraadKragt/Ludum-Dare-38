using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoTurretAim : MonoBehaviour {

    [HideInInspector]
    public bool canShoot = true;

    private GameObject target;

    private GameObject crosshair;
    private Transform turretAnchor;

    void Start()
    {
        turretAnchor = transform.parent;

    }

    void Update()
    {
        Quaternion targetRot;

        GameObject[] temp = GameObject.FindGameObjectsWithTag("Enemy");
        
        if (target != null)
        {
            targetRot = Quaternion.LookRotation(target.transform.position);
            transform.rotation = targetRot;
        }

    }

    public void SetTarget(GameObject target)
    {
        this.target = target;
    }

    public void ClearTarget()
    {
        this.target = null;
    }

    public bool HasTarget()
    {
        if(target != null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
