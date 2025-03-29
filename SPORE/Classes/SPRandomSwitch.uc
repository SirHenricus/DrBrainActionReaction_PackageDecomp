//================================================================================
// SPRandomSwitch.
//================================================================================
class SPRandomSwitch expands SPSwitch1;

var() int MinDelay;
var() int MaxDelay;

event BeginPlay ()
{
	Super.BeginPlay();
	SetTimer(MinDelay + Rand(MaxDelay - MinDelay),False);
}

event Timer ()
{
	ActivateStuff();
	SetTimer(MinDelay + Rand(MaxDelay - MinDelay),False);
}

defaultproperties
{
    MinDelay=1
    MaxDelay=10
    bHidden=True
    bCollideActors=False
    bBlockActors=False
    bBlockPlayers=False
}