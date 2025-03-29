//================================================================================
// Scout.
//================================================================================
class Scout expands Pawn
	native;

function PreBeginPlay ()
{
	Destroy();
}

defaultproperties
{
    AccelRate=1.00
    SightRadius=4100.00
    CombatStyle=4.36346778309305678E24
    CollisionRadius=52.00
    CollisionHeight=50.00
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
}