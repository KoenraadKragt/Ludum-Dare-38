using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum Sounds
{
    EnemyDeath,
    TurretShoot,
    TurretPlace,
    PlanetDamage,
    ScrapSpending
}

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
    
    public AudioClip[] clips;
    private List<AudioSource> sources = new List<AudioSource>();
    private AudioSource bgMusic;

    void Start()
    {
        bgMusic = GetComponent<AudioSource>();
        for (int i = 0; i < clips.Length; i++)
        {
            AudioSource src = gameObject.AddComponent<AudioSource>() as AudioSource;
            src.clip = clips[i];
            src.playOnAwake = false;
            sources.Add(src);
        }

        sources[(int)Sounds.TurretShoot].volume = 0.3f;
    }
    
    public void playSound(Sounds sound)
    {
        sources[(int)sound].Stop();
        sources[(int)sound].Play();
    }

    public void StartGame()
    {
        bgMusic.Stop();
        bgMusic.Play();
    }
}
