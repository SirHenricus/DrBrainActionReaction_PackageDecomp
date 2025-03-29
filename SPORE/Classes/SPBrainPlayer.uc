//================================================================================
// SPBrainPlayer.
//================================================================================
class SPBrainPlayer expands SPPlayer
	config(User);

simulated function PlayLeftFootStep ()
{
	PlaySound(Sound'step1left',3,1.00);
}

simulated function PlayRightFootStep ()
{
	PlaySound(Sound'step1right',3,1.00);
}

simulated function PlayCaptureFlagSpeech ()
{
	PlaySporeSpeech("220");
}

simulated function PlayCaptureCravenSpeech ()
{
	PlaySporeSpeech("248");
}

simulated function PlayCaptureCFOSpeech ()
{
	PlaySporeSpeech("221");
}

simulated function PlayCaptureCSOSpeech ()
{
	PlaySporeSpeech("222");
}

simulated function PlayHitByPlayerSpeech ()
{
	PlaySporeSpeech("254");
}

simulated function PlayReSpawnSpeech ()
{
	PlaySporeSpeech("273");
}

simulated function PlayerHitByGuardSpeech ()
{
	PlaySporeSpeech("254");
}

exec function Taunt1 ()
{
	PlaySporeSpeech("225");
}

exec function Taunt2 ()
{
	PlaySporeSpeech("245");
}

exec function Taunt3 ()
{
	PlaySporeSpeech("230");
}

exec function Taunt4 ()
{
	PlaySporeSpeech("265");
}

exec function Taunt5 ()
{
	PlaySporeSpeech("264");
}

exec function Taunt6 ()
{
	PlaySporeSpeech("263");
}

exec function Taunt7 ()
{
	PlaySporeSpeech("219");
}

exec function Taunt8 ()
{
	PlaySporeSpeech("260");
}

exec function Taunt9 ()
{
	PlaySporeSpeech("262");
}

exec function Taunt0 ()
{
	PlaySporeSpeech("261");
}

defaultproperties
{
    CharacterName="Dr. Brain"
    Age="26"
    Nationality="American"
    Specialties="Everything"
    Quirks="Leaps before he looks"
    Mesh=LodMesh'brain'
    DrawScale=1.60
    CollisionRadius=20.00
}