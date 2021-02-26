using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroybyContact : MonoBehaviour
{
    public GameObject explosion, playerExplosion, player;
    

    void Start()
    {
        player = GameObject.FindWithTag("Player");
    }

        // Update is called once per frame
        void Update()
        {

        }
        void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Boundary"))
            { return; }
        Instantiate(explosion, transform.position, transform.rotation);

        if (other.CompareTag("Player"))
            {
            
            StartCoroutine(DelayExplosion());
            
            return;
            }
            
            Destroy(other.gameObject);
            Destroy(gameObject);
        }
      IEnumerator DelayExplosion()
    {
        yield return new WaitForSeconds(0.02f);
        Destroy(player);
        Instantiate(playerExplosion, player.transform.position, player.transform.rotation);
        Destroy(gameObject);
        
       
    }
    }

