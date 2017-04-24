using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScrapResource : PoolObject
{
    public override void OnObjectReuse()
    {
        ResourceManager.instance.addScrap(1);
        ResourceManager.instance.scrapObjects.Add(this);
    }

    public void Expend()
    {
        AudioManager.instance.playSound(Sounds.ScrapSpending);
        Destroy();
    }
}