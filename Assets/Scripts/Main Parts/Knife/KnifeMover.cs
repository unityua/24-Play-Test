using UnityEngine;

namespace GameLogic.Knife
{
    public class KnifeMover : MonoBehaviour, IKnifeMotion
    {
        [SerializeField] private Vector3 _topPosition;
        [SerializeField] private Vector3 _bottomPosition;
        [Space]
        [SerializeField] private float _sliceSpeed;
        [SerializeField] private float _releaseSpeed;

        private float _currentSpeed;
        private Vector3 _targetPosition;

        private void Start()
        {
            transform.localPosition = _topPosition;
            _targetPosition = _topPosition;
        }

        private void Update()
        {
            if (transform.localPosition == _targetPosition)
                return;

            transform.localPosition = Vector3.MoveTowards(transform.localPosition, _targetPosition, _currentSpeed * Time.deltaTime);
        }

        public void StartMotion()
        {
            _targetPosition = _bottomPosition;
            _currentSpeed = _sliceSpeed;
        }

        public void EndMotion()
        {
            _targetPosition = _topPosition;
            _currentSpeed = _releaseSpeed;
        }
    }
}