using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorChangeOnDamage : MonoBehaviour
{
    public Renderer planetGround;
    private Hitpoints hitpoints;
    private int curHP;
    private int maxHP;

    void Start()
    {
        hitpoints = GetComponent<Hitpoints>();
        curHP = hitpoints.hitpoints;
        maxHP = hitpoints.hitpoints;
    }


    public void TakeDamage(int damage)
    {

        float amount = Mathf.Lerp(curHP, hitpoints.hitpoints, 1 * Time.deltaTime) / maxHP;

        planetGround.material.SetFloat("_SSSVertex_Color_aIntensety", amount);
    }

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.A))
        {
            this.gameObject.SendMessage("TakeDamage", 1, SendMessageOptions.DontRequireReceiver);
        }
    }
}
