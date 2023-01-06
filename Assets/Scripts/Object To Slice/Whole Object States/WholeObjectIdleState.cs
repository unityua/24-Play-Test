using System;

namespace GameLogic.WholseObjectStates
{
    public class WholeObjectIdleState : WholeObjectStateBase
    {
        public WholeObjectIdleState(WholeObjectToSlice wholeObject, Action<WholeObjectStateBase> setState) : base(wholeObject, setState) { }

        public override void StateEntered() { }

        public override void Update() { }
    }
}