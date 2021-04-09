using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthShader : MonoBehaviour
{
    public Renderer meshRenderer;
    public Material material;
    public float range;
    PlayerController player;
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
        range = currentHealth / maxHealth;
        material.SetFloat("_progressing_control", range);
        if (range==0)
        {
            Destroy(gameObject);
        }

      

    
    }
 
}
