using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orbit : MonoBehaviour {

    [Range(0,10)]
    public float targetRadius = 4;
    public float rotationSpeed = 70;
    public float radiusSpeed = 1;

    private float radius;
    private Transform planet;




    void Start () {
        planet = GameObject.FindGameObjectWithTag("Planet").transform;
        radius = (transform.position - planet.position).magnitude;
	}
	

	void Update () {
        transform.RotateAround(planet.position, Vector3.forward, rotationSpeed *  Time.deltaTime);

        if (radius > targetRadius)
        {
            Vector3 direction = (planet.position - transform.position).normalized;
            transform.position += direction * Time.deltaTime * Mathf.Min(radiusSpeed, radius - targetRadius);
            radius = (transform.position - planet.position).magnitude;
        }
        

    }
}
