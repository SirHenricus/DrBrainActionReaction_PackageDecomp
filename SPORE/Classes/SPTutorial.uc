//================================================================================
// SPTutorial.
//================================================================================
class SPTutorial expands SPActor;

var() float StartDelay;
var() name EndMover;
var string CurSpeech;
var int CurStage;
var bool bSpeechDone;
var bool bWaiting;
var bool bContinueAfterSpeech;
const TS_StateMission= 16;
const TS_Jump= 15;
const TS_PracticeWait= 14;
const TS_Practice2= 13;
const TS_Practice1= 12;
const TS_MoveRight= 11;
const TS_MoveLeft= 10;
const TS_MoveForward= 9;
const TS_Encourage= 8;
const TS_MoveBack= 7;
const TS_LookAround= 6;
const TS_Pause2= 5;
const TS_BrainIntro= 4;
const TS_Pause1= 3;
const TS_CravenSpeech= 2;
const TS_Startup= 1;

function BeginPlay ()
{
	Super.BeginPlay();
	NextStage();
}

event Timer ()
{
	if ( bWaiting )
	{
		bWaiting=False;
		NextStage();
	}
}

event Trigger (Actor Other, Pawn Instigator)
{
	SetTimer(0.00,False);
	CurStage=999;
}

function SwitchToBrain ()
{
	local SPWarpZoneInfo W;
	local SPMover M;

	foreach AllActors(Class'SPWarpZoneInfo',W,'monitor')
	{
		W.Trigger(self,Instigator);
		goto JL002E;
	}
	foreach AllActors(Class'SPMover',M,'Static')
	{
		M.Trigger(self,Instigator);
		goto JL005D;
	}
}

function SpeechDone (SPPawn Pawn, SPSpeechInfo Speech)
{
	bSpeechDone=True;
	if ( bContinueAfterSpeech )
	{
		bContinueAfterSpeech=False;
		NextStage();
	}
}

function NextStage ()
{
	CurStage++;
	if ( CurStage == 1 )
	{
		SetTimer(StartDelay,False);
		bWaiting=True;
	}
	else
	{
		if ( CurStage == 2 )
		{
			Speak("755",'SPCornelius');
			bContinueAfterSpeech=True;
		}
		else
		{
			if ( CurStage == 3 )
			{
				SetTimer(0.60,False);
				bWaiting=True;
			}
			else
			{
				if ( CurStage == 4 )
				{
					SwitchToBrain();
					Speak("233",'SPBrain');
					bContinueAfterSpeech=True;
				}
				else
				{
					if ( CurStage == 5 )
					{
						SetTimer(1.00,False);
						bWaiting=True;
					}
					else
					{
						if ( CurStage == 6 )
						{
							Speak("243",'SPBrain');
						}
						else
						{
							if ( CurStage == 7 )
							{
								Speak("238",'SPBrain');
							}
							else
							{
								if ( CurStage == 8 )
								{
									Speak("239",'SPBrain');
									bContinueAfterSpeech=True;
								}
								else
								{
									if ( CurStage == 9 )
									{
										Speak("228",'SPBrain');
									}
									else
									{
										if ( CurStage == 10 )
										{
											Speak("246",'SPBrain');
										}
										else
										{
											if ( CurStage == 11 )
											{
												Speak("236",'SPBrain');
											}
											else
											{
												if ( CurStage == 12 )
												{
													Speak("247",'SPBrain');
													bContinueAfterSpeech=True;
												}
												else
												{
													if ( CurStage == 13 )
													{
														Speak("226",'SPBrain');
														bContinueAfterSpeech=True;
													}
													else
													{
														if ( CurStage == 14 )
														{
															SetTimer(5.00,False);
															bWaiting=True;
														}
														else
														{
															if ( CurStage == 15 )
															{
																Speak("242",'SPBrain');
															}
															else
															{
																if ( CurStage == 16 )
																{
																	OpenEndMover();
																	Speak("249",'SPBrain');
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

function PlayerInput (SPPlayer Player)
{
	if ( (CurStage == 6) && bSpeechDone )
	{
		if ( (Player.aMouseX != 0) && (Player.aMouseY != 0) )
		{
			NextStage();
		}
	}
	else
	{
		if ( (CurStage == 7) && bSpeechDone )
		{
			if ( Player.aBaseY < 0 )
			{
				NextStage();
			}
		}
		else
		{
			if ( (CurStage == 9) && bSpeechDone )
			{
				if ( Player.aBaseY > 0 )
				{
					NextStage();
				}
			}
			else
			{
				if ( (CurStage == 10) && bSpeechDone )
				{
					if ( Player.aStrafe < 0 )
					{
						NextStage();
					}
				}
				else
				{
					if ( (CurStage == 11) && bSpeechDone )
					{
						if ( Player.aStrafe > 0 )
						{
							NextStage();
						}
					}
					else
					{
						if ( (CurStage == 15) && bSpeechDone )
						{
							if ( Player.aUp > 0 )
							{
								NextStage();
							}
						}
					}
				}
			}
		}
	}
}

function Speak (string Name, name PawnType)
{
	local Sound snd;
	local SPPawn speaker;
	local SPPlayer Player;

	foreach AllActors(Class'SPPlayer',Player)
	{
		goto JL0014;
	}
	foreach AllActors(Class'SPPawn',speaker)
	{
		if ( speaker.IsA(PawnType) )
		{
			goto JL0047;
		}
		else
		{
			speaker=None;
		}
	}
	if ( speaker != None )
	{
		speaker.Speak(Name,Player,self);
	}
	else
	{
		Log(string(self) $ "::Speak <ERROR> No Speaker was found!!!!!");
	}
	CurSpeech=Name;
	bSpeechDone=False;
}

function OpenEndMover ()
{
	local Mover M;

	if ( EndMover != 'None' )
	{
		foreach AllActors(Class'Mover',M,EndMover)
		{
			M.Trigger(self,Instigator);
		}
	}
}

defaultproperties
{
    StartDelay=3.00
    bHidden=True
}