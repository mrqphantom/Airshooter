using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Bullet : MonoBehaviour
{
    public float speed;
    public Rigidbody rigid;
    public float lifeTime;
    GameUI gameUI;
    public ParticleSystem hitPartilce;
    ParticleSystem Obj;
    // Start is called before the first frame update
    void Start()
    {
        rigid = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        lifeTime -= Time.deltaTime;
        if (lifeTime<=0)
        {
            Destroy(gameObject);
        }
        speed -= speed * Time.deltaTime;
        rigid.velocity = transform.up * speed;

    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Enemy"))
        {
           
            
                other.gameObject.GetComponent<Rigidbody>().AddForce(transform.forward * 1000f * Time.deltaTime);
                Obj = Instantiate(hitPartilce, other.gameObject.transform.position, other.gameObject.transform.rotation);
                Obj.transform.parent = other.gameObject.transform;
          
        }
    }
}
