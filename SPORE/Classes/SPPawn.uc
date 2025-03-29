//================================================================================
// SPPawn.
//================================================================================
class SPPawn expands Pawn
	abstract;

enum EDirection {
	EDirection_North,
	EDirection_South,
	EDirection_East,
	EDirection_West
};

var(Orders) name Orders;
var(Orders) name OrderTag;
var(Orders) bool bBumpTurnLeft;
var(Orders) bool bDelayedPatrol;
var(Orders) name InitialDirection;
var(Orders) bool bIgnoringPlayer;
var(Orders) bool bPushObstacles;
var(Movement) float WalkingSpeed;
var Actor OrderObject;
var name NextAnim;
var Pawn Hated;
var Pawn OldEnemy;
var int numHuntPaths;
var Actor Distraction;
var Vector LastHitNormal;
var Vector StartLocation;
var Actor BestPath;
var int StunTime;
var SPStars Stars;
var EDirection CurrentDirection;
var() Texture FaceList[10];
var SPSpeechInfo Speech;
var int CurLip;
var float SpeechStart;
var float SpeechTimePassed;
var bool bSpeaking;
var SPActor SpeechCaller;

function PreBeginPlay ()
{
	Super.PreBeginPlay();
}

function Speak (string soundName, optional SPPlayer Player, optional SPActor caller)
{
	local Class<SPSpeechInfo> speechClass;
	local string speechClassName;
	local Sound snd;

	SpeechCaller=caller;
	speechClassName="SporeSpeech.SPSpeech_" $ soundName;
	speechClass=Class<SPSpeechInfo>(DynamicLoadObject(speechClassName,Class'Class'));
	if ( speechClass == None )
	{
		Log("Error -- Couldn't load speech class " $ speechClassName);
		return;
	}
	Speech=Spawn(speechClass);
	snd=Sound(DynamicLoadObject("SporeSpeech." $ soundName,Class'Sound'));
	if ( Player != None )
	{
		Player.PlaySound(snd,5);
	}
	else
	{
		PlaySound(snd,5);
	}
	bSpeaking=True;
	CurLip=0;
	Skin=FaceList[Speech.GetFrame(CurLip)];
	SpeechStart=Level.TimeSeconds;
	SpeechTimePassed=0.00;
}

function SpeechDone ()
{
	Skin=None;
	bSpeaking=False;
	if ( SpeechCaller != None )
	{
		SpeechCaller.SpeechDone(self,Speech);
	}
	if (  !bSpeaking )
	{
		if ( Speech != None )
		{
			Speech.Destroy();
		}
		Speech=None;
	}
}

event Tick (float DeltaTime)
{
	local float runTime;

	runTime=Level.TimeSeconds - SpeechStart;
	if ( bSpeaking )
	{
JL0024:
		if ( runTime >= SpeechTimePassed + Speech.GetTime(CurLip) )
		{
			SpeechTimePassed += Speech.GetTime(CurLip);
			CurLip++;
			if ( Speech.GetFrame(CurLip) == 0 )
			{
				SpeechDone();
				return;
			}
			goto JL0024;
		}
		Skin=FaceList[Speech.GetFrame(CurLip) - 1];
	}
}

function HugDamageTarget ()
{
	MeleeDamageTarget(20,Normal(Target.Location - Location));
}

function bool MeleeDamageTarget (int hitdamage, Vector pushdir)
{
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector TargetPoint;
	local Actor HitActor;

	if ( (VSize(Target.Location - Location) <= MeleeRange * 1.40 + Target.CollisionRadius + CollisionRadius) && ((Physics == 4) || (Physics == 3) || (Abs(Location.Z - Enemy.Location.Z) <= FMax(CollisionHeight,Enemy.CollisionHeight) + 0.50 * FMin(CollisionHeight,Enemy.CollisionHeight))) )
	{
		HitActor=Trace(HitLocation,HitNormal,Enemy.Location,Location,False);
		if ( HitActor != None )
		{
			return False;
		}
		Target.TakeDamage(hitdamage,self,HitLocation,pushdir,'caught');
		return True;
	}
	return False;
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	local Vector starsloc;

	if ( DamageType == 'Stunned' )
	{
		StunTime=5;
		GotoState('Stunned');
	}
	else
	{
		if ( (DamageType == 'pushed') || (DamageType == 'pushedInHead') || (DamageType == 'stun') )
		{
			starsloc=Location;
			starsloc.Z += CollisionHeight;
			Stars=Spawn(Class'SPStars',,,starsloc);
			Stars.LifeSpan=5.00;
			StunTime=5;
			GotoState('Stunned');
		}
	}
}

function PlayWalking ()
{
}

function PlayIdleAnim ()
{
}

function PlayLooking ()
{
}

function PlayRunning ()
{
}

function PlayMeleeAttack ()
{
}

