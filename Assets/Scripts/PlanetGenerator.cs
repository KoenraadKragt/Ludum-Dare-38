using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlanetGenerator : MonoBehaviour 
{
    public Renderer planetMaterial;

    public float vertexStrengthMin = 5;
    public float vertexStrengthMax = 25;

    public float vertexIntensetyMin = .3f;
    public float vertexIntensetyMax = .45f;

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

        planetMaterial.material.SetFloat("_SSSVertex_aStrength", vertexStrength);
        planetMaterial.material.SetFloat("_SSSVertex_aIntensety", vertexIntensety);
        planetMaterial.material.SetFloat("_SSSVertex_aMin_Height", vertexMinHeight);
        planetMaterial.material.SetFloat("_SSSVertex_aMax_Height", vertexMaxHeight);
        planetMaterial.material.SetFloat("_SSSVertex_aScale", vertexScale);        
        planetMaterial.material.SetFloat("_SSSVertex_aSeed", vertexSeed);
    }
}