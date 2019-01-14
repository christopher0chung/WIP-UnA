using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameModel : MonoBehaviour {

    //public float worldIndexX { get; private set; }
    public Vector3 worldOffset { get; private set; }
    public float worldRateX { get; private set; }

    [Range(0.0001f, 30)] public float noiseScaleTuningVal;

    public bool burning { get; private set; }
    public bool venting { get; private set; }

    public float lR { get; private set; }

    public bool wet { get; private set; }

    public bool gone { get; private set; }

    //-----------------------------------------------------------

    public void SetRate(float rate)
    {
        worldRateX = rate;
    }

    public void Tick()
    {
        //worldIndexX += worldRateX * Time.deltaTime;
        worldOffset += new Vector3 (worldRateX * Time.deltaTime, 0, 0);
        //Debug.Log(worldIndexX);
    }

    public Vector3 WindDir (Vector3 position)
    {
        float angleAboutZ = Perlin.Noise(position.x / noiseScaleTuningVal, position.y / noiseScaleTuningVal) * 6;
        return Vector3.Normalize(new Vector3(Mathf.Cos(angleAboutZ), Mathf.Sin(angleAboutZ), 0));
    }

    public void SetBurner(bool tF)
    {
        burning = tF;
    }

    public void SetVent(bool tF)
    {
        venting = tF;
    }

    public void SetLR(float lR)
    {
        this.lR = lR;
        if (lR > .2f)
            worldRateX = lR;
    }

    public void SetWet(bool tF)
    {
        wet = tF;
    }

    public void SetGone(bool tF)
    {
        gone = tF;
    }
}
