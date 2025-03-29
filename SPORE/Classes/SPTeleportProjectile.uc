//================================================================================
// SPTeleportProjectile.
//================================================================================
class SPTeleportProjectile expands SPPushProjectile;

auto state Flying expands Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local Vector NewLocation;
	
		NewLocation=Other.Location;
		NewLocation.X += Rand(1000) - 500;
		NewLocation.Y += Rand(1000) - 500;
		NewLocation.Z += Rand(500);
		Other.SetLocation(NewLocation);
	}
	
}