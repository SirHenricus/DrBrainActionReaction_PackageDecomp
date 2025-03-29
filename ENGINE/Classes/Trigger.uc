//================================================================================
// Trigger.
//================================================================================
class Trigger expands Triggers
	native;

var() ETriggerType TriggerType;
var() localized string Message;
var() bool bTriggerOnceOnly;
var() bool bInitiallyActive;
var() Class<Actor> ClassProximityType;
var() float RepeatTriggerTime;
var() float ReTriggerDelay;
var float TriggerTime;
var() float DamageThreshold;
var Actor TriggerActor;
var Actor TriggerActor2;
enum ETriggerType {
	TT_PlayerProximity,
	TT_PawnProximity,
	TT_ClassProximity,
	TT_AnyProximity,
	TT_Shoot
};


function PostBeginPlay ()
{
	if (  !bInitiallyActive )
	{
		FindTriggerActor();
	}
	if ( TriggerType == 4 )
	{
		bHidden=False;
		bProjTarget=True;
		DrawType=0;
	}
	Super.PostBeginPlay();
}

function FindTriggerActor ()
{
	local Actor A;

	TriggerActor=None;
	TriggerActor2=None;
	foreach AllActors(Class'Actor',A)
	{
		if ( A.Event == Tag )
		{
			if ( Counter(A) != None )
			{
				return;
			}
			if ( TriggerActor == None )
			{
				TriggerActor=A;
			}
			else
			{
				TriggerActor2=A;
				return;
			}
		}
	}
}

function Actor SpecialHandling (Pawn Other)
{
	local int i;

	if ( bTriggerOnceOnly &&  !bCollideActors )
	{
		return None;
	}
	if ( (TriggerType == 0) &&  !Other.bIsPlayer )
	{
		return None;
	}
	if (  !bInitiallyActive )
	{
		if ( TriggerActor == None )
		{
			FindTriggerActor();
		}
		if ( TriggerActor == None )
		{
			return None;
		}
		if ( (TriggerActor2 != None) && (VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location)) )
		{
			return TriggerActor2;
		}
		else
		{
			return TriggerActor;
		}
	}
	if ( TriggerType == 4 )
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
		return Other;
	}
	if ( IsRelevant(Other) )
	{
		i=0;
JL016F:
		if ( i < 4 )
		{
			if ( Touching[i] == Other )
			{
				Touch(Other);
			}
			i++;
			goto JL016F;
		}
		return self;
	}
	return self;
}

function CheckTouchList ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 4 )
	{
		if ( Touching[i] != None )
		{
			Touch(Touching[i]);
		}
		i++;
		goto JL0007;
	}
}

state() NormalTrigger
{
}

state() OtherTriggerToggles
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		bInitiallyActive= !bInitiallyActive;
		if ( bInitiallyActive )
		{
			CheckTouchList();
		}
	}
	
}

state() OtherTriggerTurnsOn
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		local bool bWasActive;
	
		bWasActive=bInitiallyActive;
		bInitiallyActive=True;
		if (  !bWasActive )
		{
			CheckTouchList();
		}
	}
	
}

state() OtherTriggerTurnsOff
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		bInitiallyActive=False;
	}
	
}

final function bool IsRelevant (Actor Other)
{
	if (  !bInitiallyActive )
	{
		return False;
	}
	switch (TriggerType)
	{
		case 0:
		return (Pawn(Other) != None) && Pawn(Other).bIsPlayer;
		case 1:
		return (Pawn(Other) != None) && (Pawn(Other).Intelligence > 0);
		case 2:
		return ClassIsChildOf(Other.Class,ClassProximityType);
		case 3:
		return True;
		case 4:
		return (Projectile(Other) != None) && (Projectile(Other).Damage >= DamageThreshold);
		default:
	}
}

function Touch (Actor Other)
{
	local Actor A;

	if ( IsRelevant(Other) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
			{
				return;
			}
			TriggerTime=Level.TimeSeconds;
		}
		if ( Event != 'None' )
		{
			foreach AllActors(Class'Actor',A,Event)
			{
				A.Trigger(Other,Other.Instigator);
			}
		}
		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
		{
			Pawn(Other).SpecialGoal=None;
		}
		if ( Message != "" )
		{
			Other.Instigator.ClientMessage(Message);
		}
		if ( bTriggerOnceOnly )
		{
			SetCollision(False);
		}
		else
		{
			if ( RepeatTriggerTime > 0 )
			{
				SetTimer(RepeatTriggerTime,False);
			}
		}
	}
}

function Timer ()
{
	local bool bKeepTiming;
	local int i;

	bKeepTiming=False;
	i=0;
JL000F:
	if ( i < 4 )
	{
		if ( (Touching[i] != None) && IsRelevant(Touching[i]) )
		{
			bKeepTiming=True;
			Touch(Touching[i]);
		}
		i++;
		goto JL000F;
	}
	if ( bKeepTiming )
	{
		SetTimer(RepeatTriggerTime,False);
	}
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	local Actor A;

	if ( bInitiallyActive && (TriggerType == 4) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
			{
				return;
			}
			TriggerTime=Level.TimeSeconds;
		}
		if ( Event != 'None' )
		{
			foreach AllActors(Class'Actor',A,Event)
			{
				A.Trigger(instigatedBy,instigatedBy);
			}
		}
		if ( Message != "" )
		{
			instigatedBy.Instigator.ClientMessage(Message);
		}
		if ( bTriggerOnceOnly )
		{
			SetCollision(False);
		}
	}
}

function UnTouch (Actor Other)
{
	local Actor A;

	if ( IsRelevant(Other) )
	{
		if ( Event != 'None' )
		{
			foreach AllActors(Class'Actor',A,Event)
			{
				A.UnTrigger(Other,Other.Instigator);
			}
		}
	}
}

defaultproperties
{
    bInitiallyActive=True
    InitialState=NormalTrigger
    Texture=Texture'S_Trigger'
}