//================================================================================
// SPTimedSwitch.
//================================================================================
class SPTimedSwitch expands SPSwitch1;

var() float Delay;

event BeginPlay ()
{
	Super.BeginPlay();
	SetTimer(Delay,True);
}

event Timer ()
{
	ActivateStuff();
}

defaultproperties
{
    Delay=2.00
    bHidden=True
    bCollideActors=False
    bBlockActors=False
    bBlockPlayers=False
}