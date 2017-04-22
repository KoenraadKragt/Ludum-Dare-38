using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResourceManager : MonoBehaviour {

    #region SINGLETON
    static ResourceManager _instance;

    public static ResourceManager instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<ResourceManager>();
            }
            return _instance;
        }
    }
    #endregion
    
    public GameObject scrapPrefab;
    public List<ScrapResource> scrapObjects;


    private int scrap = 0;
    
    public int GetScrap()
    {
        return scrap;
    }

    public void addScrap(int amount)
    {
        scrap += amount;
    }

    public bool removeScrap(int amount)
    {
        if ( scrap < amount )
        {
            return false;
        }

        scrap -= amount;

        if (scrapObjects.Count >= amount)
        {
            for (int i = amount - 1; i >= 0 ; i--)
            {
                scrapObjects[i].Expend();
                scrapObjects.RemoveAt(i);
            }

        }
        return true;
    }

}
