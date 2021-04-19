using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameUI : MonoBehaviour
{
    public int points = 0;
    public Text ScoreText;
    public GameObject PausePanel;
    public GameObject LosePanel;
    GameObject Player;
    public bool isPause =false;
    
  
    // Start is called before the first frame update
    void Start()
    {
        ScoreText.text = "Score: " + points;
        LosePanel.SetActive(false);
        Player = GameObject.FindGameObjectWithTag("Player");
        
    }
    
    public void Restart()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
    public void Resume()
    {
        isPause = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Escape))
        {
            isPause = !isPause;
        }
        if(isPause == true)
        {
            Time.timeScale = 0f;
            PausePanel.SetActive(true);
       
        }
        if(isPause==false)
        {
            Time.timeScale = 1f;
            PausePanel.SetActive(false);
       
        }
        if(Player==null)
        {
            StartCoroutine(timelose());
        }
    }
    public void ScoreIncrease()
    {
        points++;
        ScoreText.text = "Score: " + points;
    }
    IEnumerator timelose()
    {
        yield return new WaitForSeconds(0.5f);
        LosePanel.SetActive(true);
    }

}
