using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ColorChangeOnDamage : MonoBehaviour
{
    public Renderer planetGround;
    private Hitpoints hitpoints;
    

    public float lerpTime = 1f;
    float currentLerpTime;
    float lerpHP;
    float startHP;
    float endHP;
    float maxHP;

    void Start()
    {
        hitpoints = GetComponent<Hitpoints>();
        maxHP = hitpoints.hitpoints;
    }

    public void TakeDamage(int damage)
    {
        //Reset
        currentLerpTime = 0f;

        //Set values to lerp between
        startHP = hitpoints.hitpoints;
        endHP = hitpoints.hitpoints - damage;
    }

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.A))
        {
            this.gameObject.SendMessage("TakeDamage", 1, SendMessageOptions.DontRequireReceiver);
        }
 
        if(lerpHP != endHP)
        {
            //increment timer once per frame
            currentLerpTime += Time.deltaTime;
            if (currentLerpTime > lerpTime) 
            {
                currentLerpTime = lerpTime;
            }
    
            //lerp!
            float perc = currentLerpTime / lerpTime;
            lerpHP = Mathf.Lerp(startHP, endHP, perc);

            planetGround.material.SetFloat("_SSSVertex_Color_aIntensety", lerpHP / maxHP);
        }
    }


}
//
