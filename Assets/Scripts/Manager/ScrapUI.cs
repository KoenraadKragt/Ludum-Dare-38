using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScrapUI : MonoBehaviour {

    public void Start()
    {
        this.gameObject.GetComponent<Text>().text = "$: 0000";
    }

	void Update()
	{
		this.gameObject.GetComponent<Text>().text = "$: " + ResourceManager.instance.GetScrap().ToString("D4");
	}

}