function PlayFalling ()
{
}

function PlayStun ()
{
}

function ZoneChange (ZoneInfo NewZone)
{
	local Vector jumpDir;

	if ( NewZone.bWaterZone )
	{
		if (  !bCanSwim )
		{
			MoveTimer=-1.00;
		}
		else
		{
			if ( Physics != 3 )
			{
				if ( Physics != 2 )
				{
					PlayDive();
				}
				SetPhysics(3);
			}
		}
	}
	else
	{
		if ( Physics == 3 )
		{
			if ( bCanFly )
			{
				SetPhysics(4);
			}
			else
			{
				SetPhysics(2);
				if ( bCanWalk && (Abs(Acceleration.X) + Abs(Acceleration.Y) > 0) && CheckWaterJump(jumpDir) )
				{
					JumpOutOfWater(jumpDir);
				}
			}
		}
	}
}

function JumpOutOfWater (Vector jumpDir)
{
	Falling();
	Velocity=jumpDir * WaterSpeed;
	Acceleration=jumpDir * AccelRate;
	Velocity.Z=380.00;
	PlayOutOfWater();
	bUpAndOut=True;
}

function SetMovementPhysics ()
{
	if ( Physics == 2 )
	{
		return;
	}
	SetPhysics(1);
}

final function SetAlertness (float NewAlertness)
{
	if ( Alertness != NewAlertness )
	{
		PeripheralVision += 0.71 * (Alertness - NewAlertness);
		HearingThreshold += 0.50 * (Alertness - NewAlertness);
		Alertness=NewAlertness;
	}
}

function WhatToDoNext (name LikelyState, name LikelyLabel)
{
	Enemy=None;
	if ( OldEnemy != None )
	{
		Enemy=OldEnemy;
		OldEnemy=None;
		GotoState('Attacking');
	}
	else
	{
		if ( Orders == 'Patroling' )
		{
			GotoState('Patroling');
		}
		else
		{
			if ( Orders == 'Guarding' )
			{
				GotoState('Guarding');
			}
			else
			{
				if ( Orders == 'Ambushing' )
				{
					GotoState('Ambushing','FindAmbushSpot');
				}
				else
				{
					if ( (LikelyState != 'None') && (FRand() < 0.35) )
					{
						GotoState(LikelyState,LikelyLabel);
					}
				}
			}
		}
	}
}

function Bump (Actor Other)
{
	local Vector VelDir;
	local Vector OtherDir;
	local float speed;

	if ( Enemy != None )
	{
		if ( Other == Enemy )
		{
			GotoState('Chasing');
			return;
		}
		else
		{
			if ( (Pawn(Other) != None) && SetEnemy(Pawn(Other)) )
			{
				GotoState('Chasing');
				return;
			}
		}
	}
	else
	{
		if ( Pawn(Other) != None )
		{
			if ( SetEnemy(Pawn(Other)) )
			{
				GotoState('Chasing');
				return;
			}
		}
		if ( TimerRate <= 0 )
		{
			SetTimer(1.00,False);
		}
	}
	speed=VSize(Velocity);
	if ( speed > 1 )
	{
		VelDir=Velocity / speed;
		VelDir.Z=0.00;
		OtherDir=Other.Location - Location;
		OtherDir.Z=0.00;
		OtherDir=Normal(OtherDir);
		if ( VelDir Dot OtherDir > 0.80 )
		{
			Velocity.X=VelDir.Y;
			Velocity.Y=-1.00 * VelDir.X;
			Velocity *= FMax(speed,280.00);
		}
	}
	Disable('Bump');
}

singular function Falling ()
{
	if ( bCanFly )
	{
		SetPhysics(4);
		return;
	}
	if ( Health > 0 )
	{
		SetFall();
	}
}

function SetFall ()
{
	NextState=Orders;
	NextLabel='Begin';
	GotoState('FallingState');
}

function LongFall ()
{
	SetFall();
	GotoState('FallingState','LongFall');
}

function HearNoise (float Loudness, Actor NoiseMaker)
{
	Distraction=NoiseMaker;
	GotoState('Distracted');
}

function SeePlayer (Actor SeenPlayer)
{
	if ( SetEnemy(Pawn(SeenPlayer)) )
	{
		LastSeenPos=Enemy.Location;
		GotoState('Chasing');
	}
}

function bool FindBestPathToward (Actor desired)
{
	local Actor Path;
	local bool success;

	Path=FindPathToward(desired);
	success=Path != None;
	if ( success )
	{
		MoveTarget=Path;
		Destination=Path.Location;
	}
	return success;
}

function bool NeedToTurn (Vector targ)
{
	local int YawErr;

	DesiredRotation=rotator(targ - Location);
	DesiredRotation.Yaw=DesiredRotation.Yaw & 65535;
	YawErr=DesiredRotation.Yaw - (Rotation.Yaw & 65535) & 65535;
	if ( (YawErr < 4000) || (YawErr > 61535) )
	{
		return False;
	}
	return True;
}

