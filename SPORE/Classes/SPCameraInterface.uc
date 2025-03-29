//================================================================================
// SPCameraInterface.
//================================================================================
class SPCameraInterface expands SPActor;

var SPPlayer CurrentPlayer;
var SPCamera CurCamera;

function Connect (SPPlayer P)
{
	if ( CurrentPlayer == None )
	{
		CurrentPlayer=P;
		CurrentPlayer.CameraInterface=self;
		P.UseCamera(True);
	}
}

function Disconnect (SPPlayer P)
{
	if ( P == CurrentPlayer )
	{
		CurrentPlayer.UseCamera(False);
		CurrentPlayer.CameraInterface=None;
		CurrentPlayer=None;
	}
}

function BeginOperating (SPPlayer Player)
{
	local SPCamera Camera;

	if ( (Player != None) && (Player == CurrentPlayer) )
	{
		foreach AllActors(Class'SPCamera',Camera,Event)
		{
			CurCamera=Camera;
			CurCamera.Controller=Player;
			goto JL0054;
		}
JL0054:
	}
}

function StopOperating (SPPlayer Player)
{
	local SPCamera Camera;

	if ( (Player != None) && (Player == CurrentPlayer) )
	{
		foreach AllActors(Class'SPCamera',Camera,Event)
		{
			Camera.Controller=None;
		}
	}
	CurCamera=None;
}

function SPCamera GetCamera ()
{
	return CurCamera;
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'CamPlatform'
    CollisionHeight=5.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}