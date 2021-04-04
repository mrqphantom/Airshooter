using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;


public class DestroybyContact : MonoBehaviour
{
    public int health=10;
    public GameObject explosion, playerExplosion, player, hitParticle,hazeHitParticle,playerHit;
    GameUI gameUI;
    GameObject lazeparticle,hazeHit;
    bool Onetime = false;
    PlayerController playerController;
    Infor infor;
    GameObject obj;
    public GameObject HitShield;
    PlayerShader playerShader;
 





    void Start()
    {
       
        player = GameObject.FindWithTag("Player");
        
    }

        // Update is called once per frame
        void Update()
    {
 
        if (health<=0)
            {
            StartCoroutine(Death(0));
            }

          }
        void OnParticleCollision(GameObject other)
         {
        if (other.CompareTag("Fire"))
            {
           
            hazeHit = Instantiate(hazeHitParticle, transform.position, transform.rotation);
            hazeHit.transform.parent = gameObject.transform;
            Destroy(other.gameObject);
            DamageTaken(FindObjectOfType<Infor>().damagePlayerHaze);
            StartCoroutine(SlowdownEnemy());
            }
        if (other.CompareTag("Shield"))
        {
            Instantiate(HitShield,transform.position, Quaternion.identity);
            health = 0;
        }
      
        }




        void OnTriggerEnter(Collider other)
         {
            if (other.CompareTag("Boundary"))
            {
            return; }

            if (other.CompareTag("Player"))
            {
           
            obj = Instantiate(playerHit, other.gameObject.transform.position, other.gameObject.transform.rotation);
            obj.transform.parent = other.gameObject.transform;
            FindObjectOfType<PlayerController>().takeDamage(FindObjectOfType<Infor>().damageBomb);
            StartCoroutine(Death(0f));
           
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
   public IEnumerator Death(float delay)
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
    public IEnumerator SlowdownEnemy()
    {

        yield return new WaitForSeconds(0.3f);
        gameObject.GetComponent<Turnable_obj>().tumb /= 3;
        gameObject.GetComponent<Mover>().speed /= 1.2f;
       
        yield return new WaitForSeconds(0.3f);
        gameObject.GetComponent<Turnable_obj>().tumb *= 3;
        gameObject.GetComponent<Mover>().speed *= 1.2f;

        yield return new WaitForSeconds(2f);
    }


}

