﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour {

    public GameObject projectile;
    public GameObject rapidProjectile;
    public GameObject rocket;
    public GameObject scrap;

    public GameObject pixel;
    private bool pixelMode = false;
    public GameObject credits;
    private bool creditsMode = false;

	void Start () {
        PoolManager.instance.CreatePool(projectile, 1024);
        PoolManager.instance.CreatePool(rapidProjectile, 1024);
        PoolManager.instance.CreatePool(rocket, 128);
        PoolManager.instance.CreatePool(scrap, 1024);
    }

    public void FullScreen()
    {
        Screen.fullScreen = !Screen.fullScreen;
    }

    public void PixelMode()
    {
        pixelMode = !pixelMode;
        pixel.SetActive(pixelMode);
    }

    public void ToggleCredits()
    {
        creditsMode = !creditsMode;
        credits.SetActive(creditsMode);
    }
}
