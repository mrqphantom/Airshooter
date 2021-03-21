using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AoEattack : MonoBehaviour
{
    public float radius = 0.3f;
    public GameObject explosion2;
   
   
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
     
    }
    void OnTriggerEnter(Collider other)
    {if (other.tag == ("Enemy"))
            {
            Instantiate(explosion2, transform.position, transform.rotation);
            Collider[] colliders = Physics.OverlapSphere(transform.position, radius);
            foreach (Collider nearbyEnemy in colliders)
            {
                if (nearbyEnemy.tag == ("Enemy") && (nearbyEnemy != null))
                {
                    Instantiate(explosion2, nearbyEnemy.transform.position, transform.rotation);
                    
                }
            }
            
        }
       

    }
   
}
