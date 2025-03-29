//================================================================================
// SPAlyia.
//================================================================================
class SPAlyia expands SPPlayer
	config(User);

simulated function PlayLeftFootStep ()
{
	PlaySound(Sound'step2left',3,1.00);
}

simulated function PlayRightFootStep ()
{
	PlaySound(Sound'step2right',3,1.00);
}

simulated function PlayCaptureFlagSpeech ()
{
	PlaySporeSpeech("1096");
}

simulated function PlayCaptureCravenSpeech ()
{
	PlaySporeSpeech("1088");
}

simulated function PlayCaptureCFOSpeech ()
{
	PlaySporeSpeech("1089");
}

simulated function PlayCaptureCSOSpeech ()
{
	PlaySporeSpeech("1091");
}

simulated function PlayHitByPlayerSpeech ()
{
	PlaySporeSpeech("10106");
}

simulated function PlayReSpawnSpeech ()
{
	PlaySporeSpeech("1092");
}

simulated function PlayerHitByGuardSpeech ()
{
	PlaySporeSpeech("1090");
}

exec function Taunt1 ()
{
	PlaySporeSpeech("10148");
}

exec function Taunt2 ()
{
	PlaySporeSpeech("10140");
}

exec function Taunt3 ()
{
	PlaySporeSpeech("10108");
}

exec function Taunt4 ()
{
	PlaySporeSpeech("10133");
}

exec function Taunt5 ()
{
	PlaySporeSpeech("10106");
}

exec function Taunt6 ()
{
	PlaySporeSpeech("10146");
}

exec function Taunt7 ()
{
	PlaySporeSpeech("10139");
}

exec function Taunt8 ()
{
	PlaySporeSpeech("10138");
}

exec function Taunt9 ()
{
	PlaySporeSpeech("10137");
}

exec function Taunt0 ()
{
	PlaySporeSpeech("10136");
}

defaultproperties
{
    CharacterName="Aliya Ophir"
    Age="17"
    Nationality="Israeli"
    Specialties="Programming, Algorithms, Cybernetics, Virtual Reality and Artificial Life"
    Quirks="Prodigy, Attention Deficit Disorder"
    Land=Sound'SPPlayer.land02'
    DrawScale=1.10
    CollisionRadius=20.00
    CollisionHeight=42.00
}