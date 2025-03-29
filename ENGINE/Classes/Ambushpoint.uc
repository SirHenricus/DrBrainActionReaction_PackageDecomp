//================================================================================
// Ambushpoint.
//================================================================================
class Ambushpoint expands NavigationPoint;

var Vector lookDir;
var byte survivecount;

function PreBeginPlay ()
{
	lookDir=2000 * vector(Rotation);
	Super.PreBeginPlay();
}

defaultproperties
{
    bDirectional=True
    SoundVolume=128
}