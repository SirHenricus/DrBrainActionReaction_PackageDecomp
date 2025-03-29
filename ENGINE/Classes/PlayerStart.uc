//================================================================================
// PlayerStart.
//================================================================================
class PlayerStart expands NavigationPoint
	native;

var() byte TeamNumber;
var() bool bSinglePlayerStart;
var() bool bCoopStart;
var() bool bEnabled;

function Trigger (Actor Other, Pawn EventInstigator)
{
	bEnabled= !bEnabled;
}

function PlayTeleportEffect (Actor Incoming, bool bOut)
{
	Level.Game.PlayTeleportEffect(Incoming,bOut,Level.Game.bDeathMatch);
}

defaultproperties
{
    bSinglePlayerStart=True
    bCoopStart=True
    bEnabled=True
    bDirectional=True
    Texture=Texture'S_Player'
    SoundVolume=128
    CollisionRadius=18.00
    CollisionHeight=40.00
}