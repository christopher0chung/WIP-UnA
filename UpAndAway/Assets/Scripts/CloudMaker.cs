using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudMaker : MonoBehaviour {

    public GameObject cloud;
    public float cloudRate;
    
	void Awake () {
		for (int i = 0; i < 200; i++)
        {
            GameObject g = new GameObject();
            g.transform.parent = this.transform;
            Instantiate(cloud, Vector3.zero, new Quaternion(Random.Range(0, 360.00f), Random.Range(0, 360.00f), Random.Range(0, 360.00f), Random.Range(0, 360.00f)), g.transform);
            g.transform.localScale = new Vector3(16, 8, 8);
            g.transform.position = new Vector3(Random.Range(-450, 450), Random.Range(0, 20), Random.Range(-20, 1000));
        }
	}
}
