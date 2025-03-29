//================================================================================
// LiftCenter.
//================================================================================
class LiftCenter expands NavigationPoint
	native;

var() name LiftTag;
var Mover MyLift;
var() name LiftTrigger;
var Trigger RecommendedTrigger;
var float LastTriggerTime;
var() float MaxZDiffAdd;

function PostBeginPlay ()
{
	if ( LiftTag != 'None' )
	{
		foreach AllActors(Class'Mover',MyLift,LiftTag)
		{
			MyLift.myMarker=self;
			SetBase(MyLift);
			goto JL0040;
		}
JL0040:
	}
	if ( LiftTrigger != 'None' )
	{
		foreach AllActors(Class'Trigger',RecommendedTrigger,LiftTrigger)
		{
			goto JL0069;
		}
JL0069:
	}
	Super.PostBeginPlay();
}

function Actor SpecialHandling (Pawn Other)
{
	local float dist2d;

	if ( MyLift == None )
	{
		return self;
	}
	if ( Other.Base == MyLift )
	{
		if ( (RecommendedTrigger != None) && (MyLift.SavedTrigger == None) && (Level.TimeSeconds - LastTriggerTime > 5) )
		{
			Other.SpecialGoal=RecommendedTrigger;
			LastTriggerTime=Level.TimeSeconds;
			return RecommendedTrigger;
		}
		return self;
	}
	if ( (LiftExit(Other.MoveTarget) != None) && (LiftExit(Other.MoveTarget).RecommendedTrigger != None) && (LiftExit(Other.MoveTarget).LiftTag == LiftTag) && (Level.TimeSeconds - LiftExit(Other.MoveTarget).LastTriggerTime > 5) && (MyLift.SavedTrigger == None) && (Abs(Other.Location.X - Other.MoveTarget.Location.X) < Other.CollisionRadius) && (Abs(Other.Location.Y - Other.MoveTarget.Location.Y) < Other.CollisionRadius) && (Abs(Other.Location.Z - Other.MoveTarget.Location.Z) < Other.CollisionHeight) )
	{
		LiftExit(Other.MoveTarget).LastTriggerTime=Level.TimeSeconds;
		Other.SpecialGoal=LiftExit(Other.MoveTarget).RecommendedTrigger;
		return LiftExit(Other.MoveTarget).RecommendedTrigger;
	}
	dist2d=Square(Location.X - Other.Location.X) + Square(Location.Y - Other.Location.Y);
	if ( (Location.Z - CollisionHeight - MaxZDiffAdd < Other.Location.Z - Other.CollisionHeight + Other.MaxStepHeight) && (Location.Z - CollisionHeight > Other.Location.Z - Other.CollisionHeight - 1200) && (dist2d < 160000) )
	{
		return self;
	}
	if ( (MyLift.BumpType == 0) &&  !Other.bIsPlayer )
	{
		return None;
	}
	Other.SpecialGoal=None;
	MyLift.HandleDoor(Other);
	MyLift.RecommendedTrigger=None;
	if ( (Other.SpecialGoal == MyLift) || (Other.SpecialGoal == None) )
	{
		Other.SpecialGoal=self;
	}
	return Other.SpecialGoal;
}

defaultproperties
{
    ExtraCost=400
    bStatic=False
    bNoDelete=True
}