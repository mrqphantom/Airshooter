using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthShader : MonoBehaviour
{
    public Renderer meshRenderer;
    public Material material;
    public float range;

    public float currentValue = -1;
    public float targetValue = -1;
    public GameObject Player;
    PlayerController player;
    // Start is called before the first frame update
    void Start()
    {
        Player = GameObject.FindGameObjectWithTag("Player");
        meshRenderer = gameObject.GetComponent<Renderer>();
        material = meshRenderer.material;
    }

    // Update is called once per frame
    void Update()
    {
        if (Player)
        {
            var dt = Time.deltaTime;
            float currentHealth = FindObjectOfType<PlayerController>().currentHeath;
            float maxHealth = FindObjectOfType<PlayerController>().maxhealth;
            if (maxHealth == 0)
            {
                return;
            }
            var range = currentHealth / maxHealth;
            if (this.currentValue <= 0)
            {
                this.currentValue = range;
            }
            if (range != this.currentValue)
            {
                this.targetValue = range;
            }

            if (this.currentValue != this.targetValue && this.targetValue >= 0)
            {
                this.currentValue += (this.targetValue - this.currentValue) * dt / 0.1f;
                if (this.currentValue < 0)
                {
                    this.currentValue = 0;
                }
                this.material.SetFloat("_progressing_control", this.currentValue);
            }
            if (this.currentValue <= 0)
            {
                Destroy(gameObject);
            }
        }

    }
}
