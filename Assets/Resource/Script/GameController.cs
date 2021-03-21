using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameController : MonoBehaviour
{
    public GameObject bomb;
    public Vector3 spawnValues;
    public float waitWave;
    public int bombCount;
    public float startWave;
    public float waitBomb;
    public GameObject player;
    public float timeStartGame;
    public Transform StartPoint;
    public float StartSpeed;
    public GameObject startParticle;
    GameObject obj;
    GameUI GameUI;
    public int points;
    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        StartCoroutine(spawnWave());
        StartCoroutine(WaitGameStart());
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
    IEnumerator WaitGameStart()
    {
      
        StartCoroutine(player.AddComponent<StartmoveAnimation>().MoveOverSpeed(StartPoint.position, StartSpeed));
        float t = 0;
        while(t<timeStartGame)
        {
            t += Time.deltaTime;
            player.GetComponent<PlayerController>().enabled = false;
            obj = Instantiate(startParticle, player.transform.position, player.transform.rotation);
            obj.transform.parent = player.transform;
            Destroy(obj,1f);
            yield return new WaitForEndOfFrame();
            
            
        }
        player.GetComponent<PlayerController>().enabled = true;
        Destroy(obj,0.5f);
        player.GetComponent<StartmoveAnimation>().enabled = false;
    }
  
}
