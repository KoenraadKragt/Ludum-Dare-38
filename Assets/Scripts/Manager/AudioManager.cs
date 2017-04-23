using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour {

    #region SINGLETON
    static AudioManager _instance;

    public static AudioManager instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<AudioManager>();
            }
            return _instance;
        }
    }
    #endregion

    public GameObject enemyObject;
    private AudioSource enemySource;

    public GameObject shootObject;
    private AudioSource shootSource;

    void Start()
    {
        enemySource = enemyObject.GetComponent<AudioSource>();
        shootSource = shootObject.GetComponent<AudioSource>();
    }

    public void PlayEnemyDeath()
    {
        playSound(enemySource);
    }
    public void PlayShoot()
    {
        playSound(shootSource);
    }

    private void playSound(AudioSource source)
    {
        source.Stop();
        source.Play();
    }
}