function bool NearWall (float walldist)
{
	local Actor HitActor;
	local Vector HitLocation;
	local Vector HitNormal;
	local Vector ViewSpot;
	local Vector ViewDist;
	local Vector lookDir;

	lookDir=vector(Rotation);
	ViewSpot=Location + BaseEyeHeight * vect(0.00,0.00,1.00);
	ViewDist=lookDir * walldist;
	HitActor=Trace(HitLocation,HitNormal,ViewSpot + ViewDist,ViewSpot,False);
	if ( HitActor == None )
	{
		return False;
	}
	ViewDist=Normal(HitNormal Cross vect(0.00,0.00,1.00)) * walldist;
	if ( FRand() < 0.50 )
	{
		ViewDist *= -1;
	}
	HitActor=Trace(HitLocation,HitNormal,ViewSpot + ViewDist,ViewSpot,False);
	if ( HitActor == None )
	{
		Focus=Location + ViewDist;
		return True;
	}
	ViewDist *= -1;
	HitActor=Trace(HitLocation,HitNormal,ViewSpot + ViewDist,ViewSpot,False);
	if ( HitActor == None )
	{
		Focus=Location + ViewDist;
		return True;
	}
	Focus=Location - lookDir * 300;
	return True;
}

function bool SetEnemy (Pawn NewEnemy)
{
	local bool Result;
	local EAttitude newAttitude;
	local EAttitude oldAttitude;
	local bool noOldEnemy;
	local float newStrength;

	if ( NewEnemy.bIsPlayer )
	{
		OldEnemy=Enemy;
		Enemy=NewEnemy;
		oldAttitude=AttitudeToPlayer;
		AttitudeToPlayer=1;
		newAttitude=AttitudeToPlayer;
		Result=True;
		return Result;
	}
}

function damageAttitudeTo (Pawn Other)
{
	local EAttitude oldAttitude;

	if ( (Other == self) || (Other == None) )
	{
		return;
	}
	if ( Other.bIsPlayer )
	{
		if ( Health < 30 )
		{
			AttitudeToPlayer=2;
		}
		else
		{
			if ( AttitudeToPlayer == 4 )
			{
				AttitudeToPlayer=1;
			}
			else
			{
				if ( AttitudeToPlayer == 3 )
				{
					AttitudeToPlayer=1;
				}
				else
				{
					if ( AttitudeToPlayer == 5 )
					{
						AttitudeToPlayer=3;
					}
				}
			}
		}
	}
	else
	{
		oldAttitude=AttitudeToCreature(Other);
		if ( oldAttitude > 4 )
		{
			return;
		}
		else
		{
			if ( oldAttitude > 2 )
			{
				Hated=Other;
			}
		}
	}
	SetEnemy(Other);
}

function EnemyAcquired ()
{
}

function EAttitude AttitudeTo (Pawn Other)
{
	if ( Other.bIsPlayer )
	{
		return AttitudeToPlayer;
	}
	else
	{
		if ( Hated == Other )
		{
			return 1;
		}
		else
		{
			return AttitudeToCreature(Other);
		}
	}
}

function EAttitude AttitudeToCreature (Pawn Other)
{
	if ( Other.Class == Class )
	{
		return 5;
	}
	else
	{
		return 4;
	}
}

function float StrafeAdjust ()
{
	local Vector Focus2D;
	local Vector Loc2D;
	local Vector Dest2D;
	local float strafemag;

	Focus2D=Focus;
	Focus2D.Z=0.00;
	Loc2D=Location;
	Loc2D.Z=0.00;
	Dest2D=Destination;
	Dest2D.Z=0.00;
	strafemag=Abs(Normal(Focus2D - Loc2D) Dot Normal(Dest2D - Loc2D));
	return (strafemag - 2.00) / GroundSpeed;
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	GotoState('TriggeredBehavior');
}

