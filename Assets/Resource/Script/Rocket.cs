using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rocket : MonoBehaviour
{
    public Transform target;
    public Rigidbody rigid;
    public float turn;
    public float speed;
    public float velocity;
    // Start is called before the first frame update
    void Start()
    {
        target = GameObject.FindWithTag("Enemy").transform;
        rigid = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        
        
        rigid.velocity = this.transform.forward * speed;
        var rocketRotation = Quaternion.LookRotation(target.position - this.transform.position);
        rigid.MoveRotation(Quaternion.RotateTowards(this.transform.rotation, rocketRotation, turn));
        
    }
}
