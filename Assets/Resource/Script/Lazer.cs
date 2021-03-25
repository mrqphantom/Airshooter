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
    List<GameObject> targets;

    float thisDistance;
    // Start is called before the first frame update
    void Start()
    {
        LauncherLaze = GameObject.FindWithTag("LauncherLaze").transform;
        lineRenderer.SetPosition(0, LauncherLaze.position);
        lineRenderer = lineRenderer.GetComponent<LineRenderer>();
        lineRenderer.startWidth = lazerWith;
        lineRenderer.endWidth = lazerWith / 2;
        LauncherLaze = GameObject.FindWithTag("LauncherLaze").transform;

        this.targets = this.FindTargets(2, 0);
        Debug.Log("Targets " + this.targets.Count);

        if (this.targets.Count == 0)
        {
            lineRenderer.startWidth = lazerWith / 3;
            Destroy(this.gameObject);
        } else
        {
            Destroy(gameObject, 0.35f);
            Destroy(particleHitActive, 0.5f);
        }
        lineRenderer.SetPosition(1, new Vector3(0, 50, 0));

    }

    List<GameObject> FindTargets(int count, float view)
    {
        var r = new List<GameObject>();
        var p = transform.position;
        var targets = new List<GameObject>(GameObject.FindGameObjectsWithTag("Enemy"));
        for (var i = 0; i < count; i++)
        {
            var target = this.FindTarget(p, view, targets);
            if (target == null)
            {
                break;
            }
            r.Add(target);
            targets.Remove(target);
            p = target.transform.position;
        }
        return r;
    }

    GameObject FindTarget(Vector3 pos, float view, List<GameObject> targets)
    {
        var r = (GameObject)null;
        var min = float.MaxValue;
        foreach (var m in targets)
        {
            var v = m.transform.position - pos;
            var d = Vector3.Distance(pos, m.transform.position);
            if (d < min)
            {
                r = m;
                min = d;
            }
        }
        return r;
    }

    GameObject findTarget()
    {
        GameObject closettarget = null;
        GameObject[] targets = GameObject.FindGameObjectsWithTag("Enemy");
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

        if (this.targets.Count == 0)
        {
            lineRenderer.SetPosition(1, new Vector3(0, 50, 0));
            return;
        }
        var p = new List<Vector3>();
        p.Add(transform.position);
        foreach (var m in this.targets)
        {
            if (m == null)
            {
                continue;
            }
            p.Add(m.transform.position);
        }
        this.lineRenderer.positionCount = p.Count;
        this.lineRenderer.SetPositions(p.ToArray());

        foreach (var m in this.targets)
        {
            if (m == null)
            {
                continue;
            }
            m.GetComponent<Mover>().run(0f);
            m.GetComponent<DestroybyContact>().DestroyObject();
        }

    }
}
