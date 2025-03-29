//================================================================================
// SPPortableMonitor.
//================================================================================
class SPPortableMonitor expands Pickup;

var SPHiddenMonitor monitor;

event BeginPlay ()
{
	Super.BeginPlay();
	monitor=Spawn(Class'SPHiddenMonitor');
	if ( monitor != None )
	{
		monitor.Event=Event;
	}
}

state Activated expands Activated
{
	function BeginState ()
	{
		local SPPlayer Player;
	
		Player=SPPlayer(Owner);
		if ( Player != None )
		{
			if ( Player.CameraInterface == None )
			{
				monitor.Connect(Player);
				Player.bPortableCam=True;
			}
		}
		Super.BeginState();
	}
	
	function EndState ()
	{
		if ( SPPlayer(Owner) != None )
		{
			monitor.Disconnect(SPPlayer(Owner));
		}
		Super.EndState();
	}
	
}

state DeActivated
{
Begin:
}

defaultproperties
{
    ExpireMessage="Monitor batteries have died."
    bActivatable=True
    bDisplayableInv=True
    PickupMessage="You picked up the Portable Monitor"
    ItemName="Portable Monitor"
    PickupViewMesh=LodMesh'SporeCam'
    Icon=Texture'Skins.JCamPlatform_02'
    Mesh=LodMesh'SporeCam'
    DrawScale=0.50
}