using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rocket2 : MonoBehaviour
{
    public GameObject[] targets;
    GameObject closettarget;
    public float speed;
    Vector3 angularVelocity;
    Rigidbody rigid;
    public float turn;
    public GameObject Explosion;
    // Start is called before the first frame update
    void Start()
    {
        
     
    }

    // Update is called once per frame
    void Update()
    {
        targets = GameObject.FindGameObjectsWithTag("Enemy");
        rigid = GetComponent<Rigidbody>();
        
       
        GameObject closetTarget = targets[0];
        float closetDistance = Vector3.Distance(transform.position, closetTarget.transform.position);
        float thisDistance;
        for(int i=1;i < targets.Length; i++)
        {
            thisDistance = Vector3.Distance(transform.position, targets[i].transform.position);
            if (thisDistance<closetDistance)
            {
                closettarget = targets[i];
                closetDistance = thisDistance;
                

            }
            var rocketRotation = Quaternion.LookRotation(closetTarget.transform.position - transform.position);
            rigid.MoveRotation(Quaternion.RotateTowards(transform.rotation, rocketRotation, turn));
           
            rigid.velocity = transform.forward * speed;



        }
        for(var i = targets.Length-1;i>=0;i--)
        {
            if(targets[i]==null)

            {
                targets[i]
            }
        }
       

        }
    }
    
