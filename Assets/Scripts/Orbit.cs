using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Orbit : PoolObject {

    public float offsetPercentage = 0.1f;
    [Range(0,10)]
    public float targetRadius = 4;
    public float rotationSpeed = 70;
    public float radiusSpeed = 1;

    private float radius;
    private Transform planet;



    void OnEnable()
    {
        planet = GameObject.FindGameObjectWithTag("Planet").transform;
        

    }

    public override void OnObjectReuse()
    {
        radius = (transform.position - planet.position).magnitude;
        float radiusOffset = (targetRadius * offsetPercentage);
        targetRadius = Random.Range(targetRadius, targetRadius + radiusOffset);
        float speedOffset = (rotationSpeed * offsetPercentage);
        rotationSpeed = Random.Range(rotationSpeed - speedOffset, rotationSpeed + speedOffset);
    }



    void Update () {
        transform.RotateAround(planet.position, Vector3.forward, rotationSpeed *  Time.deltaTime);

        if (radius != targetRadius)
        {
            Vector3 direction = (planet.position - transform.position).normalized;
            transform.position += direction * Time.deltaTime * Mathf.Min(radiusSpeed, radius - targetRadius);
            radius = (transform.position - planet.position).magnitude;
        }
        

    }
}
