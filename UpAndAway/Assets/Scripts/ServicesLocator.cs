using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ServicesLocator {

    static ServicesLocator _i;
    public static ServicesLocator instance
    {
        get {
            if (_i == null)
                _i = new ServicesLocator();
            return _i;
        }
    }

    private GameModel _g;
    public GameModel GM
    {
        get
        {
            if (_g == null)
            {
                _g = GameObject.Find("GameController").GetComponent<GameModel>();
            }
            return _g;
        }
    }

    private ViewController _v;
    public ViewController VC
    {
        get
        {
            if (_v == null)
            {
                _v = GameObject.Find("ViewController").GetComponent<ViewController>();
            }
            return _v;
        }
    }
}
