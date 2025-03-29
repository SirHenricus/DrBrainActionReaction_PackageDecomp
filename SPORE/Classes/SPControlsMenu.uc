//================================================================================
// SPControlsMenu.
//================================================================================
class SPControlsMenu expands SPMenu;

var() localized string KeyNames[256];
var string AliasNames[24];
var string PendingCommands[30];
var string OriginalKeyName;
var int Pending;
var bool bSetup;

function SaveConfigs ()
{
	ProcessPending();
}

function ProcessPending ()
{
	local int i;

	i=0;
JL0007:
	if ( i < Pending )
	{
		PlayerOwner.ConsoleCommand(PendingCommands[i]);
		i++;
		goto JL0007;
	}
	Pending=0;
}

function AddPending (string newCommand)
{
	PendingCommands[Pending]=newCommand;
	Pending++;
	if ( Pending == 30 )
	{
		ProcessPending();
	}
}

function SetUpMenu ()
{
	local int i;
	local int j;
	local int pos;
	local string KeyName;
	local string Alias;

	bSetup=True;
	i=0;
JL000F:
	if ( i < 255 )
	{
		KeyName=PlayerOwner.ConsoleCommand("KEYNAME " $ string(i));
		if ( KeyName != "" )
		{
			Alias=PlayerOwner.ConsoleCommand("KEYBINDING " $ KeyName);
			if ( Alias != "" )
			{
				pos=InStr(Alias," ");
				if ( pos != -1 )
				{
					Alias=Left(Alias,pos);
				}
				j=1;
JL00BB:
				if ( j < 20 )
				{
					if ( AliasNames[j] == Alias )
					{
						if ( MenuValues[j] == "" )
						{
							MenuValues[j]=KeyNames[i];
						}
					}
					j++;
					goto JL00BB;
				}
			}
		}
		i++;
		goto JL000F;
	}
	MenuValues[8]=string(PlayerOwner.MouseSensitivity);
	MenuValues[9]=string(PlayerOwner.bInvertMouse);
}

function ProcessMenuKey (int KeyNo, string KeyName)
{
	local int i;
	local string oldKeyName;

	if ( (KeyName == "") || (KeyName == "Escape") || (KeyNo >= 112) && (KeyNo <= 121) )
	{
		if ( KeyName == "Escape" )
		{
			MenuValues[Selection]=OriginalKeyName;
			AddPending("SET Input " $ MenuValues[Selection] $ " " $ AliasNames[Selection]);
		}
		return;
	}
	i=1;
JL0099:
	if ( i < 20 )
	{
		if ( (i != Selection) && (MenuValues[i] == KeyNames[KeyNo]) )
		{
			MenuValues[i]=OriginalKeyName;
			AddPending("SET Input " $ OriginalKeyName $ " " $ AliasNames[i]);
		}
		i++;
		goto JL0099;
	}
	oldKeyName=MenuValues[Selection];
	MenuValues[Selection]=KeyNames[KeyNo];
	AddPending("SET Input " $ oldKeyName $ " ");
	AddPending("SET Input " $ KeyName $ " " $ AliasNames[Selection]);
}

function ProcessMenuEscape ();

function ProcessMenuUpdate (coerce string InputString);

function bool ProcessLeft ()
{
	if ( Selection == 8 )
	{
		PlayerOwner.SetSensitivity(FMax(1.00,PlayerOwner.MouseSensitivity - 1));
		MenuValues[8]=string(PlayerOwner.MouseSensitivity);
	}
	else
	{
		if ( Selection == 9 )
		{
			PlayerOwner.bInvertMouse= !PlayerOwner.bInvertMouse;
			MenuValues[9]=string(PlayerOwner.bInvertMouse);
			PlayerOwner.SaveConfig();
		}
	}
	return True;
}

function bool ProcessRight ()
{
	if ( Selection == 8 )
	{
		PlayerOwner.SetSensitivity(FMax(1.00,PlayerOwner.MouseSensitivity + 1));
		MenuValues[8]=string(PlayerOwner.MouseSensitivity);
	}
	else
	{
		if ( Selection == 9 )
		{
			PlayerOwner.bInvertMouse= !PlayerOwner.bInvertMouse;
			MenuValues[9]=string(PlayerOwner.bInvertMouse);
			PlayerOwner.SaveConfig();
		}
	}
	return True;
}

