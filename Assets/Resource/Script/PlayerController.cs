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
    public Light light;
    public GameObject muzzle1, muzzle2;
    public GameObject rocket;
    RocketLauncher rocketLauncher;
    public ParticleSystem haze;
    public GameObject laze;
    GameObject obj = null;
    bool Rpressed = false;
    void Start()
    {
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
            muzzle1.SetActive(true);
            muzzle2.SetActive(true);
            nextFire = Time.time + fireRate;
            Instantiate(bullet, firePoint1.position, firePoint1.rotation);
            Instantiate(bullet, firePoint2.position, firePoint2.rotation);
            Instantiate(light, lightpoint.position, lightpoint.rotation);



        }
        else
        {
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
            Instantiate(haze, hazePoint.position, hazePoint.rotation);

        }
        if ((Input.GetKeyDown(KeyCode.R)) && !Rpressed)
        {
            Rpressed = true;
        }
        else if (Input.GetKeyUp(KeyCode.R))
        {
            Rpressed = false;
            if (this.obj != null)
            {
                Destroy(this.obj);
                this.obj = null;
            }

        }
        if (Rpressed && this.obj == null)
        {
            Debug.Log("create obj");
            this.obj = Instantiate(laze, lazePoint.position, lazePoint.rotation);
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

}
