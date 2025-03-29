//================================================================================
// SPTractorBeam.
//================================================================================
class SPTractorBeam expands Pickup;

var float TimeChange;

state Activated expands Activated
{
	function BeginState ()
	{
		TimeChange=0.00;
		if ( SPPlayer(Owner) != None )
		{
			SPPlayer(Owner).engageTractorBeam=True;
		}
		Super.BeginState();
	}
	
	function Tick (float DeltaTime)
	{
		TimeChange += DeltaTime * 10;
		if ( TimeChange > 1 )
		{
			Charge -= TimeChange;
			TimeChange=TimeChange - TimeChange;
		}
		if ( Pawn(Owner) == None )
		{
			UsedUp();
			return;
		}
		if ( Charge < 0 )
		{
			UsedUp();
		}
	}
	
	function EndState ()
	{
		if ( SPPlayer(Owner) != None )
		{
			SPPlayer(Owner).engageTractorBeam=False;
		}
		Super.EndState();
	}
	
Begin:
}

state DeActivated
{
Begin:
}

defaultproperties
{
    ExpireMessage="Tractor Beam batteries have died."
    bActivatable=True
    bDisplayableInv=True
    PickupMessage="You picked up the Tractor Beam"
    ItemName="Tractor Beam"
    RespawnTime=20.00
    PickupViewMesh=LodMesh'turtley'
    Charge=1000
    Icon=Texture'Engine.S_Player'
    RemoteRole=ROLE_DumbProxy
    Mesh=LodMesh'turtley'
    AmbientGlow=96
    CollisionRadius=22.00
    CollisionHeight=4.00
    LightBrightness=100
    LightHue=33
    LightSaturation=187
    LightRadius=7
}