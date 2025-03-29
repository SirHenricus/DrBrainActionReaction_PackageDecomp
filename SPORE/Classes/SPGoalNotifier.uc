//================================================================================
// SPGoalNotifier.
//================================================================================
class SPGoalNotifier expands SPActor;

event Touch (Actor Other)
{
	local SPConsole C;

	if ( SPPlayer(Other) != None )
	{
		SPPlayer(Other).MarkLevelFinished();
		C=SPConsole(SPPlayer(Other).Player.Console);
		if ( C != None )
		{
			C.NextLevel=SPPlayer(Other).FindNextLevelName();
		}
	}
}

defaultproperties
{
    bHidden=True
    CollisionRadius=100.00
    CollisionHeight=100.00
    bCollideActors=True
}