//================================================================================
// SPCorneliusPose.
//================================================================================
class SPCorneliusPose expands SPCornelius;

var() name PoseAnim;

function PostBeginPlay ()
{
	PlayAnim(PoseAnim);
}

auto state Ignoring
{
	ignores  TakeDamage, KilledBy;
	
Begin:
}

defaultproperties
{
    Mesh=LodMesh'cornypose'
}