using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Rocket : MonoBehaviour
{
    public Transform target;
    public float rotateSpeed;
    public float speed;
    public Rigidbody rigid;
    public Rigidbody targetVelocity;
    // Start is called before the first frame update
    void Start()
    {
        target = GameObject.FindWithTag("Enemy").transform;
        targetVelocity = GameObject.FindWithTag("Enemy").gameObject.GetComponent<Rigidbody>();
        rigid = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
       
        Vector3 targetDirection = target.position - transform.position;
        Vector3 newDirection = Vector3.RotateTowards(transform.forward, targetDirection, 45f, 0.0f);
        Debug.DrawRay(transform.position, newDirection, Color.red);
        transform.rotation = Quaternion.LookRotation(newDirection);
        transform.position = Vector3.MoveTowards(transform.position,target.position, 0.01f);
     
      
       
        
    }
}
