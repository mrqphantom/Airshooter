using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class Boundary
{
    public float minX, maxX, minY, maxY;

}
public class PlayerController : MonoBehaviour
{   public int maxhealth = 100;
    public int currentHeath;
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
    public GameObject light_point,particle_trail1,particle_trail2;
    public GameObject muzzle1, muzzle2;
    public ParticleSystem haze;
    public GameObject rocket, lazeStartParticle, smoke, ParticleSpeed,HitPartilce,ShieldParticle;
    RocketLauncher rocketLauncher;
    public GameObject laze;
    GameObject objLaze = null;
    GameObject objParticleLaze = null;
    bool Rpressed = false;
    public ParticleSystem playerExplosion;
    public float TimeFreeze;
    public GameObject stun;
    GameObject stunObj,obj,speedObj;
    bool Onetime = false;
    ShakeCamera shakeCamera;
    public HealthBar healthBar;
    HealthShader healthShader;
    public float currentvalue;




     void Start()
    {
        currentHeath = maxhealth;
        healthBar.Setmaxhealth(maxhealth);
        light_point.SetActive(false);
        muzzle1.SetActive(false);
        muzzle2.SetActive(false);
        rigid = GetComponent<Rigidbody>();
        rocketLauncher = GameObject.FindGameObjectWithTag("Launcher").GetComponent<RocketLauncher>();
        haze.Stop();
    }
    void Update()
    {
        if (ShieldParticle)
        {
           
                FindObjectOfType<HealthShader>().material.SetFloat("_Shield", 1);
                FindObjectOfType<HealthShader>().material.SetFloat("_Hit", 0);
          
        }
        else if (!ShieldParticle)
        {
            
           
                FindObjectOfType<HealthShader>().material.SetFloat("_Shield", 0);
            
        }

        if (currentHeath<=30)
        {if (!Onetime)
            {
                obj = Instantiate(smoke, transform.position, Quaternion.identity);
                obj.transform.parent = transform;
                Onetime = true;
            }
            StartCoroutine(LowHealth());
        }
        if ((Input.GetKey(KeyCode.Space)) && Time.time > nextFire)
        {
            StartCoroutine(waitMuzzle());
            nextFire = Time.time + fireRate;
            Instantiate(bullet, firePoint1.position, firePoint1.rotation);
            Instantiate(bullet, firePoint2.position, firePoint2.rotation);
            light_point.SetActive(true);
            light_point.GetComponent<Light>().color = Color.red;
           
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
        if (Input.GetKey(KeyCode.Q)&& Time.time>nextFire)
        {
            nextFire = Time.time + 0.025f;
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
            light_point.GetComponent<Light>().color = Color.red;
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
        if (Rpressed && this.objLaze == null&& Time.time>nextFire)
        {
            nextFire = Time.time + 1f;
            this.objLaze = Instantiate(laze, lazePoint.position, transform.rotation);
            this.objLaze.transform.parent = this.transform;
        }
        if(currentHeath<=0)
        {
            StartCoroutine(Death());
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
    public void takeDamage(int damage)

    {
        
        currentHeath -= damage;
    
        healthBar.setHealth(currentHeath);
    }
    IEnumerator Death()
    {
        
        yield return new WaitForSeconds(0.02f);
        Instantiate(playerExplosion, transform.position, transform.rotation);
        Destroy(gameObject);


    }
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Enemy"))
        {
            StartCoroutine(Hit());
            StartCoroutine(HitHealthBar());
            GameObject.Find("Main Camera").AddComponent<ShakeCamera>().shakeDuration = 20f;
            GameObject.Find("Main Camera").AddComponent<ShakeCamera>().shakeAmount = 1f;
            GameObject.Find("Main Camera").AddComponent<ShakeCamera>().decreaseFactor = 10f;
            StartCoroutine(OnCollisionWithObstacle());
        }
        if(other.CompareTag("ItemSpeedUp"))
        {
            StartCoroutine(SpeedUp());
            StartCoroutine(SpeedUpHit());
            Instantiate(HitPartilce, other.gameObject.transform.position, other.gameObject.transform.rotation);
            Destroy(other.gameObject);

           
        }  
        if(other.CompareTag("ItemShield"))
        {
            
                ShieldUp();
                Destroy(other.gameObject);
                Instantiate(HitPartilce, other.gameObject.transform.position, other.gameObject.transform.rotation);
            
        }

    }
    public IEnumerator OnCollisionWithObstacle()
    {
        if (!Onetime)
        {
            stunObj = Instantiate(stun, transform.position, transform.rotation);
            stunObj.transform.parent = transform;
            Onetime = true;
          
        }
     
        speed /= 3;
        fireRate *= 2;
        yield return new WaitForSeconds(1f);
        speed *= 3;
        fireRate /= 2;
        Destroy(stunObj);
        Onetime = false;
    }

    IEnumerator LowHealth()
    {
        while(true)
        {
            yield return new WaitForSeconds(0.65f);
            light_point.GetComponent<Light>().color = Color.red;
            light_point.GetComponent<Light>().intensity = 0.35f;
            light_point.SetActive(true);
            yield return new WaitForSeconds(0.3f);
            light_point.SetActive(false);

        }
    }
    public IEnumerator Hit()
    {
        
        FindObjectOfType<PlayerShader>().material.SetFloat("_Hit", 1f);
        yield return new WaitForSeconds(0.75f);
       FindObjectOfType<PlayerShader>().material.SetFloat("_Hit", 0f);
        yield return new WaitForSeconds(0.1f);

    }
    public IEnumerator HitHealthBar()
    {
        FindObjectOfType<HealthShader>().material.SetFloat("_Hit", 1f);
        yield return new WaitForSeconds(0.05f);
        FindObjectOfType<HealthShader>().material.SetFloat("_Hit", 0f);

    }
    public IEnumerator SpeedUp()
    {
            ParticleSystem Ps1 = particle_trail1.GetComponent<ParticleSystem>();
            ParticleSystem Ps2= particle_trail2.GetComponent<ParticleSystem>();
            var main1 = Ps1.main;
            var main2 = Ps2.main;
            main1.startColor = Color.cyan;
            main1.startSpeed = 2.35f;
            main2.startColor = Color.cyan;
            main2.startSpeed = 2.35f;
        Vector3 tranformObj = new Vector3(transform.position.x, transform.position.y,0.04f);
            FindObjectOfType<PlayerShader>().material.SetFloat("_SpeedUp", 1);
            speedObj = Instantiate(ParticleSpeed, tranformObj, transform.rotation);
            speedObj.transform.parent = transform;
            speed = speed * 1.5f;
            Onetime = false;
      
        yield return new WaitForSeconds(5f);
        ResetTrail();
        FindObjectOfType<PlayerShader>().material.SetFloat("_SpeedUp",0);
        speed = speed / 1.5f;
        Destroy(speedObj);

    }
    void ShieldUp()
    {
        obj = Instantiate(ShieldParticle, transform.position, transform.rotation);
        obj.transform.parent = transform;



    }
    public IEnumerator SpeedUpHit()
    {
        FindObjectOfType<PlayerShader>().material.SetFloat("_SpeedUpHit", 1);
        yield return new WaitForSeconds(0.35f);
        FindObjectOfType<PlayerShader>().material.SetFloat("_SpeedUpHit", 0);
    }
    void ResetTrail()
    {
        ParticleSystem Ps1 = particle_trail1.GetComponent<ParticleSystem>();
        ParticleSystem Ps2 = particle_trail2.GetComponent<ParticleSystem>();
        var main1 = Ps1.main;
        var main2 = Ps2.main;
        main1.startColor = Color.white;
        main1.startSpeed = Random.Range(0.6f, 1f);
        main2.startColor = Color.white;
        main2.startSpeed = 2;
        main2.startSpeed = Random.Range(0.6f, 1f);

    }
}
