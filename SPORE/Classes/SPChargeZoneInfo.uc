//================================================================================
// SPChargeZoneInfo.
//================================================================================
class SPChargeZoneInfo expands ZoneInfo
	native;

var SPActor ChargeActorList[10];
var(ZoneInfo) const bool bChargeZone;

replication
{
	un?reliable if ( Role == 4 )
		ChargeActorList;
}

simulated function PreBeginPlay ()
{
	local SPActor chargeActor;
	local int i;

	Super.PreBeginPlay();
	foreach ZoneActors(Class'SPActor',chargeActor)
	{
		if ( chargeActor.IsSourceCharge )
		{
			ChargeActorList[i++ ]=chargeActor;
		}
	}
}

event ActorEntered (Actor Other)
{
	local SPActor Actor;
	local int i;

	Actor=SPActor(Other);
	if ( Actor != None )
	{
		if ( Actor.IsSourceCharge )
		{
			i=0;
JL0034:
			if ( (i < 10) && (ChargeActorList[i] != None) )
			{
				i++;
				goto JL0034;
			}
			if ( i < 10 )
			{
				ChargeActorList[i]=Actor;
			}
		}
	}
	Super.ActorEntered(Other);
}

event ActorLeaving (Actor Other)
{
	local SPActor Actor;
	local int i;

	Actor=SPActor(Other);
	if ( Actor != None )
	{
		if ( Actor.IsSourceCharge )
		{
			i=0;
JL0034:
			if ( (i < 10) && (ChargeActorList[i] != Actor) )
			{
				i++;
				goto JL0034;
			}
JL0061:
			if ( (i + 1 < 10) && (ChargeActorList[i + 1] != None) )
			{
				ChargeActorList[i]=ChargeActorList[i + 1];
				i++;
				goto JL0061;
			}
			if ( i < 10 )
			{
				ChargeActorList[i]=None;
			}
			else
			{
			}
		}
		if ( (Actor.Charge != 0) && Actor.IgnoreGravityInChargeZone &&  !Actor.ApplyDrag )
		{
			Acceleration=vect(0.00,0.00,0.00);
		}
	}
	Super.ActorLeaving(Other);
}

defaultproperties
{
    bChargeZone=True
}