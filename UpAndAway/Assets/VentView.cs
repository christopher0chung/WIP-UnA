using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VentView : MonoBehaviour {

    GameModel GM;
    ParticleSystem PS;

	// Use this for initialization
	void Start () {
        GM = ServicesLocator.instance.GM;
        PS = GetComponent<ParticleSystem>();
	}
	
	// Update is called once per frame
	void Update () {
        if (GM.wet)
        {

        }
        else
        {
            if (GM.venting)
                PS.Emit(2);
        }
	}
}
