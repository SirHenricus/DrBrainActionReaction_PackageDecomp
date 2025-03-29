//================================================================================
// SPFlagGameInfo.
//================================================================================
class SPFlagGameInfo expands SPMultiPlayerGameInfo;

var int NumFlagPoints;
var int CurrentFlag;

function PostBeginPlay ()
{
	local SPFlagPoint FlagPoint;

	Super.PostBeginPlay();
	foreach AllActors(Class'SPFlagPoint',FlagPoint)
	{
		NumFlagPoints++;
	}
	foreach AllActors(Class'SPFlagPoint',FlagPoint)
	{
		CurrentFlag=1;
		FlagPoint.SpawnFlag();
		return;
	}
}

function SpawnFlag ()
{
	local int ChosenPoint;
	local int CurrentPoint;
	local SPFlagPoint FlagPoint;

	ChosenPoint=Rand(NumFlagPoints) + 1;
	if ( ChosenPoint == CurrentFlag )
	{
		ChosenPoint++;
		if ( ChosenPoint > NumFlagPoints )
		{
			ChosenPoint=1;
		}
	}
	foreach AllActors(Class'SPFlagPoint',FlagPoint)
	{
		CurrentPoint++;
		if ( CurrentPoint == ChosenPoint )
		{
			CurrentFlag=CurrentPoint;
			FlagPoint.SpawnFlag();
			return;
		}
	}
}

function bool PickupQuery (Pawn Other, Inventory Item)
{
	return True;
}

function MultiPlayerEndGame ()
{
	local SPFlag F;

	foreach AllActors(Class'SPFlag',F)
	{
		F.Destroy();
	}
	Super.MultiPlayerEndGame();
}