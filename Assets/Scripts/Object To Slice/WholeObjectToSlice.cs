using System;
using System.Collections.Generic;
using UnityEngine;
using GameLogic.Knife;
using GameLogic.WholseObjectStates;
using GameLogic.SplitedPartsLauncher;

namespace GameLogic
{
    public class WholeObjectToSlice : MonoBehaviour
    {
        [SerializeField] private Bounds _meshBounds;
        [Space]
        [SerializeField] private KnifeInput _knifeInput;
        [SerializeField] private Transform _knifeCutPoint;
        [SerializeField] private SliceableDetector _slicedPartsDetector;
        [Space]
        [SerializeField] private LaunchersPool _slicedPartsLauncherPool;
        [Space]
        [SerializeField] private ThicknessCalculator _thicknessCalculator;

        private List<ObjectToSlice> _objectsToSlice = new List<ObjectToSlice>();

        private SlicedPartsLauncher _partsLauncher;

        private WholeObjectStateBase _currentState;

        private WholeObjectIdleState _idleState;
        private WholeObjectCuttingState _cuttingState;
        private WholeObjectCuttedState _cuttedState;


        public Vector3 Position => transform.position;
        public Bounds MeshBounds => _meshBounds;
        public float MeshHeight => _meshBounds.size.y;
        public Vector3 KnifeCutPointLocalPosition => transform.InverseTransformPoint(_knifeCutPoint.position);


        public WholeObjectIdleState IdleState => _idleState;
        public WholeObjectCuttingState CuttingState => _cuttingState;
        public WholeObjectCuttedState CuttedState => _cuttedState;


        public Action<WholeObjectToSlice> SliceStarted;
        public Action<WholeObjectToSlice> SliceEnded;

        private void Start()
        {
            RegisterAllObjects();
            InitializeStates();

            _thicknessCalculator.Initialize(this);
        }

        private void OnDestroy()
        {
            SliceStarted = null;
            SliceEnded = null;
        }

        private void Update()
        {
            _currentState.Update();
        }

        public void SetCollidersActive(bool value)
        {
            foreach (var target in _objectsToSlice)
            {
                target.SetColliderActive(value);
            }
        }

        public void LaunchSlicedParts()
        {
            _partsLauncher.Launch();
        }

        private void RegisterAllObjects()
        {
            int childCount = transform.childCount;

            for (int i = 0; i < childCount; i++)
            {
                Transform child = transform.GetChild(i);
                RegisterObjectToSlice(child.GetComponent<ObjectToSlice>());
            }
        }

        private void SetState(WholeObjectStateBase newState)
        {
            newState.StateEntered();
            _currentState = newState;
        }

        private void InitializeStates()
        {
            _idleState = new WholeObjectIdleState(this, SetState);
            _cuttingState = new WholeObjectCuttingState(this, SetState, GetAllSlicedMaterials());
            _cuttedState = new WholeObjectCuttedState(this, SetState, OnSlicingEnded);

            SetState(_idleState);
        }

        private void OnObjectSlicedByKnife(ObjectToSlice firstSlice, GameObject newPart)
        {
            _thicknessCalculator.Recalculate(KnifeCutPointLocalPosition);
            _cuttingState.SetMaterialsFloat("_Radius", _thicknessCalculator.CurrentCutRadius);
            _cuttingState.SetMaterialsFloat("_Deviation", _thicknessCalculator.CurrentDeviation);
            _cuttingState.SetMaterialsFloat("_PointX", _thicknessCalculator.CurrentPointX);

            firstSlice.SetColliderActive(false);

            _partsLauncher = _slicedPartsLauncherPool.GetLauncher(transform.position);
            _partsLauncher.AddObject(newPart.transform);

            List<ObjectToSlice> allObjectsToSlice = _slicedPartsDetector.DetectAllSlicedParts();
            allObjectsToSlice.Remove(firstSlice);

            SliceAllObjects(allObjectsToSlice);

            SetState(_cuttingState);

            SliceStarted?.Invoke(this);
        }

        private void OnSlicingEnded()
        {
            SliceEnded?.Invoke(this);
        }

        private void SliceAllObjects(List<ObjectToSlice> objects)
        {
            foreach (var target in objects)
            {
                bool sliced = target.Splitable.Split(_knifeCutPoint, out GameObject newPart);

                target.SetColliderActive(false);

                if (sliced)
                {
                    _partsLauncher.AddObject(newPart.transform);
                }
                else
                {
                    target.TransformToSliced();
                    RemoveObjectToSlice(target);
                    _partsLauncher.AddObject(target.transform);
                }
            }
        }

        private List<Material> GetAllSlicedMaterials()
        {
            List<Material> result = new List<Material>(_objectsToSlice.Count);

            foreach (var childToSlice in _objectsToSlice)
            {
                Material slicedMaterial = childToSlice.SlicedMaterial;

                if (result.Contains(slicedMaterial) == false)
                    result.Add(slicedMaterial);
            }

            return result;
        }

        private void RegisterObjectToSlice(ObjectToSlice objectToSlice)
        {
            objectToSlice.SlicedByKnife += OnObjectSlicedByKnife;
            _objectsToSlice.Add(objectToSlice);
        }

        private void RemoveObjectToSlice(ObjectToSlice objectToSlice)
        {
            objectToSlice.SlicedByKnife -= OnObjectSlicedByKnife;
            _objectsToSlice.Remove(objectToSlice);
        }


#if UNITY_EDITOR
        [NaughtyAttributes.Button]
        private void RecalculateBounds()
        {
            Quaternion currentRotation = this.transform.rotation;
            transform.rotation = Quaternion.Euler(0f, 0f, 0f);
            _meshBounds = new Bounds(this.transform.position, Vector3.zero);
            foreach (Renderer renderer in GetComponentsInChildren<Renderer>())
            {
                _meshBounds.Encapsulate(renderer.bounds);
            }
            Vector3 localCenter = _meshBounds.center - this.transform.position;
            _meshBounds.center = localCenter;
            transform.rotation = currentRotation;
        }

        private void OnDrawGizmosSelected()
        {
            Vector3 center = transform.position + _meshBounds.center;

            Gizmos.color = new Color(1f, 0f, 0f, 0.4f);
            Gizmos.DrawCube(center, _meshBounds.size);

            Gizmos.color = Color.black;
            Gizmos.DrawWireCube(center, _meshBounds.size);

            _thicknessCalculator.OnDrawGizmosSelectedCustom(transform.position);
        }
#endif
    }
}