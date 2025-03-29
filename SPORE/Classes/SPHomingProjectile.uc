//================================================================================
// SPHomingProjectile.
//================================================================================
class SPHomingProjectile expands SPStunProjectile;

var Pawn Target;
var() float TimerTime;
var float lastTime;
var() bool bLockedOnTarget;
var Vector GuidedVelocity;

replication
{
	un?reliable if ( Role == 4 )
		GuidedVelocity;
}

simulated event BeginPlay ()
{
	Super.BeginPlay();
	lastTime=Level.TimeSeconds;
	if ( Level.NetMode != 3 )
	{
		AcquireTarget();
	}
}

auto state Flying expands Flying
{
	simulated event Tick (float DeltaTime)
	{
		if ( Level.TimeSeconds > lastTime + TimerTime )
		{
			lastTime=Level.TimeSeconds;
			MyTimer();
		}
		if ( Level.NetMode == 3 )
		{
			Velocity=GuidedVelocity;
		}
		else
		{
			GuidedVelocity=Velocity;
		}
		SetRotation(rotator(Velocity));
	}
	
	event MyTimer ()
	{
		if ( Level.NetMode != 3 )
		{
			if (  !bLockedOnTarget )
			{
				AcquireTarget();
			}
			if ( Target != None )
			{
				Velocity=speed * Normal(Target.Location - Location);
			}
		}
	}
	
}

function AcquireTarget ()
{
	local Pawn P;
	local int range;
	local int pRange;
	local bool targetIsDead;

	targetIsDead=(PlayerPawn(Target) != None) && (Target.Health <= 0);
	if ( (Target == None) || targetIsDead )
	{
		range=100000;
	}
	else
	{
		range=VSize(Target.Location - Location);
	}
	Target=None;
	foreach RadiusActors(Class'Pawn',P,range)
	{
		targetIsDead=(PlayerPawn(P) != None) && (P.Health <= 0);
		if ( ((SPPlayer(P) != None) || (SPDrone(P) != None)) &&  !targetIsDead )
		{
			pRange=VSize(P.Location - Location);
			if ( pRange < range )
			{
				Target=P;
				range=pRange;
			}
		}
	}
}

defaultproperties
{
    TimerTime=1.00
    bNetTemporary=False
    AmbientSound=Sound'Projectile.beepwosh'
}