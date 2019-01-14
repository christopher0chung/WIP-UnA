using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IslandSink : MonoBehaviour {

    public bool pauseSink;

	void Update () {
        if (!pauseSink)
            transform.position += Vector3.up * -.2f * Time.deltaTime;

        if (transform.localPosition.y < -10)
        {
            ServicesLocator.instance.VC.DestroyViewGO(this.gameObject);
        }
    }
}
