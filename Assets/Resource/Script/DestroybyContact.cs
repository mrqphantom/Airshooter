using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroybyContact : MonoBehaviour
{
    public GameObject explosion, playerExplosion, player, hitParticle;
  
    GameObject lazeparticle;
    bool Onetime = false;
    

    void Start()
    {
        player = GameObject.FindWithTag("Player");
    }

        // Update is called once per frame
        void Update()
        {
        
        }
         void OnParticleCollision(GameObject other)
         {
             Instantiate(explosion, transform.position, transform.rotation);
        Destroy(gameObject);
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
    public void DestroyObject()
    {
        if (!Onetime)
        {
            lazeparticle = Instantiate(hitParticle, this.transform.position, this.transform.rotation);
            if (this.gameObject != null)
            {
                lazeparticle.transform.parent = this.transform;
            }
            StartCoroutine(PatilceDelay());
            Onetime = true;
        }
        Destroy(this.gameObject,0.5f);
        
    
        
    }
   IEnumerator PatilceDelay()
    {
        
        yield return new WaitForSeconds(0.4f);
        Instantiate(explosion, this.transform.position, this.transform.rotation);
        Debug.Log("nhan dame");
    }
 
    }

