//================================================================================
// SPGameOverScoreBoard.
//================================================================================
class SPGameOverScoreBoard expands SPScoreBoard;

var() localized string GameOverText;
var() localized string TimeIsUpText;
var() localized string WinnerText;
var() localized string TieText;

function DrawHeader (Canvas Canvas)
{
	local GameReplicationInfo GRI;
	local float XL;
	local float YL;

	foreach AllActors(Class'GameReplicationInfo',GRI)
	{
		Canvas.bCenter=True;
		Canvas.SetPos(0.00,10.00);
		Canvas.StrLen("TEST",XL,YL);
		Canvas.DrawText(GameOverText);
		Canvas.bCenter=False;
	}
}

function DrawTrailer (Canvas Canvas)
{
	local float XL;
	local float YL;

	Canvas.bCenter=True;
	Canvas.StrLen("Test",XL,YL);
	Canvas.SetPos(0.00,Canvas.ClipY - YL);
	Canvas.DrawText(TimeIsUpText,True);
	Canvas.bCenter=False;
}

defaultproperties
{
    GameOverText="Game Over"
    TimeIsUpText="Time is Up"
    WinnerText="Winner: "
    TieText="It's a Tie!"
}