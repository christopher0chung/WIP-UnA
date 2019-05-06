using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Debug_RotateLight : MonoBehaviour {

    public Vector3 rotationRate;
    private Quaternion nextRot;

    private Light sun;

    private float applied;

    public float angleVal;

    void Awake()
    {
        sun = GetComponentInChildren<Light>();
    }

    void Update () {

        angleVal += rotationRate.x * Time.deltaTime;
        angleVal = (angleVal + 360) % 360;

        transform.rotation = Quaternion.Euler(angleVal, 0, 0);

        //if (Input.GetKeyDown(KeyCode.Space))
        //    transform.Rotate(Vector3.right * 15);

        applied = Mathf.Clamp01(Mathf.Clamp01(.7f + (Vector3.Dot(-Vector3.up, sun.transform.forward))) + .01f);

        sun.intensity = applied;

        //.6 at night
        RenderSettings.ambientIntensity = (applied * .3f) + .3f;
        //.712 at night
        RenderSettings.reflectionIntensity = (applied * .7f) + .3f;
    }
}
