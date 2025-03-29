//================================================================================
// SPDrone.
//================================================================================
class SPDrone expands SPPawn;

enum ESporeColor {
	SC_Red,
	SC_Green,
	SC_Blue,
	SC_LightBlue,
	SC_Yellow,
	SC_Purple,
	SC_Random
};

var() bool bInvincible;
var() ESporeColor Color;

event BeginPlay ()
{
	Super.BeginPlay();
	if ( Color == 6 )
	{
		Randomize();
	}
	if ( Color == 0 )
	{
		Skin=Texture'Drone05';
	}
	else
	{
		if ( Color == 2 )
		{
			Skin=Texture'Drone01';
		}
		else
		{
			if ( Color == 3 )
			{
				Skin=Texture'Drone02';
			}
			else
			{
				if ( Color == 1 )
				{
					Skin=Texture'Drone03';
				}
				else
				{
					if ( Color == 5 )
					{
						Skin=Texture'Drone04';
					}
					else
					{
						if ( Color == 4 )
						{
							Skin=Texture'Drone06';
						}
					}
				}
			}
		}
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
		if ( i >= 35 )
		{
			bit=Spawn(Class'SPGloveBit5');
			bit.Skin=Skin;
		}
		else
		{
			if ( i >= 25 )
			{
				bit=Spawn(Class'SPGloveBit4');
				bit.Skin=Skin;
			}
			else
			{
				if ( i >= 15 )
				{
					bit=Spawn(Class'SPGloveBit1');
				}
				else
				{
					if ( i >= 6 )
					{
						bit=Spawn(Class'SPGloveBit2');
					}
					else
					{
						bit=Spawn(Class'SPGloveBit3');
					}
				}
			}
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

function Randomize ()
{
	local int C;

	C=Rand(6);
	if ( C == 0 )
	{
		Color=0;
	}
	else
	{
		if ( C == 1 )
		{
			Color=1;
		}
		else
		{
			if ( C == 2 )
			{
				Color=2;
			}
			else
			{
				if ( C == 3 )
				{
					Color=3;
				}
				else
				{
					if ( C == 4 )
					{
						Color=4;
					}
					else
					{
						if ( C == 5 )
						{
							Color=5;
						}
					}
				}
			}
		}
	}
}

function PlayWalking ()
{
	LoopAnim('Walk',0.50);
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	if ( (DamageType == 'stun') &&  !bInvincible )
	{
		Destroy();
	}
}

function SeePlayer (Actor SeenPlayer)
{
}

function HearNoise (float Loudness, Actor NoiseMaker)
{
}

state Chasing expands Chasing
{
Begin:
	GotoState('MoveBumpTurning');
}

state TotallyIgnoringPlayer expands TotallyIgnoringPlayer
{
	ignores  KilledBy;
	
	event AnimEnd ()
	{
		PlayIdleAnim();
	}
	
Begin:
	PlayIdleAnim();
	GotoState('TotallyIgnoring');
}

state TotallyIgnoring
{
	ignores  KilledBy;
	
	event AnimEnd ()
	{
		PlayIdleAnim();
	}
	
Begin:
	PlayIdleAnim();
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'drone'
    DrawScale=1.70
    AmbientSound=Sound'drone.dronemove'
    CollisionRadius=45.00
    CollisionHeight=42.00
    Mass=10000000000.00
}