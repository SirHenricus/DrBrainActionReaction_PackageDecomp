//================================================================================
// UBrowserRulesList.
//================================================================================
class UBrowserRulesList expands UWindowList;

var string Rule;
var string Value;
var int SortColumn;
var bool bDescending;

function SortByColumn (int Column)
{
	if ( SortColumn == Column )
	{
		bDescending= !bDescending;
	}
	else
	{
		SortColumn=Column;
		bDescending=False;
	}
	Sort();
}

function bool Compare (UWindowList t, UWindowList B)
{
	local bool bResult;
	local UBrowserRulesList RT;
	local UBrowserRulesList RB;

	if ( B == None )
	{
		return True;
	}
	if ( UBrowserRulesList(t).Rule < UBrowserRulesList(B).Rule )
	{
		bResult=True;
	}
	else
	{
		bResult=False;
	}
	if ( UBrowserRulesList(Sentinel).bDescending )
	{
		bResult= !bResult;
	}
	return bResult;
}

defaultproperties
{
    SortColumn=1
}