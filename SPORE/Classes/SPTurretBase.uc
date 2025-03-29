//================================================================================
// SPTurretBase.
//================================================================================
class SPTurretBase expands SPActor;

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'RoboBase'
    CollisionHeight=35.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}