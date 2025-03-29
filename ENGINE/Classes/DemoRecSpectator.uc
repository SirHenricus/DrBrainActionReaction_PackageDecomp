//================================================================================
// DemoRecSpectator.
//================================================================================
class DemoRecSpectator expands Spectator
	config(User);

replication
{
	reliable if ( bDemoRecording )
		RepClientVoiceMessage,RepTeamMessage,RepClientPlaySound,RepClientMessage;
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	bIsPlayer=False;
}

function ClientMessage (coerce string S, optional name Type, optional bool bBeep)
{
	RepClientMessage(S,Type,bBeep);
}

function ClientPlaySound (Sound ASound)
{
	RepClientPlaySound(ASound);
}

function TeamMessage (PlayerReplicationInfo PRI, coerce string S, name Type)
{
	RepTeamMessage(PRI,S,Type);
}

function ClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	RepClientVoiceMessage(Sender,Recipient,messagetype,messageID);
}

simulated function RepClientMessage (coerce string S, optional name Type, optional bool bBeep)
{
	local PlayerPawn P;

	if ( Level.NetMode == 3 )
	{
		foreach AllActors(Class'PlayerPawn',P)
		{
			if ( P.Role == 4 )
			{
				P.ClientMessage(S,Type,bBeep);
			}
			else
			{
			}
		}
	}
}

simulated function RepClientPlaySound (Sound ASound)
{
	local PlayerPawn P;

	if ( Level.NetMode == 3 )
	{
		foreach AllActors(Class'PlayerPawn',P)
		{
			if ( P.Role == 4 )
			{
				P.ClientPlaySound(ASound);
			}
			else
			{
			}
		}
	}
}

simulated function RepTeamMessage (PlayerReplicationInfo PRI, coerce string S, name Type)
{
	local PlayerPawn P;

	if ( Level.NetMode == 3 )
	{
		foreach AllActors(Class'PlayerPawn',P)
		{
			if ( P.Role == 4 )
			{
				P.TeamMessage(PRI,S,Type);
			}
			else
			{
			}
		}
	}
}

simulated function RepClientVoiceMessage (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageID)
{
	local PlayerPawn P;

	if ( Level.NetMode == 3 )
	{
		foreach AllActors(Class'PlayerPawn',P)
		{
			if ( P.Role == 4 )
			{
				P.ClientVoiceMessage(Sender,Recipient,messagetype,messageID);
			}
			else
			{
			}
		}
	}
}