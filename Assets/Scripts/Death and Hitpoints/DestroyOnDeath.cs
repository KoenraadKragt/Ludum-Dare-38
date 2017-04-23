using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroyOnDeath : MonoBehaviour {

    public float deathTime = 0.2f;


    private bool dying = false;
    private float timer = 0;
    private float lerpTimer;
    private Material mat;

	public void Death()
    {
        GetComponent<Collider2D>().enabled = false;
        dying = true;
        AudioManager.instance.playSound(Sounds.EnemyDeath);
        //StartCoroutine(Destruction());
        Destroy(this.gameObject, deathTime);
    }

    void Start()
    {
        mat = GetComponentInChildren<Renderer>().material;
    }

    void Update()
    {
        if (dying && mat != null)
        {
            timer += Time.deltaTime;
            lerpTimer = (timer / deathTime);
            mat.SetFloat("_SSSVertex_aMix_Amount", lerpTimer);
        }
    }
    
}
