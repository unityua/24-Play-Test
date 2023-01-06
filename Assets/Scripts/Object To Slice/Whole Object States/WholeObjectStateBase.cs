using System;

namespace GameLogic.WholseObjectStates
{
    public abstract class WholeObjectStateBase
    {
        protected WholeObjectToSlice _wholeObject;

        protected Action<WholeObjectStateBase> _SetState;

        protected WholeObjectStateBase(WholeObjectToSlice wholeObject, Action<WholeObjectStateBase> setState)
        {
            _wholeObject = wholeObject;
            _SetState = setState;
        }

        public abstract void StateEntered();

        public abstract void Update();
    }
}