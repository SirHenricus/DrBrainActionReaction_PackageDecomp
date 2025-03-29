//================================================================================
// SPSmallBall.
//================================================================================
class SPSmallBall expands SPBall;

event Destroyed ()
{
	local SPGloveBit bit;
	local int i;
	local float MaxSpeed;

	if ( bSilentDestroy )
	{
		Super.Destroyed();
		return;
	}
	PlaySound(Sound'dronewosh',3);
	MaxSpeed=1000.00;
	i=0;
JL002D:
	if ( i < 4 )
	{
		if ( i >= 2 )
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
		goto JL002D;
	}
	Super.Destroyed();
}

defaultproperties
{
    BallSound=Sound'Balls.ball_s'
    Mesh=LodMesh'BallSM'
    DrawScale=0.15
    CollisionRadius=5.40
    CollisionHeight=5.40
    Mass=10.00
}