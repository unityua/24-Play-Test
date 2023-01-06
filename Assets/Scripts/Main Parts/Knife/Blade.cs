using UnityEngine;

namespace GameLogic.Knife
{
    public class Blade : MonoBehaviour
    {
        private void OnTriggerEnter(Collider other)
        {
            ObjectToSlice objectToSlice = other.GetComponent<ObjectToSlice>();

            bool splitted = objectToSlice.Splitable.Split(transform, out GameObject newPart);

            if (splitted == false)
                return;

            objectToSlice.InvokeSlicedByKnife(newPart);
        }

#if UNITY_EDITOR
        private void OnDrawGizmosSelected()
        {
            Vector3 worldPlanePoint = transform.position;
            Vector3 worldPlaneNormal = transform.up;

            Gizmos.color = Color.blue;
            Gizmos.DrawRay(worldPlanePoint, worldPlaneNormal);

            float size = 10;

            Quaternion rotation = Quaternion.LookRotation(worldPlaneNormal);
            Matrix4x4 trs = Matrix4x4.TRS(worldPlanePoint, rotation, Vector3.one);
            Gizmos.matrix = trs;
            Color32 color = Color.blue;
            color.a = 125;
            Gizmos.color = color;
            Gizmos.DrawCube(Vector3.zero, new Vector3(size, size, 0.0001f));
            Gizmos.matrix = Matrix4x4.identity;
            Gizmos.color = Color.white;
        }
#endif
    }
}