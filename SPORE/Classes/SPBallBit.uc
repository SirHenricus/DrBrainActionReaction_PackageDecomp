//================================================================================
// SPBallBit.
//================================================================================
class SPBallBit expands SPActor
	abstract;

var() float TotalLifeSpan;
var() float RealDrawScale;

function SetLifeSpan (float t)
{
	TotalLifeSpan=t;
	LifeSpan=t;
}

function SetDrawScale (float S)
{
	RealDrawScale=S;
	DrawScale=S;
}

event Tick (float t)
{
	DrawScale=RealDrawScale * LifeSpan / TotalLifeSpan;
}

defaultproperties
{
    Physics=PHYS_Walking
    RemoteRole=ROLE_None
    DrawType=DT_Sprite
}