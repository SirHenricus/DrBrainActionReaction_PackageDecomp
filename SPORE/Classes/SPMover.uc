//================================================================================
// SPMover.
//================================================================================
class SPMover expands Mover;

var() Class<Actor> BumpClass;
var() bool bHasPartners;
var() name OpenedEvent;
var() name ClosedEvent;
var bool bMovingContinuous;
var bool bMoving;

function FinishedOpening ()
{
	local Actor A;

	Super.FinishedOpening();
	if ( OpenedEvent != 'None' )
	{
		foreach AllActors(Class'Actor',A,OpenedEvent)
		{
			A.Trigger(self,Instigator);
		}
	}
}

function FinishedClosing ()
{
	local Actor A;

	Super.FinishedClosing();
	if ( ClosedEvent != 'None' )
	{
		foreach AllActors(Class'Actor',A,ClosedEvent)
		{
			A.Trigger(self,Instigator);
		}
	}
}

function GotoNextKey ()
{
	local byte OldKeyNum;

	OldKeyNum=PrevKeyNum;
	PrevKeyNum=KeyNum;
	PhysAlpha=0.00;
	if ( (KeyNum > 0) && (KeyNum < OldKeyNum) )
	{
		InterpolateTo(KeyNum - 1,MoveTime);
	}
	else
	{
		if ( (KeyNum < NumKeys - 1) && (KeyNum > OldKeyNum) )
		{
			InterpolateTo(KeyNum + 1,MoveTime);
		}
		else
		{
			AmbientSound=None;
		}
	}
}

state() BumpToggle
{
	function bool HandleDoor (Pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Bump (Actor Other)
	{
		local Mover M;
	
		if ( (BumpType != 2) && (Pawn(Other) == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !Pawn(Other).bIsPlayer )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		if ( (BumpClass != None) &&  !ClassIsChildOf(Other.Class,BumpClass) )
		{
			return;
		}
		Global.Bump(Other);
		Trigger(Other,Instigator);
		if ( bHasPartners && (Tag != 'None') )
		{
			foreach AllActors(Class'Mover',M,Tag)
			{
				if ( M != self )
				{
					M.Trigger(Other,Instigator);
				}
			}
		}
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		SavedTrigger=None;
		Instigator=Pawn(Other);
		if ( (KeyNum == 0) || (KeyNum < PrevKeyNum) )
		{
			GotoState('BumpToggle','Open');
		}
		else
		{
			GotoState('BumpToggle','Close');
		}
	}
	
Open:
	Disable('Bump');
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if ( SavedTrigger != None )
	{
		SavedTrigger.EndEvent();
	}
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
	Enable('Bump');
	stop
Close:
	Disable('Bump');
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Bump');
}

state() OneAtATime
{
	function bool HandleDoor (Pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		if ( KeyNum == 0 )
		{
			GotoState('OneAtATime','Open');
		}
		else
		{
			if ( KeyNum == NumKeys - 1 )
			{
				GotoState('OneAtATime','Close');
			}
			else
			{
				GotoState('OneAtATime','GoNextKey');
			}
		}
	}
	
	function InterpolateEnd (Actor Other)
	{
	}
	
Open:
	Disable('Trigger');
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Enable('Trigger');
	SavedTrigger.EndEvent();
	stop
GoNextKey:
	Disable('Trigger');
	GotoNextKey();
	FinishInterpolation();
	Enable('Trigger');
	SavedTrigger.EndEvent();
	stop
Close:
	Disable('Trigger');
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Trigger');
}

state() Continuous
{
	event BeginPlay ()
	{
		Super.BeginPlay();
		GotoState('Continuous','Open');
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		bMovingContinuous= !bMovingContinuous;
		if ( bMovingContinuous &&  !bMoving )
		{
			GotoState('Continuous','Open');
		}
	}
	
	function InterpolateEnd (Actor Other)
	{
		local byte OldKeyNum;
	
		if ( bMovingContinuous )
		{
			OldKeyNum=PrevKeyNum;
			PrevKeyNum=KeyNum;
			PhysAlpha=0.00;
			if ( KeyNum < NumKeys - 1 )
			{
				InterpolateTo(KeyNum + 1,MoveTime);
			}
			else
			{
				InterpolateTo(0,MoveTime);
			}
		}
		else
		{
			GotoState('Continuous','Wait');
		}
	}
	
Open:
	bOpening=True;
	InterpolateTo(KeyNum + 1,MoveTime);
	bMoving=True;
	FinishInterpolation();
	FinishedOpening();
Wait:
	bMoving=False;
	stop
}

defaultproperties
{
    InitialState=OneAtATime
}