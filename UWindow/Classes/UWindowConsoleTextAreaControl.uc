//================================================================================
// UWindowConsoleTextAreaControl.
//================================================================================
class UWindowConsoleTextAreaControl expands UWindowTextAreaControl;

function Created ()
{
	bNoKeyboard=True;
	bCursor=True;
	Super.Created();
}