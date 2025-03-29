//================================================================================
// HomeBase.
//================================================================================
class HomeBase expands NavigationPoint;

var() float Extent;
var Vector lookDir;

function PreBeginPlay ()
{
	lookDir=200 * vector(Rotation);
	Super.PreBeginPlay();
}

defaultproperties
{
    Extent=700.00
    Texture=Texture'S_Flag'
    SoundVolume=128
}