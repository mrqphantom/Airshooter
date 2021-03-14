using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartmoveAnimation : MonoBehaviour
{
    Vector3 targetPosition1;
    float StartSpeed;
    void Start()
    {
        StartCoroutine(MoveOverSpeed(targetPosition1,StartSpeed));
    }

    public IEnumerator MoveOverSpeed(Vector3 targetPosition,float speed)
    {
       
        while (transform.position != targetPosition)
        {
            transform.position = Vector3.MoveTowards(transform.position, targetPosition, speed * Time.deltaTime);
            yield return new WaitForEndOfFrame();
        }
    }

  
}
