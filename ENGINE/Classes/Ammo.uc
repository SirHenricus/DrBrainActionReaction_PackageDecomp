//================================================================================
// Ammo.
//================================================================================
class Ammo expands Pickup
	abstract;

var() travel int AmmoAmount;
var() travel int MaxAmmo;
var() Class<Ammo> ParentAmmo;
var() byte UsedInWeaponSlot[10];
var Ammo PAmmo;

replication
{
	un?reliable if ( (Role == 4) && bNetOwner )
		AmmoAmount;
}

event float BotDesireability (Pawn Bot)
{
	local Ammo AlreadyHas;

	if ( ParentAmmo != None )
	{
		AlreadyHas=Ammo(Bot.FindInventoryType(ParentAmmo));
	}
	else
	{
		AlreadyHas=Ammo(Bot.FindInventoryType(Class));
	}
	if ( AlreadyHas == None )
	{
		return 0.35 * MaxDesireability;
	}
	if ( AlreadyHas.AmmoAmount == 0 )
	{
		return MaxDesireability;
	}
	if ( AlreadyHas.AmmoAmount >= AlreadyHas.MaxAmmo )
	{
		return -1.00;
	}
	return MaxDesireability * FMin(1.00,0.15 * MaxAmmo / AlreadyHas.AmmoAmount);
}

function bool HandlePickupQuery (Inventory Item)
{
	if ( (Class == Item.Class) || ClassIsChildOf(Item.Class,Class'Ammo') && (Class == Ammo(Item).ParentAmmo) )
	{
		if ( AmmoAmount == MaxAmmo )
		{
			return True;
		}
		Pawn(Owner).ClientMessage(Item.PickupMessage,'Pickup');
		Item.PlaySound(Item.PickupSound);
		AddAmmo(Ammo(Item).AmmoAmount);
		Item.SetRespawn();
		return True;
	}
	if ( Inventory == None )
	{
		return False;
	}
	return Inventory.HandlePickupQuery(Item);
}

function bool UseAmmo (int AmountNeeded)
{
	if ( AmmoAmount < AmountNeeded )
	{
		return False;
	}
	AmmoAmount -= AmountNeeded;
	return True;
}

function bool AddAmmo (int AmmoToAdd)
{
	if ( AmmoAmount >= MaxAmmo )
	{
		return False;
	}
	AmmoAmount += AmmoToAdd;
	if ( AmmoAmount > MaxAmmo )
	{
		AmmoAmount=MaxAmmo;
	}
	return True;
}

function Inventory SpawnCopy (Pawn Other)
{
	local Inventory Copy;

	if ( ParentAmmo != None )
	{
		Copy=Spawn(ParentAmmo,Other);
		Copy.Tag=Tag;
		Copy.Event=Event;
		Copy.Instigator=Other;
		Ammo(Copy).AmmoAmount=AmmoAmount;
		Copy.BecomeItem();
		Other.AddInventory(Copy);
		Copy.GotoState('None');
		if ( Level.Game.ShouldRespawn(self) )
		{
			GotoState('Sleeping');
		}
		else
		{
			Destroy();
		}
		return Copy;
	}
	Copy=Super.SpawnCopy(Other);
	Ammo(Copy).AmmoAmount=AmmoAmount;
	return Copy;
}

defaultproperties
{
    PickupMessage="You picked up some ammo."
    RespawnTime=30.00
    MaxDesireability=0.20
    Texture=Texture'S_Ammo'
    bCollideActors=False
}