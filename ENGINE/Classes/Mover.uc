//================================================================================
// Mover.
//================================================================================
class Mover expands Brush
	native;

enum EBumpType {
	BT_PlayerBump,
	BT_PawnBump,
	BT_AnyBump
};

enum EMoverGlideType {
	MV_MoveByTime,
	MV_GlideByTime
};

var() EMoverEncroachType MoverEncroachType;
var() EMoverGlideType MoverGlideType;
var() EBumpType BumpType;
var() byte KeyNum;
var byte PrevKeyNum;
var() const byte NumKeys;
var() const byte WorldRaytraceKey;
var() const byte BrushRaytraceKey;
var() float MoveTime;
var() float StayOpenTime;
var() float OtherTime;
var() int EncroachDamage;
var() bool bTriggerOnceOnly;
var() bool bSlave;
var() bool bUseTriggered;
var() bool bDamageTriggered;
var() bool bDynamicLightMover;
var() name PlayerBumpEvent;
var() name BumpEvent;
var Actor SavedTrigger;
var() float DamageThreshold;
var int numTriggerEvents;
var Mover Leader;
var Mover Follower;
var() name ReturnGroup;
var() float DelayTime;
var(MoverSounds) Sound OpeningSound;
var(MoverSounds) Sound OpenedSound;
var(MoverSounds) Sound ClosingSound;
var(MoverSounds) Sound ClosedSound;
var(MoverSounds) Sound MoveAmbientSound;
var Vector KeyPos[8];
var Rotator KeyRot[8];
var Vector BasePos;
var Vector OldPos;
var Vector OldPrePivot;
var Vector SavedPos;
var Rotator BaseRot;
var Rotator OldRot;
var Rotator SavedRot;
var NavigationPoint myMarker;
var Actor TriggerActor;
var Actor TriggerActor2;
var Pawn WaitingPawn;
var bool bOpening;
var bool bDelaying;
var bool bPlayerOnly;
var Trigger RecommendedTrigger;
var Vector SimOldPos;
var int SimOldRotPitch;
var int SimOldRotYaw;
var int SimOldRotRoll;
var Vector SimInterpolate;
var Vector RealPosition;
var Rotator RealRotation;
var int ServerUpdate;
var int ClientUpdate;
enum EMoverEncroachType {
	ME_StopWhenEncroach,
	ME_ReturnWhenEncroach,
	ME_CrushWhenEncroach,
	ME_IgnoreWhenEncroach
};


replication
{
	un?reliable if ( Role == 4 )
		SimOldPos,SimOldRotPitch,SimOldRotYaw,SimOldRotRoll,SimInterpolate,RealPosition,RealRotation,ServerUpdate;
}

simulated function Timer ()
{
	if ( Velocity != vect(0.00,0.00,0.00) )
	{
		return;
	}
	if ( Level.NetMode == 3 )
	{
		if ( ClientUpdate == ServerUpdate )
		{
			SetLocation(RealPosition);
			SetRotation(RealRotation);
		}
	}
	else
	{
		if ( (Location != RealPosition) || (Rotation != RealRotation) )
		{
			ServerUpdate++;
			RealPosition=Location;
			RealRotation=Rotation;
		}
	}
}

function FindTriggerActor ()
{
	local Actor A;

	TriggerActor=None;
	TriggerActor2=None;
	foreach AllActors(Class'Actor',A)
	{
		if ( (A.Event == Tag) && (A.IsA('Trigger') || A.IsA('Mover')) )
		{
			if ( A.IsA('Counter') || A.IsA('Pawn') )
			{
				bPlayerOnly=True;
				return;
			}
			if ( TriggerActor == None )
			{
				TriggerActor=A;
			}
			else
			{
				if ( TriggerActor2 == None )
				{
					TriggerActor2=A;
				}
			}
		}
	}
	if ( TriggerActor == None )
	{
		bPlayerOnly=BumpType == 0;
		return;
	}
	bPlayerOnly=TriggerActor.IsA('Trigger') && (Trigger(TriggerActor).TriggerType == 0);
	if ( bPlayerOnly && (TriggerActor2 != None) )
	{
		bPlayerOnly=TriggerActor2.IsA('Trigger') && (Trigger(TriggerActor).TriggerType == 0);
		if (  !bPlayerOnly )
		{
			A=TriggerActor;
			TriggerActor=TriggerActor2;
			TriggerActor2=A;
		}
	}
}

function bool HandleDoor (Pawn Other)
{
	return False;
}

