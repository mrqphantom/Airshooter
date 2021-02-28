using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rocket1 : MonoBehaviour
{
    public Transform target;
    public Rigidbody rigid;
    public float turn;
    public float speed;
    // Start is called before the first frame update
    void Start()
    {

        rigid = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        rigid.velocity = transform.forward * speed;
        var rocketRotation = Quaternion.LookRotation(target.position - transform.position);
        rigid.MoveRotation(Quaternion.RotateTowards(transform.rotation, rocketRotation, turn));

    }
}
