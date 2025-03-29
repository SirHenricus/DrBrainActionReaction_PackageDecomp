//================================================================================
// WarpZoneInfo.
//================================================================================
class WarpZoneInfo expands ZoneInfo
	native;

var() string OtherSideURL;
var() name ThisTag;
var() bool bNoTeleFrag;
var const int iWarpZone;
var const Coords WarpCoords;
var transient WarpZoneInfo OtherSideActor;
var transient Object OtherSideLevel;
var() string Destinations[8];
var int numDestinations;

replication
{
	un?reliable if ( Role == 4 )
		OtherSideURL,ThisTag,OtherSideActor;
}

native(314) final function Warp (out Vector Loc, out Vector Vel, out Rotator R);

native(315) final function UnWarp (out Vector Loc, out Vector Vel, out Rotator R);

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	Generate();
	numDestinations=0;
JL0013:
	if ( numDestinations < 8 )
	{
		if ( Destinations[numDestinations] != "" )
		{
			numDestinations++;
		}
		else
		{
			numDestinations=8;
		}
		goto JL0013;
	}
	if ( (numDestinations > 0) && (OtherSideURL == "") )
	{
		OtherSideURL=Destinations[0];
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local int nextPick;

	if ( numDestinations == 0 )
	{
		return;
	}
	nextPick=0;
JL0014:
	if ( (nextPick < 8) && (Destinations[nextPick] != OtherSideURL) )
	{
		nextPick++;
		goto JL0014;
	}
	nextPick++;
	if ( (nextPick > 7) || (Destinations[nextPick] == "") )
	{
		nextPick=0;
	}
	OtherSideURL=Destinations[nextPick];
	ForceGenerate();
}

simulated event Generate ()
{
	if ( OtherSideLevel != None )
	{
		return;
	}
	ForceGenerate();
}

simulated event ForceGenerate ()
{
	if ( InStr(OtherSideURL,"/") >= 0 )
	{
		OtherSideLevel=None;
		OtherSideActor=None;
	}
	else
	{
		OtherSideLevel=XLevel;
		foreach AllActors(Class'WarpZoneInfo',OtherSideActor)
		{
			if ( (string(OtherSideActor.ThisTag) ~= OtherSideURL) && (OtherSideActor != self) )
			{
				goto JL0066;
			}
		}
JL0066:
	}
}

simulated function ActorEntered (Actor Other)
{
	local Vector L;
	local Rotator R;
	local Pawn P;

	Super.ActorEntered(Other);
	if (  !Other.bJustTeleported )
	{
		Generate();
		if ( OtherSideActor != None )
		{
			Other.Disable('Touch');
			Other.Disable('UnTouch');
			L=Other.Location;
			if ( Other.IsA('PlayerPawn') )
			{
				R=PlayerPawn(Other).ViewRotation;
			}
			else
			{
				R=Other.Rotation;
			}
			UnWarp(L,Other.Velocity,R);
			OtherSideActor.Warp(L,Other.Velocity,R);
			if ( Other.IsA('Pawn') )
			{
				Pawn(Other).bWarping=bNoTeleFrag;
				if ( Other.SetLocation(L) )
				{
					if ( Role == 4 )
					{
						P=Level.PawnList;
JL014C:
						if ( P != None )
						{
							if ( P.Enemy == Other )
							{
								P.LastSeenPos=Other.Location;
							}
							P=P.nextPawn;
							goto JL014C;
						}
					}
					R.Roll=0;
					Pawn(Other).ViewRotation=R;
					R.Pitch=0;
					Pawn(Other).SetRotation(R);
					Pawn(Other).MoveTimer=-1.00;
				}
				else
				{
					GotoState('DelayedWarp');
				}
			}
			else
			{
				Other.SetLocation(L);
				Other.SetRotation(R);
			}
			Other.Enable('Touch');
			Other.Enable('UnTouch');
		}
	}
}

event ActorLeaving (Actor Other)
{
	Super.ActorLeaving(Other);
	if ( Other.IsA('Pawn') )
	{
		Pawn(Other).bWarping=False;
	}
}

state DelayedWarp
{
	function Tick (float DeltaTime)
	{
		local Pawn P;
		local bool bFound;
	
		P=Level.PawnList;
	JL0014:
		if ( P != None )
		{
			if ( P.bWarping && (P.Region.Zone == self) )
			{
				bFound=True;
				ActorEntered(P);
			}
			P=P.nextPawn;
			goto JL0014;
		}
		if (  !bFound )
		{
			GotoState('None');
		}
	}
	
}

defaultproperties
{
    MaxCarcasses=0
}