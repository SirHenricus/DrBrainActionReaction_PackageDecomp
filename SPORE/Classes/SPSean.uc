//================================================================================
// SPSean.
//================================================================================
class SPSean expands SPPlayer
	config(User);

simulated function PlayLeftFootStep ()
{
	PlaySound(Sound'step3',3,1.00);
}

simulated function PlayRightFootStep ()
{
}

simulated function PlayCaptureFlagSpeech ()
{
	PlaySporeSpeech("922");
}

simulated function PlayCaptureCravenSpeech ()
{
	PlaySporeSpeech("943");
}

simulated function PlayCaptureCFOSpeech ()
{
	PlaySporeSpeech("921");
}

simulated function PlayCaptureCSOSpeech ()
{
	PlaySporeSpeech("920");
}

simulated function PlayHitByPlayerSpeech ()
{
	PlaySporeSpeech("919");
}

simulated function PlayReSpawnSpeech ()
{
	PlaySporeSpeech("947");
}

simulated function PlayerHitByGuardSpeech ()
{
	PlaySporeSpeech("946");
}

exec function Taunt1 ()
{
	PlaySporeSpeech("968");
}

exec function Taunt2 ()
{
	PlaySporeSpeech("945");
}

exec function Taunt3 ()
{
	PlaySporeSpeech("944");
}

exec function Taunt4 ()
{
	PlaySporeSpeech("934");
}

exec function Taunt5 ()
{
	PlaySporeSpeech("938");
}

exec function Taunt6 ()
{
	PlaySporeSpeech("939");
}

exec function Taunt7 ()
{
	PlaySporeSpeech("942");
}

exec function Taunt8 ()
{
	PlaySporeSpeech("951");
}

exec function Taunt9 ()
{
	PlaySporeSpeech("936");
}

exec function Taunt0 ()
{
	PlaySporeSpeech("940");
}

defaultproperties
{
    CharacterName="Sean Collen-Smith"
    Age="26"
    Nationality="Scottish"
    Specialties="Kinesiology, Physiology, Anatomy, Physical Therapy, Martial Arts and Athletics"
    Quirks="LOVES haggis and needlepoint"
    Land=Sound'SPPlayer.land03'
    Mesh=LodMesh'sean'
    DrawScale=1.30
    CollisionRadius=22.00
    CollisionHeight=30.00
}