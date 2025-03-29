//================================================================================
// SPEarthquake.
//================================================================================
class SPEarthquake expands Keypoint;

var() float magnitude;
var() float duration;
var() float Radius;
var() bool bThrowPlayer;
var float RemainingTime;

function Trigger (Actor Other, Pawn EventInstigator)
{
	local Pawn P;
	local Vector throwVect;

	if ( bThrowPlayer )
	{
		throwVect=0.18 * magnitude * VRand();
		throwVect.Z=FMax(Abs(throwVect.Z),120.00);
	}
	P=Level.PawnList;
JL0051:
	if ( P != None )
	{
		if ( (PlayerPawn(P) != None) && (VSize(Location - P.Location) < Radius) )
		{
			if ( bThrowPlayer && (P.Physics != 2) )
			{
				P.AddVelocity(throwVect);
			}
			PlayerPawn(P).ShakeView(duration,magnitude,0.01 * magnitude);
		}
		P=P.nextPawn;
		goto JL0051;
	}
	if ( bThrowPlayer && (duration > 0.50) )
	{
		RemainingTime=duration;
		SetTimer(0.50,False);
	}
}

function Timer ()
{
	local Vector throwVect;
	local Pawn P;

	RemainingTime -= 0.50;
	throwVect=0.15 * magnitude * VRand();
	throwVect.Z=FMax(Abs(throwVect.Z),120.00);
	P=Level.PawnList;
JL0054:
	if ( P != None )
	{
		if ( (PlayerPawn(P) != None) && (VSize(Location - P.Location) < Radius) )
		{
			if ( P.Physics != 2 )
			{
				P.AddVelocity(throwVect);
			}
			P.BaseEyeHeight=FMin(P.Default.BaseEyeHeight,P.BaseEyeHeight * (0.50 + FRand()));
			PlayerPawn(P).ShakeView(RemainingTime,magnitude,0.01 * magnitude);
		}
		P=P.nextPawn;
		goto JL0054;
	}
	if ( RemainingTime > 0.50 )
	{
		SetTimer(0.50,False);
	}
}

defaultproperties
{
    magnitude=2000.00
    duration=5.00
    Radius=300.00
    bStatic=False
}