using UnityEngine;


namespace GameLogic.SimpleUI
{
    public class TapToPlay : MonoBehaviour
    {
        [SerializeField] private MainPartsMover _mainPartsMover;

        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                _mainPartsMover.StartMoving();
                gameObject.SetActive(false);
            }
        }
    }
}