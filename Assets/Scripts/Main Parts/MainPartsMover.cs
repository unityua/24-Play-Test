using System;
using System.Collections.Generic;
using UnityEngine;

namespace GameLogic
{
    public class MainPartsMover : MonoBehaviour
    {
        [SerializeField] private bool _moveOnStart;
        [Space]
        [SerializeField] private Vector3 _startPosition;
        [SerializeField] private Vector3 _endPosition;
        [SerializeField] private float _timeToMove;
        [Space]
        [SerializeField] private List<WholeObjectToSlice> _allObjectsToSliceOnLevel = new List<WholeObjectToSlice>();

        private float _t;
        private bool _stopped;


        public Action<MainPartsMover> ReachedTarget;


        public bool Stopped
        {
            get => _stopped;
            set => _stopped = value;
        }

        private void Start()
        {
            transform.localPosition = _startPosition;

            RegisterAllObjectsToSlice();

            _stopped = !_moveOnStart;
        }

        private void OnDestroy()
        {
            ReachedTarget = null;
        }

        private void Update()
        {
            if (_stopped || _t >= 1f)
                return;

            _t += Time.deltaTime / _timeToMove;

            Vector3 newPosition = Vector3.Lerp(_startPosition, _endPosition, _t);
            transform.localPosition = newPosition;

            if (_t >= 1f)
                ReachedTarget?.Invoke(this);
        }

        public void StartMoving()
        {
            _stopped = false;
        }

        public void StopMoving()
        {
            _stopped = true;
        }

        private void RegisterAllObjectsToSlice()
        {
            foreach (var toSlice in _allObjectsToSliceOnLevel)
            {
                toSlice.SliceStarted += (o) => StopMoving();
                toSlice.SliceEnded += (o) => StartMoving();
            }
        }
    }
}