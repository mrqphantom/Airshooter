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
            Instantiate(rocket, transform.position, transform.rotation);
            yield return new WaitForSeconds(WaiteachRocket);
        }
    }
}
