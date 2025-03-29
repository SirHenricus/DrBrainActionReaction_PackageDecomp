//================================================================================
// Console.
//================================================================================
class Console expands Object
	native
	noexport
	transient;

enum EInputKey {
	IK_None,
	IK_LeftMouse,
	IK_RightMouse,
	IK_Cancel,
	IK_MiddleMouse,
	IK_Unknown05,
	IK_Unknown06,
	IK_Unknown07,
	IK_Backspace,
	IK_Tab,
	IK_Unknown0A,
	IK_Unknown0B,
	IK_Unknown0C,
	IK_Enter,
	IK_Unknown0E,
	IK_Unknown0F,
	IK_Shift,
	IK_Ctrl,
	IK_Alt,
	IK_Pause,
	IK_CapsLock,
	IK_Unknown15,
	IK_Unknown16,
	IK_Unknown17,
	IK_Unknown18,
	IK_Unknown19,
	IK_Unknown1A,
	IK_Escape,
	IK_Unknown1C,
	IK_Unknown1D,
	IK_Unknown1E,
	IK_Unknown1F,
	IK_Space,
	IK_PageUp,
	IK_PageDown,
	IK_End,
	IK_Home,
	IK_Left,
	IK_Up,
	IK_Right,
	IK_Down,
	IK_Select,
	IK_Print,
	IK_Execute,
	IK_PrintScrn,
	IK_Insert,
	IK_Delete,
	IK_Help,
	IK_0,
	IK_1,
	IK_2,
	IK_3,
	IK_4,
	IK_5,
	IK_6,
	IK_7,
	IK_8,
	IK_9,
	IK_Unknown3A,
	IK_Unknown3B,
	IK_Unknown3C,
	IK_Unknown3D,
	IK_Unknown3E,
	IK_Unknown3F,
	IK_Unknown40,
	IK_A,
	IK_B,
	IK_C,
	IK_D,
	IK_E,
	IK_F,
	IK_G,
	IK_H,
	IK_I,
	IK_J,
	IK_K,
	IK_L,
	IK_M,
	IK_N,
	IK_O,
	IK_P,
	IK_Q,
	IK_R,
	IK_S,
	IK_T,
	IK_U,
	IK_V,
	IK_W,
	IK_X,
	IK_Y,
	IK_Z,
	IK_Unknown5B,
	IK_Unknown5C,
	IK_Unknown5D,
	IK_Unknown5E,
	IK_Unknown5F,
	IK_NumPad0,
	IK_NumPad1,
	IK_NumPad2,
	IK_NumPad3,
	IK_NumPad4,
	IK_NumPad5,
	IK_NumPad6,
	IK_NumPad7,
	IK_NumPad8,
	IK_NumPad9,
	IK_GreyStar,
	IK_GreyPlus,
	IK_Separator,
	IK_GreyMinus,
	IK_NumPadPeriod,
	IK_GreySlash,
	IK_F1,
	IK_F2,
	IK_F3,
	IK_F4,
	IK_F5,
	IK_F6,
	IK_F7,
	IK_F8,
	IK_F9,
	IK_F10,
	IK_F11,
	IK_F12,
	IK_F13,
	IK_F14,
	IK_F15,
	IK_F16,
	IK_F17,
	IK_F18,
	IK_F19,
	IK_F20,
	IK_F21,
	IK_F22,
	IK_F23,
	IK_F24,
	IK_Unknown88,
	IK_Unknown89,
	IK_Unknown8A,
	IK_Unknown8B,
	IK_Unknown8C,
	IK_Unknown8D,
	IK_Unknown8E,
	IK_Unknown8F,
	IK_NumLock,
	IK_ScrollLock,
	IK_Unknown92,
	IK_Unknown93,
	IK_Unknown94,
	IK_Unknown95,
	IK_Unknown96,
	IK_Unknown97,
	IK_Unknown98,
	IK_Unknown99,
	IK_Unknown9A,
	IK_Unknown9B,
	IK_Unknown9C,
	IK_Unknown9D,
	IK_Unknown9E,
	IK_Unknown9F,
	IK_LShift,
	IK_RShift,
	IK_LControl,
	IK_RControl,
	IK_UnknownA4,
	IK_UnknownA5,
	IK_UnknownA6,
	IK_UnknownA7,
	IK_UnknownA8,
	IK_UnknownA9,
	IK_UnknownAA,
	IK_UnknownAB,
	IK_UnknownAC,
	IK_UnknownAD,
	IK_UnknownAE,
	IK_UnknownAF,
	IK_UnknownB0,
	IK_UnknownB1,
	IK_UnknownB2,
	IK_UnknownB3,
	IK_UnknownB4,
	IK_UnknownB5,
	IK_UnknownB6,
	IK_UnknownB7,
	IK_UnknownB8,
	IK_UnknownB9,
	IK_Semicolon,
	IK_Equals,
	IK_Comma,
	IK_Minus,
	IK_Period,
	IK_Slash,
	IK_Tilde,
	IK_UnknownC1,
	IK_UnknownC2,
	IK_UnknownC3,
	IK_UnknownC4,
	IK_UnknownC5,
	IK_UnknownC6,
	IK_UnknownC7,
	IK_Joy1,
	IK_Joy2,
	IK_Joy3,
	IK_Joy4,
	IK_Joy5,
	IK_Joy6,
	IK_Joy7,
	IK_Joy8,
	IK_Joy9,
	IK_Joy10,
	IK_Joy11,
	IK_Joy12,
	IK_Joy13,
	IK_Joy14,
	IK_Joy15,
	IK_Joy16,
	IK_UnknownD8,
	IK_UnknownD9,
	IK_UnknownDA,
	IK_LeftBracket,
	IK_Backslash,
	IK_RightBracket,
	IK_SingleQuote,
	IK_UnknownDF,
	IK_JoyX,
	IK_JoyY,
	IK_JoyZ,
	IK_JoyR,
	IK_MouseX,
	IK_MouseY,
	IK_MouseZ,
	IK_MouseW,
	IK_JoyU,
	IK_JoyV,
	IK_UnknownEA,
	IK_UnknownEB,
	IK_MouseWheelUp,
	IK_MouseWheelDown,
	IK_Unknown10E,
	UK_Unknown10F,
	IK_UnknownF0,
	IK_UnknownF1,
	IK_UnknownF2,
	IK_UnknownF3,
	IK_UnknownF4,
	IK_UnknownF5,
	IK_Attn,
	IK_CrSel,
	IK_ExSel,
	IK_ErEof,
	IK_Play,
	IK_Zoom,
	IK_NoName,
	IK_PA1,
	IK_OEMClear
};

