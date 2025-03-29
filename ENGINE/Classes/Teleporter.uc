//================================================================================
// Teleporter.
//================================================================================
class Teleporter expands NavigationPoint
	native;

var() string URL;
var() name ProductRequired;
var() bool bChangesVelocity;
var() bool bChangesYaw;
var() bool bReversesX;
var() bool bReversesY;
var() bool bReversesZ;
var() bool bEnabled;
var() Vector TargetVelocity;
var Actor TriggerActor;
var Actor TriggerActor2;

function PostBeginPlay ()
{
	if ( URL ~= "" )
	{
		SetCollision(False,False,False);
	}
	if (  !bEnabled )
	{
		FindTriggerActor();
	}
	Super.PostBeginPlay();
}

function FindTriggerActor ()
{
	local Actor A;

	TriggerActor=None;
	TriggerActor2=None;
	foreach AllActors(Class'Actor',A)
	{
		if ( A.Event == Tag )
		{
			if ( Counter(A) != None )
			{
				return;
			}
			if ( TriggerActor == None )
			{
				TriggerActor=A;
			}
			else
			{
				TriggerActor2=A;
				return;
			}
		}
	}
}

function bool Accept (Actor Incoming)
{
	local Rotator NewRot;
	local Rotator OldRot;
	local int oldYaw;
	local float mag;
	local Vector oldDir;
	local Pawn P;

	Disable('Touch');
	NewRot=Incoming.Rotation;
	if ( bChangesYaw )
	{
		OldRot=Incoming.Rotation;
		NewRot.Yaw=Rotation.Yaw;
	}
	if ( Pawn(Incoming) != None )
	{
		P=Level.PawnList;
JL0071:
		if ( P != None )
		{
			if ( P.Enemy == Incoming )
			{
				P.LastSeenPos=Incoming.Location;
			}
			P=P.nextPawn;
			goto JL0071;
		}
		Pawn(Incoming).SetLocation(Location);
		Pawn(Incoming).ClientSetRotation(NewRot);
		Pawn(Incoming).MoveTimer=-1.00;
		Pawn(Incoming).MoveTarget=self;
	}
	else
	{
		if (  !Incoming.SetLocation(Location) )
		{
			return False;
		}
		if ( bChangesYaw )
		{
			Incoming.SetRotation(NewRot);
		}
	}
	Enable('Touch');
	if ( bChangesVelocity )
	{
		Incoming.Velocity=TargetVelocity;
	}
	else
	{
		if ( bChangesYaw )
		{
			if ( Incoming.Physics == 1 )
			{
				OldRot.Pitch=0;
			}
			oldDir=vector(OldRot);
			mag=Incoming.Velocity Dot oldDir;
			Incoming.Velocity=Incoming.Velocity - mag * oldDir + mag * vector(Incoming.Rotation);
		}
		if ( bReversesX )
		{
			Incoming.Velocity.X *= -1.00;
		}
		if ( bReversesY )
		{
			Incoming.Velocity.Y *= -1.00;
		}
		if ( bReversesZ )
		{
			Incoming.Velocity.Z *= -1.00;
		}
	}
	PlayTeleportEffect(Incoming,True);
	return True;
}

function PlayTeleportEffect (Actor Incoming, bool bOut)
{
	if ( Incoming.IsA('Pawn') )
	{
		Incoming.MakeNoise(1.00);
		Level.Game.PlayTeleportEffect(Incoming,bOut,True);
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local int i;

	bEnabled= !bEnabled;
	if ( bEnabled )
	{
		i=0;
JL001F:
		if ( i < 4 )
		{
			if ( Touching[i] != None )
			{
				Touch(Touching[i]);
			}
			i++;
			goto JL001F;
		}
	}
}

function Touch (Actor Other)
{
	local Teleporter Dest;
	local int i;
	local Actor A;

	if (  !bEnabled )
	{
		return;
	}
	if ( Other.bCanTeleport && (Other.PreTeleport(self) == False) )
	{
		if ( (InStr(URL,"/") >= 0) || (InStr(URL,"#") >= 0) )
		{
			if ( PlayerPawn(Other) != None )
			{
				Level.Game.SendPlayer(PlayerPawn(Other),URL);
			}
		}
		else
		{
			foreach AllActors(Class'Teleporter',Dest)
			{
				if ( (string(Dest.Tag) ~= URL) && (Dest != self) )
				{
					i++;
				}
			}
			i=Rand(i);
			foreach AllActors(Class'Teleporter',Dest)
			{
				if ( (string(Dest.Tag) ~= URL) && (Dest != self) && (i--  == 0) )
				{
					goto JL0128;
				}
			}
			if ( Dest != None )
			{
				if ( Other.IsA('Pawn') )
				{
					PlayTeleportEffect(Pawn(Other),False);
				}
				Dest.Accept(Other);
				if ( (Event != 'None') && Other.IsA('Pawn') )
				{
					foreach AllActors(Class'Actor',A,Event)
					{
						A.Trigger(Other,Other.Instigator);
					}
				}
			}
			else
			{
				Pawn(Other).ClientMessage("Teleport destination not found!");
			}
		}
	}
}

function Actor SpecialHandling (Pawn Other)
{
	local int i;

	if ( bEnabled )
	{
		i=0;
JL0010:
		if ( i < 4 )
		{
			if ( Touching[i] == Other )
			{
				Touch(Other);
			}
			i++;
			goto JL0010;
		}
		return self;
	}
	if ( TriggerActor == None )
	{
		FindTriggerActor();
		if ( TriggerActor == None )
		{
			return None;
		}
	}
	if ( (TriggerActor2 != None) && (VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location)) )
	{
		return TriggerActor2;
	}
	return TriggerActor;
}

defaultproperties
{
    bEnabled=True
    bDirectional=True
    Texture=Texture'S_Teleport'
    SoundVolume=128
    CollisionRadius=18.00
    CollisionHeight=40.00
    bCollideActors=True
}