auto state StartUp
{
	function InitAmbushLoc ()
	{
		local Ambushpoint newspot;
		local float i;
		local Rotator NewRot;
	
		i=1.00;
		foreach AllActors(Class'Ambushpoint',newspot,Tag)
		{
			if (  !newspot.taken )
			{
				i=i + 1;
				if ( FRand() < 1.00 / i )
				{
					OrderObject=newspot;
				}
			}
		}
		if ( OrderObject != None )
		{
			Ambushpoint(OrderObject).Accept(self);
		}
	}
	
	function InitPatrolLoc ()
	{
		local PatrolPoint newspot;
	
	}
	
	function SetHome ()
	{
		local NavigationPoint aNode;
	
		StartLocation=Location;
		aNode=Level.NavigationPointList;
	JL001F:
		if ( aNode != None )
		{
			if ( aNode.IsA('HomeBase') && (aNode.Tag == Tag) )
			{
				home=HomeBase(aNode);
				return;
			}
			aNode=aNode.nextNavigationPoint;
			goto JL001F;
		}
	}
	
	function SetAlarm ()
	{
		local Pawn aPawn;
		local Pawn currentWinner;
		local float i;
	
		currentWinner=self;
		i=1.00;
		aPawn=Level.PawnList;
	JL0026:
		if ( aPawn != None )
		{
			if ( aPawn.IsA('SPPawn') && (SPPawn(aPawn).SharedAlarmTag == SharedAlarmTag) )
			{
				SPPawn(aPawn).SharedAlarmTag='None';
				i += 1;
				if ( FRand() < 1.00 / i )
				{
					currentWinner=aPawn;
				}
			}
			aPawn=aPawn.nextPawn;
			goto JL0026;
		}
		SPPawn(currentWinner).AlarmTag=SharedAlarmTag;
		SharedAlarmTag='None';
	}
	
	function BeginState ()
	{
		SetMovementPhysics();
		if ( Physics == 1 )
		{
			SetPhysics(2);
		}
	}
	
Begin:
	SetHome();
	if ( Orders == 'MoveBumpTurning' )
	{
		GotoState('MoveBumpTurning');
	}
	else
	{
		if ( Orders == 'TotallyIgnoringPlayer' )
		{
			GotoState('TotallyIgnoringPlayer');
		}
		else
		{
			if ( Orders == 'ScaredOfPlayer' )
			{
				GotoState('ScaredOfPlayer');
			}
			else
			{
				if ( Orders == 'Blocking' )
				{
					GotoState('Blocking');
				}
				else
				{
					if ( Orders == 'Hunting' )
					{
						GotoState('Hunting');
					}
					else
					{
						if (  !bFixedStart )
						{
							if ( Orders == 'Patroling' )
							{
								InitPatrolLoc();
							}
						}
					}
				}
			}
		}
	}
	if ( Orders != 'None' )
	{
		if ( Orders == 'Attacking' )
		{
			if ( Enemy != None )
			{
				GotoState('Attacking');
			}
		}
		else
		{
			if ( bDelayedPatrol && (Orders == 'Patroling') )
			{
				GotoState('Patroling','DelayedPatrol');
			}
			else
			{
				GotoState(Orders);
			}
		}
		if ( Physics == 2 )
		{
			SetFall();
		}
		else
		{
			SetMovementPhysics();
		}
	}
	else
	{
		GotoState('Waiting');
	}
}

