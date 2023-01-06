using UnityEngine;

namespace GameLogic.Knife
{
    public class KnifeInput : MonoBehaviour
    {
        [SerializeField] private KnifeMover _mover;
        [SerializeField] private KnifeRotator _rotator;

        private bool _isSlicing;

        public bool IsSlicing => _isSlicing;

        private void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                _isSlicing = true;
                _mover.StartMotion();
                _rotator.StartMotion();
            }
            else if (Input.GetMouseButtonUp(0))
            {
                _isSlicing = false;
                _mover.EndMotion();
                _rotator.EndMotion();
            }
        }
    }
}