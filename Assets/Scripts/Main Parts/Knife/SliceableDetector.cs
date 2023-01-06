using System.Collections.Generic;
using UnityEngine;

namespace GameLogic.Knife
{
    public class SliceableDetector : MonoBehaviour
    {
        [SerializeField] private LayerMask _sliceableLayer;
        [SerializeField] private Vector3 _size;

        private Collider[] _hitedColliders = new Collider[64];

        public List<ObjectToSlice> DetectAllSlicedParts()
        {
            int hitedCount = Physics.OverlapBoxNonAlloc(transform.position, _size / 2f, _hitedColliders, Quaternion.identity, _sliceableLayer);

            List<ObjectToSlice> result = new List<ObjectToSlice>(hitedCount);

            for (int i = 0; i < hitedCount; i++)
            {
                ObjectToSlice objectToSlice = _hitedColliders[i].GetComponent<ObjectToSlice>();

                if (objectToSlice != null)
                    result.Add(objectToSlice);
            }

            return result;
        }


#if UNITY_EDITOR

        [NaughtyAttributes.Button]
        private void TestDetection()
        {
            var result = DetectAllSlicedParts();

            string message = "Detected Count: " + result.Count + "  ";

            foreach (var item in result)
            {
                message += "  " + item.name;
            }

            Debug.Log(message);
        }

        private void OnDrawGizmosSelected()
        {
            Color color = Color.green;
            color.a = 0.3f;

            Gizmos.color = color;
            Gizmos.DrawCube(transform.position, _size);

            Gizmos.color = Color.black;
            Gizmos.DrawWireCube(transform.position, _size);
        }
#endif
    }
}