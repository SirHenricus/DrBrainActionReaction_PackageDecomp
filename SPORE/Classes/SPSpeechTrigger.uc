//================================================================================
// SPSpeechTrigger.
//================================================================================
class SPSpeechTrigger expands SPActor;

var() Class<Actor> TriggerClass;
var() name MonitorTag;
var() name StaticMoverTag;
var() string CharacterURL;
var() name CharacterTag;
var() string Speech;
var() name NextSpeechTrigger;
var() bool bTriggerOnceOnly;
var() bool bActive;
var() string DoneURL;
var() float EndPauseTime;
var() float StartPauseTime;
var SPPawn Character;
var bool bTriggered;
var bool bSpeechDone;

event Touch (Actor Other)
{
	local Mover mov;

	if (  !bActive )
	{
		return;
	}
	if ( ClassIsChildOf(Other.Class,TriggerClass) || Other.IsA('SPSpeechTrigger') )
	{
		if ( StartPauseTime > 0 )
		{
			SetTimer(StartPauseTime,False);
		}
		else
		{
			Start();
		}
		if ( StaticMoverTag != 'None' )
		{
			foreach AllActors(Class'Mover',mov,StaticMoverTag)
			{
				mov.Trigger(self,Instigator);
			}
		}
	}
}

function Trigger (Actor Other, Pawn Instigator)
{
	bActive=True;
}

function Start ()
{
	if ( bTriggered && bTriggerOnceOnly )
	{
		return;
	}
	PlaySpeech();
	bTriggered=True;
}

function PlaySpeech ()
{
	local WarpZoneInfo monitor;
	local SPPlayer Player;
	local Mover mov;

	foreach AllActors(Class'SPPlayer',Player)
	{
		goto JL0014;
	}
	if ( MonitorTag != 'None' )
	{
		foreach AllActors(Class'WarpZoneInfo',monitor,MonitorTag)
		{
			if ( CharacterURL != "" )
			{
				monitor.OtherSideURL=CharacterURL;
				monitor.ForceGenerate();
			}
			else
			{
				Log(string(self) $ "::PlaySpeech <ERROR> Monitor=" $ string(monitor) $ ", CharacterURL=" $ CharacterURL);
			}
		}
	}
	if ( (monitor != None) && (CharacterURL != "") )
	{
		monitor.OtherSideURL=CharacterURL;
		monitor.ForceGenerate();
	}
	else
	{
		Log(string(self) $ "::PlaySpeech <ERROR> Monitor=" $ string(monitor) $ ", CharacterURL=" $ CharacterURL);
	}
	if ( CharacterTag != 'None' )
	{
		foreach AllActors(Class'SPPawn',Character,CharacterTag)
		{
			goto JL0162;
		}
JL0162:
	}
	if ( Character != None )
	{
		Character.Speak(Speech,Player,self);
	}
	else
	{
		Log(string(self) $ "::PlaySpeech <ERROR> Character=" $ string(Character));
	}
}

function SpeechDone (SPPawn Pawn, SPSpeechInfo Speech)
{
	local WarpZoneInfo monitor;

	bSpeechDone=True;
	if ( MonitorTag != 'None' )
	{
		foreach AllActors(Class'WarpZoneInfo',monitor,MonitorTag)
		{
			if ( DoneURL != "" )
			{
				monitor.OtherSideURL=DoneURL;
				monitor.ForceGenerate();
			}
		}
	}
	if ( NextSpeechTrigger != 'None' )
	{
		if ( EndPauseTime > 0 )
		{
			SetTimer(EndPauseTime,False);
		}
		else
		{
			NextSpeech();
		}
	}
}

event Timer ()
{
	if ( bSpeechDone )
	{
		NextSpeech();
	}
	else
	{
		Start();
	}
}

function NextSpeech ()
{
	local SPSpeechTrigger S;

	if ( NextSpeechTrigger != 'None' )
	{
		foreach AllActors(Class'SPSpeechTrigger',S,NextSpeechTrigger)
		{
			goto JL0028;
		}
		if ( S != None )
		{
			S.Touch(self);
		}
	}
}

defaultproperties
{
    TriggerClass=Class'SPPlayer'
    MonitorTag=monitor
    bTriggerOnceOnly=True
    bActive=True
    bHidden=True
    CollisionRadius=100.00
    bCollideActors=True
}