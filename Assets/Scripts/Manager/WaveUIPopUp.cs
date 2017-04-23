using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class WaveUIPopUp : MonoBehaviour {

    void Start()
    {
        this.gameObject.GetComponent<Text>().CrossFadeAlpha(0.0f, 1, false);
    }

    public void PopUp(int waveNumber)
    {
        StartCoroutine(FadeWait(2,waveNumber));
    }

    IEnumerator FadeWait(int waitTime, int waveNumber)
    {
        Text childText = this.gameObject.GetComponent<Text>();
        childText.CrossFadeAlpha(1.0f, 1.5f, false);
        childText.text = "Wave: " + waveNumber;
        yield return new WaitForSeconds(waitTime);
        childText.CrossFadeAlpha(0.0f, 1.5f, false);
    }
}
