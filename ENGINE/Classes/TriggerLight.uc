//================================================================================
// TriggerLight.
//================================================================================
class TriggerLight expands Light;

var() float ChangeTime;
var() bool bInitiallyOn;
var() bool bDelayFullOn;
var() float RemainOnTime;
var float InitialBrightness;
var float Alpha;
var float Direction;
var Actor SavedTrigger;
var float poundTime;

simulated function BeginPlay ()
{
	Disable('Tick');
	InitialBrightness=LightBrightness;
	if ( bInitiallyOn )
	{
		Alpha=1.00;
		Direction=1.00;
	}
	else
	{
		Alpha=0.00;
		Direction=-1.00;
	}
	DrawType=0;
}

function Tick (float DeltaTime)
{
	Alpha += Direction * DeltaTime / ChangeTime;
	if ( Alpha > 1.00 )
	{
		Alpha=1.00;
		Disable('Tick');
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
	}
	else
	{
		if ( Alpha < 0.00 )
		{
			Alpha=0.00;
			Disable('Tick');
			if ( SavedTrigger != None )
			{
				SavedTrigger.EndEvent();
			}
		}
	}
	if (  !bDelayFullOn )
	{
		LightBrightness=Alpha * InitialBrightness;
	}
	else
	{
		if ( (Direction > 0) && (Alpha != 1) || (Alpha == 0) )
		{
			LightBrightness=0;
		}
		else
		{
			LightBrightness=InitialBrightness;
		}
	}
}

state() TriggerTurnsOn
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
		SavedTrigger=Other;
		SavedTrigger.BeginEvent();
		Direction=1.00;
		Enable('Tick');
	}
	
}

state() TriggerTurnsOff
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
		SavedTrigger=Other;
		SavedTrigger.BeginEvent();
		Direction=-1.00;
		Enable('Tick');
	}
	
}

state() TriggerToggle
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
		SavedTrigger=Other;
		SavedTrigger.BeginEvent();
		Direction *= -1;
		Enable('Tick');
	}
	
}

state() TriggerControl
{
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
		SavedTrigger=Other;
		SavedTrigger.BeginEvent();
		if ( bInitiallyOn )
		{
			Direction=-1.00;
		}
		else
		{
			Direction=1.00;
		}
		Enable('Tick');
	}
	
	function UnTrigger (Actor Other, Pawn EventInstigator)
	{
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
		SavedTrigger=Other;
		SavedTrigger.BeginEvent();
		if ( bInitiallyOn )
		{
			Direction=1.00;
		}
		else
		{
			Direction=-1.00;
		}
		Enable('Tick');
	}
	
}

state() TriggerPound
{
	function Timer ()
	{
		if ( poundTime >= RemainOnTime )
		{
			Disable('Timer');
		}
		poundTime += ChangeTime;
		Direction *= -1;
		SetTimer(ChangeTime,False);
	}
	
	function Trigger (Actor Other, Pawn EventInstigator)
	{
		if ( SavedTrigger != None )
		{
			SavedTrigger.EndEvent();
		}
		SavedTrigger=Other;
		SavedTrigger.BeginEvent();
		Direction=1.00;
		poundTime=ChangeTime;
		SetTimer(ChangeTime,False);
		Enable('Timer');
		Enable('Tick');
	}
	
}

defaultproperties
{
    bStatic=False
    bHidden=False
    bMovable=True
    RemoteRole=ROLE_DumbProxy
}