//================================================================================
// SPDelayedCommand.
//================================================================================
class SPDelayedCommand expands SPActor;

var PlayerPawn Player;
var string Command;

function Initialize (PlayerPawn P, string com, float Delay)
{
	if ( (P == None) || (Delay <= 0) )
	{
		Log(string(self) $ "::Initialize <ERROR> Bad Arguments! Player=" $ string(Player) $ ", Delay=" $ string(Delay));
		Destroy();
		return;
	}
	Player=P;
	Command=com;
	SetTimer(Delay,False);
}

event Timer ()
{
	Player.ConsoleCommand(Command);
	Destroy();
}

defaultproperties
{
    bHidden=True
}