//================================================================================
// SPGoon1.
//================================================================================
class SPGoon1 expands SPAbstractGoon;

function PlayFootStep ()
{
	PlaySound(Sound'step4',3,1.00);
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'goon1'
    DrawScale=1.40
    CollisionHeight=52.00
}