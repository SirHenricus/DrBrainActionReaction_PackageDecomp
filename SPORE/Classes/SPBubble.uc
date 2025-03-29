//================================================================================
// SPBubble.
//================================================================================
class SPBubble expands Effects;

simulated function BeginPlay ()
{
	Super.BeginPlay();
	PlaySound(EffectSound2);
	LifeSpan=3.00 + 4 * FRand();
	Buoyancy=3.05 + FRand() * 0.10;
	DrawScale += FRand() * DrawScale / 2;
	Acceleration= -Buoyancy / 3 * Region.Zone.ZoneGravity;
}

event Touch (Actor Other)
{
	if (  !Other.IsA('SPBubble') )
	{
		Destroy();
	}
}

event HitWall (Vector HitNormal, Actor Wall)
{
	Destroy();
}

defaultproperties
{
    bNetOptional=True
    Physics=PHYS_Walking
    DrawType=DT_Sprite
    Style=STY_Translucent
    Texture=Texture'bubble'
    CollisionRadius=5.00
    CollisionHeight=5.00
    bCollideActors=True
    bCollideWorld=True
    Mass=2.00
    Buoyancy=3.75
}