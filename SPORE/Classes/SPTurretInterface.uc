//================================================================================
// SPTurretInterface.
//================================================================================
class SPTurretInterface expands SPActor;

var SPPlayer CurrentPlayer;
var Vector StartPos;
var Vector ActivePos;

event BeginPlay ()
{
	Super.BeginPlay();
	StartPos=Location;
	ActivePos=StartPos;
	ActivePos.Z += 75;
}

function Connect (SPPlayer P)
{
	if ( CurrentPlayer == None )
	{
		CurrentPlayer=P;
		CurrentPlayer.TurretInterface=self;
		Move(ActivePos - Location);
		P.UseTurret(True);
	}
}

function Disconnect (SPPlayer P)
{
	if ( P == CurrentPlayer )
	{
		CurrentPlayer.UseTurret(False);
		CurrentPlayer.TurretInterface=None;
		CurrentPlayer=None;
		Move(StartPos - Location);
	}
}

function BeginOperating (SPPlayer Player)
{
	local SPTurret turret;

	if ( (Player != None) && (Player == CurrentPlayer) )
	{
		foreach AllActors(Class'SPTurret',turret,Event)
		{
			turret.Controller=Player;
		}
	}
}

function StopOperating (SPPlayer Player)
{
	local SPTurret turret;

	if ( (Player != None) && (Player == CurrentPlayer) )
	{
		foreach AllActors(Class'SPTurret',turret,Event)
		{
			turret.Controller=None;
		}
	}
}

function Fire (optional float F)
{
	local SPTurret turret;

	foreach AllActors(Class'SPTurret',turret,Event)
	{
		if (  !turret.IsInState('Firing') )
		{
			turret.GotoState('Firing');
		}
	}
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'TurretPlatform'
    CollisionHeight=5.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}