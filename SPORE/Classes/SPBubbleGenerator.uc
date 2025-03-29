//================================================================================
// SPBubbleGenerator.
//================================================================================
class SPBubbleGenerator expands Effects;

var(BubbleAmount) int minBubbles;
var(BubbleAmount) int maxBubbles;
var(BubbleDelay) int minBubbleDelay;
var(BubbleDelay) int maxBubbleDelay;
var() int dispersionRadius;
var() Class<Effects> BubbleType;
var() float BubbleLifeSpan;

function BeginPlay ()
{
	if ( BubbleType != None )
	{
		SetTimer(minBubbleDelay + Rand(maxBubbleDelay - minBubbleDelay),False);
	}
}

function Timer ()
{
	local Effects B;
	local int numBubbles;
	local int i;
	local Vector Loc;

	numBubbles=minBubbles + Rand(maxBubbles - minBubbles);
	i=0;
JL0022:
	if ( i < numBubbles )
	{
		Loc=Location;
		Loc.X += Rand(dispersionRadius * 2) - dispersionRadius;
		Loc.Y += Rand(dispersionRadius * 2) - dispersionRadius;
		B=Spawn(BubbleType,Owner,'None',Loc);
		if ( B != None )
		{
			B.DrawScale=FRand() * 0.50 + 0.05;
			B.LifeSpan=BubbleLifeSpan;
		}
		i++;
		goto JL0022;
	}
	SetTimer(minBubbleDelay + Rand(maxBubbleDelay - minBubbleDelay),False);
}

defaultproperties
{
    minBubbles=5
    maxBubbles=15
    minBubbleDelay=3
    maxBubbleDelay=15
    dispersionRadius=50
    BubbleType=Class'SPBubble'
    bHidden=True
    DrawType=DT_Sprite
}