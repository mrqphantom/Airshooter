using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RocketLauncher : MonoBehaviour
{
    public GameObject rocket;
    public int rocketCount;
    public float WaiteachRocket;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame

    public IEnumerator launchRocket()
    {

        for (int i = 0; i < rocketCount; i++)
        {
            float rotation = 0f;
            if (i % 2 == 0)
            { rotation = Random.Range(-140, -45); }
            else
            { rotation = Random.Range(45f, 140f); }
            Instantiate(rocket, transform.position, Quaternion.Euler(0, rotation,0 ));
            yield return new WaitForSeconds(WaiteachRocket);

        }
    }
}