state Patroling
{
	function HearNoise (float Loudness, Actor NoiseMaker)
	{
		if (  !bIgnoringPlayer )
		{
			Global.HearNoise(Loudness,NoiseMaker);
		}
		else
		{
			Disable('HearNoise');
		}
	}
	
	function SeePlayer (Actor SeenPlayer)
	{
		if (  !bIgnoringPlayer )
		{
			Global.SeePlayer(SeenPlayer);
		}
		else
		{
			Disable('SeePlayer');
		}
	}
	
	function Bump (Actor Other)
	{
		if ( Other.IsA('SPPlayer') )
		{
			Other.Velocity=Velocity * 2;
			Other.Velocity.X += 300;
			if ( Rand(2) == 1 )
			{
				Other.Velocity.X= -Other.Velocity.X;
			}
			Other.Velocity.Y += 300;
			if ( Rand(2) == 1 )
			{
				Other.Velocity.Y= -Other.Velocity.Y;
			}
			Other.Velocity.Z += 300;
			if ( Rand(2) == 1 )
			{
				Other.Velocity.Z= -Other.Velocity.Z;
			}
			Other.SetPhysics(2);
		}
	}
	
	function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
	{
		if (  !bIgnoringPlayer )
		{
			Global.TakeDamage(Damage,instigatedBy,HitLocation,Momentum,DamageType);
			if ( Health <= 0 )
			{
				return;
			}
			LastSeenPos=Enemy.Location;
			if ( NextState == 'TakeHit' )
			{
				NextState='Attacking';
				NextLabel='Begin';
				GotoState('TakeHit');
			}
			else
			{
				if ( Enemy != None )
				{
					GotoState('Attacking');
				}
			}
		}
	}
	
	function SetFall ()
	{
		NextState='Patroling';
		NextLabel='ResumePatrol';
		NextAnim=AnimSequence;
		GotoState('FallingState');
	}
	
	function HitWall (Vector HitNormal, Actor Wall)
	{
		if ( Physics == 2 )
		{
			return;
		}
		if ( Wall.IsA('Mover') && Mover(Wall).HandleDoor(self) )
		{
			if ( SpecialPause > 0 )
			{
				Acceleration=vect(0.00,0.00,0.00);
			}
			GotoState('Patroling','SpecialNavig');
			return;
		}
		Focus=Destination;
		if ( PickWallAdjust() )
		{
			GotoState('Patroling','AdjustFromWall');
		}
		else
		{
			MoveTimer=-1.00;
		}
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( bDelayedPatrol )
		{
			GotoState('Patroling','Patrol');
		}
		else
		{
			Global.Trigger(Other,EventInstigator);
		}
	}
	
	function Timer ()
	{
		Enable('Bump');
	}
	
	function AnimEnd ()
	{
		PlayPatrolStop();
	}
	
	function EnemyAcquired ()
	{
		GotoState('Acquisition');
	}
	
	function PickDestination ()
	{
		local Actor Path;
	
		Path=None;
		if ( SpecialGoal != None )
		{
			Path=FindPathToward(SpecialGoal);
		}
		else
		{
			if ( OrderObject != None )
			{
				Path=FindPathToward(OrderObject);
			}
		}
		if ( Path != None )
		{
			MoveTarget=Path;
			Destination=Path.Location;
		}
		else
		{
			OrderObject=None;
		}
	}
	
	function FindNextPatrol ()
	{
		local PatrolPoint pat;
	
		if ( (PatrolPoint(OrderObject) != None) && (PatrolPoint(OrderObject).Nextpatrol == OrderTag) )
		{
			OrderObject=PatrolPoint(OrderObject).NextPatrolPoint;
		}
		else
		{
			foreach AllActors(Class'PatrolPoint',pat,OrderTag)
			{
				OrderObject=pat;
				return;
			}
		}
	}
	
	function BeginState ()
	{
		SpecialGoal=None;
		SpecialPause=0.00;
		Enemy=None;
		NextAnim='None';
		Disable('AnimEnd');
		SetAlertness(0.00);
	}
	
AdjustFromWall:
	StrafeTo(Destination,Focus);
	Destination=Focus;
	MoveTo(Destination);
	goto ('MoveToPatrol');
ResumePatrol:
	if ( MoveTarget != None )
	{
		PlayWalking();
		MoveToward(MoveTarget,WalkingSpeed);
		goto ('ReachedPatrol');
	}
	else
	{
		goto ('Patrol');
	}
Begin:
	Sleep(0.10);
Patrol:
	WaitForLanding();
	FindNextPatrol();
	Disable('AnimEnd');
	if ( PatrolPoint(OrderObject) != None )
	{
		TweenToWalking(0.30);
		FinishAnim();
		PlayWalking();
		numHuntPaths=0;
MoveToPatrol:
		if ( actorReachable(OrderObject) || bPushObstacles )
		{
			MoveToward(OrderObject,WalkingSpeed);
		}
		else
		{
			PickDestination();
			if ( OrderObject != None )
			{
SpecialNavig:
				if ( SpecialPause > 0.00 )
				{
					Acceleration=vect(0.00,0.00,0.00);
					TweenToPatrolStop(0.30);
					Sleep(SpecialPause);
					SpecialPause=0.00;
					TweenToWalking(0.10);
					FinishAnim();
					PlayWalking();
				}
				numHuntPaths++;
				MoveToward(MoveTarget,WalkingSpeed);
				if ( numHuntPaths < 30 )
				{
					goto ('MoveToPatrol');
				}
				else
				{
					goto ('GiveUp');
				}
			}
			else
			{
				goto ('GiveUp');
			}
		}
ReachedPatrol:
		OrderTag=PatrolPoint(OrderObject).Nextpatrol;
		if ( PatrolPoint(OrderObject).pausetime > 0.00 )
		{
			Acceleration=vect(0.00,0.00,0.00);
			TweenToFighter(0.20);
			FinishAnim();
			PlayTurning();
			TurnTo(Location + PatrolPoint(OrderObject).lookDir);
			if ( PatrolPoint(OrderObject).PatrolAnim != 'None' )
			{
				TweenAnim(PatrolPoint(OrderObject).PatrolAnim,0.30);
				FinishAnim();
				PatrolPoint(OrderObject).AnimCount=PatrolPoint(OrderObject).numAnims;
JL0236:
				if ( PatrolPoint(OrderObject).AnimCount > 0 )
				{
					PatrolPoint(OrderObject).AnimCount--;
					if ( PatrolPoint(OrderObject).PatrolSound != None )
					{
						PlaySound(PatrolPoint(OrderObject).PatrolSound);
					}
					PlayAnim(PatrolPoint(OrderObject).PatrolAnim);
					FinishAnim();
					goto JL0236;
				}
			}
			else
			{
				TweenToPatrolStop(0.30);
				FinishAnim();
				Enable('AnimEnd');
				NextAnim='None';
				PlayPatrolStop();
				Sleep(PatrolPoint(OrderObject).pausetime);
				Disable('AnimEnd');
				FinishAnim();
			}
		}
		goto ('Patrol');
	}
GiveUp:
	Acceleration=vect(0.00,0.00,0.00);
	TweenToPatrolStop(0.30);
	FinishAnim();
DelayedPatrol:
	Enable('AnimEnd');
	PlayPatrolStop();
PatrolBlocked:
	Acceleration=vect(0.00,0.00,0.00);
	Sleep(3.00);
	goto ('ResumePatrol');
}

