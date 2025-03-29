//================================================================================
// SPSeaweed.
//================================================================================
class SPSeaweed expands SPActor;

event BeginPlay ()
{
	LoopAnim('wave',0.25);
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'seaweed'
}