enum EInputAction {
	IST_None,
	IST_Press,
	IST_Hold,
	IST_Release,
	IST_Axis
};

const TextMsgSize=128;
const MaxHistory=16;
const MaxLines=64;
const MaxBorder=6;
var const private int vtblOut;
var Viewport Viewport;
var int HistoryTop;
var int HistoryBot;
var int HistoryCur;
var string TypedStr;
var string History[16];
var int Scrollback;
var int NumLines;
var int TopLine;
var int TextLines;
var float MsgTime;
var string MsgText[64];
var name MsgType[64];
var PlayerReplicationInfo MsgPlayer[64];
var float MsgTick[64];
var int BorderSize;
var int ConsoleLines;
var int BorderLines;
var int BorderPixels;
var float ConsolePos;
var float ConsoleDest;
var float FrameX;
var float FrameY;
var Texture ConBackground;
var Texture Border;
var bool bNoStuff;
var bool bTyping;
var bool bTimeDemo;
var TimeDemo TimeDemo;
var bool bNoDrawWorld;
var localized string LoadingMessage;
var localized string SavingMessage;
var localized string ConnectingMessage;
var localized string PausedMessage;
var localized string PrecachingMessage;

native function bool ConsoleCommand (coerce string S);

exec function Type ()
{
	TypedStr="";
	GotoState('Typing');
}

exec function Talk ()
{
	TypedStr="Say ";
	bNoStuff=True;
	GotoState('Typing');
}

exec function TeamTalk ()
{
	TypedStr="TeamSay ";
	bNoStuff=True;
	GotoState('Typing');
}

exec function ViewUp ()
{
	BorderSize=Clamp(BorderSize - 1,0,6);
}

exec function ViewDown ()
{
	BorderSize=Clamp(BorderSize + 1,0,6);
}

function string GetMsgText (int Index)
{
	return MsgText[Index];
}

function SetMsgText (int Index, string NewMsgText)
{
	MsgText[Index]=NewMsgText;
}

function name GetMsgType (int Index)
{
	return MsgType[Index];
}

