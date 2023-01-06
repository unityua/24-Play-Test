using System;
using System.Collections.Generic;
using UnityEngine;

namespace GameLogic.WholseObjectStates
{
    public class WholeObjectCuttingState : WholeObjectStateBase
    {
        private float _currentCutPointY;

        private readonly List<Material> _slicedMaterials = new List<Material>();

        private float LocalCutPositionY => _wholeObject.KnifeCutPointLocalPosition.y;

        public WholeObjectCuttingState(WholeObjectToSlice wholeObject, Action<WholeObjectStateBase> setState, List<Material> slicedMaterials)
                : base(wholeObject, setState)
        {
            _slicedMaterials = slicedMaterials;
            InitializeMaterials();

            _currentCutPointY = wholeObject.MeshHeight;
        }

        public override void StateEntered()
        {
            _currentCutPointY = LocalCutPositionY;
            SetMaterialsPointY(_currentCutPointY);
        }

        public override void Update()
        {
            _currentCutPointY = Mathf.Min(_currentCutPointY, LocalCutPositionY);
            _currentCutPointY = Mathf.Clamp(_currentCutPointY, 0f, float.MaxValue);

            SetMaterialsPointY(_currentCutPointY);

            if (_currentCutPointY <= 0f)
            {
                _wholeObject.LaunchSlicedParts();
                _SetState(_wholeObject.CuttedState);
            }
        }

        public void SetMaterialsFloat(string floatName, float value)
        {
            foreach (var material in _slicedMaterials)
            {
                material.SetFloat(floatName, value);
            }
        }

        private void InitializeMaterials()
        {
            float meshHeight = _wholeObject.MeshHeight;

            SetMaterialsPointY(meshHeight);

            foreach (var material in _slicedMaterials)
            {
                material.SetFloat("_MeshTop", meshHeight);
            }
        }

        private void SetMaterialsPointY(float y)
        {
            foreach (var material in _slicedMaterials)
            {
                material.SetFloat("_PointY", y);
            }
        }
    }
}