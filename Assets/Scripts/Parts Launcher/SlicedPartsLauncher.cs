using System;
using UnityEngine;

namespace GameLogic.SplitedPartsLauncher
{
    [RequireComponent(typeof(Animator))]
    public class SlicedPartsLauncher : MonoBehaviour
    {
        [SerializeField] private Transform _partsParent;
        [SerializeField] private Vector3 _partsDefaultPosition;

        private Animator _animator;

        private int _launchHash;

        public bool AnimatorEnabled
        {
            get => _animator.enabled;
            set => _animator.enabled = value;
        }

        public Action<SlicedPartsLauncher> AnimationEnded;

        private void Awake()
        {
            _animator = GetComponent<Animator>();

            _launchHash = Animator.StringToHash("Launch");
        }

        private void OnDestroy()
        {
            AnimationEnded = null;
        }

        public void Launch()
        {
            gameObject.SetActive(true);
            _animator.enabled = true;

            _animator.SetTrigger(_launchHash);
        }

        public void AddObject(Transform newObject)
        {
            newObject.SetParent(_partsParent, true);
        }

        public void SetPosition(Vector3 position)
        {
            transform.position = position;
        }

        public void SetActive(bool value)
        {
            gameObject.SetActive(value);
        }

        public void ResetPartParentPosition()
        {
            _partsParent.localPosition = _partsDefaultPosition;
        }

        public void ClearAllObjects()
        {
            int childCount = _partsParent.childCount;

            for (int i = childCount - 1; i >= 0; i--)
            {
                Destroy(_partsParent.GetChild(i).gameObject);
            }
        }

        public void OnAnimationEnded()
        {
            AnimationEnded?.Invoke(this);
        }
    }
}