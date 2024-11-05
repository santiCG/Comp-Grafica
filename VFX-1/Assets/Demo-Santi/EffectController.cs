using UnityEngine;
using UnityEngine.VFX;
using UnityEngine.UI;
using TMPro;
using UnityEngine.Playables;
using UnityEditor.UI;

public class EffectController : MonoBehaviour
{
    private PlayableDirector currentDirector;
    
    [SerializeField] private TMP_Dropdown effectDropdown; // El dropdown que selecciona el efecto.
    [SerializeField] private Button pauseButton; // El dropdown que selecciona el efecto.
    private TextMeshProUGUI pauseButtonText; // El dropdown que selecciona el efecto.

    [SerializeField] private PlayableDirector[] directors;

    private void Start()
    {
        pauseButtonText = pauseButton.GetComponentInChildren<TextMeshProUGUI>();

        foreach (var director in directors)
        {
            director.Stop();
        }

        // Inicializa el efecto seleccionado.
        if (directors.Length > 0)
        {
            currentDirector = directors[0];
        }

        //// Escucha los cambios del dropdown.
        effectDropdown.onValueChanged.AddListener(delegate { ChangeEffect(); });
    }

    public void ChangeEffect()
    {
        // Cambia el efecto actual según el valor del dropdown.
        int index = effectDropdown.value;

        if (index >= 0 && index < directors.Length)
        {
            currentDirector = directors[index];
        }
    }

    public void PlayEffect()
    {
        if (currentDirector != null)
        {
            currentDirector.Play();
        }
    }

    public void PauseEffect()
    {
        if (currentDirector.state == PlayState.Playing)
        {
            Time.timeScale = 0f;
            currentDirector.Pause();
            pauseButtonText.text = "Resume";
            pauseButton.GetComponent<Image>().color = Color.red;
        }
        else if (currentDirector.state == PlayState.Paused)
        {
            Time.timeScale = 1.0f;
            currentDirector.Resume();
            pauseButtonText.text = "Pause";
            pauseButton.GetComponent<Image>().color = Color.blue;
        }
    }
}
