using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlanetGenerator : MonoBehaviour 
{
    public bool generatePlanetOnStart = true;

    public Renderer planetMaterial;

    public float vertexStrengthMin = 5;
    public float vertexStrengthMax = 25;

    public float vertexIntensetyMin = .39f;
    public float vertexIntensetyMax = .42f;

    public float vertexMinHeightMin = 0f;
    public float vertexMinHeightMax = .5f;

    public float vertexMaxHeightMin = .5f;
    public float vertexMaxHeightMax = 1f;

    public float vertexScaleMin = 0f;
    public float vertexScaleMax = 10f;

    public float vertexSeed;

    void Start()
    {
        planetMaterial = GetComponent<Renderer>();
        if(generatePlanetOnStart)
            GeneratePlanet();
    }

    public void GeneratePlanet()
    {
        if(planetMaterial == null)
            planetMaterial = GetComponent<Renderer>();

        float vertexStrength = Random.Range(vertexStrengthMin, vertexStrengthMax);
        float vertexIntensety = Random.Range(.3f, .45f);
        float vertexMinHeight = Random.Range(0f, .5f);
        float vertexMaxHeight = Random.Range(.5f, 1f);
        float vertexScale = Random.Range(0f, 10f);
        vertexSeed = Random.Range(-10000f, 10000f);

        planetMaterial.sharedMaterial.SetFloat("_SSSVertex_aStrength", vertexStrength);
        planetMaterial.sharedMaterial.SetFloat("_SSSVertex_aIntensety", vertexIntensety);
        planetMaterial.sharedMaterial.SetFloat("_SSSVertex_aMin_Height", vertexMinHeight);
        planetMaterial.sharedMaterial.SetFloat("_SSSVertex_aMax_Height", vertexMaxHeight);
        planetMaterial.sharedMaterial.SetFloat("_SSSVertex_aScale", vertexScale);        
        planetMaterial.sharedMaterial.SetFloat("_SSSVertex_aSeed", vertexSeed);
    }
}