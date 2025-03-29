//================================================================================
// Counter.
//================================================================================
class Counter expands Triggers;

var() byte NumToCount;
var() bool bShowMessage;
var() localized string CountMessage;
var() localized string CompleteMessage;
var byte OriginalNum;

function BeginPlay ()
{
	OriginalNum=NumToCount;
}

function Reset ()
{
	NumToCount=OriginalNum;
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local string S;
	local string Num;
	local int i;
	local Actor A;

	if ( NumToCount > 0 )
	{
		if (  --NumToCount == 0 )
		{
			if ( bShowMessage && (CompleteMessage != "") )
			{
				EventInstigator.ClientMessage(CompleteMessage);
			}
			if ( Event != 'None' )
			{
				foreach AllActors(Class'Actor',A,Event)
				{
					A.Trigger(Other,EventInstigator);
				}
			}
		}
		else
		{
			if ( bShowMessage && (CountMessage != "") )
			{
				switch (NumToCount)
				{
					case 1:
					Num="one";
					break;
					case 2:
					Num="two";
					break;
					case 3:
					Num="three";
					break;
					case 4:
					Num="four";
					break;
					case 5:
					Num="five";
					break;
					case 6:
					Num="six";
					break;
					default:
					Num=string(NumToCount);
					break;
				}
				S=CountMessage;
JL0138:
				if ( InStr(S,"%i") >= 0 )
				{
					i=InStr(S,"%i");
					S=Left(S,i) $ Num $ Mid(S,i + 2);
					goto JL0138;
				}
				EventInstigator.ClientMessage(S);
			}
		}
	}
}

defaultproperties
{
    NumToCount=2
    CountMessage="Only %i more to go..."
    CompleteMessage="Completed!"
    Texture=Texture'S_Counter'
}