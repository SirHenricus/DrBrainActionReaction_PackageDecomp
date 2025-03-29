//================================================================================
// UWindowFrameCloseBox.
//================================================================================
class UWindowFrameCloseBox expands UWindowButton;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
}

function Click (float X, float Y)
{
	ParentWindow.Close();
}

function KeyDown (int Key, float X, float Y)
{
}