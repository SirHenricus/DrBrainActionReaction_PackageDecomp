//================================================================================
// SPScoreBoard.
//================================================================================
class SPScoreBoard expands ScoreBoard;

var() localized string RespawnString;
var string PlayerNames[16];
var string TeamNames[16];
var float Scores[16];
var byte Teams[16];
var int Pings[16];

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
		if ( Level.NetMode != 0 )
		{
			Canvas.DrawText(GRI.ServerName);
		}
		Canvas.SetPos(0.00,10.00 + YL);
		Canvas.DrawText(Level.Title,True);
		Canvas.bCenter=False;
	}
}

function DrawTrailer (Canvas Canvas)
{
	local int Hours;
	local int Minutes;
	local int Seconds;
	local string HourString;
	local string MinuteString;
	local string SecondString;
	local float XL;
	local float YL;

	Seconds=Level.TimeSeconds;
	Minutes=Seconds / 60;
	Hours=Minutes / 60;
	Seconds=Seconds - Minutes * 60;
	Minutes=Minutes - Hours * 60;
	if ( Seconds < 10 )
	{
		SecondString="0" $ string(Seconds);
	}
	else
	{
		SecondString=string(Seconds);
	}
	if ( Minutes < 10 )
	{
		MinuteString="0" $ string(Minutes);
	}
	else
	{
		MinuteString=string(Minutes);
	}
	if ( Hours < 10 )
	{
		HourString="0" $ string(Hours);
	}
	else
	{
		HourString=string(Hours);
	}
	Canvas.bCenter=True;
	Canvas.StrLen("Test",XL,YL);
	Canvas.SetPos(0.00,Canvas.ClipY - YL);
	Canvas.DrawText("Elapsed Time: " $ HourString $ ":" $ MinuteString $ ":" $ SecondString,True);
	Canvas.bCenter=False;
	if ( (Pawn(Owner) != None) && (Pawn(Owner).Health <= 0) )
	{
		Canvas.bCenter=True;
		Canvas.StrLen("Test",XL,YL);
		Canvas.SetPos(0.00,Canvas.ClipY - YL * 6);
		Canvas.DrawColor.R=0;
		Canvas.DrawColor.G=255;
		Canvas.DrawColor.B=0;
		Canvas.DrawText(RespawnString,True);
		Canvas.bCenter=False;
	}
}

function DrawName (Canvas C, int i, float XOffset, int LoopCount)
{
	local float xSize;
	local float ySize;

	C.StrLen("TEST",xSize,ySize);
	C.SetPos(C.ClipX / 4,32.00 + 2 * ySize + LoopCount * ySize);
	C.DrawText(PlayerNames[i],False);
}

function DrawPing (Canvas C, int i, float XOffset, int LoopCount)
{
	local float XL;
	local float YL;
	local float xSize;
	local float ySize;

	C.StrLen("TEST",xSize,ySize);
	if ( Level.NetMode == 0 )
	{
		return;
	}
	C.StrLen(string(Pings[i]),XL,YL);
	C.SetPos(C.ClipX / 4 - XL - 8,32.00 + 2 * ySize + LoopCount * ySize);
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	C.DrawText(string(Pings[i]),False);
	C.DrawColor.R=0;
	C.DrawColor.G=255;
	C.DrawColor.B=0;
}

function DrawScore (Canvas C, int i, float XOffset, int LoopCount)
{
	local float xSize;
	local float ySize;

	C.StrLen("TEST",xSize,ySize);
	C.SetPos(C.ClipX / 4 * 3,32.00 + 2 * ySize + LoopCount * ySize);
	if ( Scores[i] >= 100.00 )
	{
		C.CurX -= 6.00;
	}
	if ( Scores[i] >= 10.00 )
	{
		C.CurX -= 6.00;
	}
	if ( Scores[i] < 0.00 )
	{
		C.CurX -= 6.00;
	}
	C.DrawText(string(Scores[i]),False);
}

function Swap (int L, int R)
{
	local string TempPlayerName;
	local string TempTeamName;
	local float TempScore;
	local byte TempTeam;
	local int TempPing;

	TempPlayerName=PlayerNames[L];
	TempTeamName=TeamNames[L];
	TempScore=Scores[L];
	TempTeam=Teams[L];
	TempPing=Pings[L];
	PlayerNames[L]=PlayerNames[R];
	TeamNames[L]=TeamNames[R];
	Scores[L]=Scores[R];
	Teams[L]=Teams[R];
	Pings[L]=Pings[R];
	PlayerNames[R]=TempPlayerName;
	TeamNames[R]=TempTeamName;
	Scores[R]=TempScore;
	Teams[R]=TempTeam;
	Pings[R]=TempPing;
}

function SortScores (int N)
{
	local int i;
	local int j;
	local int Max;

	i=0;
JL0007:
	if ( i < N - 1 )
	{
		Max=i;
		j=i + 1;
JL0032:
		if ( j < N )
		{
			if ( Scores[j] > Scores[Max] )
			{
				Max=j;
			}
			j++;
			goto JL0032;
		}
		Swap(Max,i);
		i++;
		goto JL0007;
	}
}

function ShowScores (Canvas C)
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount;
	local int LoopCount;
	local int i;
	local float XL;
	local float YL;

	if ( C.ClipX >= 1000 )
	{
		C.Font=Font'SPLargeFont';
	}
	else
	{
		if ( C.ClipX >= 512 )
		{
			C.Font=Font'SPMediumFont';
		}
		else
		{
			C.Font=Font'SPSmallFont';
		}
	}
	i=0;
JL007B:
	if ( i < 16 )
	{
		Scores[i]=-500.00;
		i++;
		goto JL007B;
	}
	C.DrawColor.R=0;
	C.DrawColor.G=255;
	C.DrawColor.B=0;
	foreach AllActors(Class'PlayerReplicationInfo',PRI)
	{
		if (  !PRI.bIsSpectator )
		{
			PlayerNames[PlayerCount]=PRI.PlayerName;
			TeamNames[PlayerCount]=PRI.TeamName;
			Scores[PlayerCount]=PRI.Score;
			Teams[PlayerCount]=PRI.Team;
			Pings[PlayerCount]=PRI.Ping;
			PlayerCount++;
		}
	}
	SortScores(PlayerCount);
	LoopCount=0;
	i=0;
JL01AD:
	if ( i < PlayerCount )
	{
		DrawName(C,i,0.00,LoopCount);
		DrawPing(C,i,0.00,LoopCount);
		DrawScore(C,i,0.00,LoopCount);
		LoopCount++;
		i++;
		goto JL01AD;
	}
	DrawHeader(C);
	DrawTrailer(C);
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
}

defaultproperties
{
    RespawnString="They got you! Hit [FIRE] to start over"
}