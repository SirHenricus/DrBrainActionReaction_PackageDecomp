//================================================================================
// SPPushableTrampoline.
//================================================================================
class SPPushableTrampoline expands SPTrampoline;

auto state Coiled expands Coiled
{
	function Bump (Actor Other)
	{
		local float speed;
		local float oldZ;
	
		if ( Other.IsA('PlayerPawn') && (Other.Physics == 2) && ((LimitedToClass == None) || (Other.Class == LimitedToClass)) )
		{
			Pending=PlayerPawn(Other);
			SetTimer(0.01,False);
		}
		else
		{
			oldZ=Velocity.Z;
			speed=VSize(Other.Velocity);
			Velocity=Other.Velocity * FMin(120.00,20.00 + speed) / speed;
			Velocity.Z=32.00;
			SetPhysics(2);
			Instigator=Pawn(Other);
		}
	}
	
}

defaultproperties
{
    Mesh=LodMesh'ptrampo'
    CollisionHeight=21.00
    bProjTarget=False
}