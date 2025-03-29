//================================================================================
// Pickup.
//================================================================================
class Pickup expands Inventory
	abstract;

var Inventory Inv;
var travel int NumCopies;
var() bool bCanHaveMultipleCopies;
var() bool bCanActivate;
var() localized string ExpireMessage;
var() bool bAutoActivate;

replication
{
	un?reliable if ( (Role == 4) && bNetOwner )
		NumCopies;
}

function TravelPostAccept ()
{
	Super.TravelPostAccept();
	PickupFunction(Pawn(Owner));
}

function bool HandlePickupQuery (Inventory Item)
{
	if ( Item.Class == Class )
	{
		if ( bCanHaveMultipleCopies )
		{
			NumCopies++;
			Pawn(Owner).ClientMessage(PickupMessage,'Pickup');
			Item.PlaySound(Item.PickupSound,,2.00);
			Item.SetRespawn();
		}
		else
		{
			if ( bDisplayableInv )
			{
				if ( Charge < Item.Charge )
				{
					Charge=Item.Charge;
				}
				Pawn(Owner).ClientMessage(PickupMessage,'Pickup');
				Item.PlaySound(PickupSound,,2.00);
				Item.SetRespawn();
			}
		}
		return True;
	}
	if ( Inventory == None )
	{
		return False;
	}
	return Inventory.HandlePickupQuery(Item);
}

function float UseCharge (float Amount);

function Inventory SpawnCopy (Pawn Other)
{
	local Inventory Copy;

	Copy=Super.SpawnCopy(Other);
	Copy.Charge=Charge;
	return Copy;
}

auto state Pickup expands Pickup
{
	function Touch (Actor Other)
	{
		local Inventory Copy;
	
		if ( ValidTouch(Other) )
		{
			Copy=SpawnCopy(Pawn(Other));
			if ( Level.Game.LocalLog != None )
			{
				Level.Game.LocalLog.LogPickup(self,Pawn(Other));
			}
			if ( Level.Game.WorldLog != None )
			{
				Level.Game.WorldLog.LogPickup(self,Pawn(Other));
			}
			if ( bActivatable && (Pawn(Other).SelectedItem == None) )
			{
				Pawn(Other).SelectedItem=Copy;
			}
			if ( bActivatable && bAutoActivate && Pawn(Other).bAutoActivate )
			{
				Copy.Activate();
			}
			Pawn(Other).ClientMessage(PickupMessage,'Pickup');
			PlaySound(PickupSound,,2.00);
			Pickup(Copy).PickupFunction(Pawn(Other));
		}
	}
	
	function BeginState ()
	{
		Super.BeginState();
		NumCopies=0;
	}
	
}

function PickupFunction (Pawn Other)
{
}

function UsedUp ()
{
	if ( Pawn(Owner) != None )
	{
		bActivatable=False;
		Pawn(Owner).NextItem();
		if ( Pawn(Owner).SelectedItem == self )
		{
			Pawn(Owner).NextItem();
			if ( Pawn(Owner).SelectedItem == self )
			{
				Pawn(Owner).SelectedItem=None;
			}
		}
		Pawn(Owner).ClientMessage(ExpireMessage);
	}
	Owner.PlaySound(DeActivateSound);
	Destroy();
}

state Activated expands Activated
{
	function Activate ()
	{
		if ( (Pawn(Owner) != None) && Pawn(Owner).bAutoActivate && bAutoActivate && (Charge > 0) )
		{
			return;
		}
		Super.Activate();
	}
	
}

defaultproperties
{
    bRotatingPickup=False
}