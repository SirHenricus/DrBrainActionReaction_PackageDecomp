//================================================================================
// SPHiddenMonitor.
//================================================================================
class SPHiddenMonitor expands SPCameraInterface;

function Connect (SPPlayer P)
{
	if ( CurrentPlayer == None )
	{
		CurrentPlayer=P;
		CurrentPlayer.CameraInterface=self;
		CurrentPlayer.UseCamera(True);
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

defaultproperties
{
    bHidden=True
    DrawType=0
    Mesh=None
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
}