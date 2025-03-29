//================================================================================
// UWindowTabControlItem.
//================================================================================
class UWindowTabControlItem expands UWindowList;

var string Caption;
var string HelpText;
var UWindowTabControl Owner;
var float TabLeft;
var float TabWidth;
var float TabHeight;

function SetCaption (string NewCaption)
{
	Caption=NewCaption;
}