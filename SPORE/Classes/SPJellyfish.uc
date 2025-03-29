//================================================================================
// SPJellyfish.
//================================================================================
class SPJellyfish expands Effects;

event BeginPlay ()
{
	local Rotator Rot;

	Super.BeginPlay();
	Rot.Pitch=32767 / 2;
	SetRotation(Rot);
	LoopAnim('swim',0.25);
}

event Touch (Actor Other)
{
	Destroy();
}

event Bump (Actor Other)
{
	Destroy();
}

event HitWall (Vector HitNormal, Actor Wall)
{
	Destroy();
}

defaultproperties
{
    bNetOptional=True
    Physics=PHYS_Walking
    Velocity=(X=0.00,Y=0.00,Z=10.00)
    DrawType=DT_Sprite
    Mesh=LodMesh'jellyfish'
    bCollideActors=True
    bCollideWorld=True
    LightType=LT_Steady
    LightBrightness=129
    LightSaturation=64
    LightRadius=15
    Mass=2.00
    Buoyancy=1.00
}