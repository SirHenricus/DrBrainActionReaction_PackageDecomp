//================================================================================
// UWindowDialogClientWindow.
//================================================================================
class UWindowDialogClientWindow expands UWindowClientWindow;

var float DesiredWidth;
var float DesiredHeight;
var UWindowDialogControl TabLast;

function OKPressed ()
{
}

function Notify (UWindowDialogControl C, byte E)
{
}

function UWindowDialogControl CreateControl (Class<UWindowDialogControl> ControlClass, float X, float Y, float W, float H)
{
	local UWindowDialogControl C;

	C=UWindowDialogControl(CreateWindow(ControlClass,X,Y,W,H));
	C.Register(self);
	C.Notify(C.0);
	if ( TabLast == None )
	{
		TabLast=C;
		C.TabNext=C;
		C.TabPrev=C;
	}
	else
	{
		C.TabNext=TabLast.TabNext;
		C.TabPrev=TabLast;
		TabLast.TabNext.TabPrev=C;
		TabLast.TabNext=C;
		TabLast=C;
	}
	return C;
}

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	LookAndFeel.DrawClientArea(self,C);
}

function GetDesiredDimensions (out float W, out float H)
{
	W=DesiredWidth;
	H=DesiredHeight;
}