function bool HandleTriggerDoor (Pawn Other)
{
	local bool bOne;
	local bool bTwo;
	local float DP1;
	local float DP2;
	local float Dist1;
	local float Dist2;

	if ( bOpening || bDelaying )
	{
		WaitingPawn=Other;
		Other.SpecialPause=2.50;
		return True;
	}
	if ( bPlayerOnly &&  !Other.bIsPlayer )
	{
		return False;
	}
	if ( bUseTriggered )
	{
		WaitingPawn=Other;
		Other.SpecialPause=2.50;
		Trigger(Other,Other);
		return True;
	}
	if ( (BumpEvent == Tag) || Other.bIsPlayer && (PlayerBumpEvent == Tag) )
	{
		WaitingPawn=Other;
		Other.SpecialPause=2.50;
		if ( Other.Base == self )
		{
			Trigger(Other,Other);
		}
		return True;
	}
	if ( bDamageTriggered )
	{
		WaitingPawn=Other;
		Other.SpecialGoal=self;
		if (  !Other.bCanDoSpecial || (Other.Weapon == None) )
		{
			return False;
		}
		Other.Target=self;
		Other.bShootSpecial=True;
		Other.FireWeapon();
		Trigger(self,Other);
		Other.bFire=0;
		Other.bAltFire=0;
		return True;
	}
	if ( RecommendedTrigger != None )
	{
		Other.SpecialGoal=RecommendedTrigger;
		Other.MoveTarget=RecommendedTrigger;
		return True;
	}
	bOne=(TriggerActor != None) && ( !TriggerActor.IsA('Trigger') || Trigger(TriggerActor).IsRelevant(Other));
	bTwo=(TriggerActor2 != None) && ( !TriggerActor2.IsA('Trigger') || Trigger(TriggerActor2).IsRelevant(Other));
	if ( bOne && bTwo )
	{
		Dist1=VSize(TriggerActor.Location - Other.Location);
		Dist2=VSize(TriggerActor2.Location - Other.Location);
		if ( Dist1 < Dist2 )
		{
			if ( (Dist1 < 500) && Other.actorReachable(TriggerActor) )
			{
				bTwo=False;
			}
		}
		else
		{
			if ( (Dist2 < 500) && Other.actorReachable(TriggerActor2) )
			{
				bOne=False;
			}
		}
		if ( bOne && bTwo )
		{
			DP1=Normal(Location - Other.Location) Dot (TriggerActor.Location - Other.Location) / Dist1;
			DP2=Normal(Location - Other.Location) Dot (TriggerActor2.Location - Other.Location) / Dist2;
			if ( (DP1 > 0) && (DP2 < 0) )
			{
				bOne=False;
			}
			else
			{
				if ( (DP1 < 0) && (DP2 > 0) )
				{
					bTwo=False;
				}
				else
				{
					if ( Dist1 < Dist2 )
					{
						bTwo=False;
					}
					else
					{
						bOne=False;
					}
				}
			}
		}
	}
	if ( bOne )
	{
		Other.SpecialGoal=TriggerActor;
		Other.MoveTarget=TriggerActor;
		return True;
	}
	else
	{
		if ( bTwo )
		{
			Other.SpecialGoal=TriggerActor2;
			Other.MoveTarget=TriggerActor2;
			return True;
		}
	}
	return False;
}

function Actor SpecialHandling (Pawn Other)
{
	if ( bDamageTriggered )
	{
		if (  !Other.bCanDoSpecial || (Other.Weapon == None) )
		{
			return None;
		}
		Other.Target=self;
		Other.bShootSpecial=True;
		Other.FireWeapon();
		Other.bFire=0;
		Other.bAltFire=0;
		return self;
	}
	if ( (BumpType == 0) &&  !Other.bIsPlayer )
	{
		return None;
	}
	return self;
}

final function InterpolateTo (byte NewKeyNum, float Seconds)
{
	NewKeyNum=Clamp(NewKeyNum,0,8 - 1);
	if ( (NewKeyNum == PrevKeyNum) && (KeyNum != PrevKeyNum) )
	{
		PhysAlpha=1.00 - PhysAlpha;
		OldPos=BasePos + KeyPos[KeyNum];
		OldRot=BaseRot + KeyRot[KeyNum];
	}
	else
	{
		OldPos=Location;
		OldRot=Rotation;
		PhysAlpha=0.00;
	}
	SetPhysics(9);
	bInterpolating=True;
	PrevKeyNum=KeyNum;
	KeyNum=NewKeyNum;
	PhysRate=1.00 / FMax(Seconds,0.00);
	ClientUpdate++;
	SimOldPos=OldPos;
	SimOldRotYaw=OldRot.Yaw;
	SimOldRotPitch=OldRot.Pitch;
	SimOldRotRoll=OldRot.Roll;
	SimInterpolate.X=100.00 * PhysAlpha;
	SimInterpolate.Y=100.00 * FMax(0.01,PhysRate);
	SimInterpolate.Z=256.00 * PrevKeyNum + KeyNum;
}

