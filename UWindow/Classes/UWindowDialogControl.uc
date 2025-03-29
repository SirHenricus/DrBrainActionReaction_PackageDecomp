//================================================================================
// UWindowDialogControl.
//================================================================================
class UWindowDialogControl expands UWindowWindow;

var UWindowDialogClientWindow NotifyWindow;
var string Text;
var int Font;
var Color TextColor;
var TextAlign Align;
var float TextX;
var float TextY;
var bool bHasKeyboardFocus;
var bool bNoKeyboard;
var bool bAcceptExternalDragDrop;
var string HelpText;
var float MinWidth;
var float MinHeight;
var UWindowDialogControl TabNext;
var UWindowDialogControl TabPrev;

function Created ()
{
	if (  !bNoKeyboard )
	{
		SetAcceptsFocus();
	}
}

function KeyFocusEnter ()
{
	Super.KeyFocusEnter();
	bHasKeyboardFocus=True;
}

function KeyFocusExit ()
{
	Super.KeyFocusExit();
	bHasKeyboardFocus=False;
}

function SetHelpText (string NewHelpText)
{
	HelpText=NewHelpText;
}

function SetText (string NewText)
{
	Text=NewText;
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	C.Font=Root.Fonts[Font];
}

function SetFont (int NewFont)
{
	Font=NewFont;
}

function SetTextColor (Color NewColor)
{
	TextColor=NewColor;
}

function Register (UWindowDialogClientWindow W)
{
	NotifyWindow=W;
	Notify(0);
}

function Notify (byte E)
{
	if ( NotifyWindow != None )
	{
		NotifyWindow.Notify(self,E);
	}
}

function bool ExternalDragOver (UWindowDialogControl ExternalControl, float X, float Y)
{
	return False;
}

function UWindowDialogControl CheckExternalDrag (float X, float Y)
{
	local float RootX;
	local float RootY;
	local float ExtX;
	local float ExtY;
	local UWindowWindow W;
	local UWindowDialogControl C;

	WindowToGlobal(X,Y,RootX,RootY);
	W=Root.FindWindowUnder(RootX,RootY);
	C=UWindowDialogControl(W);
	if ( (W != self) && (C != None) && C.bAcceptExternalDragDrop )
	{
		W.GlobalToWindow(RootX,RootY,ExtX,ExtY);
		if ( C.ExternalDragOver(self,ExtX,ExtY) )
		{
			return C;
		}
	}
	return None;
}

function KeyDown (int Key, float X, float Y)
{
	local PlayerPawn P;
	local UWindowDialogControl N;

	P=Root.GetPlayerOwner();
	switch (Key)
	{
		case P.9:
		if ( TabNext != None )
		{
			N=TabNext;
JL0041:
			if ( (N != self) &&  !N.bWindowVisible )
			{
				N=N.TabNext;
				goto JL0041;
			}
			N.ActivateWindow(0,False);
		}
		break;
		default:
		Super.KeyDown(Key,X,Y);
		break;
	}
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	Notify(8);
}

function MouseLeave ()
{
	Super.MouseLeave();
	Notify(9);
}