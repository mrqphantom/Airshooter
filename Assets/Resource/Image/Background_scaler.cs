using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Background_scaler : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
       
            var worldHeight = Camera.main.orthographicSize * 2;
            var worldWight = worldHeight * Screen.width / Screen.height;
        transform.localScale = new Vector3(worldWight, worldHeight, 0);
    
    }
}

  
