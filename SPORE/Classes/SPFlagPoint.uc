//================================================================================
// SPFlagPoint.
//================================================================================
class SPFlagPoint expands NavigationPoint;

function SpawnFlag ()
{
	Spawn(Class'SPFlag',self);
}