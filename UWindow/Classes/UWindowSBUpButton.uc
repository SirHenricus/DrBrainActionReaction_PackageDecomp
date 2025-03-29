//================================================================================
// UWindowSBUpButton.
//================================================================================
class UWindowSBUpButton expands UWindowButton;

var float NextClickTime;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
}

function BeforePaint (Canvas C, float X, float Y)
{
	LookAndFeel.SB_SetupUpButton(self);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	UWindowVScrollbar(ParentWindow).Scroll( -UWindowVScrollbar(ParentWindow).ScrollAmount);
	NextClickTime=GetLevel().TimeSeconds + 0.50;
}

function Tick (float Delta)
{
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetLevel().TimeSeconds) )
	{
		UWindowVScrollbar(ParentWindow).Scroll( -UWindowVScrollbar(ParentWindow).ScrollAmount);
		NextClickTime=GetLevel().TimeSeconds + 0.10;
	}
	if (  !bMouseDown )
	{
		NextClickTime=0.00;
	}
}