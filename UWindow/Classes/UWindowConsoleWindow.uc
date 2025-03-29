//================================================================================
// UWindowConsoleWindow.
//================================================================================
class UWindowConsoleWindow expands UWindowFramedWindow;

var float OldParentWidth;
var float OldParentHeight;

function BeginPlay ()
{
	Super.BeginPlay();
	ClientClass=Class'UWindowConsoleClientWindow';
}

function Created ()
{
	Super.Created();
	bSizable=True;
	bStatusBar=True;
	bLeaveOnscreen=True;
	OldParentWidth=ParentWindow.WinWidth;
	OldParentHeight=ParentWindow.WinHeight;
	SetDimensions();
	SetAcceptsFocus();
}

function ShowWindow ()
{
	Super.ShowWindow();
	if ( (ParentWindow.WinWidth != OldParentWidth) || (ParentWindow.WinHeight != OldParentHeight) )
	{
		SetDimensions();
		OldParentWidth=ParentWindow.WinWidth;
		OldParentHeight=ParentWindow.WinHeight;
	}
}

function ResolutionChanged (float W, float H)
{
	SetDimensions();
}

function SetDimensions ()
{
	Log("Centering Console WIndow");
	if ( ParentWindow.WinWidth < 500 )
	{
		SetSize(200.00,150.00);
	}
	else
	{
		SetSize(410.00,310.00);
	}
	WinLeft=ParentWindow.WinWidth / 2 - WinWidth / 2;
	WinTop=ParentWindow.WinHeight / 2 - WinHeight / 2;
}

function KeyType (int Key, float MouseX, float MouseY)
{
	local WindowConsole Con;

	if ( (Key >= 32) && (Key < 128) && (Key != Asc("`")) && (Key != Asc("~")) )
	{
		Con=Root.Console;
		Con.TypedStr=Con.TypedStr $ Chr(Key);
	}
}

function KeyDown (int Key, float X, float Y)
{
	local string Temp;
	local WindowConsole Con;
	local PlayerPawn P;

	Con=Root.Console;
	P=GetPlayerOwner();
	switch (Key)
	{
		case P.27:
		if ( Con.TypedStr != "" )
		{
			Con.TypedStr="";
		}
		break;
		case P.13:
		if ( Con.TypedStr != "" )
		{
			Con.Message(None,"(> " $ Con.TypedStr,'Console');
			Con.UpdateHistory();
			Temp=Con.TypedStr;
			Con.TypedStr="";
			if (  !Con.ConsoleCommand(Temp) )
			{
				Con.Message(None,Localize('Errors','Exec','Core'),'Console');
			}
			Con.Message(None,"",'Console');
		}
		break;
		case P.38:
		Con.HistoryUp();
		break;
		case P.40:
		Con.HistoryDown();
		break;
		case P.8:
		case P.37:
		if ( Len(Con.TypedStr) > 0 )
		{
			Con.TypedStr=Left(Con.TypedStr,Len(Con.TypedStr) - 1);
		}
		break;
		default:
		break;
	}
}

function Close (optional bool bByParent)
{
	Root.Console.HideConsole();
}

defaultproperties
{
    WindowTitle="System Console"
}