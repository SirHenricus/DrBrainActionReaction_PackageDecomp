//================================================================================
// SPPlayerCharger.
//================================================================================
class SPPlayerCharger expands Pickup;

var() float PlayerCharge;

state Activated expands Activated
{
	function BeginState ()
	{
		if ( SPPlayer(Owner) != None )
		{
			SPPlayer(Owner).Charge=PlayerCharge;
			SPPlayer(Owner).PlaySound(Sound'vestOnSound',0);
		}
		Super.BeginState();
	}
	
	function EndState ()
	{
		if ( SPPlayer(Owner) != None )
		{
			SPPlayer(Owner).Charge=0.00;
			SPPlayer(Owner).PlaySound(Sound'vestOffSound',0);
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
    PlayerCharge=-100.00
    ExpireMessage="Attractor Vest batteries have died."
    bActivatable=True
    bDisplayableInv=True
    bRotatingPickup=True
    PickupMessage="You picked up the Attractor Vest"
    ItemName="Attractor Vest"
    RespawnTime=20.00
    PickupViewMesh=LodMesh'vest'
    Charge=1000
    Icon=Texture'Icons.vestoff'
    bTravel=False
    RemoteRole=ROLE_DumbProxy
    Mesh=LodMesh'vest'
    CollisionRadius=22.00
    CollisionHeight=40.00
    LightBrightness=100
    LightHue=33
    LightSaturation=187
    LightRadius=7
}