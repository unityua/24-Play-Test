using MeshSplitting.MeshTools;
using MeshSplitting.SplitterMath;
using System;
using UnityEngine;

namespace MeshSplitting.Splitables
{
    [AddComponentMenu("Mesh Splitting/Splitable")]
    public class Splitable : MonoBehaviour, ISplitable
    {
#if UNITY_EDITOR
        [NonSerialized]
        public bool ShowDebug = false;
#endif

        public bool Convex = false;

        public bool CreateCap = true;
        public bool UseCapUV = false;
        public bool CustomUV = false;
        public Vector2 CapUVMin = Vector2.zero;
        public Vector2 CapUVMax = Vector2.one;

        private PlaneMath _splitPlane;
        private MeshContainer[] _meshContainerStatic;
        private IMeshSplitter[] _meshSplitterStatic;

        public event Action<GameObject> Splited;

        private void OnDestroy()
        {
            Splited = null;
        }

        public bool Split(Transform splitTransform, out GameObject newPart)
        {
            _splitPlane = new PlaneMath(splitTransform);

            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();

            _meshContainerStatic = new MeshContainer[meshFilters.Length];
            _meshSplitterStatic = new IMeshSplitter[meshFilters.Length];

            for (int i = 0; i < meshFilters.Length; i++)
            {
                _meshContainerStatic[i] = new MeshContainer(meshFilters[i]);

                _meshSplitterStatic[i] = Convex ? (IMeshSplitter)new MeshSplitterConvex(_meshContainerStatic[i], _splitPlane, splitTransform.rotation) :
                                                  (IMeshSplitter)new MeshSplitterConcave(_meshContainerStatic[i], _splitPlane, splitTransform.rotation);

                if (UseCapUV) _meshSplitterStatic[i].SetCapUV(UseCapUV, CustomUV, CapUVMin, CapUVMax);
#if UNITY_EDITOR
                _meshSplitterStatic[i].DebugDraw(ShowDebug);
#endif
            }

            bool anySplit = false;

            for (int i = 0; i < _meshContainerStatic.Length; i++)
            {
                _meshContainerStatic[i].MeshInitialize();
                _meshContainerStatic[i].CalculateWorldSpace();

                // split mesh
                _meshSplitterStatic[i].MeshSplit();

                if (_meshContainerStatic[i].IsMeshSplit())
                {
                    anySplit = true;
                    if (CreateCap) _meshSplitterStatic[i].MeshCreateCaps();
                }
            }


            if (anySplit)
            {
                UpdateMeshesInChildren(1, gameObject);
                newPart = CreateSplitedObject();

                Splited?.Invoke(newPart);

                return true;
            }

            newPart = null;

            return false;
        }

        private GameObject CreateSplitedObject()
        {
            string oldName = gameObject.name;

            GameObject splitedPart = new GameObject(oldName + " Splitted", typeof(MeshFilter), typeof(MeshRenderer));

            Vector3 position = transform.position;
            Quaternion rotation = transform.rotation;
            Vector3 scale = transform.localScale;

            splitedPart.transform.SetPositionAndRotation(position, rotation);
            splitedPart.transform.localScale = scale;

            Material thisMaterial = GetComponent<MeshRenderer>().sharedMaterial;

            splitedPart.GetComponent<MeshRenderer>().sharedMaterial = thisMaterial;

            UpdateMeshesInChildren(0, splitedPart);

            return splitedPart;
        }

        private void UpdateMeshesInChildren(int i, GameObject go)
        {
            if (_meshContainerStatic.Length > 0)
            {
                MeshFilter[] meshFilters = go.GetComponentsInChildren<MeshFilter>();
                for (int j = 0; j < _meshContainerStatic.Length; j++)
                {
                    Renderer renderer = meshFilters[j].GetComponent<Renderer>();
                    if (i == 0)
                    {
                        if (_meshContainerStatic[j].HasMeshUpper() & _meshContainerStatic[j].HasMeshLower())
                        {
                            meshFilters[j].mesh = _meshContainerStatic[j].CreateMeshUpper();
                        }
                        else if (!_meshContainerStatic[j].HasMeshUpper())
                        {
                            if (renderer != null) 
                                Destroy(renderer);
                            Destroy(meshFilters[j]);
                        }
                    }
                    else
                    {
                        if (_meshContainerStatic[j].HasMeshUpper() & _meshContainerStatic[j].HasMeshLower())
                        {
                            meshFilters[j].mesh = _meshContainerStatic[j].CreateMeshLower();
                        }
                        else if (!_meshContainerStatic[j].HasMeshLower())
                        {
                            if (renderer != null) 
                                Destroy(renderer);
                            Destroy(meshFilters[j]);
                        }
                    }
                }
            }
        }

        private Material[] GetSharedMaterials(GameObject go)
        {
            SkinnedMeshRenderer skinnedMeshRenderer = go.GetComponent<SkinnedMeshRenderer>();
            if (skinnedMeshRenderer != null)
            {
                return skinnedMeshRenderer.sharedMaterials;
            }
            else
            {
                Renderer renderer = go.GetComponent<Renderer>();
                if (renderer != null)
                {
                    return renderer.sharedMaterials;
                }
            }

            return null;
        }

        private void SetSharedMaterials(GameObject go, Material[] materials)
        {
            SkinnedMeshRenderer skinnedMeshRenderer = go.GetComponent<SkinnedMeshRenderer>();
            if (skinnedMeshRenderer != null)
            {
                skinnedMeshRenderer.sharedMaterials = materials;
            }
            else
            {
                Renderer renderer = go.GetComponent<Renderer>();
                if (renderer != null)
                {
                    renderer.sharedMaterials = materials;
                }
            }
        }

        private void SetMeshOnGameObject(GameObject go, Mesh mesh)
        {
            MeshFilter meshFilter = go.GetComponent<MeshFilter>();
            if (meshFilter != null)
            {
                meshFilter.mesh = mesh;
            }
        }

        private Mesh GetMeshOnGameObject(GameObject go)
        {
            MeshFilter meshFilter = go.GetComponent<MeshFilter>();
            if (meshFilter != null)
            {
                return meshFilter.mesh;
            }

            return null;
        }
    }
}
