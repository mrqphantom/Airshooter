using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test_background : MonoBehaviour
{
    public Material Materialspeed;
    public float speedBackground;
    public GameObject SpeedUpPartilce;
    
    
    // Start is called before the first frame update
    void Start()
    {
        
        Materialspeed.SetVector("Vector2_7287DD1B", new Vector2(0, speedBackground));

    }

    // Update is called once per frame
    void Update()
    {
        if(SpeedUpPartilce)
        {
            Materialspeed.SetVector("Vector2_7287DD1B", new Vector2(0, 2f));

        }
    }
}
