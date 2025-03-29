//================================================================================
// SPGelBubble.
//================================================================================
class SPGelBubble expands Effects;

var() float UpdateRate;
var int Direction;

simulated function BeginPlay ()
{
	Super.BeginPlay();
	PlaySound(EffectSound2);
	LifeSpan=9.00 + 4 * FRand();
	Buoyancy=1.50 + FRand() * 0.10;
	DrawScale += FRand() * DrawScale / 2;
	Acceleration= -Buoyancy / 3 * Region.Zone.ZoneGravity;
	Direction=1;
	if ( UpdateRate > 0 )
	{
		SetTimer(UpdateRate,True);
	}
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

event Timer ()
{
	if ( FRand() > 0.70 )
	{
		Direction *= -1;
	}
	DrawScale += 0.05 * Direction;
	SetCollisionSize(CollisionRadius * DrawScale / Default.DrawScale,CollisionHeight * DrawScale / Default.DrawScale);
}

defaultproperties
{
    UpdateRate=0.10
    bNetOptional=True
    Physics=PHYS_Walking
    DrawType=DT_Sprite
    Style=STY_Normal
    Texture=Texture'GelBubble'
    CollisionRadius=30.00
    CollisionHeight=22.00
    bCollideActors=True
    bCollideWorld=True
    Mass=2.00
    Buoyancy=3.75
}