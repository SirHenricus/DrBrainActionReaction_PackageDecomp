//================================================================================
// SPCamera.
//================================================================================
class SPCamera expands SPActor;

var() ECameraMode cameraMode;
var() float TrackingDelay;
var() float DelayBetweenScans;
var() float ScanTime;
var SPPlayer Controller;
var bool bScanning;
enum ECameraMode {
	CM_FixedView,
	CM_TrackPlayer,
	CM_ScanHorizontal,
	CM_PlayerControl
};


event BeginPlay ()
{
	if ( cameraMode == 1 )
	{
		SetTimer(TrackingDelay,True);
	}
	else
	{
		if ( cameraMode == 2 )
		{
			RotationRate.Roll=0;
			RotationRate.Pitch=0;
			bScanning=True;
			bFixedRotationDir=True;
			SetTimer(ScanTime,False);
		}
	}
}

event Tick (float tDelay)
{
	if ( cameraMode == 3 )
	{
		if ( Controller != None )
		{
			SetRotation(Controller.ViewRotation);
		}
	}
}

event Timer ()
{
	if ( cameraMode == 1 )
	{
		RotateToPlayer();
	}
	else
	{
		if ( cameraMode == 2 )
		{
			if ( bScanning )
			{
				bScanning=False;
				bFixedRotationDir=False;
				SetTimer(DelayBetweenScans,False);
			}
			else
			{
				bScanning=True;
				RotationRate.Yaw *= -1;
				bFixedRotationDir=True;
				SetTimer(ScanTime,False);
			}
		}
	}
}

function RotateToPlayer ()
{
	local Rotator Rot;
	local Vector toPlayer;
	local PlayerPawn pPawn;
	local Vector playerPos;

	foreach AllActors(Class'PlayerPawn',pPawn)
	{
		playerPos=pPawn.Location;
		goto JL0028;
	}
	if ( pPawn != None )
	{
		toPlayer=playerPos - Location;
		bRotateToDesired=True;
	}
	else
	{
		bRotateToDesired=False;
	}
	DesiredRotation=rotator(toPlayer);
}

defaultproperties
{
    TrackingDelay=0.10
    DelayBetweenScans=2.00
    ScanTime=7.00
    Physics=PHYS_Walking
    DrawType=DT_Sprite
    Mesh=LodMesh'SporeCam'
    CollisionRadius=10.00
    CollisionHeight=10.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
    RotationRate=(Pitch=2500,Yaw=2500,Roll=2500)
}