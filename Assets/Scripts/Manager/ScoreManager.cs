using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreManager : MonoBehaviour {

    protected int score;
    public GameObject scoreUI;
	
    public void IncreaseScore(int score)
    {
        this.score += score;
        scoreUI.SendMessage("SetScore", this.score);
/*        if (GameObject.FindGameObjectWithTag("ScoreUI"))
        {
            GameObject.FindGameObjectWithTag("ScoreUI").SendMessage("SetScore", this.score);
            scoreUI.SendMessage("SetScore",this.score);
        }*/
    }

    public void DecreaseScore(int score)
    {
        this.score -= score;
        if (score < 0)
        {
            score = 0;
        }

        if (GameObject.FindGameObjectWithTag("ScoreUI"))
        {
            GameObject.FindGameObjectWithTag("ScoreUI").SendMessage("SetScore", score);
        }
    }

    public void SetScore(int score)
    {
        this.score = score;
        if (GameObject.FindGameObjectWithTag("ScoreUI"))
        {
            GameObject.FindGameObjectWithTag("ScoreUI").SendMessage("SetScore", score);
        }

    }

    public int GetScore()
    {
        return score;
    }
}
