using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BurnerView : MonoBehaviour {

    GameModel GM;
    Light childLight;
    void Start()
    {
        GM = ServicesLocator.instance.GM;
        childLight = GetComponentInChildren<Light>();
    }

	void Update () {
        if (GM.wet)
        {
            transform.localScale = Vector3.one * .3f;
            childLight.intensity = .3f;
        }
        else
        {
            if (GM.burning)
            {
                transform.localScale = Vector3.one * 2;
                childLight.intensity = 5;
            }
            else
            {
                transform.localScale = Vector3.one * .6f;
                childLight.intensity = 3;
            }
        }
	}
}
