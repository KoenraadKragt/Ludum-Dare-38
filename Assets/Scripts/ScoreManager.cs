using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScoreManager : MonoBehaviour {

    public int score;
	
    public void IncreaseScore(int score)
    {
        this.score += score;
    }

    public void DecreaseScore(int score)
    {
        this.score -= score;
        if (score < 0)
        {
            score = 0;
        }
    }

    public void SetScore(int score)
    {
        this.score = score;
    }

    public int GetScore()
    {
        return score;
    }
}