state Chasing
{
	function SeePlayer (Actor SeenPlayer)
	{
		if ( actorReachable(SeenPlayer) && (SeenPlayer == Enemy) )
		{
			GotoState('Chasing');
		}
	}
	
	event PlayerNotVisible ()
	{
		GotoState('Hunting');
	}
	
	function AnimEnd ()
	{
		if ( AnimSequence == 'rungrab' )
		{
			PlayRunning();
			GotoState('Chase','Chase');
		}
	}
	
Begin:
	Disable('SeePlayer');
	if ( VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + MeleeRange )
	{
		goto ('CaughtPlayer');
	}
Chase:
	PlayRunning();
	if ( CanSee(Enemy) )
	{
		if ( actorReachable(Enemy) )
		{
			MoveToward(Enemy);
			if ( VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + 10 * MeleeRange )
			{
				PlayMeleeAttack();
				MoveToward(Enemy);
				stop
			}
			else
			{
				if ( VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + MeleeRange )
				{
					goto ('CaughtPlayer');
				}
				else
				{
					goto ('Chase');
				}
			}
		}
		else
		{
			GotoState('Chasing','PlayerUnreachable');
		}
	}
	else
	{
		LastSeenPos=Enemy.Location;
		GotoState('CheckingLastSeenPos');
	}
CaughtPlayer:
	GotoState('Attacking');
PlayerUnreachable:
	LoopAnim('chill1',0.10);
	Acceleration=vect(0.00,0.00,0.00);
WatchEnemy:
	TurnToward(Enemy);
	if ( actorReachable(Enemy) )
	{
		goto ('Chase');
	}
	else
	{
		goto ('WatchEnemy');
	}
}

state CheckingLastSeenPos
{
GotThere:
	GotoState('Hunting');
Begin:
	GotoState('Hunting');
	if ( VSize(Location - LastSeenPos) <= MeleeRange )
	{
		goto ('GotThere');
	}
Moving:
	MoveTo(LastSeenPos);
	if ( VSize(Location - LastSeenPos) <= MeleeRange )
	{
		goto ('GotThere');
	}
	else
	{
		goto ('Moving');
	}
}

state Attacking
{
	function HugDamageTarget ()
	{
		MeleeDamageTarget(20,Normal(Target.Location - Location));
		GotoState('Attacking','Delay');
	}
	
Begin:
	if ( Enemy != None )
	{
		Target=Enemy;
	}
Delay:
	Acceleration=vect(0.00,0.00,0.00);
	TurnToward(Target);
	Sleep(0.50);
CheckDistance:
	if (  !VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + MeleeRange )
	{
		GotoState('Chasing');
	}
	else
	{
		PlayMeleeAttack();
	}
}

state FallingState
{
	ignores  TakeDamage, KilledBy;
	
	function Landed (Vector HitNormal)
	{
		GotoState('FallingState','Landed');
	}
	
Landed:
	GotoState(NextState,NextLabel);
Begin:
	PlayFalling();
	LastHitNormal= -LastHitNormal;
fall:
}

state Distracted
{
Investigating:
	PlayRunning();
	MoveToward(Distraction);
	if ( VSize(Location - Distraction.Location) <= CollisionRadius + Distraction.CollisionRadius + MeleeRange )
	{
		goto ('FoundDistraction');
	}
	else
	{
		goto ('LookForDistraction');
	}
LookForDistraction:
	if ( CanSee(Distraction) )
	{
		if ( Distraction.IsA('SPPlayer') )
		{
			goto ('DistractionIsaPlayer');
		}
		else
		{
			goto ('DistractionIsNotInteresting');
		}
	}
	else
	{
		goto ('Investigating');
	}
DistractionIsaPlayer:
	if ( SetEnemy(Pawn(Distraction)) )
	{
		GotoState('Chasing');
	}
	else
	{
		if ( Enemy != None )
		{
			GotoState('Chasing');
		}
		else
		{
			goto ('Investigating');
		}
	}
DistractionIsNotInteresting:
	GotoState('Patroling','ResumePatrol');
FoundDistraction:
	if ( Distraction.IsA('SPPlayer') )
	{
		goto ('DistractionIsaPlayer');
	}
	else
	{
		goto ('DistractionIsNotInteresting');
	}
Begin:
	goto ('Investigating');
}

