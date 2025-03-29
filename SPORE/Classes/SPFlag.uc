//================================================================================
// SPFlag.
//================================================================================
class SPFlag expands Pickup;

var bool bclosed;
var() localized string BroadcastPointsString;
var() localized string CapturedFlagString;

event BeginPlay ()
{
	SetTimer(0.20,True);
	bclosed=False;
}

auto state Pickup expands Pickup
{
	event Timer ()
	{
		local SPPlayer Player;
		local int nearbyPlayers;
	
		foreach AllActors(Class'SPPlayer',Player)
		{
			if ( VSize(Location - Player.Location) <= 5 * (CollisionRadius + Player.CollisionRadius) )
			{
				nearbyPlayers++;
			}
		}
		if ( nearbyPlayers > 0 )
		{
			if ( bclosed == False )
			{
				bclosed=True;
				TweenAnim('Closed',0.10);
				PlaySound(Sound'flagclos',3);
			}
		}
		else
		{
			if ( bclosed == True )
			{
				bclosed=False;
				TweenAnim('Opened',0.10);
				PlaySound(Sound'flagopen',3);
			}
		}
	}
	
	function Touch (Actor Other)
	{
		local Inventory Copy;
		local SPFlagPoint CurrentFlagPoint;
		local int i;
		local string Message;
		local SPPlayer Player;
	
		if ( ValidTouch(Other) )
		{
			Copy=SpawnCopy(Pawn(Other));
			if ( bActivatable && (Pawn(Other).SelectedItem == None) )
			{
				Pawn(Other).SelectedItem=Copy;
			}
			if ( bActivatable && bAutoActivate && Pawn(Other).bAutoActivate )
			{
				Copy.Activate();
			}
			PlaySound(PickupSound,,2.00);
			AmbientSound=None;
			SPPlayer(Other).PlayCaptureFlagSpeech();
			LightType=0;
			SPFlagGameInfo(Level.Game).SpawnFlag();
			SPPlayer(Other).IncrementScore();
			Message=SPPlayer(Other).PlayerReplicationInfo.PlayerName $ CapturedFlagString;
			BroadcastMessage(Message,False);
			Message=SPPlayer(Other).PlayerReplicationInfo.PlayerName $ "'s" $ BroadcastPointsString $ string(SPPlayer(Other).PlayerReplicationInfo.Score);
			BroadcastMessage(Message,False);
		}
	}
	
	function BeginState ()
	{
		Super.BeginState();
		NumCopies=0;
	}
	
}

defaultproperties
{
    BroadcastPointsString=" score is now "
    CapturedFlagString=" found the secret plans"
    bCanHaveMultipleCopies=True
    bInstantRespawn=True
    bRotatingPickup=True
    PickupMessage=""
    PlayerViewMesh=LodMesh'Case'
    PickupViewMesh=LodMesh'Case'
    PickupSound=Sound'SPFlag.flagpick'
    Mesh=LodMesh'Case'
    AmbientSound=Sound'SPFlag.flagamb'
    CollisionRadius=40.00
    LightType=LT_Steady
    LightBrightness=200
    LightHue=35
    LightRadius=1
    VolumeBrightness=153
    VolumeRadius=1
    bActorShadows=True
}