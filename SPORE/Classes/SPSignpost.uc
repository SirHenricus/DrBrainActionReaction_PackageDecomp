//================================================================================
// SPSignpost.
//================================================================================
class SPSignpost expands SPActor;

var() EDirection Pointing;
enum EDirection {
	EDirection_North,
	EDirection_South,
	EDirection_East,
	EDirection_West
};


defaultproperties
{
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}