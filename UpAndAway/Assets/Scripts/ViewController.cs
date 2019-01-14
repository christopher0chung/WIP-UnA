using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ViewController : MonoBehaviour {

    public Camera mainCam;
    public GameObject balloon;

    public CloudMaker c0;
    public CloudMaker c1;
    public float cloudRate;

    public Material waterMat;

    private GameModel GM;

    List<GameObject> viewItems;
    List<GameObject> windItems;

    void Awake()
    {
        GM = ServicesLocator.instance.GM;
    }

    void Start () {
        CloudSetup();
        viewItems = new List<GameObject>();
        AddNewViewGO("Mountains", Vector3.forward * 500 + Vector3.right * 0);
        AddNewViewGO("Mountains", Vector3.forward * 500 + Vector3.right * 500);
        AddNewViewGO("Mountains", Vector3.forward * 500 + Vector3.right * 1000);
        AddNewViewGO("Mountains", Vector3.forward * 500 + Vector3.right * 1500);
        AddNewViewGO("Mountains", Vector3.forward * 500 + Vector3.right * 2000);

        AddNewViewGO("IslandParent", Vector3.zero);

        windItems = new List<GameObject>();
    }

    // Update is called once per frame
    void Update () {
        CloudUpdate();
        WaterUpdate();
        UpdateViewGO();
        WindUpdate();
        WindManage();
        LRUpdate();
        CamUpdate();
        //WindDebug();
    }

    private void CloudSetup()
    {
        c0.transform.position = new Vector3(-900, 30, 0);
        c1.transform.position = new Vector3(0, 80, 0);
    }

    private void CloudUpdate()
    {
        c0.transform.position -= (cloudRate + GM.worldRateX) * Vector3.right * Time.deltaTime;
        c1.transform.position -= (cloudRate + GM.worldRateX) * Vector3.right * Time.deltaTime;

        if (c0.transform.localPosition.x < - 900)
            c0.transform.localPosition += Vector3.right * 1800;
        if (c1.transform.localPosition.x < - 900)
            c1.transform.localPosition += Vector3.right * 1800;
    }

    private void WaterUpdate()
    {
        waterMat.SetFloat("_WorldSpaceCameraOffset", GM.worldOffset.x);
    }

    public GameObject AddNewViewGO (string prefabName, Vector3 posRelativeToView)
    {
        GameObject newPrefab = Instantiate<GameObject>(Resources.Load<GameObject>("Prefabs/" + prefabName), transform);
        newPrefab.transform.localPosition = posRelativeToView;
        viewItems.Add(newPrefab);
        return newPrefab;
    }

    private void UpdateViewGO ()
    {
        foreach(GameObject g in viewItems)
        {
            g.transform.localPosition -= Vector3.right * GM.worldRateX * g.GetComponent<BackgroundRateModel>().rateScale * Time.deltaTime;
        }
    }

    private float windTimer;
    private List<GameObject> trailsToDestroys = new List<GameObject>();
    private void WindManage()
    {
        windTimer += Time.deltaTime;
        if (windTimer >= .05f)
        {
            windTimer -= .05f;

            if (windItems.Count < 200)
            {
                GameObject newPrefab = Instantiate<GameObject>(Resources.Load<GameObject>("Prefabs/WindParent"), transform);
                Vector3 pos = mainCam.transform.position + new Vector3(Random.Range(-8, 8), Random.Range(-5f, 5f), 0);
                pos.z = 0;
                newPrefab.transform.position = pos;
                windItems.Add(newPrefab);
            }

            foreach (GameObject g in windItems)
            {
                if (Mathf.Abs(mainCam.transform.position.x - g.transform.position.x) > 8.1f || Mathf.Abs(mainCam.transform.position.y - g.transform.position.y) > 5.1f)
                {
                    trailsToDestroys.Add(g);
                }
            }

            if (trailsToDestroys.Count>0)
            {
                foreach (GameObject g in trailsToDestroys)
                {
                    GameObject gRef = g;
                    windItems.Remove(gRef);
                    Destroy(gRef);
                }
                trailsToDestroys.Clear();
            }
            //Debug.Log(windItems.Count);
        }

    }

    private void WindUpdate()
    {
        foreach(GameObject g in windItems)
        {
            g.transform.position -= Vector3.right * GM.worldRateX * Time.deltaTime;
        }
    }

    Vector3 resetPos = new Vector3(0, 1.11f, -20f);
    private void CamUpdate()
    {
        Vector3 camPos = balloon.transform.position;
        if (!GM.gone)
        {
            camPos.x = 0;
            camPos.y += .5f;
            camPos.z = -20;
            mainCam.transform.position = camPos;
        }
        else
        {
            mainCam.transform.position = Vector3.Lerp(mainCam.transform.position, resetPos, .05f);
        }
    }

    private void LRUpdate()
    {
        GM.SetLR(balloon.transform.position.x);
    }

    private void WindDebug()
    {
        for (int i = -30; i < 30; i++)
        {
            for (int j = -20; j < 20; j++)
            {
                Vector3 samplePoint = (new Vector3((float)i / 10, (float)j / 10, 0))
                    + GM.worldOffset +
                    balloon.transform.position;

                Vector3 wind = GM.WindDir(samplePoint);

                Debug.DrawRay(new Vector3((float)i / 10, (float)j / 10, 0) + balloon.transform.position,
                    wind * .2f,
                    new Color(.5f + .5f * wind.x, .5f + .5f * wind.y, 0));
            }
        }
    }

    public void DestroyViewGO(GameObject gO)
    {
        if (viewItems.Contains(gO))
        {
            Debug.Log("Proceeding with destroy sequence...");
            viewItems.Remove(gO);
            Destroy(gO);
            Debug.Log("Game object removed and destroyed.");
        }
        else
        {
            Debug.Log("Attempting to destroy untracked item. Aborting...");
        }
    }
}
