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

    public AudioClip enemyDeath;
    public AudioClip shoot;

    private AudioSource audio;

    void Start()
    {
        audio = GetComponent<AudioSource>();
    }

    public void PlayEnemyDeath()
    {
        playSound(enemyDeath);
    }
    public void PlayShoot()
    {
        playSound(shoot);
    }

    private void playSound(AudioClip clip)
    {
        audio.Stop();
        audio.clip = clip;
        audio.Play();
    }
}
