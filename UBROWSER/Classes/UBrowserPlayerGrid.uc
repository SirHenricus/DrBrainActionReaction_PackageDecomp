//================================================================================
// UBrowserPlayerGrid.
//================================================================================
class UBrowserPlayerGrid expands UWindowGrid;

var localized string NameText;
var localized string FragsText;
var localized string PingText;
var localized string TeamText;
var localized string MeshText;
var localized string SkinText;
var localized string IDText;

function Created ()
{
	Super.Created();
	RowHeight=12.00;
	AddColumn(NameText,60.00);
	AddColumn(FragsText,30.00);
	AddColumn(PingText,30.00);
	AddColumn(TeamText,30.00);
	AddColumn(MeshText,50.00);
	AddColumn(SkinText,60.00);
	AddColumn(IDText,30.00);
}

function PaintColumn (Canvas C, UWindowGridColumn Column, float MouseX, float MouseY)
{
	local UBrowserPlayerList PlayerList;
	local UBrowserPlayerList L;
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
	PlayerList=UBrowserInfoWindow(ParentWindow.ParentWindow.ParentWindow).Server.PlayerList;
	if ( PlayerList == None )
	{
		return;
	}
	Count=PlayerList.Count();
	C.Font=Root.Fonts[0];
	Visible=(WinHeight - TopMargin + BottomMargin) / RowHeight;
	VertSB.SetRange(0.00,Count + 1,Visible);
	TopRow=VertSB.pos;
	Skipped=0;
	Y=1;
	L=UBrowserPlayerList(PlayerList.Next);
JL0132:
	if ( (Y < RowHeight + WinHeight - RowHeight - TopMargin + BottomMargin) && (L != None) )
	{
		if ( Skipped >= VertSB.pos )
		{
			switch (Column.ColumnNum)
			{
				case 0:
				Column.ClipText(C,2.00,Y + TopMargin,L.PlayerName);
				break;
				case 1:
				Column.ClipText(C,2.00,Y + TopMargin,string(L.PlayerFrags));
				break;
				case 2:
				Column.ClipText(C,2.00,Y + TopMargin,string(L.PlayerPing));
				break;
				case 3:
				Column.ClipText(C,2.00,Y + TopMargin,L.PlayerTeam);
				break;
				case 4:
				Column.ClipText(C,2.00,Y + TopMargin,L.PlayerMesh);
				break;
				case 5:
				Column.ClipText(C,2.00,Y + TopMargin,L.PlayerSkin);
				break;
				case 6:
				Column.ClipText(C,2.00,Y + TopMargin,string(L.PlayerID));
				break;
				default:
			}
			Y=Y + RowHeight;
		}
		Skipped++;
		L=UBrowserPlayerList(L.Next);
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
	UBrowserInfoWindow(ParentWindow.ParentWindow.ParentWindow).Server.PlayerList.SortByColumn(Column.ColumnNum);
}

function SelectRow (int Row)
{
}

defaultproperties
{
    NameText="Name"
    FragsText="Frags"
    PingText="Ping"
    TeamText="Team"
    MeshText="Mesh"
    SkinText="Skin"
    IDText="ID"
}