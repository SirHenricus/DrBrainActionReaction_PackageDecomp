//================================================================================
// UBrowserServerGrid.
//================================================================================
class UBrowserServerGrid expands UWindowGrid;

var UBrowserRightClickMenu Menu;
var UWindowGridColumn Server;
var UWindowGridColumn Ping;
var UWindowGridColumn MapName;
var UWindowGridColumn Players;
var UWindowGridColumn SortByColumn;
var bool bSortDescending;
var localized string ServerName;
var localized string PingName;
var localized string MapNameName;
var localized string PlayersName;
var localized string PlayerCountName;
var localized string ServerCountName;
var int SelectServer;
var int Count;
var float TimePassed;
var int AutoPingInterval;
var UBrowserServerList OldPingServer;

function Created ()
{
	Super.Created();
	RowHeight=12.00;
	CreateColumns();
	Menu=UBrowserRightClickMenu(Root.CreateWindow(Class'UBrowserRightClickMenu',0.00,0.00,100.00,100.00));
	Menu.HideWindow();
}

function Close (optional bool bByParent)
{
	Super.Close(bByParent);
	if ( (Menu != None) && Menu.bWindowVisible )
	{
		Menu.HideWindow();
	}
}

function CreateColumns ()
{
	Server=AddColumn(ServerName,300.00);
	Ping=AddColumn(PingName,30.00);
	MapName=AddColumn(MapNameName,100.00);
	Players=AddColumn(PlayersName,50.00);
	SortByColumn=Ping;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local UBrowserServerList L;

	Super.BeforePaint(C,X,Y);
	L=UBrowserServerListWindow(ParentWindow).List;
	UBrowserMainWindow(GetParent(Class'UBrowserMainWindow')).DefaultStatusBarText(string(L.TotalServers) $ " " $ ServerCountName $ ", " $ string(L.TotalPlayers) $ " " $ PlayerCountName);
}

function PaintColumn (Canvas C, UWindowGridColumn Column, float MouseX, float MouseY)
{
	local UBrowserServerList List;
	local float Y;
	local int Visible;
	local int Skipped;
	local int TopMargin;
	local int BottomMargin;

	C.Font=Root.Fonts[0];
	List=UBrowserServerListWindow(ParentWindow).List;
	if ( List == None )
	{
		Count=0;
	}
	else
	{
		Count=List.Count();
	}
	if ( bShowHorizSB )
	{
		BottomMargin=LookAndFeel.Size_ScrollbarWidth;
	}
	else
	{
		BottomMargin=0;
	}
	TopMargin=LookAndFeel.ColumnHeadingHeight;
	Visible=(WinHeight - TopMargin + BottomMargin) / RowHeight;
	VertSB.SetRange(0.00,Count + 1,Visible);
	TopRow=VertSB.pos;
	Skipped=0;
	if ( List != None )
	{
		Y=1.00;
		List=UBrowserServerList(List.Next);
JL012E:
		if ( (Y < RowHeight + WinHeight - RowHeight - TopMargin + BottomMargin) && (List != None) )
		{
			if ( Skipped >= VertSB.pos )
			{
				if ( Skipped == SelectServer )
				{
					Column.DrawStretchedTexture(C,0.00,Y - 1 + TopMargin,Column.WinWidth,RowHeight + 1,Texture'Highlight');
				}
				if (! (MouseY >= Y + TopMargin) && (MouseY <= Y + RowHeight + TopMargin) && Column.MouseIsOver() ) goto JL0220;
JL0220:
				switch (Column)
				{
					case Server:
					Column.ClipText(C,2.00,Y + TopMargin,List.HostName);
					break;
					case Ping:
					Column.ClipText(C,2.00,Y + TopMargin,string(List.Ping));
					break;
					case MapName:
					Column.ClipText(C,2.00,Y + TopMargin,List.MapName);
					break;
					case Players:
					Column.ClipText(C,2.00,Y + TopMargin,string(List.NumPlayers) $ "/" $ string(List.MaxPlayers));
					break;
					default:
				}
				Y=Y + RowHeight;
			}
			Skipped++;
			List=UBrowserServerList(List.Next);
			goto JL012E;
		}
	}
}

function SortColumn (UWindowGridColumn Column)
{
	if ( SortByColumn == Column )
	{
		bSortDescending= !bSortDescending;
	}
	else
	{
		bSortDescending=False;
	}
	SortByColumn=Column;
	UBrowserServerListWindow(ParentWindow).List.Sort();
}

function Tick (float DeltaTime)
{
	local UBrowserServerList Server;

	TimePassed=TimePassed + DeltaTime;
	if ( TimePassed > AutoPingInterval )
	{
		TimePassed=0.00;
		Server=GetSelectedServer();
		if ( Server != OldPingServer )
		{
			if ( OldPingServer != None )
			{
				OldPingServer.CancelPing();
			}
			OldPingServer=Server;
		}
		if ( (Server != None) &&  !Server.bPinging )
		{
			Server.PingServer(False,True,True);
		}
	}
}

function SelectRow (int Row)
{
	if ( SelectServer != Row )
	{
		TimePassed=0.00;
	}
	if ( Row <= Count )
	{
		SelectServer=Row;
	}
}

function RightClickRow (int Row, float X, float Y)
{
	local float MenuX;
	local float MenuY;

	WindowToGlobal(X,Y,MenuX,MenuY);
	Menu.WinLeft=MenuX;
	Menu.WinTop=MenuY;
	if ( Row <= Count )
	{
		Menu.List=GetSelectedServer();
	}
	else
	{
		Menu.List=None;
	}
	Menu.Grid=self;
	Menu.ShowWindow();
}

