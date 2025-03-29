//================================================================================
// InterpolationPoint.
//================================================================================
class InterpolationPoint expands Keypoint
	native;

var() int Position;
var() float RateModifier;
var() float GameSpeedModifier;
var() float FovModifier;
var() bool bEndOfPath;
var() bool bSkipNextPath;
var() float ScreenFlashScale;
var() Vector ScreenFlashFog;
var InterpolationPoint Prev;
var InterpolationPoint Next;

function BeginPlay ()
{
	Super.BeginPlay();
	foreach AllActors(Class'InterpolationPoint',Prev,Tag)
	{
		if ( Prev.Position == Position - 1 )
		{
			goto JL003A;
		}
	}
	if ( Prev != None )
	{
		Prev.Next=self;
	}
	foreach AllActors(Class'InterpolationPoint',Next,Tag)
	{
		if ( Next.Position == Position + 1 )
		{
			goto JL008A;
		}
	}
	if ( Next == None )
	{
		foreach AllActors(Class'InterpolationPoint',Next,Tag)
		{
			if ( Next.Position == 0 )
			{
				goto JL00C3;
			}
		}
JL00C3:
	}
	if ( Next != None )
	{
		Next.Prev=self;
	}
}

function PostBeginPlay ()
{
	Super.PostBeginPlay();
}

function InterpolateEnd (Actor Other)
{
	if ( bEndOfPath )
	{
		if ( (Pawn(Other) != None) && Pawn(Other).bIsPlayer )
		{
			Other.bCollideWorld=True;
			Other.bInterpolating=False;
			if ( Pawn(Other).Health > 0 )
			{
				Other.SetCollision(True,True,True);
				Other.SetPhysics(2);
				Other.AmbientSound=None;
				if ( Other.IsA('PlayerPawn') )
				{
					Other.GotoState('PlayerWalking');
				}
			}
		}
	}
}

defaultproperties
{
    RateModifier=1.00
    GameSpeedModifier=1.00
    FovModifier=1.00
    ScreenFlashScale=1.00
    bStatic=False
    bDirectional=True
    Texture=Texture'S_Interp'
}