//================================================================================
// SPGameIntro.
//================================================================================
class SPGameIntro expands SPGameInfo;

var PlayerPawn NewPlayer;
var SPSub TheSub;
var bool bSetupDone;

event PlayerPawn Login (string Portal, string Options, out string Error, Class<PlayerPawn> SpawnClass)
{
	NewPlayer=Super.Login(Portal,Options,Error,SpawnClass);
	SetTimer(0.05,False);
	NewPlayer.SetCollisionSize(18.00,39.00);
	return NewPlayer;
}

function Timer ()
{
	if ( bSetupDone )
	{
		Super.Timer();
	}
	else
	{
		bSetupDone=True;
		SetUpFlyThrough();
		SetTimer(3.00 * 60,True);
	}
}

function SetUpFlyThrough ()
{
	local Actor A;
	local InterpolationPoint i;
	local SPSub S;

	if ( NewPlayer != None )
	{
		foreach AllActors(Class'InterpolationPoint',i,'Path')
		{
			if ( i.Position == 0 )
			{
				NewPlayer.SetCollision(False,False,False);
				NewPlayer.Target=i;
				NewPlayer.SetPhysics(8);
				NewPlayer.PhysRate=1.00;
				NewPlayer.PhysAlpha=0.00;
				NewPlayer.bInterpolating=True;
			}
		}
		foreach AllActors(Class'SPSub',S)
		{
			foreach AllActors(Class'InterpolationPoint',i,S.Tag)
			{
				if ( i.Position == 0 )
				{
					S.SetCollision(False,False,False);
					S.Target=i;
					S.SetPhysics(8);
					S.PhysRate=1.00;
					S.PhysAlpha=0.00;
					S.bInterpolating=True;
				}
			}
		}
	}
}

defaultproperties
{
    DefaultWeapon=None
    HUDType=Class'SPIntroHud'
}