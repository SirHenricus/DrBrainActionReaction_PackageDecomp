//================================================================================
// LiftExit.
//================================================================================
class LiftExit expands NavigationPoint
	native;

var() name LiftTag;
var Mover MyLift;
var() name LiftTrigger;
var Trigger RecommendedTrigger;
var float LastTriggerTime;

function PostBeginPlay ()
{
	if ( LiftTag != 'None' )
	{
		foreach AllActors(Class'Mover',MyLift,LiftTag)
		{
			goto JL0028;
		}
JL0028:
	}
	if ( LiftTrigger != 'None' )
	{
		foreach AllActors(Class'Trigger',RecommendedTrigger,LiftTrigger)
		{
			goto JL0051;
		}
JL0051:
	}
	Super.PostBeginPlay();
}

function Actor SpecialHandling (Pawn Other)
{
	if ( (Other.Base == MyLift) && (MyLift != None) )
	{
		if ( (self.Location.Z < Other.Location.Z + Other.CollisionHeight) && Other.LineOfSightTo(self) )
		{
			return self;
		}
		Other.SpecialGoal=None;
		Other.DesiredRotation=rotator(Location - Other.Location);
		MyLift.HandleDoor(Other);
		if ( (Other.SpecialGoal == MyLift) || (Other.SpecialGoal == None) )
		{
			Other.SpecialGoal=MyLift.myMarker;
		}
		return Other.SpecialGoal;
	}
	return self;
}