function SetMsgType (int Index, name NewMsgType)
{
	MsgType[Index]=NewMsgType;
}

function PlayerReplicationInfo GetMsgPlayer (int Index)
{
	return MsgPlayer[Index];
}

function SetMsgPlayer (int Index, PlayerReplicationInfo NewMsgPlayer)
{
	MsgPlayer[Index]=NewMsgPlayer;
}

function float GetMsgTick (int Index)
{
	return MsgTick[Index];
}

function SetMsgTick (int Index, int NewMsgTick)
{
	MsgTick[Index]=NewMsgTick;
}

function ClearMessages ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 64 )
	{
		MsgText[i]="";
		MsgType[i]='None';
		MsgPlayer[i]=None;
		MsgTick[i]=0.00;
		i++;
		goto JL0007;
	}
	MsgTime=0.00;
}

event Message (PlayerReplicationInfo PRI, coerce string Msg, name N)
{
	if ( Msg != "" )
	{
		TopLine=(TopLine + 1) % 64;
		NumLines=Min(NumLines + 1,64 - 1);
		MsgType[TopLine]=N;
		MsgTime=6.00;
		TextLines++;
		MsgText[TopLine]=Msg;
		MsgPlayer[TopLine]=PRI;
		MsgTick[TopLine]=MsgTime;
	}
}

event bool KeyType (EInputKey Key);

event bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
{
	if ( Action != 1 )
	{
		return False;
	}
	else
	{
		if ( Key == 192 )
		{
			if ( ConsoleDest == 0.00 )
			{
				ConsoleDest=0.60;
				GotoState('Typing');
			}
			else
			{
				GotoState('None');
			}
			return True;
		}
		else
		{
			return False;
		}
	}
}

event Tick (float Delta)
{
	local int i;

	if ( TimeDemo != None )
	{
		TimeDemo.TickTimeDemo(Delta);
	}
	else
	{
		if ( bTimeDemo )
		{
			TimeDemo=Viewport.Actor.Spawn(Class'TimeDemo');
			TimeDemo.DoSetup(self);
			bTimeDemo=False;
		}
	}
	i=0;
JL006A:
	if ( i < 64 )
	{
		if ( MsgTick[i] > 0.00 )
		{
			MsgTick[i] -= Delta;
		}
		if ( MsgTick[i] < 0.00 )
		{
			MsgTick[i]=0.00;
		}
		i++;
		goto JL006A;
	}
	if ( ConsolePos < ConsoleDest )
	{
		ConsolePos=FMin(ConsolePos + Delta,ConsoleDest);
	}
	else
	{
		if ( ConsolePos > ConsoleDest )
		{
			ConsolePos=FMax(ConsolePos - Delta,ConsoleDest);
		}
	}
	if ( ((MsgTime -= Delta) <= 0.00) && (TextLines > 0) )
	{
		TextLines--;
	}
}

event PreRender (Canvas C);

event NotifyLevelChange ()
{
	if ( TimeDemo != None )
	{
		TimeDemo.DoShutdown();
		TimeDemo=None;
		bTimeDemo=True;
	}
	ClearMessages();
}

function DrawLevelAction (Canvas C)
{
	local string BigMessage;
	local Font LargeFont;
	local float XL;
	local float YL;

	LargeFont=C.LargeFont;
	C.Style=1;
	if ( Viewport.Actor.bShowMenu )
	{
		BigMessage="";
	}
	else
	{
		if ( Viewport.Actor.Level.LevelAction == 1 )
		{
			BigMessage=LoadingMessage;
		}
		else
		{
			if ( Viewport.Actor.Level.LevelAction == 2 )
			{
				BigMessage=SavingMessage;
			}
			else
			{
				if ( Viewport.Actor.Level.LevelAction == 3 )
				{
					BigMessage=ConnectingMessage;
				}
				else
				{
					if ( Viewport.Actor.Level.LevelAction == 4 )
					{
						BigMessage=PrecachingMessage;
					}
					else
					{
						if ( Viewport.Actor.Level.Pauser != "" )
						{
							LargeFont=C.MedFont;
							BigMessage=PausedMessage;
						}
					}
				}
			}
		}
	}
	if ( BigMessage != "" )
	{
		C.bCenter=False;
		C.Font=LargeFont;
		C.StrLen(BigMessage,XL,YL);
		C.SetPos(FrameX / 2 - XL / 2,FrameY / 2 - YL / 2);
		C.DrawText(BigMessage,False);
	}
}

