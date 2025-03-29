//================================================================================
// SPBrainPose.
//================================================================================
class SPBrainPose expands SPBrain;

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
    Mesh=LodMesh'brainpose'
}