using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour
{
    public GameObject bomb;
    public Vector3 spawnValues;
    // Start is called before the first frame update
    void Start()
    {
        spawnWave();
    }

    // Update is called once per frame
    
    void spawnWave()
    {
        Vector3 spawnPosition = new Vector3(Random.Range(-0.217f, 0.318f), spawnValues.y, -0.0094f);
        Quaternion spawnRotation = new Quaternion();
        Instantiate(bomb, spawnPosition, spawnRotation);


    }
}
