//================================================================================
// SPGameInfo.
//================================================================================
class SPGameInfo expands GameInfo;

var() localized string RocketMessage;
var() localized string SharkMessage;
var() localized string GuardMessage;
var() localized string CrushMessage;

event BeginPlay ()
{
	SetTimer(3.00 * 60,True);
}

event Timer ()
{
	local PlayerPawn P;

	foreach AllActors(Class'PlayerPawn',P)
	{
		goto JL0014;
	}
	if ( P != None )
	{
		P.ConsoleCommand("CDTRACK " $ string(Level.CdTrack));
	}
}

function string KillMessage (name DamageType, Pawn Other)
{
	if ( DamageType == 'stun' )
	{
		return RocketMessage;
	}
	else
	{
		if ( DamageType == 'sharks' )
		{
			return SharkMessage;
		}
		else
		{
			if ( DamageType == 'Crushed' )
			{
				return CrushMessage;
			}
			else
			{
				if ( DamageType == 'suicided' )
				{
					return CrushMessage;
				}
			}
		}
	}
}

function string CreatureKillMessage (name DamageType, Pawn Other)
{
	if ( DamageType == 'caught' )
	{
		return GuardMessage;
	}
}

defaultproperties
{
    RocketMessage=" was stunned by a rocket."
    SharkMessage=" was captured by sharks."
    GuardMessage=" was caught by a guard."
    CrushMessage=" was stuck between a rock and a hard place."
    bPauseable=False
    DefaultPlayerClass=Class'SPPlayer'
    DefaultWeapon=Class'SPPushWeapon'
    GameMenuType=Class'SPMainMenu'
    HUDType=Class'SPHud'
}