function bool ProcessSelection ()
{
	local int i;

	if ( Selection == MenuLength )
	{
		Pending=0;
		i=0;
JL001D:
		if ( i < 24 )
		{
			AddPending("SET Input " $ MenuValues[i] $ " ");
			MenuValues[i]="";
			i++;
			goto JL001D;
		}
		ProcessPending();
		PlayerOwner.ResetKeyboard();
		PlayerOwner.MouseSensitivity=3.00;
		PlayerOwner.bInvertMouse=False;
		PlayerOwner.SaveConfig();
		SetUpMenu();
		return True;
	}
	if ( Selection == 8 )
	{
		return True;
	}
	if ( Selection == 9 )
	{
		return True;
	}
	OriginalKeyName=MenuValues[Selection];
	AddPending("SET Input " $ MenuValues[Selection] $ " ");
	MenuValues[Selection]="_";
	PlayerOwner.Player.Console.GotoState('KeyMenuing');
	return True;
}

function DrawMenu (Canvas Canvas)
{
	if (  !bSetup )
	{
		SetUpMenu();
	}
	Super.DrawMenu(Canvas);
}

defaultproperties
{
    KeyNames(0)="None"
    KeyNames(1)="LeftMouse"
    KeyNames(2)="RightMouse"
    KeyNames(3)="Cancel"
    KeyNames(4)="MiddleMouse"
    KeyNames(5)="Unknown05"
    KeyNames(6)="Unknown06"
    KeyNames(7)="Unknown07"
    KeyNames(8)="Backspace"
    KeyNames(9)="Tab"
    KeyNames(10)="Unknown0A"
    KeyNames(11)="Unknown0B"
    KeyNames(12)="Unknown0C"
    KeyNames(13)="Enter"
    KeyNames(14)="Unknown0E"
    KeyNames(15)="Unknown0F"
    KeyNames(16)="Shift"
    KeyNames(17)="Ctrl"
    KeyNames(18)="Alt"
    KeyNames(19)="Pause"
    KeyNames(20)="CapsLock"
    KeyNames(21)="Unknown15"
    KeyNames(22)="Unknown16"
    KeyNames(23)="Unknown17"
    KeyNames(24)="Unknown18"
    KeyNames(25)="Unknown19"
    KeyNames(26)="Unknown1A"
    KeyNames(27)="Escape"
    KeyNames(28)="Unknown1C"
    KeyNames(29)="Unknown1D"
    KeyNames(30)="Unknown1E"
    KeyNames(31)="Unknown1F"
    KeyNames(32)="Space"
    KeyNames(33)="PageUp"
    KeyNames(34)="PageDown"
    KeyNames(35)="End"
    KeyNames(36)="Home"
    KeyNames(37)="Left"
    KeyNames(38)="Up"
    KeyNames(39)="Right"
    KeyNames(40)="Down"
    KeyNames(41)="Select"
    KeyNames(42)="Print"
    KeyNames(43)="Execute"
    KeyNames(44)="PrintScrn"
    KeyNames(45)="Insert"
    KeyNames(46)="Delete"
    KeyNames(47)="Help"
    KeyNames(48)="0"
    KeyNames(49)="1"
    KeyNames(50)="2"
    KeyNames(51)="3"
    KeyNames(52)="4"
    KeyNames(53)="5"
    KeyNames(54)="6"
    KeyNames(55)="7"
    KeyNames(56)="8"
    KeyNames(57)="9"
    KeyNames(58)="Unknown3A"
    KeyNames(59)="Unknown3B"
    KeyNames(60)="Unknown3C"
    KeyNames(61)="Unknown3D"
    KeyNames(62)="Unknown3E"
    KeyNames(63)="Unknown3F"
    KeyNames(64)="Unknown40"
    KeyNames(65)="A"
    KeyNames(66)="B"
    KeyNames(67)="C"
    KeyNames(68)="D"
    KeyNames(69)="E"
    KeyNames(70)="F"
    KeyNames(71)="G"
    KeyNames(72)="H"
    KeyNames(73)="I"
    KeyNames(74)="J"
    KeyNames(75)="K"
    KeyNames(76)="L"
    KeyNames(77)="M"
    KeyNames(78)="N"
    KeyNames(79)="O"
    KeyNames(80)="P"
    KeyNames(81)="Q"
    KeyNames(82)="R"
    KeyNames(83)="S"
    KeyNames(84)="T"
    KeyNames(85)="U"
    KeyNames(86)="V"
    KeyNames(87)="W"
    KeyNames(88)="X"
    KeyNames(89)="Y"
    KeyNames(90)="Z"
    KeyNames(91)="Unknown5B"
    KeyNames(92)="Unknown5C"
    KeyNames(93)="Unknown5D"
    KeyNames(94)="Unknown5E"
    KeyNames(95)="Unknown5F"
    KeyNames(96)="NumPad0"
    KeyNames(97)="NumPad1"
    KeyNames(98)="NumPad2"
    KeyNames(99)="NumPad3"
    KeyNames(100)="NumPad4"
    KeyNames(101)="NumPad5"
    KeyNames(102)="NumPad6"
    KeyNames(103)="NumPad7"
    KeyNames(104)="NumPad8"
    KeyNames(105)="NumPad9"
    KeyNames(106)="GreyStar"
    KeyNames(107)="GreyPlus"
    KeyNames(108)="Separator"
    KeyNames(109)="GreyMinus"
    KeyNames(110)="NumPadPeriod"
    KeyNames(111)="GreySlash"
    KeyNames(112)="F1"
    KeyNames(113)="F2"
    KeyNames(114)="F3"
    KeyNames(115)="F4"
    KeyNames(116)="F5"
    KeyNames(117)="F6"
    KeyNames(118)="F7"
    KeyNames(119)="F8"
    KeyNames(120)="F9"
    KeyNames(121)="F10"
    KeyNames(122)="F11"
    KeyNames(123)="F12"
    KeyNames(124)="F13"
    KeyNames(125)="F14"
    KeyNames(126)="F15"
    KeyNames(127)="F16"
    KeyNames(128)="F17"
    KeyNames(129)="F18"
    KeyNames(130)="F19"
    KeyNames(131)="F20"
    KeyNames(132)="F21"
    KeyNames(133)="F22"
    KeyNames(134)="F23"
    KeyNames(135)="F24"
    KeyNames(136)="Unknown88"
    KeyNames(137)="Unknown89"
    KeyNames(138)="Unknown8A"
    KeyNames(139)="Unknown8B"
    KeyNames(140)="Unknown8C"
    KeyNames(141)="Unknown8D"
    KeyNames(142)="Unknown8E"
    KeyNames(143)="Unknown8F"
    KeyNames(144)="NumLock"
    KeyNames(145)="ScrollLock"
    KeyNames(146)="Unknown92"
    KeyNames(147)="Unknown93"
    KeyNames(148)="Unknown94"
    KeyNames(149)="Unknown95"
    KeyNames(150)="Unknown96"
    KeyNames(151)="Unknown97"
    KeyNames(152)="Unknown98"
    KeyNames(153)="Unknown99"
    KeyNames(154)="Unknown9A"
    KeyNames(155)="Unknown9B"
    KeyNames(156)="Unknown9C"
    KeyNames(157)="Unknown9D"
    KeyNames(158)="Unknown9E"
    KeyNames(159)="Unknown9F"
    KeyNames(160)="LShift"
    KeyNames(161)="RShift"
    KeyNames(162)="LControl"
    KeyNames(163)="RControl"
    KeyNames(164)="UnknownA4"
    KeyNames(165)="UnknownA5"
    KeyNames(166)="UnknownA6"
    KeyNames(167)="UnknownA7"
    KeyNames(168)="UnknownA8"
    KeyNames(169)="UnknownA9"
    KeyNames(170)="UnknownAA"
    KeyNames(171)="UnknownAB"
    KeyNames(172)="UnknownAC"
    KeyNames(173)="UnknownAD"
    KeyNames(174)="UnknownAE"
    KeyNames(175)="UnknownAF"
    KeyNames(176)="UnknownB0"
    KeyNames(177)="UnknownB1"
    KeyNames(178)="UnknownB2"
    KeyNames(179)="UnknownB3"
    KeyNames(180)="UnknownB4"
    KeyNames(181)="UnknownB5"
    KeyNames(182)="UnknownB6"
    KeyNames(183)="UnknownB7"
    KeyNames(184)="UnknownB8"
    KeyNames(185)="UnknownB9"
    KeyNames(186)="Semicolon"
    KeyNames(187)="Equals"
    KeyNames(188)="Comma"
    KeyNames(189)="Minus"
    KeyNames(190)="Period"
    KeyNames(191)="Slash"
    KeyNames(192)="Tilde"
    KeyNames(193)="UnknownC1"
    KeyNames(194)="UnknownC2"
    KeyNames(195)="UnknownC3"
    KeyNames(196)="UnknownC4"
    KeyNames(197)="UnknownC5"
    KeyNames(198)="UnknownC6"
    KeyNames(199)="UnknownC7"
    KeyNames(200)="Joy1"
    KeyNames(201)="Joy2"
    KeyNames(202)="Joy3"
    KeyNames(203)="Joy4"
    KeyNames(204)="Joy5"
    KeyNames(205)="Joy6"
    KeyNames(206)="Joy7"
    KeyNames(207)="Joy8"
    KeyNames(208)="Joy9"
    KeyNames(209)="Joy10"
    KeyNames(210)="Joy11"
    KeyNames(211)="Joy12"
    KeyNames(212)="Joy13"
    KeyNames(213)="Joy14"
    KeyNames(214)="Joy15"
    KeyNames(215)="Joy16"
    KeyNames(216)="UnknownD8"
    KeyNames(217)="UnknownD9"
    KeyNames(218)="UnknownDA"
    KeyNames(219)="LeftBracket"
    KeyNames(220)="Backslash"
    KeyNames(221)="RightBracket"
    KeyNames(222)="SingleQuote"
    KeyNames(223)="UnknownDF"
    KeyNames(224)="JoyX"
    KeyNames(225)="JoyY"
    KeyNames(226)="JoyZ"
    KeyNames(227)="JoyR"
    KeyNames(228)="MouseX"
    KeyNames(229)="MouseY"
    KeyNames(230)="MouseZ"
    KeyNames(231)="MouseW"
    KeyNames(232)="JoyU"
    KeyNames(233)="JoyV"
    KeyNames(234)="UnknownEA"
    KeyNames(235)="UnknownEB"
    KeyNames(236)="MouseWheelUp"
    KeyNames(237)="MouseWheelDown"
    KeyNames(238)="Unknown10E"
    KeyNames(239)="Unknown10F"
    KeyNames(240)="JoyPovUp"
    KeyNames(241)="JoyPovDown"
    KeyNames(242)="JoyPovLeft"
    KeyNames(243)="JoyPovRight"
    KeyNames(244)="UnknownF4"
    KeyNames(245)="UnknownF5"
    KeyNames(246)="Attn"
    KeyNames(247)="CrSel"
    KeyNames(248)="ExSel"
    KeyNames(249)="ErEof"
    KeyNames(250)="Play"
    KeyNames(251)="Zoom"
    KeyNames(252)="NoName"
    KeyNames(253)="PA1"
    KeyNames(254)="OEMClear"
    KeyNames(255)="MAX"
    AliasNames(1)="Fire"
    AliasNames(2)="MoveForward"
    AliasNames(3)="MoveBackward"
    AliasNames(4)="StrafeLeft"
    AliasNames(5)="StrafeRight"
    AliasNames(6)="Jump"
    AliasNames(7)="InventoryActivate"
    MaxMenuString="Move Backward         LeftMouse"
    MenuLength=10
    MenuList(1)="Fire"
    MenuList(2)="Move Forward"
    MenuList(3)="Move Backward"
    MenuList(4)="Step Left"
    MenuList(5)="Step Right"
    MenuList(6)="Jump/Up"
    MenuList(7)="Activate Item"
    MenuList(8)="Mouse Sensitivity"
    MenuList(9)="Invert Mouse"
    MenuList(10)="RESET TO DEFAULTS"
    MenuTitle="CONTROLS"
}