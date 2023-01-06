using UnityEngine.SceneManagement;
using UnityEngine;

namespace GameLogic.SimpleUI
{
    public class RestartLevel : MonoBehaviour
    {
        [SerializeField] private bool _hideOnStart;
        [Space]
        [SerializeField] private MainPartsMover _mainPartsMover;

        private void Start()
        {
            _mainPartsMover.ReachedTarget += OnLevelReachedEnd;

            gameObject.SetActive(!_hideOnStart);
        }

        private void Update()
        {
            if (Input.GetMouseButtonUp(0))
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().name);
            }
        }

        private void OnLevelReachedEnd(MainPartsMover partsMover)
        {
            gameObject.SetActive(true);
        }
    }
}