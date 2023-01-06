using System;

namespace GameLogic.WholseObjectStates
{
    public class WholeObjectCuttedState : WholeObjectStateBase
    {
        private Action _StartMoving;

        public WholeObjectCuttedState(WholeObjectToSlice wholeObject, Action<WholeObjectStateBase> setState, Action startMoving) : base(wholeObject, setState)
        {
            _StartMoving = startMoving;
        }

        public override void StateEntered()
        {

        }

        public override void Update()
        {
            if (_wholeObject.KnifeCutPointLocalPosition.y > _wholeObject.MeshHeight + 0.1f)
            {
                _wholeObject.SetCollidersActive(true);

                _SetState(_wholeObject.IdleState);
                _StartMoving();
            }
        }
    }
}