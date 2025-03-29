//================================================================================
// SPGoonStunner.
//================================================================================
class SPGoonStunner expands SPActor;

event Bump (Actor Other)
{
	if ( Other.IsA('SPPawn') )
	{
		Other.GotoState('Stunned');
	}
}

defaultproperties
{
    DrawType=DT_Sprite
    Mesh=LodMesh'Shroom'
    CollisionRadius=40.00
    CollisionHeight=30.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}