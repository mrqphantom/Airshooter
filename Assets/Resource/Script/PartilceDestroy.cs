﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PartilceDestroy : MonoBehaviour
{
    // Start is called before the first frame update
    void OnTriggerEnter(Collider other)
    {
        Destroy(other.gameObject);
     
    }

}
