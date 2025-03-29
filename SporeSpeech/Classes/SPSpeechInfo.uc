//================================================================================
// SPSpeechInfo.
//================================================================================
class SPSpeechInfo expands Actor;

var() Lips Data[1000];
struct Lips
{
	var() int frame;
	var() float Time;
};


function int GetFrame (int whichLip)
{
	return Data[whichLip].frame;
}

function float GetTime (int whichLip)
{
	return Data[whichLip].Time;
}

defaultproperties
{
    bHidden=True
}