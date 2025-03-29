//================================================================================
// SPGoon3.
//================================================================================
class SPGoon3 expands SPAbstractGoon;

function PlayFootStep ()
{
	PlaySound(Sound'step5',3,1.00);
}

defaultproperties
{
    Land=Sound'SPAbstractGoon.land05'
    DrawType=DT_Sprite
    Mesh=LodMesh'goon3'
    DrawScale=3.00
    CollisionRadius=50.00
    CollisionHeight=65.00
}