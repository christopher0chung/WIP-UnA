using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FogController : MonoBehaviour {

    public Material skybox;
    public Color fogColor;
    public Debug_RotateLight sunAngle;
    public Color c_Sunrise;
    public Color c_Noon;
    public Color c_Sunset;
    public Color c_Midnight;

    public Quaternion literalAng;
    public float xRot;
    public float ang;

	void Start () {
        c_Sunrise = skybox.GetColor("_SkySunrise");
        c_Noon = skybox.GetColor("_SkyNoon");
        c_Sunset = skybox.GetColor("_SkySunset");
        c_Midnight = skybox.GetColor("_NightSkyColor");
	}
	
	void Update () {

        ang = sunAngle.angleVal;

        if (ang >= 0 && ang < 90)
            fogColor = Color.Lerp(c_Sunrise, c_Noon,  ang/ 90);
        else if (ang >= 90 && ang < 180)
            fogColor = Color.Lerp(c_Noon, c_Sunset, (ang - 90) / 90);
        else if (ang >= 180 && ang < 270)
            fogColor = Color.Lerp(c_Sunset, c_Midnight, (ang - 180) / 90);
        else if (ang >= 270 && ang < 360)
            fogColor = Color.Lerp(c_Midnight, c_Sunrise, (ang - 270) / 90);

        RenderSettings.fogColor = fogColor;
	}
}
