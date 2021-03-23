using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lazer : MonoBehaviour
{
    public float lazerWith = 1f;
    public float maxlength = 50f;
    public LineRenderer lineRenderer;
    Transform LauncherLaze;
    
  
    ParticleSystem particleHitActive;
    public ParticleSystem hitParticle;
    
    int length;
    GameObject closettarget;


    public GameObject[] targets;
    float thisDistance;
    // Start is called before the first frame update
    void Start()
    {
        LauncherLaze = GameObject.FindWithTag("LauncherLaze").transform;
        lineRenderer.SetPosition(0, LauncherLaze.position);
        lineRenderer = lineRenderer.GetComponent<LineRenderer>();
        lineRenderer.startWidth = lazerWith;
        lineRenderer.endWidth = lazerWith/2;
        LauncherLaze = GameObject.FindWithTag("LauncherLaze").transform;
        closettarget = this.findTarget();
        if (closettarget == null)
        {
            lineRenderer.startWidth = lazerWith/3;
            Destroy(this.gameObject);
        }
       
        lineRenderer.SetPosition(1, new Vector3(0, 50, 0));
    
}
  
    GameObject findTarget()
    {
        GameObject closettarget = null;
        targets = GameObject.FindGameObjectsWithTag("Enemy");
        if (targets.Length >= 1)
        {
            closettarget = targets[0];
            float closetDistance = Vector3.Distance(transform.position, closettarget.transform.position);

            for (int i = 1; i < targets.Length; i++)
            {
                float thisDistance = Vector3.Distance(transform.position, targets[i].transform.position);
                if (thisDistance < closetDistance || closettarget == this.closettarget)
                {
                    closettarget = targets[i];
                    closetDistance = thisDistance;
                }
            }
        }
        return closettarget;
    }

    void Update()
    {
        lineRenderer.SetPosition(0, LauncherLaze.position);

        if (closettarget == null)
        {
            lineRenderer.SetPosition(1, new Vector3(0, 50, 0));
            return;
        }

       
        lineRenderer.SetPosition(1, closettarget.transform.position);
        RaycastHit hit;
        if (Physics.Raycast(LauncherLaze.position,transform.forward, out hit))
        {
            if (hit.collider)
            {
                closettarget.GetComponent<Mover>().run(0f);
                closettarget.GetComponent<DestroybyContact>().DestroyObject();
                Destroy(gameObject,0.35f);
                Destroy(particleHitActive, 0.5f);
            }
        }
        else
        {
            lineRenderer.SetPosition(1,new Vector3(0,1000,0));
        }
     
    }
}
