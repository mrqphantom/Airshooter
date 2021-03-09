using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lazer : MonoBehaviour
{
    public float lazerWith = 1f;
    public float maxlength = 50f;
    public Color color = Color.blue;
    public LineRenderer lineRenderer;
    Transform LauncherLaze;
     public MeshCollider meshCollider;
    public Mesh mesh;
    int length;
    
    public GameObject[] targets;
    float thisDistance;
    // Start is called before the first frame update
    void Start()
    {

        

    }

    // Update is called once per frame
    void Update()
    {
       
       
        LauncherLaze = GameObject.FindWithTag("LauncherLaze").transform;
        lineRenderer = GetComponent<LineRenderer>();
     
       targets = GameObject.FindGameObjectsWithTag("Enemy");
        if(targets.Length == 0)
        {
            lineRenderer.SetPosition(1, LauncherLaze.transform.up * 500);
            return;
        }
   if(targets.Length >= 1)
        {   
            GameObject closettarget = targets[0];
            float closetDistance = Vector3.Distance(transform.position, closettarget.transform.position);

            for (int i = 1; i < targets.Length; i++)
            {
                thisDistance = Vector3.Distance(transform.position, targets[i].transform.position);
                if (thisDistance < closetDistance)
                {
                    closettarget = targets[i];
                    closetDistance = thisDistance;


                }
            }
            
          
            lineRenderer.SetPosition(0, LauncherLaze.position);
            RaycastHit hit;
            if (Physics.Raycast(LauncherLaze.position, transform.forward, out hit))
            {
                if (hit.collider)
                {
         
                    lineRenderer.SetPosition(1,closettarget.transform.position);
                    closettarget.transform.localScale -= new Vector3(2f , 2f, 2f)*Time.deltaTime;
                    Destroy(closettarget, 0.5f);

                }
            }
            else
                lineRenderer.SetPosition(1, transform.up* 500);
        }
       
       


    }
}
