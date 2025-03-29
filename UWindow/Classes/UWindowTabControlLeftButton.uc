//================================================================================
// UWindowTabControlLeftButton.
//================================================================================
class UWindowTabControlLeftButton expands UWindowButton;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
}

function BeforePaint (Canvas C, float X, float Y)
{
	LookAndFeel.Tab_SetupLeftButton(self);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	UWindowTabControl(ParentWindow).TabArea.TabOffset--;
}