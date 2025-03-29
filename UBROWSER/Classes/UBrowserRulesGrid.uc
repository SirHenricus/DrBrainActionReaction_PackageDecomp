//================================================================================
// UBrowserRulesGrid.
//================================================================================
class UBrowserRulesGrid expands UWindowGrid;

var localized string RuleText;
var localized string ValueText;

function Created ()
{
	Super.Created();
	RowHeight=12.00;
	AddColumn(RuleText,100.00);
	AddColumn(ValueText,200.00);
}

function PaintColumn (Canvas C, UWindowGridColumn Column, float MouseX, float MouseY)
{
	local UBrowserRulesList RulesList;
	local UBrowserRulesList L;
	local int Visible;
	local int Count;
	local int Skipped;
	local int Y;
	local int TopMargin;
	local int BottomMargin;

	if ( bShowHorizSB )
	{
		BottomMargin=LookAndFeel.Size_ScrollbarWidth;
	}
	else
	{
		BottomMargin=0;
	}
	TopMargin=LookAndFeel.ColumnHeadingHeight;
	RulesList=UBrowserInfoWindow(ParentWindow.ParentWindow.ParentWindow).Server.RulesList;
	if ( RulesList == None )
	{
		return;
	}
	Count=RulesList.Count();
	C.Font=Root.Fonts[0];
	Visible=(WinHeight - TopMargin + BottomMargin) / RowHeight;
	VertSB.SetRange(0.00,Count + 1,Visible);
	TopRow=VertSB.pos;
	Skipped=0;
	Y=1;
	L=UBrowserRulesList(RulesList.Next);
JL0132:
	if ( (Y < RowHeight + WinHeight - RowHeight - TopMargin + BottomMargin) && (L != None) )
	{
		if ( Skipped >= VertSB.pos )
		{
			switch (Column.ColumnNum)
			{
				case 0:
				Column.ClipText(C,2.00,Y + TopMargin,L.Rule);
				break;
				case 1:
				Column.ClipText(C,2.00,Y + TopMargin,L.Value);
				break;
				default:
			}
			Y=Y + RowHeight;
		}
		Skipped++;
		L=UBrowserRulesList(L.Next);
		goto JL0132;
	}
}

function RightClickRow (int Row, float X, float Y)
{
	local UBrowserInfoMenu Menu;
	local float MenuX;
	local float MenuY;

	Menu=UBrowserInfoWindow(GetParent(Class'UBrowserInfoWindow')).Menu;
	WindowToGlobal(X,Y,MenuX,MenuY);
	Menu.WinLeft=MenuX;
	Menu.WinTop=MenuY;
	Menu.ShowWindow();
}

function SortColumn (UWindowGridColumn Column)
{
	UBrowserInfoWindow(ParentWindow.ParentWindow.ParentWindow).Server.RulesList.SortByColumn(Column.ColumnNum);
}

function SelectRow (int Row)
{
}

defaultproperties
{
    RuleText="Rule"
    ValueText="Value"
}