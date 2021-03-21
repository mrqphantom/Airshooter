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
}
