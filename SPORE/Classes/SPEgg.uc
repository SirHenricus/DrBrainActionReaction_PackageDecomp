//================================================================================
// SPEgg.
//================================================================================
class SPEgg expands SPBall;

var() float SpawnTime;
var() Class<Pawn> PawnType;
var() bool bWaitForBump;
var() Mesh PawnMesh;

event BeginPlay ()
{
	Super.BeginPlay();
	if (  !bWaitForBump )
	{
		SetTimer(SpawnTime,False);
	}
}

event Bump (Actor Other)
{
	if ( bWaitForBump && (Other.IsA('SPPlayer') || Other.IsA('Projectile')) )
	{
		SetTimer(SpawnTime,False);
		bWaitForBump=False;
	}
}

event Timer ()
{
	local Pawn P;

	P=Spawn(PawnType);
	if ( (P != None) && (PawnMesh != None) )
	{
		P.Mesh=PawnMesh;
	}
	Destroy();
}

event Destroyed ()
{
	local SPGloveBit bit;
	local int i;
	local float MaxSpeed;

	PlaySound(Sound'dronewosh',3);
	MaxSpeed=1000.00;
	i=0;
JL001C:
	if ( i < 10 )
	{
		if ( i >= 5 )
		{
			bit=Spawn(Class'SPGloveBit5');
			bit.Skin=Skin;
		}
		else
		{
			bit=Spawn(Class'SPGloveBit4');
			bit.Skin=Skin;
		}
		bit.Velocity.X=Rand(MaxSpeed) - MaxSpeed / 2;
		bit.Velocity.Y=Rand(MaxSpeed) - MaxSpeed / 2;
		bit.Velocity.Z=Rand(MaxSpeed) - MaxSpeed / 2;
		bit.DrawScale=0.50 * FRand();
		bit.RotationRate.Yaw=300000 + Rand(30000);
		if ( Rand(2) == 0 )
		{
			bit.RotationRate.Yaw *= -1;
		}
		bit.RotationRate.Pitch=300000 + Rand(30000);
		if ( Rand(2) == 0 )
		{
			bit.RotationRate.Pitch *= -1;
		}
		bit.RotationRate.Roll=300000 + Rand(30000);
		if ( Rand(2) == 0 )
		{
			bit.RotationRate.Roll *= -1;
		}
		bit.bFixedRotationDir=True;
		bit.LifeSpan=1.00;
		i++;
		goto JL001C;
	}
	Super.Destroyed();
}

defaultproperties
{
    SpawnTime=3.00
    PawnType=Class'SPTurtle'
}