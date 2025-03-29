//================================================================================
// SPCynthiaPose.
//================================================================================
class SPCynthiaPose expands SPCynthia;

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
    Mesh=LodMesh'cynpose'
}