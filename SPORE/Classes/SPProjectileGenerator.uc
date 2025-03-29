//================================================================================
// SPProjectileGenerator.
//================================================================================
class SPProjectileGenerator expands Effects;

var(ProjectileAmount) int minProjectiles;
var(ProjectileAmount) int maxProjectiles;
var(ProjectileDelay) float minProjectileDelay;
var(ProjectileDelay) float maxProjectileDelay;
var() int dispersionRadius;
var() Class<SPPushProjectile> ProjectileType;
var() float ProjectileLifeSpan;

function BeginPlay ()
{
	if ( ProjectileType != None )
	{
		SetTimer(minProjectileDelay + Rand(maxProjectileDelay - minProjectileDelay),False);
	}
}

function Timer ()
{
	local SPPushProjectile B;
	local int numProjectiles;
	local int i;
	local Vector Loc;

	numProjectiles=minProjectiles + Rand(maxProjectiles - minProjectiles);
	i=0;
JL0022:
	if ( i < numProjectiles )
	{
		Loc=Location;
		Loc.X += Rand(dispersionRadius * 2) - dispersionRadius;
		Loc.Y += Rand(dispersionRadius * 2) - dispersionRadius;
		B=Spawn(ProjectileType,Owner,'None',Loc);
		B.SetRotation(Rotation);
		if ( B != None )
		{
			B.DrawScale=FRand() * 0.50 + 0.05;
			B.LifeSpan=ProjectileLifeSpan;
			B.Go();
		}
		i++;
		goto JL0022;
	}
	SetTimer(minProjectileDelay + Rand(maxProjectileDelay - minProjectileDelay),False);
}

defaultproperties
{
    minProjectiles=1
    maxProjectiles=1
    minProjectileDelay=0.10
    maxProjectileDelay=0.20
    ProjectileType=Class'SPBubbleProjectile'
    ProjectileLifeSpan=5.00
    bHidden=True
    bDirectional=True
    DrawType=DT_Sprite
}