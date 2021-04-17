using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Infor : MonoBehaviour
{
    public int damageBomb=10;
    public int damagePlayerRocket = 2;
    public int damagePlayerLaze = 1;
    public int damagePlayerHaze = 3;
    public int damageBullet = 1;
    int default_damageBomb, default_damagePlayerRocket, default_damagePlayerLaze, default_damagePlayerHaze,default_damageBullet;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    void resetDamage()
    {
        default_damageBomb = damageBomb;
        default_damagePlayerRocket = damagePlayerRocket;
        default_damagePlayerLaze = damagePlayerLaze;
        default_damageBullet = damageBullet;
        default_damagePlayerHaze = damagePlayerHaze;
    }
}
