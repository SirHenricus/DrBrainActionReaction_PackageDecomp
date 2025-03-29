//================================================================================
// SPTurret.
//================================================================================
class SPTurret expands SPActor;

enum EShootType {
	ST_Timer,
	ST_Random,
	ST_Bump,
	ST_PlayerControl,
	ST_FireButton
};

var() EAimType AimType;
var() EShootType ShootType;
var() Class<Projectile> projType;
var() int AimDelaySeconds;
var() int ShootDelaySeconds;
var() Rotator AimRotation;
var() bool bCheckRange;
var() int TriggerRange;
var() int ProjectileSpeed;
var() float ReBumpDelay;
var() float ReShootDelay;
var() bool bInitiallyActive;
var() float ProjectileLifeSpan;
var() int MaxShots;
var() int RandomMinTime;
var() int RandomMaxTime;
var float BumpTime;
var int ShootTime;
var int NextShootTime;
var int timerSeconds;
var SPPlayer Controller;
var bool bActive;
var EPhysics InitialPhysics;
var int NumShots;
var Pawn PawnTarget;
enum EAimType {
	AT_FixedAim,
	AT_TrackPlayer,
	AT_ClosestPawn,
	AT_RotateAim,
	AT_RandomAim,
	AT_PlayerControl
};


event BeginPlay ()
{
	Super.BeginPlay();
	bRotateToDesired=False;
	SetTimer(1.00,True);
	timerSeconds=0;
	if ( ShootType == 1 )
	{
		NextShootTime=timerSeconds + RandomMinTime + Rand(RandomMaxTime - RandomMinTime);
	}
	InitialPhysics=Physics;
	if ( bInitiallyActive )
	{
		Activate();
	}
	else
	{
		DeActivate();
	}
}

function Activate ()
{
	bActive=True;
	SetTimer(1.00,True);
}

function DeActivate ()
{
	bActive=False;
	SetTimer(0.00,False);
}

event Trigger (Actor Other, Pawn Instigator)
{
	if ( bActive )
	{
		DeActivate();
	}
	else
	{
		Activate();
	}
}

event Tick (float tDelay)
{
	if (  !bActive )
	{
		return;
	}
	if ( Controller != None )
	{
		SetRotation(Controller.ViewRotation);
	}
}

event Timer ()
{
	timerSeconds += 1;
	if ( Controller == None )
	{
		if ( timerSeconds % AimDelaySeconds == 0 )
		{
			Aim();
		}
	}
	if ( (Controller == None) && (ShootType == 0) )
	{
		if ( timerSeconds % ShootDelaySeconds == 0 )
		{
			if ( (MaxShots == -1) || (NumShots < MaxShots) )
			{
				GotoState('Firing');
				NumShots++;
			}
		}
	}
	if ( (Controller == None) && (ShootType == 1) )
	{
		if ( NextShootTime == timerSeconds )
		{
			if ( (MaxShots == -1) || (NumShots < MaxShots) )
			{
				GotoState('Firing');
				NumShots++;
			}
			NextShootTime=timerSeconds + RandomMinTime + Rand(RandomMaxTime - RandomMinTime);
		}
	}
}

event Bump (Actor Other)
{
	if (  !bActive )
	{
		return;
	}
	if ( ShootType == 2 )
	{
		if ( Other.IsA('Pawn') || Other.IsA('Projectile') )
		{
			if ( ReBumpDelay > 0 )
			{
				if ( Level.TimeSeconds < BumpTime )
				{
					BumpTime=0.00;
				}
				if ( Level.TimeSeconds - BumpTime < ReBumpDelay )
				{
					return;
				}
				BumpTime=Level.TimeSeconds;
			}
			if ( (MaxShots == -1) || (NumShots < MaxShots) )
			{
				GotoState('Firing');
				NumShots++;
			}
		}
	}
}

event Landed (Vector HitNormal)
{
	SetPhysics(5);
}

event BaseChange ()
{
	if ( (Base == None) && (InitialPhysics == 2) )
	{
		SetPhysics(2);
	}
}

function ButtonFire ()
{
	if (  !bActive )
	{
		return;
	}
	if ( ShootType == 4 )
	{
		if ( ReBumpDelay > 0 )
		{
			if ( Level.TimeSeconds < BumpTime )
			{
				BumpTime=0.00;
			}
			if ( Level.TimeSeconds - BumpTime < ReBumpDelay )
			{
				return;
			}
			BumpTime=Level.TimeSeconds;
		}
		if ( (MaxShots == -1) || (NumShots < MaxShots) )
		{
			GotoState('Firing');
			NumShots++;
		}
	}
}

