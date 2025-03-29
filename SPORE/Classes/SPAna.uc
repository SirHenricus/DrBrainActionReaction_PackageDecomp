//================================================================================
// SPAna.
//================================================================================
class SPAna expands SPPlayer
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
	PlaySporeSpeech("115");
}

simulated function PlayCaptureCravenSpeech ()
{
	PlaySporeSpeech("088");
}

simulated function PlayCaptureCFOSpeech ()
{
	PlaySporeSpeech("065");
}

simulated function PlayCaptureCSOSpeech ()
{
	PlaySporeSpeech("086");
}

simulated function PlayHitByPlayerSpeech ()
{
	PlaySporeSpeech("059");
}

simulated function PlayReSpawnSpeech ()
{
	PlaySporeSpeech("084");
}

simulated function PlayerHitByGuardSpeech ()
{
	PlaySporeSpeech("116");
}

exec function Taunt1 ()
{
	PlaySporeSpeech("082");
}

exec function Taunt2 ()
{
	PlaySporeSpeech("094");
}

exec function Taunt3 ()
{
	PlaySporeSpeech("080");
}

exec function Taunt4 ()
{
	PlaySporeSpeech("106");
}

exec function Taunt5 ()
{
	PlaySporeSpeech("078");
}

exec function Taunt6 ()
{
	PlaySporeSpeech("103");
}

exec function Taunt7 ()
{
	PlaySporeSpeech("077");
}

exec function Taunt8 ()
{
	PlaySporeSpeech("075");
}

exec function Taunt9 ()
{
	PlaySporeSpeech("072");
}

exec function Taunt0 ()
{
	PlaySporeSpeech("071");
}

defaultproperties
{
    CharacterName="Ana-Maria Benzala"
    Age="26"
    Nationality="Brazilian"
    Specialties="Psychology, Personality, Cognition, Memory, Emotion and Development"
    Quirks="Finds fault in everything"
    Land=Sound'SPPlayer.land02'
    Mesh=LodMesh'ana'
    DrawScale=1.30
    CollisionRadius=14.00
    CollisionHeight=46.00
}