//================================================================================
// SPChair.
//================================================================================
class SPChair expands SPActor;

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'chair'
    DrawScale=1.40
    CollisionRadius=28.00
    CollisionHeight=58.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}