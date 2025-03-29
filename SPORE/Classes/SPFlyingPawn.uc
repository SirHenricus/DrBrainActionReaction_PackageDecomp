//================================================================================
// SPFlyingPawn.
//================================================================================
class SPFlyingPawn expands Pawn
	abstract;

var() float CircleRadius;
var float Angle;
var Vector CircleCenter;
var() bool bCircle;
var() name defaultAnim;
var() float defaultAnimSpeed;
var() bool bMakesBubbles;
var(BubbleAmount) int minBubbles;
var(BubbleAmount) int maxBubbles;
var(BubbleDelay) int minBubbleDelay;
var(BubbleDelay) int maxBubbleDelay;
var Vector X;
var Vector Y;
var Vector Z;

function BeginPlay ()
{
	if ( bMakesBubbles )
	{
		SetTimer(minBubbleDelay + Rand(maxBubbleDelay - minBubbleDelay),False);
	}
}

function Timer ()
{
	local SPBubble B;
	local int numBubbles;
	local int i;

	numBubbles=minBubbles + Rand(maxBubbles - minBubbles);
	i=0;
JL0022:
	if ( i < numBubbles )
	{
		B=Spawn(Class'SPBubble');
		if ( B != None )
		{
			B.DrawScale=FRand() * 0.50 + 0.05;
		}
		i++;
		goto JL0022;
	}
	SetTimer(minBubbleDelay + Rand(maxBubbleDelay - minBubbleDelay),False);
}

auto state() Flying
{
Begin:
	SetPhysics(4);
	LoopAnim(defaultAnim,defaultAnimSpeed);
	if ( bCircle )
	{
		goto ('circle');
	}
	else
	{
		CircleCenter=Location;
		goto ('wander');
	}
circle:
	Angle += 1.05;
	Destination.X=CircleCenter.X - CircleRadius * Sin(Angle);
	Destination.Y=CircleCenter.Y + CircleRadius * Cos(Angle);
	Destination.Z=CircleCenter.Z + 30 * FRand() - 15;
	MoveTo(Destination);
	goto ('circle');
wander:
	Destination=CircleCenter + FRand() * CircleRadius * VRand();
	if ( Abs(Destination.Z - CircleCenter.Z) > 200 )
	{
		Destination.Z=CircleCenter.Z;
	}
	MoveTo(Destination);
	goto ('wander');
}

state() Wandering
{
Begin:
	SetPhysics(4);
	LoopAnim(defaultAnim,defaultAnimSpeed);
wander:
	if ( Rand(7) == 0 )
	{
		TurnTo(Location + vector(Rotation) * -100);
	}
	else
	{
		Destination=Location + vector(Rotation) * 200;
		MoveTo(Destination);
	}
	goto ('wander');
}

defaultproperties
{
    CircleRadius=500.00
    defaultAnimSpeed=1.00
    bMakesBubbles=True
    minBubbles=2
    maxBubbles=8
    minBubbleDelay=1
    maxBubbleDelay=6
    AirSpeed=300.00
    AccelRate=800.00
}