//================================================================================
// SPBallReceptor.
//================================================================================
class SPBallReceptor expands SPActor;

var(Receptor) int Capacity;
var(Receptor) ESporeColor Color;
var(Receptor) float ResetTime;
var(Receptor) name CounterName;
var(Receptor) Sound SuccessSound;
var() name RelaySwitchName;
var() float OnTurretDelay;
var() float OffTurretDelay;
var() name OnTurretName;
var() name OffTurretName;
var() bool bReplaceCaptured;
var() name MyTurret;
var int AmountIn;
var float RelayStartTime;
var float RelayDelayTime;
var SPTurret RelayTurret;

event BeginPlay ()
{
	Super.BeginPlay();
	if ( Color == 0 )
	{
		Texture=Texture'cam5001';
	}
	else
	{
		if ( Color == 2 )
		{
			Texture=Texture'cam1001';
		}
		else
		{
			if ( Color == 3 )
			{
				Texture=Texture'cam2001';
			}
			else
			{
				if ( Color == 1 )
				{
					Texture=Texture'cam3001';
				}
				else
				{
					if ( Color == 5 )
					{
						Texture=Texture'cam4001';
					}
					else
					{
						if ( Color == 4 )
						{
							Texture=Texture'cam6001';
						}
					}
				}
			}
		}
	}
	DrawScale=0.15;
	Disable('Tick');
}

event Touch (Actor Other)
{
	local SPColoredBall ball;
	local SPChargedColoredBall chargeBall;
	local SPLargeColoredBall largeBall;
	local SPPlayer P;
	local bool bPlaySound;

	ball=SPColoredBall(Other);
	chargeBall=SPChargedColoredBall(Other);
	largeBall=SPLargeColoredBall(Other);
	foreach AllActors(Class'SPPlayer',P)
	{
		goto JL0044;
	}
	if ( ball != None )
	{
		if ( (Color == 6) || (ball.BallColor == Color) )
		{
			if ( ball.bSilentDestroy )
			{
				ball.Destroy();
			}
			else
			{
				ball.Explode();
			}
			AmountIn++;
			if ( AmountIn == Capacity )
			{
				Filled();
			}
			bPlaySound=True;
			if ( bReplaceCaptured )
			{
				FireMyTurret();
			}
		}
	}
	else
	{
		if ( chargeBall != None )
		{
			if ( (Color == 6) || (chargeBall.BallColor == Color) )
			{
				if ( chargeBall.bSilentDestroy )
				{
					chargeBall.Destroy();
				}
				else
				{
					chargeBall.Explode();
				}
				AmountIn++;
				if ( AmountIn == Capacity )
				{
					Filled();
				}
				bPlaySound=True;
				if ( bReplaceCaptured )
				{
					FireMyTurret();
				}
			}
		}
		else
		{
			if ( largeBall != None )
			{
				if ( (Color == 6) || (largeBall.BallColor == Color) )
				{
					largeBall.Destroy();
					AmountIn++;
					if ( AmountIn == Capacity )
					{
						Filled();
					}
					bPlaySound=True;
					if ( bReplaceCaptured )
					{
						FireMyTurret();
					}
				}
			}
		}
	}
	if ( bPlaySound && (P != None) )
	{
		P.PlaySound(SuccessSound,5);
	}
}

event Bump (Actor Other)
{
	Touch(Other);
}

function Filled ()
{
	local Actor A;
	local SPSwitch1 Switch;

	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(self,Instigator);
		}
	}
	if ( CounterName != 'None' )
	{
		foreach AllActors(Class'Actor',A,CounterName)
		{
			A.Trigger(self,Instigator);
		}
	}
	if ( (RelaySwitchName != 'None') && (OnTurretName != 'None') && (OffTurretName != 'None') )
	{
		foreach AllActors(Class'SPSwitch1',Switch,RelaySwitchName)
		{
			if ( Switch.isOn )
			{
				foreach AllActors(Class'SPTurret',RelayTurret,OnTurretName)
				{
					RelayStartTime=Level.TimeSeconds;
					RelayDelayTime=OnTurretDelay;
					Enable('Tick');
					goto JL010D;
				}
			}
			else
			{
				foreach AllActors(Class'SPTurret',RelayTurret,OffTurretName)
				{
					RelayStartTime=Level.TimeSeconds;
					RelayDelayTime=OffTurretDelay;
					Enable('Tick');
					goto JL0150;
				}
JL0150:
			}
		}
	}
	Disable('Touch');
	Disable('Bump');
	SetTimer(ResetTime,False);
}

event Tick (float Delay)
{
	if ( Level.TimeSeconds - RelayStartTime >= RelayDelayTime )
	{
		if ( RelayTurret != None )
		{
			RelayTurret.GotoState('Firing');
		}
		else
		{
			Log("SPBallReceptor::Tick <ERROR> RelayTurret is None!!!!!");
		}
		Disable('Tick');
	}
}

function Reset ()
{
	local Actor A;

	AmountIn=0;
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(self,Instigator);
		}
	}
	if ( CounterName != 'None' )
	{
		foreach AllActors(Class'Actor',A,CounterName)
		{
			if ( A.IsA('Counter') )
			{
				Counter(A).NumToCount++;
			}
		}
	}
	Enable('Touch');
	Enable('Bump');
}

event Timer ()
{
	Reset();
}

event Trigger (Actor Other, Pawn Instigator)
{
	GotoState('Done');
}

function FireMyTurret ()
{
	local SPTurret t;

	if ( MyTurret != 'None' )
	{
		foreach AllActors(Class'SPTurret',t,MyTurret)
		{
			t.ButtonFire();
		}
	}
}

state Done
{
	ignores  Reset;
	
}

defaultproperties
{
    Capacity=1
    Texture=Texture'SporeSkin.Lips.Platforms.cam1001'
    DrawScale=0.15
    bCollideActors=True
    bCollideWorld=True
}