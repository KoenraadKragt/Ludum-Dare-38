using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoTurretAim2000 : MonoBehaviour {

    public List<GameObject> targets = new List<GameObject>();

    void Update()
    {
        if (targets.Count>0)
        {
            while (targets[0] == null)
            {
                targets.RemoveAt(0);
            }
        }

        aimAtTarget();
    }

    public void SetTarget(GameObject target)
    {
        targets.Add(target);
    }


    public void ClearTarget(GameObject target)
    {
        targets.Remove(target);
    }

    private void aimAtTarget()
    {
        Quaternion targetRot;

        if (targets.Count > 0)
        {
            targetRot = Quaternion.LookRotation(targets[0].transform.position);
            transform.rotation = targetRot;
        }
    }

    //Check for ShootAutoTurret
    public bool HasTarget()
    {
        return (targets.Count > 0);
    }
}
