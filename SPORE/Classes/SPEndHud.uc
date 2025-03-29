//================================================================================
// SPEndHud.
//================================================================================
class SPEndHud expands SPIntroHud
	config(User);

simulated event BeginPlay ()
{
	local int numNarrations;
	local int i;

	i=0;
JL0007:
	if ( i < 10 )
	{
		if ( Narration[i] != "" )
		{
			numNarrations++;
		}
		else
		{
			goto JL003C;
		}
		i++;
		goto JL0007;
	}
JL003C:
	bCopyrightDone=True;
	NarrationSpeed=15.00 / numNarrations;
	SetTimer(NarrationSpeed,True);
}

defaultproperties
{
    ESCMessage="Mission Completed"
    Narration(0)="Great work! You’ve escaped!"
    Narration(1)="The world is safe from the S.P.O.R.E. menace..."
    Narration(2)="For now..."
    Narration(3)=""
    Narration(4)=""
}