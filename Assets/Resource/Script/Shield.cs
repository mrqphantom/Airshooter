using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shield : MonoBehaviour
{
    ParticleSystem particle;
    public Color color1;
    public Color color2;
    public Color color3;
    public Color color4;
    public Color color5;
    public float Size;
    Gradient gra;
    public List<ParticleCollisionEvent> collisionEvents;
    public GameObject HitShield;



    // Start is called before the first frame update
    void Start()
    {
        ParticleSystem ps = GetComponent<ParticleSystem>();
        var color = ps.main;
        color.startColor = Color.white;
        StartCoroutine(Delay());

    }

    IEnumerator Delay()
    {
        ParticleSystem ps = GetComponent<ParticleSystem>();
        var colgradient = ps.colorOverLifetime;
        var partilceEnable = ps.emission;
        var particleMain = ps.main;
        

        colgradient.enabled = true;

        Gradient grad = new Gradient();
        grad.SetKeys(

            new GradientColorKey[] { new GradientColorKey(color1, 0.0f), new GradientColorKey(color2, 1.0f)},

            new GradientAlphaKey[] { new GradientAlphaKey(1.0f, 0.0f), new GradientAlphaKey(0.0f, 1.0f) });

        colgradient.color = grad;
        yield return new WaitForSeconds(13f);
        particleMain.startLifetime = 0.2f;
        grad.SetKeys(

            new GradientColorKey[] { new GradientColorKey(color3, 0.0f), new GradientColorKey(color4, 0.3f), new GradientColorKey(color3, 0.6f), new GradientColorKey(color4, 0.8f), new GradientColorKey(color3, 1f) }, 

            new GradientAlphaKey[] { new GradientAlphaKey(1.0f, 0.0f), new GradientAlphaKey(0.0f, 0.3f), new GradientAlphaKey(1f, 0.6f), new GradientAlphaKey(0.0f, 0.8f), new GradientAlphaKey(1f, 1f) });

        colgradient.color = grad;
       
        particleMain.loop = false;
        yield return new WaitForSeconds(2f);
        Destroy(gameObject);

    }
    public IEnumerator colorHit()
    {
        ParticleSystem ps = GetComponent<ParticleSystem>();
        var color = ps.main;
        color.startColor = color5;
        yield return new WaitForSeconds(1f);
        color.startColor = Color.white;
    }
    void OnParticleCollision(GameObject other)
    {
        if (other.CompareTag("Enemy"))
        {      
            StartCoroutine(colorHit());
        }
    }

}