state MoveBumpTurning
{
	function Bump (Actor Other)
	{
		if ( Other.IsA('SPSignpost') )
		{
			TurnToDirectionOfSignPost(SPSignpost(Other));
		}
		else
		{
			if ( Other.IsA('SPPlayer') )
			{
				Other.Velocity=Velocity * 2;
				Other.Velocity.X += 300;
				if ( Rand(2) == 1 )
				{
					Other.Velocity.X= -Other.Velocity.X;
				}
				Other.Velocity.Y += 300;
				if ( Rand(2) == 1 )
				{
					Other.Velocity.Y= -Other.Velocity.Y;
				}
				Other.Velocity.Z += 300;
				if ( Rand(2) == 1 )
				{
					Other.Velocity.Z= -Other.Velocity.Z;
				}
				Other.SetPhysics(2);
			}
		}
	}
	
	function TurnToDirectionOfSignPost (SPSignpost sign)
	{
		Disable('Bump');
		Disable('HitWall');
		switch (sign.Pointing)
		{
			case 0:
			GotoState('MoveBumpTurning','MovingNorth');
			break;
			case 2:
			GotoState('MoveBumpTurning','MovingEast');
			break;
			case 1:
			GotoState('MoveBumpTurning','MovingSouth');
			break;
			case 3:
			GotoState('MoveBumpTurning','MovingWest');
			break;
			default:
		}
	}
	
	function BumpTurn ()
	{
		switch (CurrentDirection)
		{
			case 0:
			if ( bBumpTurnLeft )
			{
				GotoState('MoveBumpTurning','MovingWest');
			}
			else
			{
				GotoState('MoveBumpTurning','MovingEast');
			}
			break;
			case 2:
			if ( bBumpTurnLeft )
			{
				GotoState('MoveBumpTurning','MovingNorth');
			}
			else
			{
				GotoState('MoveBumpTurning','MovingSouth');
			}
			break;
			case 1:
			if ( bBumpTurnLeft )
			{
				GotoState('MoveBumpTurning','MovingEast');
			}
			else
			{
				GotoState('MoveBumpTurning','MovingWest');
			}
			break;
			case 3:
			if ( bBumpTurnLeft )
			{
				GotoState('MoveBumpTurning','MovingSouth');
			}
			else
			{
				GotoState('MoveBumpTurning','MovingNorth');
			}
			break;
			default:
		}
	}
	
	function HitWall (Vector HitNormal, Actor HitWall)
	{
		Super.HitWall(HitNormal,HitWall);
		if ( HitWall.IsA('SPSignpost') )
		{
			TurnToDirectionOfSignPost(SPSignpost(HitWall));
			return;
		}
		else
		{
			if (  !HitWall.IsA('SPActor') )
			{
				if ( HitNormal != LastHitNormal )
				{
					LastHitNormal=HitNormal;
					BumpTurn();
				}
			}
		}
	}
	
MovingNorth:
North:
	PlayWalking();
	Destination=Location;
	Destination.Y -= 5000;
	CurrentDirection=0;
	TurnTo(Destination);
	MoveTo(Destination,WalkingSpeed);
	goto ('End');
MovingSouth:
South:
	PlayWalking();
	Destination=Location;
	Destination.Y += 5000;
	CurrentDirection=1;
	TurnTo(Destination);
	MoveTo(Destination,WalkingSpeed);
	goto ('End');
MovingEast:
East:
	PlayWalking();
	Destination=Location;
	Destination.X += 5000;
	CurrentDirection=2;
	TurnTo(Destination);
	MoveTo(Destination,WalkingSpeed);
	goto ('End');
MovingWest:
West:
	PlayWalking();
	Destination=Location;
	Destination.X -= 5000;
	CurrentDirection=3;
	TurnTo(Destination);
	MoveTo(Destination,WalkingSpeed);
	goto ('End');
Begin:
	MinHitWall=0.71;
	PlayWalking();
	if ( InitialDirection != 'None' )
	{
		goto (InitialDirection);
	}
	else
	{
		goto ('MovingNorth');
	}
End:
	Enable('Bump');
	Enable('HitWall');
}

state Stunned
{
	ignores  KilledBy;
	
	function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
	{
		Super(Pawn).TakeDamage(Damage,instigatedBy,HitLocation,Momentum,DamageType);
	}
	
	function Tick (float deltaT)
	{
		local Vector starsloc;
	
		starsloc=Location;
		starsloc.Z += CollisionHeight;
		Stars.SetLocation(starsloc);
	}
	
	event Timer ()
	{
		Stars.Destroy();
		Stars=None;
		GotoState('StartUp');
	}
	
Begin:
	Acceleration=vect(0.00,0.00,0.00);
	PlayStun();
	PlaySound(Sound'stungurd',3);
	SetTimer(StunTime,False);
}

state TotallyIgnoringPlayer
{
	ignores  TakeDamage, KilledBy;
	
	event AnimEnd ()
	{
		PlayIdleAnim();
	}
	
Begin:
	PlayIdleAnim();
}

