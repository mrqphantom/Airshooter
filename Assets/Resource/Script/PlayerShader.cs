using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerShader : MonoBehaviour
{
    public Renderer meshRenderer;
    public Material material;

  
    // Start is called before the first frame update
    void Start()
    {
       
        meshRenderer = gameObject.GetComponent<Renderer>();
        material = meshRenderer.material;
       

    }

    // Update is called once per frame
    void Update()
    {
    
        float currentHealth = FindObjectOfType<PlayerController>().currentHeath;
        float maxHealth = FindObjectOfType<PlayerController>().maxhealth;
        float range = currentHealth / maxHealth;
        if (range < 0.4)
        {
            material.SetFloat("_Low_health", 1);
        }
    }
}
