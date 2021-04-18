using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test_background : MonoBehaviour
{
    public Material Materialspeed;
    public float speedBackground=0;
    PlayerController playerController;
    
    
    // Start is called before the first frame update
    void Start()
    {
        playerController = FindObjectOfType<PlayerController>();
  
    }

    // Update is called once per frame
    void Update()
    {
       
        if (playerController.isSpeedUp==true)
        {

            SlowSpeed();
        }
        else if(playerController.isSpeedUp==false)
        {
            defaultSpeed();
        }
    }
    void defaultSpeed()
    {
        Materialspeed.SetFloat("SpeedBackground", speedBackground+=Time.deltaTime/4);
    }
    void SlowSpeed()
    {
        Materialspeed.SetFloat("SpeedBackground", speedBackground += Time.deltaTime / 15);
    }
}