final function SetKeyframe (byte NewKeyNum, Vector NewLocation, Rotator NewRotation)
{
	KeyNum=Clamp(NewKeyNum,0,8 - 1);
	KeyPos[KeyNum]=NewLocation;
	KeyRot[KeyNum]=NewRotation;
}

function InterpolateEnd (Actor Other)
{
	local byte OldKeyNum;

	OldKeyNum=PrevKeyNum;
	PrevKeyNum=KeyNum;
	PhysAlpha=0.00;
	if ( (KeyNum > 0) && (KeyNum < OldKeyNum) )
	{
		InterpolateTo(KeyNum - 1,MoveTime);
	}
	else
	{
		if ( (KeyNum < NumKeys - 1) && (KeyNum > OldKeyNum) )
		{
			InterpolateTo(KeyNum + 1,MoveTime);
		}
		else
		{
			AmbientSound=None;
		}
	}
}

function FinishNotify ()
{
	local Pawn P;

	if ( StandingCount > 0 )
	{
		P=Level.PawnList;
JL0020:
		if ( P != None )
		{
			if ( P.Base == self )
			{
				P.StopWaiting();
				if ( (P.SpecialGoal == self) || (P.SpecialGoal == myMarker) )
				{
					P.SpecialGoal=None;
				}
				if ( P == WaitingPawn )
				{
					WaitingPawn=None;
				}
			}
			P=P.nextPawn;
			goto JL0020;
		}
	}
	if ( WaitingPawn != None )
	{
		WaitingPawn.StopWaiting();
		if ( (WaitingPawn.SpecialGoal == self) || (WaitingPawn.SpecialGoal == myMarker) )
		{
			WaitingPawn.SpecialGoal=None;
		}
		WaitingPawn=None;
	}
}

function FinishedClosing ()
{
	PlaySound(ClosedSound,0);
	if ( SavedTrigger != None )
	{
		SavedTrigger.EndEvent();
	}
	SavedTrigger=None;
	Instigator=None;
	FinishNotify();
}

function FinishedOpening ()
{
	local Actor A;

	PlaySound(OpenedSound,0);
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(self,Instigator);
		}
	}
	FinishNotify();
}

function DoOpen ()
{
	bOpening=True;
	bDelaying=False;
	InterpolateTo(1,MoveTime);
	PlaySound(OpeningSound,0);
	AmbientSound=MoveAmbientSound;
}

function DoClose ()
{
	local Actor A;

	bOpening=False;
	bDelaying=False;
	InterpolateTo(Max(0,KeyNum - 1),MoveTime);
	PlaySound(ClosingSound,0);
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.UnTrigger(self,Instigator);
		}
	}
	AmbientSound=MoveAmbientSound;
}

simulated function BeginPlay ()
{
	local Rotator R;

	if ( Level.NetMode != 0 )
	{
		SetTimer(2.00,True);
		if ( Role < 4 )
		{
			return;
		}
	}
	Super.BeginPlay();
	KeyNum=Clamp(KeyNum,0,8 - 1);
	PhysAlpha=0.00;
	Move(BasePos + KeyPos[KeyNum] - Location);
	SetRotation(BaseRot + KeyRot[KeyNum]);
	if ( ReturnGroup == 'None' )
	{
		ReturnGroup=Tag;
	}
}

function PostBeginPlay ()
{
	local Mover M;

	if (  !Level.Game.IsRelevant(self) )
	{
		bHidden=True;
		DrawType=0;
		SetCollision(False,False,False);
		SetLocation(Location + vect(0.00,0.00,20000.00));
	}
	else
	{
		FindTriggerActor();
		if (  !bSlave )
		{
			foreach AllActors(Class'Mover',M,Tag)
			{
				if ( M.bSlave )
				{
					M.GotoState('None');
					M.SetBase(self);
				}
			}
		}
		if ( Leader == None )
		{
			Leader=self;
			foreach AllActors(Class'Mover',M)
			{
				if ( (M != self) && (M.ReturnGroup == ReturnGroup) )
				{
					M.Leader=self;
					M.Follower=Follower;
					Follower=M;
				}
			}
		}
	}
}

