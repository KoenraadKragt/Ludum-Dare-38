using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateScrap : MonoBehaviour {

    public GameObject scrapPrefab;

	public void Death()
    {
        Instantiate(scrapPrefab, transform.position, transform.rotation);
    }
}
