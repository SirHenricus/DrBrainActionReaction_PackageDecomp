//================================================================================
// SPStunProjectileExhaust.
//================================================================================
class SPStunProjectileExhaust expands SPActor;

var SPStunProjectile missile;

event PreBeginPlay ()
{
	Super.PreBeginPlay();
}

event Tick (float DeltaTime)
{
	local Vector Loc;

	Super.Tick(DeltaTime);
	Loc=missile.Location - vector(missile.Rotation) * 40;
	SetLocation(Loc);
}

defaultproperties
{
    Texture=None
}