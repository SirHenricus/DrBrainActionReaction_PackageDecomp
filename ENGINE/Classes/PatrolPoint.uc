//================================================================================
// PatrolPoint.
//================================================================================
class PatrolPoint expands NavigationPoint;

var() name Nextpatrol;
var() float pausetime;
var Vector lookDir;
var() name PatrolAnim;
var() Sound PatrolSound;
var() byte numAnims;
var int AnimCount;
var PatrolPoint NextPatrolPoint;

function PreBeginPlay ()
{
	if ( pausetime > 0.00 )
	{
		lookDir=200 * vector(Rotation);
	}
	foreach AllActors(Class'PatrolPoint',NextPatrolPoint,Nextpatrol)
	{
		goto JL0039;
	}
	Super.PreBeginPlay();
}

defaultproperties
{
    bDirectional=True
    Texture=Texture'S_Patrol'
    SoundVolume=128
}