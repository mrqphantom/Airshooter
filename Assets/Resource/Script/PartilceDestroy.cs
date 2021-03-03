using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PartilceDestroy : MonoBehaviour
{
    public ParticleSystem part;
  void Start()
    {
        part = GetComponent<ParticleSystem>();
    }
    void OnParticleCollision(GameObject other)
    {   
            Debug.Log("Chamroi");
            Destroy(other.gameObject);
        
    }

}
