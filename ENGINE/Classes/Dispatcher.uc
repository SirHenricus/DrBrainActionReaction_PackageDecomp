//================================================================================
// Dispatcher.
//================================================================================
class Dispatcher expands Triggers;

var() name OutEvents[8];
var() float OutDelays[8];
var int i;

function Trigger (Actor Other, Pawn EventInstigator)
{
	Instigator=EventInstigator;
	GotoState('Dispatch');
}

state Dispatch
{
Begin:
	Disable('Trigger');
	i=0;
JL000E:
	if ( i < 8 )
	{
		if ( OutEvents[i] != 'None' )
		{
			Sleep(OutDelays[i]);
			foreach AllActors(Class'Actor',Target,OutEvents[i])
			{
				Target.Trigger(self,Instigator);
			}
		}
		i++;
		goto JL000E;
	}
	Enable('Trigger');
}

defaultproperties
{
    Texture=Texture'S_Dispatcher'
}