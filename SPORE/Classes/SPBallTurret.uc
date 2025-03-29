//================================================================================
// SPBallTurret.
//================================================================================
class SPBallTurret expands SPTurret;

var() Class<SPBall> BallType;
var() float BallMass;
var() float BallElasticity;
var() bool BallIgnorsGavityInChargeZone;
var() bool bBallDiesSilently;

function FireProjectile ()
{
	local Vector Start;
	local SPBall ball;

	if ( bCheckRange && (DistanceToPlayer() > TriggerRange) )
	{
		return;
	}
	Start=Location + vector(Rotation) * 10;
	ball=Spawn(BallType,,,Start,Rotation);
	if ( ball != None )
	{
		ball.Velocity=vector(Rotation) * ProjectileSpeed;
		ball.SetLifeSpan(ProjectileLifeSpan);
		ball.IgnoreGravityInChargeZone=BallIgnorsGavityInChargeZone;
		ball.bSilentDestroy=bBallDiesSilently;
		if ( BallMass != 0 )
		{
			ball.Mass=BallMass;
		}
		if ( BallElasticity != 0 )
		{
			ball.Elasticity=BallElasticity;
		}
	}
}

state Firing expands Firing
{
Begin:
	PlaySound(Sound'turret_f',3);
	PlayAnim('Fire');
	FinishAnim();
	FireProjectile();
	GotoState('None');
}

defaultproperties
{
    BallType=Class'SPMediumBall'
    BallIgnorsGavityInChargeZone=True
    AimType=AT_FixedAim
}