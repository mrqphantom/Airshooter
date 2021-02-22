using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Turnable_obj : MonoBehaviour
{
    public float tumb;
    public Rigidbody rigid;
    // Start is called before the first frame update
    void Start()
    {
        rigid = GetComponent<Rigidbody>();
        rigid.angularVelocity = Random.insideUnitSphere * tumb;
    }

    // Update is called once per frame
   
    
}
