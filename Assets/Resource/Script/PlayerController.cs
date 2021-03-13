using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class Boundary
{
    public float minX, maxX, minY, maxY;

}
public class PlayerController : MonoBehaviour
{
    public Boundary boundary;
    public float speed = 0.5f;
    public float tilt;
    public Rigidbody rigid;
    public GameObject bullet;
    public Transform firePoint1, firePoint2, lightpoint, hazePoint, lazePoint;
    public float fireRate;
    private float nextFire;
    public float fireRocketRate;
    private float nextRocket;
    public GameObject light_point;
    public GameObject muzzle1, muzzle2;
    public ParticleSystem haze;
    public GameObject rocket, lazeStartParticle;
    RocketLauncher rocketLauncher;
    public GameObject laze;
    GameObject objLaze = null;
    GameObject objParticleLaze = null;
    bool Rpressed = false;
    void Start()
    {
        light_point.SetActive(false);
        muzzle1.SetActive(false);
        muzzle2.SetActive(false);
        rigid = GetComponent<Rigidbody>();
        rocketLauncher = GameObject.FindGameObjectWithTag("Launcher").GetComponent<RocketLauncher>();
        haze.Stop();
    }
    void Update()
    {
        if ((Input.GetKey(KeyCode.Space)) && Time.time > nextFire)
        {
            StartCoroutine(waitMuzzle());
            nextFire = Time.time + fireRate;
            Instantiate(bullet, firePoint1.position, firePoint1.rotation);
            Instantiate(bullet, firePoint2.position, firePoint2.rotation);
            light_point.SetActive(true);
            light_point.GetComponent<Light>().color = Color.yellow;
           
        }
      
    
        else if(Input.GetKeyUp(KeyCode.Space))
        {
            light_point.SetActive(false);
            muzzle1.SetActive(false);
            muzzle2.SetActive(false);
        }

        
        if (Input.GetKey(KeyCode.E) && Time.time > nextRocket)
        {
            nextRocket = Time.time + fireRocketRate;
            StartCoroutine(rocketLauncher.launchRocket());
        }
        if (Input.GetKey(KeyCode.Q))
        {
            light_point.SetActive(true);
            light_point.GetComponent<Light>().color = Color.red;
            Instantiate(haze, hazePoint.position, hazePoint.rotation);

        }
        else if(Input.GetKeyUp(KeyCode.Q))
        {
            light_point.SetActive(false);
        }
        if (Input.GetKey(KeyCode.R))
        {

            light_point.SetActive(true);
            light_point.GetComponent<Light>().color = Color.cyan;
            this.objParticleLaze = Instantiate(lazeStartParticle, lazePoint.position, lazePoint.rotation);
            this.objParticleLaze.transform.parent = this.transform;
            Destroy(this.objParticleLaze,0.2f);
        }
        if ((Input.GetKeyDown(KeyCode.R)) && !Rpressed)
        {
            Rpressed = true;
        }
        else if (Input.GetKeyUp(KeyCode.R))
        {
            light_point.SetActive(false);
            Rpressed = false;
            if (this.objLaze != null)
            {
                
                Destroy(this.objLaze);
                this.objLaze = null;
               
            }

        }
        if (Rpressed && this.objLaze == null)
        {
            this.objLaze = Instantiate(laze, lazePoint.position, transform.rotation);
            this.objLaze.transform.parent = this.transform;
        }
       
    }
    void FixedUpdate()
    {
        float moveX = Input.GetAxis("Horizontal");
        float moveY = Input.GetAxis("Vertical");
        Vector3 movement = new Vector3(moveX, moveY, 0f);
        rigid.velocity = movement * speed * Time.deltaTime;
        rigid.position = new Vector3(
            Mathf.Clamp(rigid.position.x, boundary.minX, boundary.maxX),
            Mathf.Clamp(rigid.position.y, boundary.minY, boundary.maxY),
            0.0f
            );
        rigid.rotation = Quaternion.Euler(90f, rigid.velocity.x * -tilt, 180f);

    }
    IEnumerator waitMuzzle()
    {

        muzzle1.SetActive(true);
        muzzle2.SetActive(true);
        yield return new WaitForSeconds(0.1f);
        muzzle1.SetActive(false);
        muzzle2.SetActive(false);
        yield return new WaitForSeconds(0.2f);


    }

}
