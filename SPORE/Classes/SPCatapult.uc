//================================================================================
// SPCatapult.
//================================================================================
class SPCatapult expands SPTrampoline;

auto state Coiled expands Coiled
{
	function Trigger (Actor Other, Pawn Instigator)
	{
		local Actor A;
	
		foreach AllActors(Class'Actor',A)
		{
			if ( A.Base == self )
			{
				Pending=A;
				SetTimer(0.01,False);
			}
		}
		SetTimer(0.01,False);
	}
	
}

defaultproperties
{
    JumpZ=2000.00
}