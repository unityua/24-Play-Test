using UnityEngine;

namespace GameLogic.MeshManipulation
{
	public static class MeshApplyTransform
	{
		// Apply a transform to a mesh. The transform needs to be
		// reset also after this application to keep the same shape.
		public static Mesh ApplyTransform(
			Transform transform,
			Mesh mesh,
			bool applyTranslation,
			bool applyRotation,
			bool applyScale)
		{
			var verts = mesh.vertices;
			var norms = mesh.normals;

			// Handle vertices.
			for (int i = 0; i < verts.Length; ++i)
			{
				var nvert = verts[i];

				if (applyScale)
				{
					var scale = transform.localScale;
					nvert.x *= scale.x;
					nvert.y *= scale.y;
					nvert.z *= scale.z;
				}

				if (applyRotation)
				{
					nvert = transform.rotation * nvert;
				}

				if (applyTranslation)
				{
					nvert += transform.position;
				}

				verts[i] = nvert;
			}

			// Handle normals.
			for (int i = 0; i < verts.Length; ++i)
			{
				var nnorm = norms[i];

				if (applyRotation)
				{
					nnorm = transform.rotation * nnorm;
				}

				norms[i] = nnorm;
			}

			mesh.vertices = verts;
			mesh.normals = norms;

			mesh.RecalculateBounds();
			mesh.RecalculateTangents();

			return mesh;
		}

		// Reset the transform values, this should be executed after
		// applying the transform to the mesh data.
		public static Transform ResetTransform(
			Transform transform,
			bool applyTranslation,
			bool applyRotation,
			bool applyScale)
		{
			var scale = transform.localScale;
			var rotation = transform.localRotation;
			var translation = transform.position;

			// Update the children to keep their shape.
			foreach (Transform child in transform)
			{
				if (applyTranslation)
					child.Translate(transform.localPosition);

				if (applyRotation)
				{
					var worldPos = rotation * child.localPosition;
					child.localRotation = rotation * child.localRotation;
					child.localPosition = worldPos;
				}

				if (applyScale)
				{
					var childScale = child.localScale;
					childScale.x *= scale.x;
					childScale.y *= scale.y;
					childScale.z *= scale.z;
					child.localScale = childScale;

					var childPosition = child.localPosition;
					childPosition.x *= scale.x;
					childPosition.y *= scale.y;
					childPosition.z *= scale.z;
					child.localPosition = childPosition;
				}

				// This makes the inspector update the position values.
				child.Translate(Vector3.zero);
				// Though for some reason the .position value is still screwed
				// for this frame though.
			}

			// Reset the transform.
			if (applyTranslation)
				transform.position = Vector3.zero;
			if (applyRotation)
				transform.rotation = Quaternion.identity;
			if (applyScale)
				transform.localScale = Vector3.one;

			return transform;
		}
	}
}
