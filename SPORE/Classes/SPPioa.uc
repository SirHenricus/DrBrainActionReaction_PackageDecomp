//================================================================================
// SPPioa.
//================================================================================
class SPPioa expands SPPlayer
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
	PlaySporeSpeech("616");
}

simulated function PlayCaptureCravenSpeech ()
{
	PlaySporeSpeech("604");
}

simulated function PlayCaptureCFOSpeech ()
{
	PlaySporeSpeech("603");
}

simulated function PlayCaptureCSOSpeech ()
{
	PlaySporeSpeech("602");
}

simulated function PlayHitByPlayerSpeech ()
{
	PlaySporeSpeech("572");
}

simulated function PlayReSpawnSpeech ()
{
	PlaySporeSpeech("600");
}

simulated function PlayerHitByGuardSpeech ()
{
	PlaySporeSpeech("585");
}

exec function Taunt1 ()
{
	PlaySporeSpeech("593");
}

exec function Taunt2 ()
{
	PlaySporeSpeech("570");
}

exec function Taunt3 ()
{
	PlaySporeSpeech("575");
}

exec function Taunt4 ()
{
	PlaySporeSpeech("586");
}

exec function Taunt5 ()
{
	PlaySporeSpeech("562");
}

exec function Taunt6 ()
{
	PlaySporeSpeech("563");
}

exec function Taunt7 ()
{
	PlaySporeSpeech("564");
}

exec function Taunt8 ()
{
	PlaySporeSpeech("565");
}

exec function Taunt9 ()
{
	PlaySporeSpeech("566");
}

exec function Taunt0 ()
{
	PlaySporeSpeech("567");
}

defaultproperties
{
    CharacterName="Pioa"
    Age="35"
    Nationality="Samoan"
    Specialties="Meteorology, Climatology, Vortices and Chaotic Systems"
    Quirks="Uncomfortable and shy about his remarkable size"
    Mesh=LodMesh'pioa'
    DrawScale=1.50
    CollisionRadius=25.00
    CollisionHeight=48.00
}