event PostRender (Canvas C)
{
	local int YStart;
	local int YEnd;
	local int Y;
	local int i;
	local int j;
	local int Line;
	local int iLine;

	if ( bNoDrawWorld )
	{
		C.SetPos(0.00,0.00);
		C.DrawPattern(Texture'Border',C.ClipX,C.ClipY,1.00);
	}
	if ( TimeDemo != None )
	{
		TimeDemo.PostRender(C);
	}
	DrawLevelAction(C);
	if ( ConsoleLines > 0 )
	{
		C.SetOrigin(0.00,ConsoleLines - FrameY * 0.60);
		C.SetPos(0.00,0.00);
		C.DrawTile(ConBackground,FrameX,FrameY * 0.60,C.CurX,C.CurY,FrameX,FrameY);
	}
	YStart=BorderLines;
	YEnd=FrameY - BorderLines;
	if ( (BorderLines > 0) || (BorderPixels > 0) )
	{
		YStart += ConsoleLines;
		if ( BorderLines > 0 )
		{
			C.SetOrigin(0.00,0.00);
			C.SetPos(0.00,0.00);
			C.DrawPattern(Border,FrameX,BorderLines,1.00);
			C.SetPos(0.00,YEnd);
			C.DrawPattern(Border,FrameX,BorderLines,1.00);
		}
		if ( BorderPixels > 0 )
		{
			C.SetOrigin(0.00,0.00);
			C.SetPos(0.00,YStart);
			C.DrawPattern(Border,BorderPixels,YEnd - YStart,1.00);
			C.SetPos(FrameX - BorderPixels,YStart);
			C.DrawPattern(Border,BorderPixels,YEnd - YStart,1.00);
		}
	}
	C.SetOrigin(0.00,0.00);
	if ( ConsoleLines > 0 )
	{
		DrawConsoleView(C);
	}
	else
	{
		DrawSingleView(C);
	}
}

simulated function DrawConsoleView (Canvas C)
{
	local int Y;
	local int i;
	local int Line;
	local float XL;
	local float YL;

	Y=ConsoleLines - 1;
	MsgText[(TopLine + 1 + 64) % 64]="(>" @ TypedStr;
	i=Scrollback;
JL003E:
	if ( i < NumLines + 1 )
	{
		Line=(TopLine + 64 * 2 - i - 1) % 64;
		C.Font=C.MedFont;
		if ( (MsgType[Line] == 'Say') || (MsgType[Line] == 'TeamSay') )
		{
			C.StrLen(MsgPlayer[Line].PlayerName $ ":" @ MsgText[Line],XL,YL);
		}
		else
		{
			C.StrLen(MsgText[Line],XL,YL);
		}
		if ( YL == 0 )
		{
			YL=5.00;
		}
		Y -= YL;
		if ( Y + YL < 0 )
		{
			goto JL0213;
		}
		C.SetPos(4.00,Y);
		C.Font=C.MedFont;
		if ( (MsgType[Line] == 'Say') || (MsgType[Line] == 'TeamSay') )
		{
			C.DrawText(MsgPlayer[Line].PlayerName $ ":" @ MsgText[Line],False);
		}
		else
		{
			C.DrawText(MsgText[Line],False);
		}
		i++;
		goto JL003E;
	}
JL0213:
}

simulated function DrawSingleView (Canvas C)
{
	local string TypingPrompt;
	local int i;
	local int j;
	local float XL;
	local float YL;
	local string ShortMessages[4];
	local int ExtraSpace;

	C.SetOrigin(0.00,0.00);
	if ( Viewport.Actor.myHUD != None )
	{
		if ( Viewport.Actor.myHUD.DisplayMessages(C) )
		{
			return;
		}
	}
	if (  !Viewport.Actor.bShowMenu )
	{
		if ( bTyping )
		{
			TypingPrompt="(>" @ TypedStr $ "_";
			C.Font=C.MedFont;
			C.StrLen(TypingPrompt,XL,YL);
			C.SetPos(2.00,FrameY - ConsoleLines - YL - 1);
			C.DrawText(TypingPrompt,False);
		}
	}
	if ( (TextLines > 0) && ( !Viewport.Actor.bShowMenu || Viewport.Actor.bShowScores) )
	{
		j=TopLine;
		i=0;
JL016C:
		if ( (i < 4) && (j >= 0) )
		{
			if ( (MsgText[j] != "") && (MsgTick[j] > 0.00) )
			{
				if ( MsgType[j] == 'Say' )
				{
					ShortMessages[i]=string(MsgPlayer[j]) $ ":" @ MsgText[j];
				}
				else
				{
					ShortMessages[i]=MsgText[j];
				}
				i++;
			}
			j--;
			goto JL016C;
		}
		j=0;
		C.Font=C.MedFont;
		i=0;
JL0243:
		if ( i < 4 )
		{
			if ( ShortMessages[3 - i] != "" )
			{
				C.SetPos(4.00,2.00 + 10 * j + 10 * ExtraSpace);
				C.StrLen(ShortMessages[3 - i],XL,YL);
				C.DrawText(ShortMessages[3 - i],False);
				if ( YL == 18.00 )
				{
					ExtraSpace++;
				}
				j++;
			}
			i++;
			goto JL0243;
		}
	}
}

