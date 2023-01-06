using UnityEngine;

namespace GameLogic.Knife
{
    public class KnifeRotator : MonoBehaviour, IKnifeMotion
    {
        [SerializeField] private Vector3 _idleRotation;
        [SerializeField] private Vector3 _sliceRotation;
        [SerializeField] private float _timeToRotate;
        [SerializeField] private AnimationCurve _rotationCurve;

        private Quaternion _idleRotationQuaternion;
        private Quaternion _sliceRotationQuaternion;

        private float _t = 100f;
        private Quaternion _startRotation;
        private Quaternion _targetRotation;

        void Start()
        {
            _idleRotationQuaternion = Quaternion.Euler(_idleRotation);
            _sliceRotationQuaternion = Quaternion.Euler(_sliceRotation);

            transform.localRotation = _idleRotationQuaternion;
        }

        private void Update()
        {
            if (_t > 1f)
                return;

            _t += Time.deltaTime / _timeToRotate;
            float curvedT = _rotationCurve.Evaluate(_t);

            Quaternion newRotation = Quaternion.Lerp(_startRotation, _targetRotation, curvedT);
            transform.localRotation = newRotation;
        }

        public void StartMotion()
        {
            ResetMotionParameters();
            _targetRotation = _sliceRotationQuaternion;
        }

        public void EndMotion()
        {
            ResetMotionParameters();
            _targetRotation = _idleRotationQuaternion;
        }

        private void ResetMotionParameters()
        {
            _t = 0f;
            _startRotation = transform.localRotation;
        }
    }
}