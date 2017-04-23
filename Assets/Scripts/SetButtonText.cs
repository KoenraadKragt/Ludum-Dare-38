using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SetButtonText : MonoBehaviour {

    public Turrets turretType = Turrets.BasicTurret;

    private Text textComponent;
    private SpawnTurret buyScript;


	// Use this for initialization
	void Start () {
        textComponent = GetComponent<Text>();
        buyScript = GameObject.FindGameObjectWithTag("Planet").GetComponent<SpawnTurret>();
	}
	
	// Update is called once per frame
	void Update () {
        textComponent.text = buyScript.shopEntries[(int)turretType].cost + "$: " + turretType.ToString();
	}
}