state Typing
{
	exec function Type ()
	{
		TypedStr="";
		GotoState('None');
	}
	
	function bool KeyType (EInputKey Key)
	{
		if ( (Key >= 32) && (Key < 128) && (Key != Asc("~")) && (Key != Asc("`")) )
		{
			if ( bNoStuff )
			{
				bNoStuff=False;
				return True;
			}
			TypedStr=TypedStr $ Chr(Key);
			Scrollback=0;
			return True;
		}
	}
	
	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local string Temp;
	
		if ( Global.KeyEvent(Key,Action,Delta) || (Action != 1) )
		{
			return True;
		}
		else
		{
			if ( Key == 27 )
			{
				if ( Scrollback != 0 )
				{
					Scrollback=0;
				}
				else
				{
					if ( TypedStr != "" )
					{
						TypedStr="";
					}
					else
					{
						ConsoleDest=0.00;
						GotoState('None');
					}
				}
				Scrollback=0;
			}
			else
			{
				if ( Key == 13 )
				{
					if ( Scrollback != 0 )
					{
						Scrollback=0;
					}
					else
					{
						if ( TypedStr != "" )
						{
							if ( ConsoleLines != 0 )
							{
								Message(None,"(>" @ TypedStr,'Console');
							}
							History[HistoryCur++  % 16]=TypedStr;
							if ( HistoryCur > HistoryBot )
							{
								HistoryBot++;
							}
							if ( HistoryCur - HistoryTop >= 16 )
							{
								HistoryTop=HistoryCur - 16 + 1;
							}
							Temp=TypedStr;
							TypedStr="";
							if (  !ConsoleCommand(Temp) )
							{
								Message(None,Localize('Errors','Exec','Core'),'Console');
							}
							Message(None,"",'Console');
						}
						if ( ConsoleDest == 0.00 )
						{
							GotoState('None');
						}
						Scrollback=0;
					}
				}
				else
				{
					if ( Key == 38 )
					{
						if ( HistoryCur > HistoryTop )
						{
							History[HistoryCur % 16]=TypedStr;
							TypedStr=History[ --HistoryCur % 16];
						}
						Scrollback=0;
					}
					else
					{
						if ( Key == 40 )
						{
							History[HistoryCur % 16]=TypedStr;
							if ( HistoryCur < HistoryBot )
							{
								TypedStr=History[ ++HistoryCur % 16];
							}
							else
							{
								TypedStr="";
							}
							Scrollback=0;
						}
						else
						{
							if ( Key == 33 )
							{
								if (  ++Scrollback >= 64 )
								{
									Scrollback=64 - 1;
								}
							}
							else
							{
								if ( Key == 34 )
								{
									if (  --Scrollback < 0 )
									{
										Scrollback=0;
									}
								}
								else
								{
									if ( (Key == 8) || (Key == 37) )
									{
										if ( Len(TypedStr) > 0 )
										{
											TypedStr=Left(TypedStr,Len(TypedStr) - 1);
										}
										Scrollback=0;
									}
								}
							}
						}
					}
				}
			}
		}
		return True;
	}
	
	function BeginState ()
	{
		bTyping=True;
		Viewport.Actor.Typing(bTyping);
	}
	
	function EndState ()
	{
		bTyping=False;
		Viewport.Actor.Typing(bTyping);
		Log("Console leaving Typing");
		ConsoleDest=0.00;
	}
	
}

