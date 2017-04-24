using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartGameUI : MonoBehaviour {

    public GameObject shopUI;
    public GameObject startGameUI;

	public void StartGame()
    {
        startGameUI.SetActive(false);
        shopUI.SetActive(true);
    }
}
