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
    float range = 0.01f;
    PlayerShader playerShader;
    DestroybyContact destroybyContact;
    public GameObject health;
    public GameObject[] enemy;
    public GameObject SpeedUp,Shield;
    PlayerController playerController;
    Mover mover;
 
    Test_background test_Background;


    // Start is called before the first frame update
    void Start()

    {
        playerController = FindObjectOfType<PlayerController>();
        mover = FindObjectOfType<Mover>();
        player = GameObject.FindGameObjectWithTag("Player");
        if (player)
        {
            StartCoroutine(spawnWave());
            StartCoroutine(WaitGameStart());
            StartCoroutine(Dissolve());
            StartCoroutine(spawnSpeedItem());
            StartCoroutine(spawnShieldItem());
        }

    }

    void Update()
    {
       
        enemy = GameObject.FindGameObjectsWithTag("Enemy");
        if (!player)
        {
            if (enemy.Length == 0)
            {
                return;
            }

            {
                if (enemy.Length != 0)
                {
                    for (int i = 1; i < enemy.Length; i++)
                    {
                        StartCoroutine(enemy[i].GetComponent<DestroybyContact>().Death(0f));
                    }
                    bombCount = 0;
                }
            }
        }
 
    }
    // Update is called once per frame

    IEnumerator spawnWave()
    {
        yield return new WaitForSeconds(startWave);
        while (player != null)

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
        while (t < timeStartGame)
        {   FindObjectOfType<Test_background>().Materialspeed.SetFloat("SpeedBackground",Time.deltaTime / 3);
            t += Time.deltaTime;
            player.GetComponent<PlayerController>().enabled = false;
            obj = Instantiate(startParticle, player.transform.position, player.transform.rotation);
            obj.transform.parent = player.transform;
            Destroy(obj, 1f);
            yield return new WaitForEndOfFrame();


        }
        player.GetComponent<PlayerController>().enabled = true;
        Destroy(obj, 0.5f);
        player.GetComponent<StartmoveAnimation>().enabled = false;
    }

    public IEnumerator Dissolve()
    {
        for (int i = 0; i < 100; i++)
        {
            FindObjectOfType<PlayerShader>().material.SetFloat("_DissolveAmount", range += 0.01f);
            yield return new WaitForSeconds(0.02f);
        }
    }
    IEnumerator spawnSpeedItem()
    {
        yield return new WaitForSeconds(2f);
        while (player != null)

        {
            for (int i = 0; i < 1; i++)
            {
                Vector3 spawnPosition = new Vector3(Random.Range(-0.217f, 0.318f), spawnValues.y, -0.0094f);
                Quaternion spawnRotation = new Quaternion();
                Instantiate(SpeedUp, spawnPosition, spawnRotation);
                yield return new WaitForSeconds(10f);
            }
            yield return new WaitForSeconds(5f);

        }


    }
    IEnumerator spawnShieldItem()
    {
        yield return new WaitForSeconds(8f);
        while (player != null)

        {
            for (int i = 0; i < 1; i++)
            {
                Vector3 spawnPosition = new Vector3(Random.Range(-0.217f, 0.318f), spawnValues.y, -0.0094f);
                Quaternion spawnRotation = new Quaternion();
                Instantiate(Shield, spawnPosition, spawnRotation);
                yield return new WaitForSeconds(15f);
            }
            yield return new WaitForSeconds(10f);

        }


    }
}
