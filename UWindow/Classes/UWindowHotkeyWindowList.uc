//================================================================================
// UWindowHotkeyWindowList.
//================================================================================
class UWindowHotkeyWindowList expands UWindowList;

var UWindowWindow Window;

function UWindowHotkeyWindowList FindWindow (UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L=UWindowHotkeyWindowList(Next);
JL0010:
	if ( L != None )
	{
		if ( L.Window == W )
		{
			return L;
		}
		L=UWindowHotkeyWindowList(L.Next);
		goto JL0010;
	}
	return None;
}