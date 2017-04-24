using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraZoom : MonoBehaviour {

    #region SINGLETON
    static CameraZoom _instance;

    public static CameraZoom instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<CameraZoom>();
            }
            return _instance;
        }
    }
    #endregion

    public float minZoom = 5;
    public float maxZoom = 16;
    public float incrementPerWave = 0.2f;
    public float zoomRate = 1;

    private float targetSize = 5;

    public void waveBasedZoom(int waveNum)
    {
        targetSize = Camera.main.orthographicSize + (waveNum * incrementPerWave);


        targetSize = Mathf.Min(maxZoom, Mathf.Max(minZoom, targetSize));

        //Camera.main.orthographicSize = targetSize;
    }

    void Update()
    {
        Camera.main.orthographicSize = Mathf.Lerp(Camera.main.orthographicSize, targetSize, Time.deltaTime * zoomRate);
    }
}
