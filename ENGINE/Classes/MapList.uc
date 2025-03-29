//================================================================================
// MapList.
//================================================================================
class MapList expands Info;

var(Maps) config string Maps[32];
var config int MapNum;

function string GetNextMap ()
{
	local string CurrentMap;
	local int i;

	CurrentMap=GetURLMap();
	if ( CurrentMap != "" )
	{
		if ( Right(CurrentMap,4) ~= ".unr" )
		{
			CurrentMap=CurrentMap;
		}
		else
		{
			CurrentMap=CurrentMap $ ".unr";
		}
		i=0;
JL0051:
		if ( i < 32 )
		{
			if ( CurrentMap ~= Maps[i] )
			{
				MapNum=i;
			}
			else
			{
				i++;
				goto JL0051;
			}
		}
	}
	MapNum++;
	if ( MapNum > 32 - 1 )
	{
		MapNum=0;
	}
	if ( Maps[MapNum] == "" )
	{
		MapNum=0;
	}
	SaveConfig();
	return Maps[MapNum];
}