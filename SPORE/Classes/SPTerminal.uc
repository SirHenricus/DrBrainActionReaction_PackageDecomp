//================================================================================
// SPTerminal.
//================================================================================
class SPTerminal expands SPActor;

var() bool bKillWithProjectile;
var() bool bKillWhenTriggered;
var() bool bAnimate;
var() float AnimationFPS;
var() int NumSkins;

event BeginPlay ()
{
	Super.BeginPlay();
	if ( bAnimate )
	{
		CreateSkinAnimation(0,NumSkins - 1,1.00 / AnimationFPS,True);
		StartAnimQ();
	}
}

event Bump (Actor Other)
{
	if ( bKillWithProjectile && Other.IsA('Projectile') )
	{
		GotoState('Dying');
	}
}

event Trigger (Actor Other, Pawn Instigator)
{
	if ( bKillWhenTriggered )
	{
		GotoState('Dying');
	}
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
	if ( i < 45 )
	{
		if ( i >= 23 )
		{
			bit=Spawn(Class'SPGloveBit5');
			bit.Skin=Skin;
		}
		else
		{
			bit=Spawn(Class'SPGloveBit4');
			bit.Skin=Skin;
		}
		if ( Skin != None )
		{
			bit.Skin=Skin;
		}
		else
		{
			bit.Skin=Texture'JTerminal_02';
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

state Dying
{
Begin:
	PlayAnim('crash');
	FinishAnim();
	Sleep(0.50);
	Destroy();
}

defaultproperties
{
    bKillWithProjectile=True
    DrawType=DT_Sprite
    Mesh=LodMesh'Terminal'
    CollisionRadius=30.00
    CollisionHeight=40.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}