//================================================================================
// Mutator.
//================================================================================
class Mutator expands Info;

var Mutator NextMutator;
var Class<Weapon> DefaultWeapon;

event PreBeginPlay ()
{
}

function Class<Weapon> MutatedDefaultWeapon ()
{
	local Class<Weapon> W;

	if ( NextMutator != None )
	{
		W=NextMutator.MutatedDefaultWeapon();
		if ( W == Level.Game.DefaultWeapon )
		{
			W=MyDefaultWeapon();
		}
	}
	else
	{
		W=MyDefaultWeapon();
	}
	return W;
}

function Class<Weapon> MyDefaultWeapon ()
{
	if ( DefaultWeapon != None )
	{
		return DefaultWeapon;
	}
	else
	{
		return Level.Game.DefaultWeapon;
	}
}

function AddMutator (Mutator M)
{
	if ( NextMutator == None )
	{
		NextMutator=M;
	}
	else
	{
		NextMutator.AddMutator(M);
	}
}

function bool ReplaceWith (Actor Other, string aClassName)
{
	local Actor A;
	local Class<Actor> aClass;

	aClass=Class<Actor>(DynamicLoadObject(aClassName,Class'Class'));
	if ( aClass != None )
	{
		A=Spawn(aClass,,Other.Tag,Other.Location,Other.Rotation);
	}
	if ( Other.IsA('Inventory') && (Inventory(Other).myMarker != None) )
	{
		Inventory(Other).myMarker.markedItem=Inventory(A);
		if ( Inventory(A) != None )
		{
			Inventory(A).myMarker=Inventory(Other).myMarker;
		}
		Inventory(Other).myMarker=None;
	}
	if ( A != None )
	{
		A.Event=Other.Event;
		A.Tag=Other.Tag;
		return True;
	}
	return False;
}

function bool IsRelevant (Actor Other, out byte bSuperRelevant)
{
	local bool bResult;

	bResult=CheckReplacement(Other,bSuperRelevant);
	if ( bResult && (NextMutator != None) )
	{
		bResult=NextMutator.IsRelevant(Other,bSuperRelevant);
	}
	return bResult;
}

function bool CheckReplacement (Actor Other, out byte bSuperRelevant)
{
	return True;
}