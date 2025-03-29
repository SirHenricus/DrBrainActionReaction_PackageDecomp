//================================================================================
// SPDroneReceptor.
//================================================================================
class SPDroneReceptor expands SPBallReceptor;

event Touch (Actor Other)
{
	local SPDrone drone;
	local SPPlayer P;

	drone=SPDrone(Other);
	if ( drone == None )
	{
		return;
	}
	foreach AllActors(Class'SPPlayer',P)
	{
		goto JL0031;
	}
	if ( (Color == 6) || (drone.Color == Color) )
	{
		drone.Destroy();
		AmountIn++;
		if ( AmountIn == Capacity )
		{
			Filled();
		}
		if ( P != None )
		{
			P.PlaySound(SuccessSound,5);
		}
		if ( bReplaceCaptured )
		{
			FireMyTurret();
		}
	}
}