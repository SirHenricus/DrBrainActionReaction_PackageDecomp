//================================================================================
// UWindowComboListItem.
//================================================================================
class UWindowComboListItem expands UWindowList;

var string Value;
var string Value2;
var int SortWeight;
var float ItemTop;

function bool Compare (UWindowList t, UWindowList B)
{
	local UWindowComboListItem TI;
	local UWindowComboListItem BI;

	TI=UWindowComboListItem(t);
	BI=UWindowComboListItem(B);
	if ( TI.SortWeight == BI.SortWeight )
	{
		return Caps(TI.Value) < Caps(BI.Value);
	}
	else
	{
		return TI.SortWeight < BI.SortWeight;
	}
}