//================================================================================
// UWindowEditControl.
//================================================================================
class UWindowEditControl expands UWindowDialogControl;

var float EditBoxWidth;
var float EditAreaDrawX;
var float EditAreaDrawY;
var UWindowEditBox EditBox;

function Created ()
{
	local Color C;

	Super.Created();
	EditBox=UWindowEditBox(CreateWindow(Class'UWindowEditBox',0.00,0.00,WinWidth,WinHeight));
	EditBox.NotifyOwner=self;
	EditBox.bSelectOnFocus=True;
	EditBoxWidth=WinWidth / 2;
	SetEditTextColor(LookAndFeel.EditBoxTextColor);
}

function SetNumericOnly (bool bNumericOnly)
{
	EditBox.bNumericOnly=bNumericOnly;
}

function SetFont (int NewFont)
{
	Super.SetFont(NewFont);
	EditBox.SetFont(NewFont);
}

function SetEditTextColor (Color NewColor)
{
	EditBox.SetTextColor(NewColor);
}

function Clear ()
{
	EditBox.Clear();
}

function string GetValue ()
{
	return EditBox.GetValue();
}

function SetValue (string NewValue)
{
	EditBox.SetValue(NewValue);
}

function SetMaxLength (int MaxLength)
{
	EditBox.MaxLength=MaxLength;
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.Editbox_Draw(self,C);
	Super.Paint(C,X,Y);
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	LookAndFeel.Editbox_SetupSizes(self,C);
}

function SetDelayedNotify (bool bDelayedNotify)
{
	EditBox.bDelayedNotify=bDelayedNotify;
}