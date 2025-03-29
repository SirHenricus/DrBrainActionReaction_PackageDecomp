//================================================================================
// WarpZoneMarker.
//================================================================================
class WarpZoneMarker expands NavigationPoint
	native;

var WarpZoneInfo markedWarpZone;
var Actor TriggerActor;
var Actor TriggerActor2;

function PostBeginPlay ()
{
	if ( markedWarpZone.numDestinations > 1 )
	{
		FindTriggerActor();
	}
	Super.PostBeginPlay();
}

function FindTriggerActor ()
{
	local ZoneTrigger Z;

	foreach AllActors(Class'ZoneTrigger',Z)
	{
		if ( Z.Event == markedWarpZone.ZoneTag )
		{
			TriggerActor=Z;
			return;
		}
	}
}

function Actor SpecialHandling (Pawn Other)
{
	if ( Other.Region.Zone == markedWarpZone )
	{
		markedWarpZone.ActorEntered(Other);
	}
	return self;
}

defaultproperties
{
    bCollideWhenPlacing=False
    bHiddenEd=True
    CollisionRadius=20.00
    CollisionHeight=40.00
}