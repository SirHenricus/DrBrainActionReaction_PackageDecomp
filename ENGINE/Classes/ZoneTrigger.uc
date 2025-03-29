//================================================================================
// ZoneTrigger.
//================================================================================
class ZoneTrigger expands Trigger;

function Touch (Actor Other)
{
	local ZoneInfo Z;

	if ( IsRelevant(Other) )
	{
		if ( Event != 'None' )
		{
			foreach AllActors(Class'ZoneInfo',Z)
			{
				if ( Z.ZoneTag == Event )
				{
					Z.Trigger(Other,Other.Instigator);
				}
			}
		}
		if ( Message != "" )
		{
			Other.Instigator.ClientMessage(Message);
		}
		if ( bTriggerOnceOnly )
		{
			SetCollision(False);
		}
	}
}

function UnTouch (Actor Other)
{
	local ZoneInfo Z;

	if ( IsRelevant(Other) )
	{
		if ( Event != 'None' )
		{
			foreach AllActors(Class'ZoneInfo',Z)
			{
				if ( Z.ZoneTag == Event )
				{
					Z.UnTrigger(Other,Other.Instigator);
				}
			}
		}
	}
}