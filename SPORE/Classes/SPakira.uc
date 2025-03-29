//================================================================================
// SPakira.
//================================================================================
class SPakira expands SPPlayer
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
	PlaySporeSpeech("807");
}

simulated function PlayCaptureCravenSpeech ()
{
	PlaySporeSpeech("806");
}

simulated function PlayCaptureCFOSpeech ()
{
	PlaySporeSpeech("805");
}

simulated function PlayCaptureCSOSpeech ()
{
	PlaySporeSpeech("804");
}

simulated function PlayHitByPlayerSpeech ()
{
	PlaySporeSpeech("803");
}

simulated function PlayReSpawnSpeech ()
{
	PlaySporeSpeech("828");
}

simulated function PlayerHitByGuardSpeech ()
{
	PlaySporeSpeech("834");
}

exec function Taunt1 ()
{
	PlaySporeSpeech("810");
}

exec function Taunt2 ()
{
	PlaySporeSpeech("830");
}

exec function Taunt3 ()
{
	PlaySporeSpeech("827");
}

exec function Taunt4 ()
{
	PlaySporeSpeech("838");
}

exec function Taunt5 ()
{
	PlaySporeSpeech("850");
}

exec function Taunt6 ()
{
	PlaySporeSpeech("820");
}

exec function Taunt7 ()
{
	PlaySporeSpeech("831");
}

exec function Taunt8 ()
{
	PlaySporeSpeech("832");
}

exec function Taunt9 ()
{
	PlaySporeSpeech("822");
}

exec function Taunt0 ()
{
	PlaySporeSpeech("811");
}

defaultproperties
{
    CharacterName="Akira Miyazaki"
    Age="22"
    Nationality="Japanese"
    Specialties="Electronics, Electrical Engineering, Circuitry and Nanotechnology"
    Quirks="Constantly playing practical (and impractical) jokes. Chews a LOT of gum."
    Mesh=LodMesh'akira'
    DrawScale=1.70
    CollisionRadius=18.00
    CollisionHeight=46.00
}