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
    public float minturn,maxturn;
    public GameObject Explosion;
    float thisDistance;
    public GameObject Dir;
    public ParticleSystem hitRocketPartilce;
    ParticleSystem Obj;
   
    // Start is called before the first frame update
    void Start()
    {

        
    }

    // Update is called once per frame
    void Update()
    {
        Dir= GameObject.FindGameObjectWithTag("Launcher");
        targets = GameObject.FindGameObjectsWithTag("Enemy");
        rigid = GetComponent<Rigidbody>();
        if (targets.Length == 0)
        {
            
            rigid.AddForce(transform.position * speed,ForceMode.Acceleration);
            return;
            
        }
       if(targets.Length >= 1)
        {
            GameObject closetTarget = targets[0];
            float closetDistance = Vector3.Distance(transform.position, closetTarget.transform.position);

            for (int i = 1; i < targets.Length; i++)
            {
                thisDistance = Vector3.Distance(transform.position, targets[i].transform.position);
                if (thisDistance < closetDistance)
                {
                    closettarget = targets[i];
                    closetDistance = thisDistance;


                }
            }
            var rocketRotation = Quaternion.LookRotation(closetTarget.transform.position - transform.position);
            rigid.MoveRotation(Quaternion.RotateTowards(transform.rotation, rocketRotation, Random.Range(minturn, maxturn)));
            speed += Time.deltaTime;
            rigid.velocity = transform.forward * speed;



        }

    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Enemy"))
        {
            Obj = Instantiate(hitRocketPartilce, other.gameObject.transform.position, other.gameObject.transform.rotation);
        }
    }
}

