using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SplashView : MonoBehaviour {

    GameModel GM;
    public ParticleSystem PS;

    private bool _w;
    private bool nowWet
    {
        get
        {
            return _w;
        }
        set
        {
            if (value != _w)
            {
                _w = value;
                if (value)
                    PS.Emit(500);
            }
        }
    }

    void Start () {
        GM = ServicesLocator.instance.GM;
	}
	
	// Update is called once per frame
	void Update () {
        nowWet = GM.wet;
	}

    public void Splash()
    {
        PS.Emit(500);
    }
}
