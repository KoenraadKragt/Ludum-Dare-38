using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Apocalypse : MonoBehaviour {

    public float endTime = 3;

	public void Death()
    {
        foreach(Renderer rend in GetComponentsInChildren<Renderer>())
        {
            rend.enabled = false;
            // TODO: Explosion
            
        }
        GetComponent<CircleCollider2D>().enabled = false;
        StartCoroutine(EndGame());
    }

    IEnumerator EndGame()
    {
        yield return new WaitForSecondsRealtime(endTime);
        // TODO: Back To Menu
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    } 
}
