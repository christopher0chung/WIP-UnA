using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour {

    GameModel GM;

    public GameObject balloon;

    void Start () {
        GM = ServicesLocator.instance.GM;
        GM.SetRate(0);
        _velocity = Vector3.up;
        balloon.GetComponent<SplashView>().Splash();
	}

	void Update () {

        //if (Input.GetAxis("Mouse ScrollWheel") > 0)
        //    GM.SetRate(GM.worldRateX - .1f);
        //else if (Input.GetAxis("Mouse ScrollWheel") < 0)
        //    GM.SetRate(GM.worldRateX + .1f);

        if (GM.gone)
        {
            RespawnSequence();
        }
        else if (GM.wet)
        {
            DeathPan();
            GoneCheck();
        }
        else
        {
            Inputs();
            BallonBehavior();
            Calc();
            Compensate();
            Move();
            WetCheck();
            GoneCheck();
        }
        GM.Tick();
	}

    void FixedUpdate()
    {
    }

    [Range(0, 10)] public float liftMag;
    private Vector3 _LiftForce;
   
    public float drag;
    private float _dragCorrectionFactor;
    private Vector3 _windDirection;
    private Vector3 _windForce;

    private Vector3 _velocity;

    private void Inputs()
    {
        if (Input.GetMouseButtonDown(0))
            GM.SetBurner(true);
        if (Input.GetMouseButtonUp(0))
            GM.SetBurner(false);

        if (Input.GetMouseButtonDown(1))
            GM.SetVent(true);
        if (Input.GetMouseButtonUp(1))
            GM.SetVent(false);

        if (Input.GetKeyDown(KeyCode.Escape))
            Application.Quit();
    }

    private void BallonBehavior()
    {
        if (GM.burning && GM.venting)
        {
            _LiftForce = Vector3.zero;
        }
        else if (GM.burning)
        {
            _LiftForce = Vector3.up * liftMag;
        }
        else if (GM.venting)
        {
            _LiftForce = -Vector3.up * liftMag;
        }
        else
        {
            _LiftForce = Vector3.zero;
        }
    }

    private void Calc()
    {
        _windDirection = GM.WindDir(balloon.transform.position + GM.worldOffset + Vector3.up * 1.66f);
        _dragCorrectionFactor = .7f - (Vector3.Dot(Vector3.Normalize(_velocity), Vector3.Normalize(_windDirection)) / 2);
        _windForce = drag * _dragCorrectionFactor * _windDirection;

        _velocity += (_LiftForce + _windForce) * Time.deltaTime;

        //Debug.DrawRay(balloon.transform.position + Vector3.up * 1.66f, Vector3.Normalize(_windForce) * 5, Color.blue);
        //Debug.DrawRay(balloon.transform.position + Vector3.up * 1.66f, Vector3.Normalize(_velocity) * 5, Color.red);
    }

    private void Move()
    {
        _velocity *= .999f;
        balloon.transform.position += _velocity * Time.deltaTime;
    }

    private void WetCheck()
    {
        if (balloon.transform.position.y <= 0)
        { GM.SetWet(true); }
    }

    private void GoneCheck()
    {
        if (balloon.transform.position.x <= -9.75f)
        {
            GM.SetGone(true);
            _spawned = false;
        }
    }

    private void Compensate()
    {
        balloon.transform.position -= Vector3.right * (GM.worldRateX + .1f) * Time.deltaTime * .25f;
    }

    private void DeathPan()
    {
        Vector3 loc = balloon.transform.position;
        loc.y = 0;
        loc -= Vector3.right * (GM.worldRateX + .5f) * Time.deltaTime;
        balloon.transform.position = loc;
    }

    private bool _spawned;
    private GameObject island;
    private void RespawnSequence()
    {
        if (!_spawned)
        {
            GM.SetWet(false);
            island = ServicesLocator.instance.VC.AddNewViewGO("IslandParent", Vector3.up * -4);
            Debug.Log(island.transform.position);
            island.GetComponent<IslandSink>().pauseSink = true;
            balloon.transform.position = island.transform.position + Vector3.up * 1.11f;
            balloon.transform.localScale = Vector3.one * .9f;
            GM.SetBurner(false);
            GM.SetVent(false);
            _spawned = true;
        }
        else
        {
            if (balloon.transform.position.y <= 1.11f)
            {
                Debug.Log(balloon.transform.position.y);
                island.transform.position += Vector3.up * 1 * Time.deltaTime;
                balloon.transform.position = island.transform.position + Vector3.up * 1.11f;
                balloon.transform.localScale = Mathf.Lerp(balloon.transform.localScale.x, 1, .03f) * Vector3.one;
            }
            else
            {
                island.transform.position = Vector3.zero;
                island.GetComponent<IslandSink>().pauseSink = false;
                balloon.transform.position = Vector3.up * 1.11f;
                balloon.transform.localScale = Vector3.one;
                _velocity = Vector3.up;
                balloon.GetComponent<SplashView>().Splash();
                GM.SetGone(false);
            }
        }
    }
}
