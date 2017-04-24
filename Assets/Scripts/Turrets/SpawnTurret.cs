using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum Turrets
{
    BasicTurret,
    AutoTurret,
    RapidTurret,
    Launcher
}

[System.Serializable]
public struct ShopEntry
{
    public Turrets turretType;
    public GameObject turretPrefab;
    public int cost;
    public int costIncrement;
}

public class SpawnTurret : MonoBehaviour {

    private GameObject crosshair;
    private float planetRadius;

    public GameObject spawningGraphics;

    public ShopEntry[] shopEntries = new ShopEntry[2];
    private Turrets currentType = Turrets.BasicTurret;


    public bool isBuying = false;
    

    void Start () {

        crosshair = GameObject.FindGameObjectWithTag("CrossHair");
        planetRadius = GetComponent<CircleCollider2D>().radius * transform.localScale.x;

        spawningGraphics = GameObject.Instantiate(spawningGraphics);
        spawningGraphics.SetActive(false);
    }
	
	void Update () {
        

        if (isBuying)
        {
            spawningGraphics.SetActive(true);
            Vector3 direction = (crosshair.transform.position - transform.position).normalized;
            spawningGraphics.transform.position = transform.position + direction * planetRadius;
            spawningGraphics.transform.up = direction;
            // TODO: placing graphics
            Debug.DrawLine(transform.position, crosshair.transform.position, Color.green);
            if (Input.GetButtonDown("Fire1"))
            {
                placeTurret();
                isBuying = false;
                spawningGraphics.SetActive(false);
            }
        }


        if (Input.GetKeyDown(KeyCode.Space))
        {
            BuyTurret((int)Turrets.BasicTurret);
        }
	}

    private void placeTurret()
    {
        Vector3 direction = ( crosshair.transform.position - transform.position ).normalized;
        GameObject turret = (GameObject)Instantiate(shopEntries[(int)currentType].turretPrefab);
        turret.transform.parent = transform;
        turret.transform.position = transform.position + direction * planetRadius;

        turret.transform.forward = direction;
        AudioManager.instance.playSound(Sounds.TurretPlace);
    }

    public void BuyTurret(int type)
    {
        currentType = (Turrets)type;
        if (ResourceManager.instance.removeScrap ( shopEntries[(int)currentType].cost) )
        {
            isBuying = true;
            shopEntries[(int)currentType].cost += shopEntries[(int)currentType].costIncrement;


        }
    }
}
