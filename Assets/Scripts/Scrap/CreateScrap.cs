using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateScrap : MonoBehaviour {

    public GameObject scrapPrefab;
    private bool scrappable = true;

    public void ScrapCollision ()
    {
        scrappable = false;
    }

    public void Death()
    {
        if (scrappable)
        {
            PoolManager.instance.ReuseObject(scrapPrefab, transform.position, transform.rotation);
        }
    }
}
