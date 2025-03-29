//================================================================================
// SPTransmogrifyProjectile.
//================================================================================
class SPTransmogrifyProjectile expands SPPushProjectile;

var() Class<Actor> TransmogrifyClass;

auto state Flying expands Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local Vector SpawnLocation;
		local Vector SpawnVelocity;
		local Actor Spawned;
	
		SpawnLocation=Other.Location;
		SpawnVelocity=Other.Velocity;
		Other.Destroy();
		Spawned=Spawn(TransmogrifyClass,,,SpawnLocation);
		Spawned.Velocity=SpawnVelocity;
	}
	
}

defaultproperties
{
    TransmogrifyClass=Class'SPLargeBall'
}