state Menuing
{
	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		if ( Action != 1 )
		{
			return False;
		}
		if ( (Viewport.Actor.myHUD == None) || (Viewport.Actor.myHUD.MainMenu == None) )
		{
			return False;
		}
		Viewport.Actor.myHUD.MainMenu.MenuProcessInput(Key,Action);
		Scrollback=0;
		return True;
	}
	
	function BeginState ()
	{
		Log("Console entering Menuing");
	}
	
	function EndState ()
	{
		Log("Console leaving Menuing");
	}
	
}

state EndMenuing
{
	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		if ( (Viewport.Actor.myHUD == None) || (Viewport.Actor.myHUD.MainMenu == None) )
		{
			return False;
		}
		Viewport.Actor.myHUD.MainMenu.MenuProcessInput(Key,Action);
		Scrollback=0;
		return True;
	}
	
}

state MenuTyping
{
	function bool KeyType (EInputKey Key)
	{
		if ( (Key >= 32) && (Key < 128) && (Key != Asc("~")) && (Key != Asc("`")) && (Key != Asc(" ")) )
		{
			TypedStr=TypedStr $ Chr(Key);
			Scrollback=0;
			if ( (Viewport.Actor.myHUD != None) && (Viewport.Actor.myHUD.MainMenu != None) )
			{
				Viewport.Actor.myHUD.MainMenu.ProcessMenuUpdate(TypedStr);
			}
			return True;
		}
	}
	
	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local Menu PlayerMenu;
	
		if ( Action != 1 )
		{
			return False;
		}
		if ( (Viewport.Actor.myHUD == None) || (Viewport.Actor.myHUD.MainMenu == None) )
		{
			return False;
		}
		PlayerMenu=Viewport.Actor.myHUD.MainMenu;
		if ( Key == 27 )
		{
			if ( Scrollback != 0 )
			{
				Scrollback=0;
			}
			else
			{
				if ( TypedStr != "" )
				{
					TypedStr="";
				}
				else
				{
					GotoState('Menuing');
				}
			}
			PlayerMenu.ProcessMenuEscape();
			Scrollback=0;
		}
		else
		{
			if ( Key == 13 )
			{
				if ( Scrollback != 0 )
				{
					Scrollback=0;
				}
				else
				{
					if ( TypedStr != "" )
					{
						PlayerMenu.ProcessMenuInput(TypedStr);
					}
					TypedStr="";
					GotoState('Menuing');
					Scrollback=0;
				}
			}
			else
			{
				if ( (Key == 8) || (Key == 37) )
				{
					if ( Len(TypedStr) > 0 )
					{
						TypedStr=Left(TypedStr,Len(TypedStr) - 1);
					}
					Scrollback=0;
					PlayerMenu.ProcessMenuUpdate(TypedStr);
				}
			}
		}
		return True;
	}
	
	function BeginState ()
	{
		Log("Console entering MenuTyping");
	}
	
	function EndState ()
	{
		Log("Console leaving MenuTyping");
	}
	
}

state KeyMenuing
{
	function bool KeyType (EInputKey Key)
	{
		ConsoleDest=0.00;
		if ( (Viewport.Actor.myHUD != None) && (Viewport.Actor.myHUD.MainMenu != None) )
		{
			Viewport.Actor.myHUD.MainMenu.ProcessMenuKey(Key,Chr(Key));
		}
		Scrollback=0;
		GotoState('Menuing');
	}
	
	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		if ( Action == 1 )
		{
			ConsoleDest=0.00;
			if ( (Viewport.Actor.myHUD != None) && (Viewport.Actor.myHUD.MainMenu != None) )
			{
				Viewport.Actor.myHUD.MainMenu.ProcessMenuKey(Key,Mid(string(GetEnum(Enum'EInputKey',Key)),3));
			}
			Scrollback=0;
			GotoState('Menuing');
			return True;
		}
	}
	
	function BeginState ()
	{
		Log("Console entering KeyMenuing");
	}
	
	function EndState ()
	{
		Log("Console leaving KeyMenuing");
	}
	
}

defaultproperties
{
    ConBackground=Texture'ConsoleBack'
    Border=Texture'Border'
    LoadingMessage="LOADING"
    SavingMessage="SAVING"
    ConnectingMessage="CONNECTING"
    PausedMessage="PAUSED"
    PrecachingMessage="PRECACHING"
}