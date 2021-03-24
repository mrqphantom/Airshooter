using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;


public class DestroybyContact : MonoBehaviour
{
    public int health=10;
    public GameObject explosion, playerExplosion, player, hitParticle,hazeHitParticle;
    GameUI gameUI;
    GameObject lazeparticle,hazeHit;
    bool Onetime = false;
    PlayerController playerController;
    Infor infor;
    
    

    void Start()
    {
        
        player = GameObject.FindWithTag("Player");
        
    }

        // Update is called once per frame
        void Update()
        {
            if(health<=0)
            {
            StartCoroutine(Death(0));
            }

          }
         void OnParticleCollision(GameObject other)
         {
           
          hazeHit = Instantiate(hazeHitParticle,transform.position,transform.rotation);
          hazeHit.transform.parent = gameObject.transform;
          Destroy(other.gameObject);
          DamageTaken(FindObjectOfType<Infor>().damagePlayerHaze);
          
          }


        void OnTriggerEnter(Collider other)
         {
            if (other.CompareTag("Boundary"))
            {
            return; }

            if (other.CompareTag("Player"))
            {
            FindObjectOfType<PlayerController>().takeDamage(FindObjectOfType<Infor>().damageBomb);
            StartCoroutine(Death(0));

            return;
            }
            if(other.CompareTag("Bullet"))
            {
                pullback(80f, gameObject.transform.position);
                Destroy(other.gameObject);
                DamageTaken(FindObjectOfType<Infor>().damageBullet);
             }
            if(other.CompareTag("Rocket"))
             {
                 Destroy(other.gameObject);
                 DamageTaken(FindObjectOfType<Infor>().damagePlayerRocket);
              }

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
            Onetime = true;
        }

        DamageTaken(FindObjectOfType<Infor>().damagePlayerLaze);
        
    
        
    }
   IEnumerator Death(float delay)
    {
        FindObjectOfType<GameUI>().ScoreIncrease();
        Instantiate(explosion, this.transform.position, this.transform.rotation);
        Destroy(gameObject,delay);
        yield return new WaitForSeconds(0.4f);
        
    }
    public void DamageTaken(int damage)
    {
        health -= damage; 
    }
    void pullback(float pullpower, Vector3 pulldir)
    {
        gameObject.GetComponent<Rigidbody>().velocity = new Vector3(0, 0, 0);
        gameObject.GetComponent<Rigidbody>().AddForce(new Vector3(0, pulldir.y *pullpower, 0));
    }

}

