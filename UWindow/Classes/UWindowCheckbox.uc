//================================================================================
// UWindowCheckbox.
//================================================================================
class UWindowCheckbox expands UWindowButton;

var bool bChecked;

function BeforePaint (Canvas C, float X, float Y)
{
	LookAndFeel.Checkbox_SetupSizes(self,C);
	Super.BeforePaint(C,X,Y);
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.Checkbox_Draw(self,C);
	Super.Paint(C,X,Y);
}

function LMouseUp (float X, float Y)
{
	if (  !bDisabled )
	{
		bChecked= !bChecked;
		Notify(1);
	}
	Super.LMouseUp(X,Y);
}