function MakeGroupStop ()
{
	bInterpolating=False;
	AmbientSound=None;
	GotoState(,'None');
	if ( Follower != None )
	{
		Follower.MakeGroupStop();
	}
}

function MakeGroupReturn ()
{
	bInterpolating=False;
	AmbientSound=None;
	if ( KeyNum < PrevKeyNum )
	{
		GotoState(,'Open');
	}
	else
	{
		GotoState(,'Close');
	}
	if ( Follower != None )
	{
		Follower.MakeGroupReturn();
	}
}

function bool EncroachingOn (Actor Other)
{
	local Pawn P;

	if ( Other.IsA('Carcass') || Other.IsA('Decoration') )
	{
		Other.TakeDamage(10000,None,Other.Location,vect(0.00,0.00,0.00),'Crushed');
		return False;
	}
	if ( Other.IsA('Fragment') || Other.IsA('Weapon') && (Other.Owner == None) && (FRand() < 0.50) )
	{
		Other.Destroy();
		return False;
	}
	if ( EncroachDamage != 0 )
	{
		Other.TakeDamage(EncroachDamage,Instigator,Other.Location,vect(0.00,0.00,0.00),'Crushed');
	}
	P=Pawn(Other);
	if ( (P != None) && P.bIsPlayer && (PlayerBumpEvent != 'None') )
	{
		Bump(Other);
		if ( (myMarker != None) && (P.Base != self) && (P.Location.Z < myMarker.Location.Z - P.CollisionHeight - 0.70 * myMarker.CollisionHeight) )
		{
			P.UnderLift(self);
		}
	}
	if ( MoverEncroachType == 0 )
	{
		Leader.MakeGroupStop();
		return True;
	}
	else
	{
		if ( MoverEncroachType == 1 )
		{
			Leader.MakeGroupReturn();
			if ( Other.IsA('Pawn') )
			{
				if ( Pawn(Other).bIsPlayer )
				{
					Pawn(Other).PlaySound(Pawn(Other).Land,5);
				}
				else
				{
					Pawn(Other).PlaySound(Pawn(Other).HitSound1,5);
				}
			}
			return True;
		}
		else
		{
			if ( MoverEncroachType == 2 )
			{
				Other.KilledBy(Instigator);
				return False;
			}
			else
			{
				if ( MoverEncroachType == 3 )
				{
					return False;
				}
			}
		}
	}
}

function Bump (Actor Other)
{
	local Actor A;
	local Pawn P;

	P=Pawn(Other);
	if ( (BumpType != 2) && (P == None) )
	{
		return;
	}
	if ( (BumpType == 0) &&  !P.bIsPlayer )
	{
		return;
	}
	if ( (BumpType == 1) && (Other.Mass < 10) )
	{
		return;
	}
	if ( BumpEvent != 'None' )
	{
		foreach AllActors(Class'Actor',A,BumpEvent)
		{
			A.Trigger(self,P);
		}
	}
	if ( P != None )
	{
		if ( P.bIsPlayer && (PlayerBumpEvent != 'None') )
		{
			foreach AllActors(Class'Actor',A,PlayerBumpEvent)
			{
				A.Trigger(self,P);
			}
		}
		if ( P.SpecialGoal == self )
		{
			P.SpecialGoal=None;
		}
	}
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	if ( bDamageTriggered && (Damage >= DamageThreshold) )
	{
		self.Trigger(self,instigatedBy);
	}
}

state() TriggerOpenTimed
{
	function bool HandleDoor (Pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		GotoState('TriggerOpenTimed','Open');
	}
	
	function BeginState ()
	{
		bOpening=False;
	}
	
Open:
	Disable('Trigger');
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep(StayOpenTime);
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Trigger');
}

state() TriggerToggle
{
	function bool HandleDoor (Pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		if ( (KeyNum == 0) || (KeyNum < PrevKeyNum) )
		{
			GotoState('TriggerToggle','Open');
		}
		else
		{
			GotoState('TriggerToggle','Close');
		}
	}
	
Open:
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	SavedTrigger.EndEvent();
	stop
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

state() TriggerControl
{
	function bool HandleDoor (Pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents++;
		SavedTrigger=Other;
		Instigator=EventInstigator;
		if ( SavedTrigger != None )
		{
			SavedTrigger.BeginEvent();
		}
		GotoState('TriggerControl','Open');
	}
	
	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents--;
		if ( numTriggerEvents <= 0 )
		{
			numTriggerEvents=0;
			SavedTrigger=Other;
			Instigator=EventInstigator;
			SavedTrigger.BeginEvent();
			GotoState('TriggerControl','Close');
		}
	}
	
	function BeginState ()
	{
		numTriggerEvents=0;
	}
	
Open:
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	SavedTrigger.EndEvent();
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
	stop
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
}

