//================================================================================
// SpecialEvent.
//================================================================================
class SpecialEvent expands Triggers;

var() int Damage;
var() name DamageType;
var() localized string DamageString;
var() Sound Sound;
var() localized string Message;
var() bool bBroadcast;
var() bool bPlayerViewRot;

function Trigger (Actor Other, Pawn EventInstigator)
{
	local Pawn P;

	if ( bBroadcast )
	{
		BroadcastMessage(Message,True,'CriticalEvent');
	}
	else
	{
		if ( (EventInstigator != None) && (Len(Message) != 0) )
		{
			EventInstigator.ClientMessage(Message);
		}
	}
}

state() DisplayMessage
{
}

state() DamageInstigator
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		Global.Trigger(self,EventInstigator);
		if ( Other.IsA('PlayerPawn') )
		{
			Level.Game.SpecialDamageString=DamageString;
		}
		Other.TakeDamage(Damage,EventInstigator,EventInstigator.Location,vect(0.00,0.00,0.00),DamageType);
	}
	
}

state() KillInstigator
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		Global.Trigger(self,EventInstigator);
		if ( Other.IsA('PlayerPawn') )
		{
			Level.Game.SpecialDamageString=DamageString;
		}
		if ( EventInstigator != None )
		{
			EventInstigator.Died(None,DamageType,EventInstigator.Location);
		}
	}
	
}

state() PlaySoundEffect
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		Global.Trigger(self,EventInstigator);
		PlaySound(Sound);
	}
	
}

state() PlayersPlaySoundEffect
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		local Pawn P;
	
		Global.Trigger(self,EventInstigator);
		P=Level.PawnList;
	JL0020:
		if ( P != None )
		{
			if ( P.bIsPlayer && P.IsA('PlayerPawn') )
			{
				PlayerPawn(P).ClientPlaySound(Sound);
			}
			P=P.nextPawn;
			goto JL0020;
		}
	}
	
}

state() PlayAmbientSoundEffect
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		Global.Trigger(self,EventInstigator);
		EventInstigator.AmbientSound=AmbientSound;
	}
	
}

state() PlayerPath
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		local InterpolationPoint i;
	
		Global.Trigger(self,EventInstigator);
		if ( (EventInstigator != None) && EventInstigator.bIsPlayer && (Level.NetMode == 0) )
		{
			foreach AllActors(Class'InterpolationPoint',i,Event)
			{
				if ( i.Position == 0 )
				{
					EventInstigator.GotoState('None');
					EventInstigator.SetCollision(True,False,False);
					EventInstigator.bCollideWorld=False;
					EventInstigator.Target=i;
					EventInstigator.SetPhysics(8);
					EventInstigator.PhysRate=1.00;
					EventInstigator.PhysAlpha=0.00;
					EventInstigator.bInterpolating=True;
					EventInstigator.AmbientSound=AmbientSound;
				}
			}
		}
	}
	
}

defaultproperties
{
    Texture=Texture'S_SpecialEvent'
}