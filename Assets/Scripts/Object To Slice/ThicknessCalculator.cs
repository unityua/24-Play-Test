using UnityEngine;

namespace GameLogic.WholseObjectStates
{
    [System.Serializable]
    public class ThicknessCalculator
    {
        [SerializeField] private float _defaultSliceRadius;
        [SerializeField] private float _additionalRadiusPerUnit;
        [Space]
        [SerializeField] private float _maxDeviation = 0.5f;
        [SerializeField] private float _minDeviation = 0.3f;

        private float _currentCutRadius;
        private float _currentDeviation;
        private float _currentPointX;

        private Vector3 _lastCutPosition;


        public float CurrentCutRadius => _currentCutRadius;
        public float CurrentDeviation => _currentDeviation;
        public float CurrentPointX => _currentPointX;


        public void Initialize(WholeObjectToSlice wholeObject)
        {
            Bounds meshBounds = wholeObject.MeshBounds;

            _lastCutPosition.y += meshBounds.center.y + meshBounds.extents.y;
            _lastCutPosition.z += (meshBounds.center.z - meshBounds.extents.z);

            _currentCutRadius = _defaultSliceRadius;
            _currentDeviation = _maxDeviation;
            _currentPointX = 0;
        }

        public void Recalculate(Vector3 newLocalCutPosition)
        {
            float zDistance = Mathf.Abs(newLocalCutPosition.z - _lastCutPosition.z);

            _lastCutPosition.z = newLocalCutPosition.z;

            _currentCutRadius = _defaultSliceRadius + _additionalRadiusPerUnit * zDistance;

            if (_currentCutRadius < _minDeviation)
                _currentDeviation = _minDeviation;
            else if (_currentCutRadius > _maxDeviation)
                _currentDeviation = _maxDeviation;
            else
                _currentDeviation = _currentCutRadius;

            if (newLocalCutPosition.z > 0f)
                _currentPointX = -newLocalCutPosition.z;
        }

#if UNITY_EDITOR
        public void OnDrawGizmosSelectedCustom(Vector3 worldPosition)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawSphere(worldPosition + _lastCutPosition, 0.15f);
        }
#endif
    }
}