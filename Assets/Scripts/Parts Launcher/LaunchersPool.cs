using System.Collections.Generic;
using UnityEngine;

namespace GameLogic.SplitedPartsLauncher
{
    public class LaunchersPool : MonoBehaviour
    {
        [SerializeField] private SlicedPartsLauncher _launcherPrefab;
        [SerializeField] private int _startCount = 4;

        private Queue<SlicedPartsLauncher> freeLaunchers;

        private void Start()
        {
            CreateLaunchers(_startCount);
        }

        public SlicedPartsLauncher GetLauncher(Vector3 position)
        {
            SlicedPartsLauncher launcher;

            if (freeLaunchers.Count > 0)
                launcher = freeLaunchers.Dequeue();
            else
                launcher = CreateSingleLauncher(position);

            launcher.AnimatorEnabled = false;
            launcher.SetPosition(position);
            launcher.SetActive(true);

            return launcher;
        }

        private void CreateLaunchers(int count)
        {
            freeLaunchers = new Queue<SlicedPartsLauncher>(count);

            for (int i = 0; i < count; i++)
            {
                freeLaunchers.Enqueue(CreateSingleLauncher(transform.position));
            }
        }

        private SlicedPartsLauncher CreateSingleLauncher(Vector3 position)
        {
            SlicedPartsLauncher newLauncher = Instantiate(_launcherPrefab, position, Quaternion.identity, transform);

            newLauncher.AnimationEnded += OnLauncherAnimationEnded;

            return newLauncher;
        }

        private void OnLauncherAnimationEnded(SlicedPartsLauncher launcher)
        {
            launcher.SetActive(false);
            launcher.ResetPartParentPosition();

            freeLaunchers.Enqueue(launcher);
        }
    }
}