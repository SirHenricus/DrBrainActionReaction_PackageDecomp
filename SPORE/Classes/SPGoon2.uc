//================================================================================
// SPGoon2.
//================================================================================
class SPGoon2 expands SPAbstractGoon;

function PlayFootStep ()
{
	PlaySound(Sound'step4',3,1.00);
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'goon2'
    DrawScale=1.45
    CollisionHeight=46.00
}