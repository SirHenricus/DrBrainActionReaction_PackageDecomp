//================================================================================
// RoundRobin.
//================================================================================
class RoundRobin expands Triggers;

var() name OutEvents[16];
var() bool bLoop;
var int i;

function Trigger (Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if ( OutEvents[i] != 'None' )
	{
		foreach AllActors(Class'Actor',A,OutEvents[i])
		{
			A.Trigger(self,EventInstigator);
		}
		if ( ( ++i >= 16) || (OutEvents[i] == 'None') )
		{
			if ( bLoop )
			{
				i=0;
			}
			else
			{
				SetCollision(False,False,False);
			}
		}
	}
}