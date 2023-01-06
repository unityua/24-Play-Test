using System;
using UnityEngine;
using MeshSplitting.Splitables;
using GameLogic.MeshManipulation;

namespace GameLogic
{
    [RequireComponent(typeof(MeshRenderer))]
    [RequireComponent(typeof(MeshCollider))]
    [RequireComponent(typeof(Splitable))]
    public class ObjectToSlice : MonoBehaviour
    {
        [SerializeField] private int _subdivisionFactor = 3;
        [SerializeField] private Material _slicedMaterial;

        private MeshFilter _meshFilter;
        private MeshRenderer _meshRenderer;
        private MeshCollider _meshCollider;
        private Splitable _splitable;


        public Material SlicedMaterial => _slicedMaterial;
        public Splitable Splitable => _splitable;


        public Action<ObjectToSlice, GameObject> SlicedByKnife;

        private void Start()
        {
            _meshFilter = GetComponent<MeshFilter>();
            _meshRenderer = GetComponent<MeshRenderer>();
            _meshCollider = GetComponent<MeshCollider>();
            _splitable = GetComponent<Splitable>();

            ApplyRotationAndScaleToMesh();

            GetComponent<Splitable>().Splited += OnSplitted;
        }

        private void OnDestroy()
        {
            GetComponent<Splitable>().Splited -= OnSplitted;
            SlicedByKnife = null;
        }

        public void TransformToSliced()
        {
            Subdivider.Subdivide(_meshFilter.sharedMesh, _subdivisionFactor);
            _meshRenderer.sharedMaterial = _slicedMaterial;
        }

        public void InvokeSlicedByKnife(GameObject newPart)
        {
            SlicedByKnife?.Invoke(this, newPart);
        }

        public void SetColliderActive(bool value)
        {
            _meshCollider.enabled = value;
        }

        private void ApplyRotationAndScaleToMesh()
        {
            Mesh originalMesh = _meshFilter.mesh;

            Mesh newMesh = MeshApplyTransform.ApplyTransform(transform, originalMesh, false, true, true);
            MeshApplyTransform.ResetTransform(transform, false, true, true);

            _meshCollider.sharedMesh = newMesh;
            _meshFilter.sharedMesh = newMesh;
        }

        private void OnSplitted(GameObject newPart)
        {
            Subdivider.Subdivide(newPart.GetComponent<MeshFilter>().sharedMesh, _subdivisionFactor);
            newPart.GetComponent<MeshRenderer>().sharedMaterial = _slicedMaterial;

            _meshCollider.sharedMesh = _meshFilter.sharedMesh;
        }
    }
}