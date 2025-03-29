//================================================================================
// UWindowListControl.
//================================================================================
class UWindowListControl expands UWindowDialogControl;

var Class<UWindowList> ListClass;
var UWindowList Items;

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
}

function Created ()
{
	Super.Created();
	Items=new (,ListClass);
	Items.Last=Items;
	Items.Next=None;
	Items.Prev=None;
	Items.Sentinel=Items;
}