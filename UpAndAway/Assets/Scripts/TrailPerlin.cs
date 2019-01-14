using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrailPerlin : MonoBehaviour {
   
    GameModel GM;
    Vector3 offset;
    Vector3 wind;

	// Use this for initialization
	void Start () {
        GM = ServicesLocator.instance.GM;
	}
	
	// Update is called once per frame
	void Update () {
        wind = GM.WindDir(transform.localPosition + transform.parent.position + GM.worldOffset);

        transform.localPosition += wind * Time.deltaTime;
	}
}