function UBrowserServerList GetSelectedServer ()
{
	local int i;
	local UBrowserServerList List;

	List=UBrowserServerListWindow(ParentWindow).List;
	if ( List != None )
	{
		i=0;
		List=UBrowserServerList(List.Next);
JL0044:
		if ( List != None )
		{
			if ( i == SelectServer )
			{
				return List;
			}
			List=UBrowserServerList(List.Next);
			i++;
			goto JL0044;
		}
	}
	return None;
}

function DoubleClickRow (int Row)
{
	local UBrowserServerList Server;

	if ( SelectServer != Row )
	{
		return;
	}
	Server=GetSelectedServer();
	if ( (Server != None) && (Server.GamePort != 0) )
	{
		GetPlayerOwner().ClientTravel("unreal://" $ Server.IP $ ":" $ string(Server.GamePort) $ UBrowserServerListWindow(ParentWindow).URLAppend,0,False);
		GetParent(Class'UWindowFramedWindow').Close();
		Root.Console.CloseUWindow();
	}
}

function MouseLeaveColumn (UWindowGridColumn Column)
{
	ToolTip("");
}

function KeyDown (int Key, float X, float Y)
{
	switch (Key)
	{
		case 116:
		Refresh();
		break;
		case 38:
		SelectRow(Clamp(SelectServer - 1,0,Count - 1));
		VertSB.Show(SelectServer);
		break;
		case 40:
		SelectRow(Clamp(SelectServer + 1,0,Count - 1));
		VertSB.Show(SelectServer);
		break;
		case 13:
		DoubleClickRow(SelectServer);
		break;
		default:
		Super.KeyDown(Key,X,Y);
		break;
	}
}

function bool Compare (UBrowserServerList t, UBrowserServerList B)
{
	switch (SortByColumn)
	{
		case Server:
		return ByName(t,B);
		case Ping:
		return ByPing(t,B);
		case MapName:
		return ByMap(t,B);
		case Players:
		return ByPlayers(t,B);
		default:
	}
	return True;
}

function bool ByPing (UBrowserServerList t, UBrowserServerList B)
{
	local bool bResult;

	if ( B == None )
	{
		return True;
	}
	if ( t.Ping < B.Ping )
	{
		bResult=True;
	}
	else
	{
		if ( t.Ping > B.Ping )
		{
			bResult=False;
		}
		else
		{
			bResult=t.HostName < B.HostName;
		}
	}
	if ( bSortDescending )
	{
		bResult= !bResult;
	}
	return bResult;
}

function bool ByName (UBrowserServerList t, UBrowserServerList B)
{
	local bool bResult;

	if ( B == None )
	{
		return True;
	}
	if ( t.Ping == 9999 )
	{
		return False;
	}
	if ( B.Ping == 9999 )
	{
		return True;
	}
	if ( t.HostName < B.HostName )
	{
		bResult=True;
	}
	else
	{
		if ( t.HostName > B.HostName )
		{
			bResult=False;
		}
		else
		{
			return t.Ping < B.Ping;
		}
	}
	if ( bSortDescending )
	{
		bResult= !bResult;
	}
	return bResult;
}

function bool ByMap (UBrowserServerList t, UBrowserServerList B)
{
	local bool bResult;

	if ( B == None )
	{
		return True;
	}
	if ( t.Ping == 9999 )
	{
		return False;
	}
	if ( B.Ping == 9999 )
	{
		return True;
	}
	if ( t.MapName < B.MapName )
	{
		bResult=True;
	}
	else
	{
		if ( t.MapName > B.MapName )
		{
			bResult=False;
		}
		else
		{
			return t.Ping < B.Ping;
		}
	}
	if ( bSortDescending )
	{
		bResult= !bResult;
	}
	return bResult;
}

function bool ByPlayers (UBrowserServerList t, UBrowserServerList B)
{
	local bool bResult;

	if ( B == None )
	{
		return True;
	}
	if ( t.Ping == 9999 )
	{
		return False;
	}
	if ( B.Ping == 9999 )
	{
		return True;
	}
	if ( t.NumPlayers > B.NumPlayers )
	{
		bResult=True;
	}
	else
	{
		if ( t.NumPlayers < B.NumPlayers )
		{
			bResult=False;
		}
		else
		{
			if ( t.MaxPlayers > B.MaxPlayers )
			{
				bResult=True;
			}
			else
			{
				if ( t.MaxPlayers < B.MaxPlayers )
				{
					bResult=False;
				}
				else
				{
					return t.Ping < B.Ping;
				}
			}
		}
	}
	if ( bSortDescending )
	{
		bResult= !bResult;
	}
	return bResult;
}

function ShowInfo (UBrowserServerList List)
{
	local UBrowserInfoWindow InfoWindow;

	InfoWindow=UBrowserInfoWindow(Root.FindChildWindow(Class'UBrowserInfoWindow'));
	if ( Server == None )
	{
		return;
	}
	if ( InfoWindow == None )
	{
		InfoWindow=UBrowserInfoWindow(Root.CreateWindow(Class'UBrowserInfoWindow',10.00,40.00,310.00,170.00));
		InfoWindow.BringToFront();
	}
	else
	{
		InfoWindow.BringToFront();
	}
	InfoWindow.Server=List;
	InfoWindow.WindowTitle="Info - " $ List.HostName;
	List.ServerStatus();
}

function Refresh ()
{
	UBrowserServerListWindow(ParentWindow).Refresh();
}

defaultproperties
{
    ServerName="Server"
    PingName="Ping"
    MapNameName="Map Name"
    PlayersName="Players"
    PlayerCountName="Players"
    ServerCountName="Servers"
    AutoPingInterval=5
}