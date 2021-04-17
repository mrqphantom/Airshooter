using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mover : MonoBehaviour
{
   public float speed;
    float defaultSpeed;
    public Rigidbody rigid;
   
    // Start is called before the first frame update
    void Start()
    {
       
        defaultSpeed = speed;
        rigid = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {   
        run(speed);
    }
    public void run(float speedVelocity)
    { rigid.velocity = new Vector3(0, speedVelocity, 0); }
    public void resetSpeed()
    {
        speed = defaultSpeed;
    }
}
