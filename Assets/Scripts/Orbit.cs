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
        //radius = Mathf.Lerp(radius, targetRadius, Time.deltaTime);

        Vector3 desiredPosition;

        transform.RotateAround(planet.position, Vector3.forward, rotationSpeed *  Time.deltaTime);
        desiredPosition = (transform.position - planet.position).normalized * targetRadius + planet.position;

        transform.position = Vector3.MoveTowards(transform.position, desiredPosition, Time.deltaTime * radiusSpeed);

    }
}
