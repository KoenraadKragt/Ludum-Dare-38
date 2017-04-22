using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScoreUI : MonoBehaviour {

    public void Start()
    {
        this.gameObject.GetComponent<Text>().text = "Score: 0";
    }

    public void SetScore(int score)
    {
        this.gameObject.GetComponent<Text>().text = "Score: " + score;
    }
	
}