function Aim ()
{
	if ( AimType == 1 )
	{
		RotateToPlayer();
	}
	else
	{
		if ( AimType == 2 )
		{
			TargetClosestPawn();
		}
		else
		{
			if ( AimType == 3 )
			{
				AimRotate();
			}
			else
			{
				if ( AimType == 4 )
				{
					AimRandom();
				}
				else
				{
					if (! AimType == 0 ) goto JL006A;
				}
			}
		}
	}
JL006A:
}

function AimRotate ()
{
	DesiredRotation=Rotation + AimRotation;
	bRotateToDesired=True;
}

function AimRandom ()
{
	local Rotator Rot;

	Rot.Yaw=Rand(32000);
	Rot.Roll=Rand(32000);
	Rot.Pitch=Rand(32000);
	DesiredRotation=Rotation + Rot;
	bRotateToDesired=True;
}

function RotateToPlayer ()
{
	local Rotator Rot;
	local Vector toPlayer;
	local PlayerPawn pPawn;
	local Vector playerPos;

	foreach AllActors(Class'PlayerPawn',pPawn)
	{
		playerPos=pPawn.Location;
		goto JL0028;
	}
	if ( pPawn != None )
	{
		PawnTarget=pPawn;
		toPlayer=playerPos - Location;
		bRotateToDesired=True;
	}
	else
	{
		bRotateToDesired=False;
	}
	DesiredRotation=rotator(toPlayer);
}

function TargetClosestPawn ()
{
	local Rotator Rot;
	local Vector toPlayer;
	local Pawn P;
	local Vector targetPos;
	local float targetDist;
	local Pawn Target;
	local float tempDist;
	local bool pIsDead;

	foreach RadiusActors(Class'Pawn',P,TriggerRange)
	{
		pIsDead=(PlayerPawn(P) != None) && (P.Health <= 0);
		if ( Target != None )
		{
			tempDist=VSize(P.Location - Location);
			if ( (tempDist < targetDist) &&  !pIsDead )
			{
				Target=P;
				targetPos=P.Location;
				targetDist=tempDist;
			}
		}
		else
		{
			if (  !pIsDead )
			{
				Target=P;
				targetPos=P.Location;
				targetDist=VSize(targetPos - Location);
			}
		}
	}
	if ( Target != None )
	{
		PawnTarget=Target;
		toPlayer=targetPos - Location;
		bRotateToDesired=True;
	}
	else
	{
		bRotateToDesired=False;
	}
	DesiredRotation=rotator(toPlayer);
}

function FireProjectile ()
{
	local Vector Start;
	local Projectile P;

	if (  !bActive )
	{
		return;
	}
	Start=Location + vector(Rotation) * 10;
	P=Spawn(projType,,,Start,Rotation);
	if ( SPPushProjectile(P) != None )
	{
		SPPushProjectile(P).SetSpeed(ProjectileSpeed);
		SPPushProjectile(P).Go();
	}
	P.LifeSpan=ProjectileLifeSpan;
}

function int DistanceToPlayer ()
{
	local PlayerPawn pPawn;

	foreach AllActors(Class'PlayerPawn',pPawn)
	{
		goto JL0014;
	}
	if ( pPawn != None )
	{
		return VSize(pPawn.Location - Location);
	}
	else
	{
		return 32000;
	}
}

function bool AbortFire ()
{
	local bool targetIsDead;

	targetIsDead=(PlayerPawn(PawnTarget) != None) && (PawnTarget.Health <= 0);
	if ( targetIsDead )
	{
		return True;
	}
	if ( bCheckRange && (PawnTarget != None) && (VSize(PawnTarget.Location - Location) > TriggerRange) )
	{
		return True;
	}
	if ( (AimType == 1) || (AimType == 2) )
	{
		if ( PawnTarget == None )
		{
			return True;
		}
	}
	return False;
}

state Firing
{
Begin:
	if ( AbortFire() )
	{
		GotoState('None');
	}
	PlayAnim('Fire');
	FinishAnim();
	PlaySound(Sound'helpingh',3);
	FireProjectile();
	GotoState('None');
}

defaultproperties
{
    AimType=AT_TrackPlayer
    projType=Class'SPPushProjectile'
    AimDelaySeconds=1
    ShootDelaySeconds=2
    TriggerRange=500
    ProjectileSpeed=750
    ReBumpDelay=0.25
    ReShootDelay=0.50
    bInitiallyActive=True
    MaxShots=-1
    Physics=PHYS_Walking
    DrawType=DT_Sprite
    Mesh=LodMesh'RoboTurret'
    CollisionRadius=40.00
    CollisionHeight=30.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
    RotationRate=(Pitch=10000,Yaw=10000,Roll=10000)
}