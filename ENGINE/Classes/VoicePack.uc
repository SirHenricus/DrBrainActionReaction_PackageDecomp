//================================================================================
// VoicePack.
//================================================================================
class VoicePack expands Info
	abstract;

function ClientInitialize (PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name messagetype, byte messageIndex);

function PlayerSpeech (int Type, int Index, int Callsign);

defaultproperties
{
    RemoteRole=0
    LifeSpan=10.00
}