state() TriggerPound
{
	function bool HandleDoor (Pawn Other)
	{
		return HandleTriggerDoor(Other);
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents++;
		SavedTrigger=Other;
		Instigator=EventInstigator;
		GotoState('TriggerPound','Open');
	}
	
	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		numTriggerEvents--;
		if ( numTriggerEvents <= 0 )
		{
			numTriggerEvents=0;
			SavedTrigger=None;
			Instigator=None;
			GotoState('TriggerPound','Close');
		}
	}
	
	function BeginState ()
	{
		numTriggerEvents=0;
	}
	
Open:
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	Sleep(OtherTime);
Close:
	DoClose();
	FinishInterpolation();
	Sleep(StayOpenTime);
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
	if ( SavedTrigger != None )
	{
		goto ('Open');
	}
}

state() BumpOpenTimed
{
	function bool HandleDoor (Pawn Other)
	{
		if ( (BumpType == 0) &&  !Other.bIsPlayer )
		{
			return False;
		}
		Bump(Other);
		WaitingPawn=Other;
		Other.SpecialPause=2.50;
		return True;
	}
	
	function Bump (Actor Other)
	{
		if ( (BumpType != 2) && (Pawn(Other) == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !Pawn(Other).bIsPlayer )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		Global.Bump(Other);
		SavedTrigger=None;
		Instigator=Pawn(Other);
		GotoState('BumpOpenTimed','Open');
	}
	
Open:
	Disable('Bump');
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep(StayOpenTime);
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Bump');
}

state() BumpButton
{
	function bool HandleDoor (Pawn Other)
	{
		if ( (BumpType == 0) &&  !Other.bIsPlayer )
		{
			return False;
		}
		Bump(Other);
		return False;
	}
	
	function Bump (Actor Other)
	{
		if ( (BumpType != 2) && (Pawn(Other) == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !Pawn(Other).bIsPlayer )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		Global.Bump(Other);
		SavedTrigger=Other;
		Instigator=Pawn(Other);
		GotoState('BumpButton','Open');
	}
	
	function BeginEvent ()
	{
		bSlave=True;
	}
	
	function EndEvent ()
	{
		bSlave=False;
		Instigator=None;
		GotoState('BumpButton','Close');
	}
	
Open:
	Disable('Bump');
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
	if ( bSlave )
	{
		stop
	}
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Bump');
}

state() StandOpenTimed
{
	function bool HandleDoor (Pawn Other)
	{
		if ( bPlayerOnly &&  !Other.bIsPlayer )
		{
			return False;
		}
		Other.SpecialPause=2.50;
		WaitingPawn=Other;
		if ( Other.Base == self )
		{
			Attach(Other);
		}
		return True;
	}
	
	function Attach (Actor Other)
	{
		local Pawn P;
	
		P=Pawn(Other);
		if ( (BumpType != 2) && (P == None) )
		{
			return;
		}
		if ( (BumpType == 0) &&  !P.bIsPlayer )
		{
			return;
		}
		if ( (BumpType == 1) && (Other.Mass < 10) )
		{
			return;
		}
		SavedTrigger=None;
		GotoState('StandOpenTimed','Open');
	}
	
Open:
	Disable('Attach');
	if ( DelayTime > 0 )
	{
		bDelaying=True;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();
	Sleep(StayOpenTime);
	if ( bTriggerOnceOnly )
	{
		GotoState('None');
	}
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();
	Enable('Attach');
}

defaultproperties
{
    MoverEncroachType=ME_ReturnWhenEncroach
    MoverGlideType=MV_GlideByTime
    NumKeys=2
    MoveTime=1.00
    StayOpenTime=4.00
    bStatic=False
    Physics=PHYS_Walking
    RemoteRole=ROLE_DumbProxy
    InitialState=BumpOpenTimed
    bIsMover=True
    bAlwaysRelevant=True
    SoundVolume=228
    TransientSoundVolume=3.00
    CollisionRadius=160.00
    CollisionHeight=160.00
    bCollideActors=True
    bBlockActors=True
    bBlockPlayers=True
    NetPriority=7.00
}