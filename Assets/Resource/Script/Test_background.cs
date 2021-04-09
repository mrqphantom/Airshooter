using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test_background : MonoBehaviour
{
    public Material Materialspeed;
    public float speedBackground;
    PlayerController playerController;
    
    
    // Start is called before the first frame update
    void Start()
    {
        playerController = FindObjectOfType<PlayerController>();
  
    }

    // Update is called once per frame
    void Update()
    {
        speedBackground +=Time.deltaTime/10;
        if (playerController.speed>25)
        {
            
            Materialspeed.SetFloat("SpeedBackground", speedBackground+=Time.deltaTime/5);
        }
        else
        {
            Materialspeed.SetFloat("SpeedBackground", speedBackground);
        }
    }
}
