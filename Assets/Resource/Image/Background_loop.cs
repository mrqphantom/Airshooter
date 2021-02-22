using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Background_loop : MonoBehaviour
{
    public float speed = 0.5f;
    private Vector2 _offset = Vector2.zero;
    private Material _mat;
    // Start is called before the first frame update
    void Start()
    {
        _mat = GetComponent<Renderer>().material;
        _offset = _mat.GetTextureOffset("_MainTex");
    }

    // Update is called once per frame
    void Update()
    {
        _offset.y += speed * Time.deltaTime;
        _mat.SetTextureOffset("_MainTex", _offset);
    }
}
