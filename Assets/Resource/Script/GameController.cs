using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour
{
    public GameObject bomb;
    public Vector3 spawnValues;
    public float waitWave;
    public int bombCount;
    public float startWave;
    public float waitBomb;
    public GameObject player;
    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        StartCoroutine(spawnWave());
    }

    // Update is called once per frame
    
    IEnumerator spawnWave()
    {
        yield return new WaitForSeconds(startWave);
        while(player != null)

        {
            for (int i = 0; i < bombCount; i++)
            {
                Vector3 spawnPosition = new Vector3(Random.Range(-0.217f, 0.318f), spawnValues.y, -0.0094f);
                Quaternion spawnRotation = new Quaternion();
                Instantiate(bomb, spawnPosition, spawnRotation);
                yield return new WaitForSeconds(waitBomb);
            }
            yield return new WaitForSeconds(waitWave);

        }


    }
}