state Waiting
{
	event AnimEnd ()
	{
		PlayIdleAnim();
	}
	
Begin:
	Acceleration=vect(0.00,0.00,0.00);
	PlayIdleAnim();
}

state ScaredOfPlayer
{
	ignores  TakeDamage;
	
	function SeePlayer (Actor SeenPlayer)
	{
		if ( SetEnemy(Pawn(SeenPlayer)) )
		{
			LastSeenPos=Enemy.Location;
		}
		GotoState('ScaredOfPlayer','RunningFromPlayer');
	}
	
	function PickDestination ()
	{
		local SPPatrolPoint D;
	
		Destination=Location - Enemy.Location - Location;
		if (  !pointReachable(Destination) )
		{
			foreach AllActors(Class'SPPatrolPoint',D,'Cornelius')
			{
				goto JL0048;
			}
			Destination=D.Location;
		}
	}
	
RunningFromPlayer:
	PickDestination();
	PlayRunning();
	MoveTo(Destination);
	stop
Begin:
	if ( Enemy != None )
	{
		if ( CanSee(Enemy) )
		{
			goto ('RunningFromPlayer');
		}
	}
}

state Blocking
{
	ignores  TakeDamage;
	
	function SeePlayer (Actor SeenPlayer)
	{
		if ( SetEnemy(Pawn(SeenPlayer)) )
		{
			LastSeenPos=Enemy.Location;
		}
		GotoState('Blocking','MoveToBlock');
	}
	
MoveToBlock:
	MoveTo((Enemy.Location + StartLocation) / 2);
Begin:
}

state Following
{
	ignores  TakeDamage, KilledBy;
	
	function SetPlayer ()
	{
		local SPPlayer Player;
	
		foreach AllActors(Class'SPPlayer',Player)
		{
			goto JL0014;
		}
		Enemy=Player;
	}
	
Begin:
	SetPlayer();
	if ( VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + 5 * MeleeRange )
	{
		goto ('CaughtPlayer');
	}
Chase:
	PlayRunning();
	MoveToward(Enemy);
	if ( VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + 5 * MeleeRange )
	{
		goto ('CaughtPlayer');
	}
	else
	{
		goto ('Chase');
	}
CaughtPlayer:
	LoopAnim('chill',0.10);
	Acceleration=vect(0.00,0.00,0.00);
	Sleep(2.00);
	if ( VSize(Location - Enemy.Location) <= CollisionRadius + Enemy.CollisionRadius + 5 * MeleeRange )
	{
		goto ('CaughtPlayer');
	}
	else
	{
		goto ('Chase');
	}
}

state Hunting
{
	ignores  TakeDamage;
	
	function SeePlayer (Actor SeenPlayer)
	{
		SetEnemy(Pawn(SeenPlayer));
		if ( Enemy != None )
		{
			if ( actorReachable(Enemy) )
			{
				GotoState('Chasing');
			}
			else
			{
				GotoState('Hunting','Begin');
			}
		}
	}
	
	function PickDestination ()
	{
		local Actor BestPath;
	
		BestPath=FindPathToward(Enemy);
		if ( BestPath != None )
		{
			MoveTarget=BestPath;
			return;
		}
	}
	
Begin:
	if ( Enemy == None )
	{
		stop
	}
	TweenToRunning(0.10);
	WaitForLanding();
RunAway:
	PickDestination();
	if ( MoveTarget == None )
	{
		stop
	}
SpecialNavig:
Moving:
	if ( SpecialPause > 0.00 )
	{
		Disable('AnimEnd');
		Acceleration=vect(0.00,0.00,0.00);
		Sleep(SpecialPause);
		SpecialPause=0.00;
		Enable('AnimEnd');
	}
	MoveToward(MoveTarget);
	goto ('RunAway');
}

state TriggeredBehavior
{
	ignores  TakeDamage, KilledBy;
	
	function FindDestination ()
	{
		local PatrolPoint pat;
	
		if ( (PatrolPoint(OrderObject) != None) && (PatrolPoint(OrderObject).Nextpatrol == OrderTag) )
		{
			OrderObject=PatrolPoint(OrderObject).NextPatrolPoint;
		}
		else
		{
			foreach AllActors(Class'PatrolPoint',pat,OrderTag)
			{
				OrderObject=pat;
				return;
			}
		}
	}
	
Begin:
	FindDestination();
	PlayRunning();
	MoveToward(OrderObject);
}

function string KillMessage (name DamageType, Pawn Other)
{
	local string Message;

	Message=Level.Game.CreatureKillMessage(DamageType,Other);
	return Message;
}

defaultproperties
{
    WalkingSpeed=0.25
    MeleeRange=10.00
    GroundSpeed=260.00
    Intelligence=BRAINS_HUMAN
}