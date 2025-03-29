//================================================================================
// UBrowserServerListWindow.
//================================================================================
class UBrowserServerListWindow expands UWindowPageWindow;

var UBrowserServerList List;
var string ListFactories[10];
var UBrowserServerListFactory Factories[10];
var int QueryDone[10];
var UBrowserServerGrid Grid;
var string GridClass;
var string URLAppend;
var float TimeElapsed;
var int AutoRefreshTime;
var bool bPingSuspend;
var bool bPingResume;
var bool bPingResumeIntial;
var bool bSuspendPingOnClose;
var UBrowserSubsetList SubsetList;
var UBrowserSupersetList SupersetList;

function WindowShown ()
{
	local UBrowserSupersetList L;

	Super.WindowShown();
	ResumePinging();
	L=UBrowserSupersetList(SupersetList.Next);
JL0025:
	if ( L != None )
	{
		L.SupersetWindow.ResumePinging();
		L=UBrowserSupersetList(L.Next);
		goto JL0025;
	}
}

function WindowHidden ()
{
	local UBrowserSupersetList L;

	Super.WindowHidden();
	SuspendPinging();
	L=UBrowserSupersetList(SupersetList.Next);
JL0025:
	if ( L != None )
	{
		L.SupersetWindow.SuspendPinging();
		L=UBrowserSupersetList(L.Next);
		goto JL0025;
	}
}

function SuspendPinging ()
{
	if ( bSuspendPingOnClose )
	{
		bPingSuspend=True;
	}
}

function ResumePinging ()
{
	bPingSuspend=False;
	if ( bPingResume )
	{
		bPingResume=False;
		List.PingNext(bPingResumeIntial);
	}
}

function Created ()
{
	local Class<UBrowserServerGrid> C;

	C=Class<UBrowserServerGrid>(DynamicLoadObject(GridClass,Class'Class'));
	Grid=UBrowserServerGrid(CreateWindow(C,0.00,0.00,WinWidth,WinHeight));
	SubsetList=new (,Class'UBrowserSubsetList');
	SubsetList.SetupSentinel();
	SupersetList=new (,Class'UBrowserSupersetList');
	SupersetList.SetupSentinel();
}

function AddSubset (UBrowserSubsetFact Subset)
{
	local UBrowserSubsetList L;

	L=UBrowserSubsetList(SubsetList.Next);
JL0019:
	if ( L != None )
	{
		if ( L.SubsetFactory == Subset )
		{
			return;
		}
		L=UBrowserSubsetList(L.Next);
		goto JL0019;
	}
	L=UBrowserSubsetList(SubsetList.Append(Class'UBrowserSubsetList'));
	L.SubsetFactory=Subset;
}

function AddSuperSet (UBrowserServerListWindow Superset)
{
	local UBrowserSupersetList L;

	L=UBrowserSupersetList(SupersetList.Next);
JL0019:
	if ( L != None )
	{
		if ( L.SupersetWindow == Superset )
		{
			return;
		}
		L=UBrowserSupersetList(L.Next);
		goto JL0019;
	}
	L=UBrowserSupersetList(SupersetList.Append(Class'UBrowserSupersetList'));
	L.SupersetWindow=Superset;
}

function RemoveSubset (UBrowserSubsetFact Subset)
{
	local UBrowserSubsetList L;

	L=UBrowserSubsetList(SubsetList.Next);
JL0019:
	if ( L != None )
	{
		if ( L.SubsetFactory == Subset )
		{
			L.Remove();
		}
		L=UBrowserSubsetList(L.Next);
		goto JL0019;
	}
}

function RemoveSuperset (UBrowserServerListWindow Superset)
{
	local UBrowserSupersetList L;

	L=UBrowserSupersetList(SupersetList.Next);
JL0019:
	if ( L != None )
	{
		if ( L.SupersetWindow == Superset )
		{
			L.Remove();
		}
		L=UBrowserSupersetList(L.Next);
		goto JL0019;
	}
}

function AddFavorite (UBrowserServerList Server)
{
	UBrowserServerListWindow(UBrowserMainClientWindow(GetParent(Class'UBrowserMainClientWindow')).Favorites.Page).AddFavorite(Server);
}

function Refresh (optional bool bBySuperset, optional bool bInitial)
{
	local UBrowserSubsetList L;
	local UBrowserSubsetList NextSubset;

	if ( List != None )
	{
		List.DestroyList();
		List=None;
	}
	List=new (,Class'UBrowserServerList');
	List.Owner=self;
	List.SetupSentinel();
	ShutdownFactories(bBySuperset);
	CreateFactories();
	Query(bBySuperset,bInitial);
	if (  !bInitial )
	{
		L=UBrowserSubsetList(SubsetList.Next);
JL0097:
		if ( L != None )
		{
			L.bOldElement=True;
			L=UBrowserSubsetList(L.Next);
			goto JL0097;
		}
		L=UBrowserSubsetList(SubsetList.Next);
JL00E8:
		if ( (L != None) && L.bOldElement )
		{
			NextSubset=UBrowserSubsetList(L.Next);
			UBrowserServerListWindow(L.SubsetFactory.Owner.Owner).Refresh(True);
			L=NextSubset;
			goto JL00E8;
		}
	}
}

function Resized ()
{
	Super.Resized();
	Grid.SetSize(WinWidth,WinHeight);
}

function QueryFinished (UBrowserServerListFactory Fact, bool bSuccess, optional string ErrorMsg)
{
	local int i;
	local bool bDone;

	bDone=True;
	i=0;
JL000F:
	if ( i < 10 )
	{
		if ( Factories[i] == None )
		{
			goto JL0074;
		}
		if ( Factories[i] == Fact )
		{
			QueryDone[i]=1;
		}
		if ( QueryDone[i] == 0 )
		{
			bDone=False;
		}
		i++;
		goto JL000F;
	}
JL0074:
	if ( bDone )
	{
		List.Sort();
		List.PingServers(True);
	}
}

function CreateFactories ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 10 )
	{
		if ( ListFactories[i] == "" )
		{
			goto JL007B;
		}
		Factories[i]=UBrowserServerListFactory(BuildObjectWithProperties(ListFactories[i]));
		Factories[i].Owner=List;
		QueryDone[i]=0;
		i++;
		goto JL0007;
	}
JL007B:
}

function ShutdownFactories (optional bool bBySuperset)
{
	local int i;

	i=0;
JL0007:
	if ( i < 10 )
	{
		if ( Factories[i] != None )
		{
			Factories[i].Shutdown(bBySuperset);
			Factories[i]=None;
		}
		i++;
		goto JL0007;
	}
}

function Query (optional bool bBySuperset, optional bool bInitial)
{
	local int i;

	i=0;
JL0007:
	if ( i < 10 )
	{
		if ( Factories[i] == None )
		{
			goto JL0052;
		}
		Factories[i].Query(bBySuperset,bInitial);
		i++;
		goto JL0007;
	}
JL0052:
}

function Paint (Canvas C, float X, float Y)
{
	DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'BlackTexture');
}

function Tick (float Delta)
{
	if ( List.bNeedUpdateCount )
	{
		List.UpdateServerCount();
		List.bNeedUpdateCount=False;
	}
	if ( AutoRefreshTime > 0 )
	{
		TimeElapsed += Delta;
		if ( TimeElapsed > AutoRefreshTime )
		{
			TimeElapsed=0.00;
			Refresh();
		}
	}
}

defaultproperties
{
    GridClass="UBrowser.UBrowserServerGrid"
    bSuspendPingOnClose=True
}