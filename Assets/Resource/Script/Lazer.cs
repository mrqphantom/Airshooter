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
    MeshCollider meshCollider;
    Mesh mesh;
    ParticleSystem particleHitActive;
    public ParticleSystem hitParticle;
    bool partilceOnce = false;
    int length;
  
    
    public GameObject[] targets;
    float thisDistance;
    // Start is called before the first frame update
    void Start()
    {
        lineRenderer = lineRenderer.GetComponent<LineRenderer>();
        meshCollider = gameObject.AddComponent<MeshCollider>();


        Mesh mesh = new Mesh();
        lineRenderer.BakeMesh(mesh, true);
        meshCollider.sharedMesh = mesh;



    }

    // Update is called once per frame
    void Update()
    {
       

        LauncherLaze = GameObject.FindWithTag("LauncherLaze").transform;
       

        lineRenderer.SetPosition(0, LauncherLaze.position);

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
            
    
            RaycastHit hit;
            if (Physics.Raycast(LauncherLaze.position, transform.forward, out hit))
            {
                if (hit.collider)
                {
         
                    lineRenderer.SetPosition(1,closettarget.transform.position);
                   
                    closettarget.GetComponent<Mover>().run(0f);
                    
                    if (!partilceOnce)
                    {
                        particleHitActive = Instantiate(hitParticle, closettarget.transform.position, closettarget.transform.rotation);
                        
                        partilceOnce = true;
                    }
                    Destroy(closettarget, 0.5f);
                    Destroy(gameObject, 0.5f);
                    Destroy(particleHitActive, 0.5f);
                }
            }
            else
                lineRenderer.SetPosition(1, transform.up* 500);
        }
       
       


    }
}
