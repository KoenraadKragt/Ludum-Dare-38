using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoTurretAim : MonoBehaviour {

    [HideInInspector]
    public bool canShoot = true;

    public GameObject[] target;

    private GameObject crosshair;
    private Transform turretAnchor;

    void Start()
    {
        turretAnchor = transform.parent;

    }

    void Update()
    {
        Quaternion targetRot;
        
        if (target.Length > 0)
        {
            if (target[0] == null)
            {
                RemoveNull();
            }
            else
            {
                targetRot = Quaternion.LookRotation(target[0].transform.position);
                transform.rotation = targetRot;
            }
        }
    }

    public void SetTarget(GameObject target)
    {
        GameObject[] temp = new GameObject[this.target.Length + 1];
        for (int i = 0; i < this.target.Length; i++)
        {
            temp[i] = this.target[i];
        }
        this.target = temp;
        this.target[this.target.Length - 1] = target;
    }

    public void ClearTarget(GameObject target)
    {
        bool foundTarget = false;
        GameObject[] temp = new GameObject[this.target.Length - 1];
        for (int i = 0; i < this.target.Length; i++)
        {
            if (foundTarget)
            {
                temp[i] = this.target[i + 1];
            } else if (this.target[i] == target) {
                foundTarget = true;
            } else {
                temp[i] = this.target[i];
            }
        }
        this.target = temp;
    }

    public void RemoveNull()
    {
        GameObject[] temp = new GameObject[this.target.Length - 1];
        for(int i = 0; i < temp.Length; i++)
        {
            temp[i] = target[i + 1];
        }
    }

    public bool HasTarget()
    {
        if(target.Length>0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
