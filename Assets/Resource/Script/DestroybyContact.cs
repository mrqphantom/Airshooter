using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DestroybyContact : MonoBehaviour
{
    public GameObject explosion;
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Boundary"))
        { return; }
        Instantiate(explosion, transform.position,transform.rotation );
        Destroy(other.gameObject);
        Destroy(gameObject);
    }
}
