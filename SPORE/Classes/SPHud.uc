//================================================================================
// SPHud.
//================================================================================
class SPHud expands HUD
	config(User);

var() localized string MessageList[240];
var int History[20];
var int NumMessages;
var int CurMessage;
var bool bShowMessage;
var bool bShowStunGraphic;
var Texture StunGraphic;
var float StunSizeX;
var float StunSizeY;
var float StunPosX;
var float StunPosY;
var float ClipX;
var float ClipY;
var Font MessageFont;

simulated function CreateMenu ()
{
	if ( PlayerPawn(Owner).bSpecialMenu && (PlayerPawn(Owner).SpecialMenu != None) )
	{
		MainMenu=Spawn(PlayerPawn(Owner).SpecialMenu,self);
		PlayerPawn(Owner).bSpecialMenu=False;
	}
	if ( MainMenu == None )
	{
		MainMenu=Spawn(MainMenuType,self);
	}
	if ( MainMenu == None )
	{
		PlayerPawn(Owner).bShowMenu=False;
		Level.bPlayersOnly=False;
		return;
	}
	else
	{
		MainMenu.PlayerOwner=PlayerPawn(Owner);
	}
}

simulated function HUDSetup (Canvas Canvas)
{
	Canvas.Reset();
	Canvas.SpaceX=0.00;
	Canvas.bNoSmooth=True;
	Canvas.DrawColor.R=255;
	Canvas.DrawColor.G=255;
	Canvas.DrawColor.B=255;
	Canvas.Font=Canvas.LargeFont;
}

simulated function DrawCrossHair (Canvas Canvas, int StartX, int StartY)
{
	Canvas.SetPos(StartX,StartY);
	Canvas.Style=2;
	Canvas.DrawIcon(Texture'Crosshair',1.00);
	Canvas.Style=1;
}

simulated function DisplayProgressMessage (Canvas Canvas)
{
	Canvas.DrawColor.R=255;
	Canvas.DrawColor.G=255;
	Canvas.DrawColor.B=255;
	Canvas.SetPos(0.00,0.25 * Canvas.ClipY);
	Canvas.bCenter=True;
	Canvas.Font=Font'SPMediumFont';
	Canvas.SetPos(0.00,0.25 * Canvas.ClipY + 12);
	Canvas.bCenter=False;
}

simulated function PostRender (Canvas Canvas)
{
	local PlayerPawn Player;

	HUDSetup(Canvas);
	Canvas.Style=1;
	Player=PlayerPawn(Owner);
	if ( Player != None )
	{
		if ( Player.bShowMenu )
		{
			if ( MainMenu == None )
			{
				CreateMenu();
			}
			if ( MainMenu != None )
			{
				MainMenu.DrawMenu(Canvas);
			}
			return;
		}
		else
		{
			if ( PlayerPawn(Owner).bShowScores )
			{
				if ( (PlayerPawn(Owner).Weapon != None) &&  !PlayerPawn(Owner).Weapon.bOwnsCrosshair )
				{
					DrawCrossHair(Canvas,0.50 * Canvas.ClipX - 8,0.50 * Canvas.ClipY - 8);
					DrawInventory(Canvas,Canvas.ClipX - 96,0,True);
				}
				if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
				{
					PlayerPawn(Owner).Scoring=Spawn(PlayerPawn(Owner).ScoringType,PlayerPawn(Owner));
				}
				if ( PlayerPawn(Owner).Scoring != None )
				{
					PlayerPawn(Owner).Scoring.ShowScores(Canvas);
					return;
				}
			}
		}
		DrawInventory(Canvas,Canvas.ClipX - 96,0,True);
		DrawCrossHair(Canvas,0.50 * Canvas.ClipX - 8,0.50 * Canvas.ClipY - 8);
		if ( Player.ProgressTimeOut > Level.TimeSeconds )
		{
			DisplayProgressMessage(Canvas);
		}
		if ( SPFlyer(Player.Base) != None )
		{
			Canvas.SetPos(20.00,20.00);
			Canvas.Font=Canvas.MedFont;
			Canvas.DrawText("RIDING THE FLYER: FUEL = " $ string(SPFlyer(Player.Base).fuel),False);
		}
		if ( bShowMessage )
		{
			DrawMessage(Canvas);
		}
		if ( bShowStunGraphic )
		{
			DrawStunGraphic(Canvas);
		}
	}
}

simulated event Timer ()
{
	if ( bShowMessage )
	{
		bShowMessage=False;
		PlaySound(Sound'message2',0);
	}
	if ( bShowStunGraphic )
	{
		bShowStunGraphic=False;
	}
}

simulated function ShowStunGraphic ()
{
	StunGraphic=Texture(DynamicLoadObject("Spore.stuntxt" $ string(Rand(5) + 1),Class'Texture'));
	bShowStunGraphic=True;
	StunSizeX=0.30 + 0.30 * FRand();
	StunSizeY=0.30 + 0.30 * FRand();
	StunPosX=(1.00 - StunSizeX) * FRand();
	StunPosY=(1.00 - StunSizeY) * FRand();
	SetTimer(1.00,False);
}

simulated function StartMessage (int Num)
{
	local int i;
	local bool bInList;

	i=0;
JL0007:
	if ( i < NumMessages )
	{
		if ( History[i] == Num )
		{
			CurMessage=i;
			bInList=True;
		}
		else
		{
			i++;
			goto JL0007;
		}
	}
	if (  !bInList )
	{
		if ( NumMessages < 20 )
		{
			History[NumMessages]=Num;
			NumMessages++;
			CurMessage=NumMessages - 1;
		}
		else
		{
			i=0;
JL0092:
			if ( i < 19 )
			{
				History[i]=History[i + 1];
				i++;
				goto JL0092;
			}
			History[19]=Num;
			CurMessage=19;
		}
	}
	PlaySound(Sound'message1',0);
	bShowMessage=True;
	SetTimer(7.00,False);
}

simulated function ToggleMessage ()
{
	bShowMessage= !bShowMessage;
	if ( bShowMessage )
	{
		PlaySound(Sound'message1',0);
	}
	else
	{
		PlaySound(Sound'message2',0);
	}
}

simulated function NextMessage ()
{
	bShowMessage=True;
	CurMessage++;
	if ( CurMessage >= NumMessages )
	{
		CurMessage=0;
	}
	PlaySound(Sound'message4',0);
}

simulated function PrevMessage ()
{
	bShowMessage=True;
	CurMessage--;
	if ( CurMessage < 0 )
	{
		CurMessage=NumMessages - 1;
	}
	PlaySound(Sound'message3',0);
}

simulated function DrawMessage (Canvas C)
{
	local int x1;
	local int y1;
	local int x2;
	local int y2;
	local int boxW;
	local int boxH;
	local int textOffsetX;
	local int textOffsetY;
	local float xSize;
	local float ySize;
	local float saveOriginX;
	local float SaveOriginY;
	local float saveClipX;
	local float saveClipY;
	local bool bFontFits;
	local int i;

	saveOriginX=C.OrgX;
	SaveOriginY=C.OrgY;
	saveClipX=C.ClipX;
	saveClipY=C.ClipY;
	textOffsetX=C.ClipX * 0.03;
	textOffsetY=C.ClipY * 0.03;
	boxW=0.60 * C.ClipX;
	boxH=0.25 * C.ClipY;
	x1=(C.ClipX - boxW) / 2;
	x2=C.ClipX - x1;
	y1=0.10 * C.ClipY;
	y2=y1 + boxH;
	C.Style=4;
	C.SetPos(x1,y1);
	C.DrawRect(Texture'MessageBox',x2 - x1,y2 - y1);
	C.Style=1;
	C.SetPos(x1,y1);
	C.DrawRect(Texture'MBoxFrame',x2 - x1,y2 - y1);
	if ( NumMessages > 0 )
	{
		C.bCenter=False;
		C.SetOrigin(x1 + textOffsetX,y1 + textOffsetY);
		C.SetClip(boxW - textOffsetX * 2,boxH - textOffsetY * 2);
		C.SetPos(0.00,0.00);
		C.Style=1;
		if ( (ClipX != C.ClipX) || (ClipY != C.ClipY) )
		{
			ClipX=C.ClipX;
			ClipY=C.ClipY;
			bFontFits=True;
			C.Font=Font'MBoxFontLarge';
			i=0;
JL02FD:
			if ( i < 240 )
			{
				C.StrLen(MessageList[i],xSize,ySize);
				if ( (xSize > boxW - textOffsetX * 2) || (ySize > boxH - textOffsetY * 2) )
				{
					bFontFits=False;
				}
				else
				{
					i++;
					goto JL02FD;
				}
			}
			if (  !bFontFits )
			{
				bFontFits=True;
				C.Font=Font'SPMediumFont';
				i=0;
JL03A5:
				if ( i < 240 )
				{
					C.StrLen(MessageList[i],xSize,ySize);
					if ( (xSize > boxW - textOffsetX * 2) || (ySize > boxH - textOffsetY * 2) )
					{
						bFontFits=False;
					}
					else
					{
						i++;
						goto JL03A5;
					}
				}
			}
			if (  !bFontFits )
			{
				bFontFits=True;
				C.Font=Font'SPSmallFont';
				i=0;
JL044D:
				if ( i < 240 )
				{
					C.StrLen(MessageList[i],xSize,ySize);
					if ( (xSize > boxW - textOffsetX * 2) || (ySize > boxH - textOffsetY * 2) )
					{
						bFontFits=False;
					}
					else
					{
						i++;
						goto JL044D;
					}
				}
			}
			MessageFont=C.Font;
			if (  !bFontFits )
			{
				Log(string(self) $ "::DrawMessage <ERROR> Couldn't fit message into box!!!");
			}
		}
		C.Font=MessageFont;
		C.DrawText(MessageList[History[CurMessage]],False);
	}
	C.SetOrigin(saveOriginX,SaveOriginY);
	C.SetClip(saveClipX,saveClipY);
}

simulated function DrawStunGraphic (Canvas C)
{
	local int x1;
	local int y1;

	x1=StunPosX * C.ClipX;
	y1=StunPosY * C.ClipY;
	C.Style=2;
	C.SetPos(x1,y1);
	C.DrawRect(StunGraphic,StunSizeX * C.ClipX,StunSizeY * C.ClipY);
}

simulated function DrawInventory (Canvas Canvas, int X, int Y, bool bDrawOne)
{
	local bool bGotNext;
	local bool bGotPrev;
	local bool bGotSelected;
	local Inventory Inv;
	local Inventory Prev;
	local Inventory Next;
	local Inventory SelectedItem;
	local int TempX;
	local int TempY;
	local int HalfHUDX;
	local int HalfHUDY;
	local int AmmoIconSize;
	local int i;

	if ( Owner.Inventory == None )
	{
		return;
	}
	bGotSelected=False;
	bGotNext=False;
	bGotPrev=False;
	Prev=None;
	Next=None;
	SelectedItem=Pawn(Owner).SelectedItem;
	Inv=Owner.Inventory;
JL0069:
	if ( Inv != None )
	{
		if (  !bDrawOne )
		{
			if ( Inv == SelectedItem )
			{
				bGotSelected=True;
			}
			else
			{
				if ( Inv.bActivatable )
				{
					if ( bGotSelected )
					{
						if (  !bGotNext )
						{
							Next=Inv;
							bGotNext=True;
						}
						else
						{
							if (  !bGotPrev )
							{
								Prev=Inv;
							}
						}
					}
					else
					{
						if ( Next == None )
						{
							Next=Prev;
						}
						Prev=Inv;
						bGotPrev=True;
					}
				}
			}
		}
		Inv=Inv.Inventory;
		goto JL0069;
	}
	if ( SelectedItem != None )
	{
		if ( Prev != None )
		{
			if (! Prev.bActive ) goto JL0156;
JL0156:
			DrawHudIcon(Canvas,X,Y,Prev);
		}
		if ( SelectedItem.Icon != None )
		{
			if ( SelectedItem.bActive )
			{
				SelectedItem.Icon=Texture'veston';
			}
			else
			{
				SelectedItem.Icon=Texture'vestoff';
			}
			if ( (Next == None) && (Prev == None) &&  !bDrawOne )
			{
				DrawHudIcon(Canvas,X + 64,Y,SelectedItem);
			}
			else
			{
				DrawHudIcon(Canvas,X + 32,Y,SelectedItem);
			}
			Canvas.Style=2;
			Canvas.CurX=X + 32;
			if ( (Next == None) && (Prev == None) &&  !bDrawOne )
			{
				Canvas.CurX=X + 64;
			}
			Canvas.CurY=Y;
			Canvas.Style=1;
		}
		if ( Next != None )
		{
			if (! Next.bActive ) goto JL02D0;
JL02D0:
			DrawHudIcon(Canvas,X + 64,Y,Next);
		}
	}
}

simulated function DrawHudIcon (Canvas Canvas, int X, int Y, Inventory Item)
{
	local int Width;

	if ( Item.Icon == None )
	{
		return;
	}
	Width=Canvas.CurX;
	Canvas.CurX=X;
	Canvas.CurY=Y;
	Canvas.DrawRect(Item.Icon,32.00,32.00);
	Canvas.CurX -= 30;
	Canvas.CurY += 28;
	if ( (HudMode != 2) && (HudMode != 4) && (HudMode != 1) ||  !Item.bIsAnArmor )
	{
		Canvas.DrawTile(Texture'HudLine',FMin(27.00,27.00 * Item.Charge / Item.Default.Charge),2.00,0.00,0.00,32.00,2.00);
	}
	Canvas.CurX=Width + 32;
}

defaultproperties
{
    MessageList(0)="CHECK IT OUT! I CAN SEND YOU MESSAGES THROUGHT THE BASE COMPUTER SYSTEM!"
    MessageList(1)="USE THE 'PAGE UP' KEY ON YOUR KEYBOARD TO READ MY OLDER MESSAGES."
    MessageList(2)="TO OPEN THE DOOR, YOU'LL NEED TO FLIP THE SWITCH ON TOP OF THOSE CRATES."
    MessageList(3)="I'VE LEFT YOU A LITTLE PRESENT UP THERE, TOO."
    MessageList(4)="WITH THIS 'HELPING HAND', YOU'LL BE ABLE TO GET OUT OF STICKY SITUATIONS."
    MessageList(5)="YOU'LL NEED TO GET TO THE EXIT UP HIGH. USE THESE FLOATING PLATFORMS TO GET THERE."
    MessageList(6)="NICE WORK!"
    MessageList(7)="FLIP THE SWITCH TO OPEN THE DOOR."
    MessageList(8)="TO USE THE 'GEL-O-VATORS', LOOK DOWN AND MOVE FORWARD. SWIM WHERE YOU NEED TO GO!"
    MessageList(9)="BE SURE TO AVOID BEING HIT BY THOSE STUN MISSILES!"
    MessageList(10)="THESE DRONES ARE HARMLESS. NOTICE THEIR MOVEMENT, YOU'LL NEED THEM LATER."
    MessageList(11)="THESE PLATFORMS WILL MOVE BACK TO THEIR ORIGINAL PLACE AFTER A FEW SECONDS. DON'T LAG."
    MessageList(12)="IF YOU GET STUCK, JUST JUMP BACK TO THE FLOOR. YOU WON'T GET HURT. I HOPE..."
    MessageList(13)="USE THE HELPING HAND TO MOVE WALL BLOCKS UP AND DOWN."
    MessageList(14)="HIT ONE OF THE LARGE BUTTONS TO CALL OUT A DRONE. I SUGGEST ONLY CALLING ONE."
    MessageList(15)="GET A DRONE INTO THE CENTER TO LOWER THE BRIDGE."
    MessageList(16)="NOW, HIT YOUR 'E' KEY TO ACTIVATE YOUR ATTRACTOR VEST. HIT IT AGAIN TO STOP FLYING."
    MessageList(17)="LOOK AT THE ATTRACTOR ORB UP IN THE CENTER OF THE DOME. USE THE HELPING HAND TO TURN IT OFF AND ON."
    MessageList(18)="WHEN YOUR VEST IS ON AND THE ATTRACTOR ORB IS ON, YOU SHOULD BE FLYING TOWARDS THE ORB."
    MessageList(19)="HIT YOUR 'E' KEY TO DEACTIVATE YOUR VEST AGAIN. A QUICK WAY TO STOP YOUR FLIGHT."
    MessageList(20)="YOU'LL NEED TO PUSH THE COLORED BALLS IN THE CENTER OF THE ROOM INTO THE CORRESPONDING COLORED BIN."
    MessageList(21)="AVOID THE DRONES, THEY'LL KNOCK BALLS AROUND. YOU, TOO."
    MessageList(22)="CHECK THE TOWER NEXT TO THE EXIT TO SEE WHICH BINS YOU'VE FILLED."
    MessageList(23)="CHOOSE A DOOR."
    MessageList(24)="AVOID BEING HIT BY THESE BALLS. THEY MAY LOOK FRIENDLY, BUT THEY PACK A WALLOP."
    MessageList(25)="YOU JUST NEED TO MAKE IT TO THE EXIT UP TOP IN ONE PIECE."
    MessageList(26)="USE THE PLATFORMS TO GET TO THE UPPER LEVELS."
    MessageList(27)="YOU'VE FOUND THE HIDDEN TURTLE TANK!"
    MessageList(28)="WHAT'S THIS? THIS ISN'T ON THE MAP."
    MessageList(29)="WHEN YOU'RE DONE SWIMMING, USE THE BACK DOOR TO GET BACK TO THE MISSION."
    MessageList(30)="USE THE HELPING HAND TO TURN THE FLOATING ATTRACTOR ORB ON AND OFF."
    MessageList(31)="PUSH THE LARGE BUTTONS TO LAUNCH BALLS. NOTICE HOW BALLS ARE AFFECTED BY TURNING ATTRACTOR BALLS ON."
    MessageList(32)="USE THE ATTRACTOR ORBS TO DIRECT BALLS INTO THEIR PROPER COLORED BINS."
    MessageList(33)="USE THE HELPING HAND TO MOVE THE RED FLOOR TILES UP AND DOWN."
    MessageList(34)="USE THE RED FLOOR TILES TO REDIRECT DRONES INTO THEIR PROPER COLORED BINS."
    MessageList(35)="YOU ONLY NEED TO GET ONE DRONE INTO EACH BIN."
    MessageList(36)="FILL ALL THE BINS TO OPEN THE FORCE FIELD AND FIND YOUR WAY OUT."
    MessageList(37)="CHECK THE PROGRESS TOWER TO SEE HOW YOU'RE DOING."
    MessageList(38)="FLIP THE SWITCHES IN THE CENTER OF THE ROOM TO RAISE AND LOWER THE COLORED PANELS."
    MessageList(39)="FIND THE CORRECT COMBINATION OF SWITCHES TO DISABLE THE DEFENSES AND OPEN THE EXIT."
    MessageList(40)="AS ALWAYS, AVOID THE MISSILES."
    MessageList(41)="THESE PORTALS CAN BE CONFUSING, SO PAY ATTENTION."
    MessageList(42)="SEE THE ENERGY BEAM ON TOP OF THE PORTAL? NOTICE IT'S ATTACHED TO ANOTHER PORTAL ON THE OTHER SIDE."
    MessageList(43)="BY WALKING THROUGH THE PORTAL, YOU ARE ZAPPING TO THAT OTHER PORTAL ON THE OTHER SIDE."
    MessageList(44)="PRETTY COOL, EH?"
    MessageList(45)="JUST FOLLOW THE BEAMS CONNECTING THE PORTALS AND YOU SHOULD FIND THE SWITCH WE NEED."
    MessageList(46)="ONCE YOU FLIP THE SWITCH, JUMP DOWN AND FIND THE EXIT."
    MessageList(47)="YOU'RE DOING FINE. KEEP IT UP!"
    MessageList(48)="GREAT JOB!"
    MessageList(49)="WAY TO GO!"
    MessageList(50)="LET'S GET GOING."
    MessageList(51)="IF YOU GET LOST, YOU CAN ALWAYS JUMP DOWN AND START OVER."
    MessageList(52)="RUN AND JUMP ON THE TRAMPOLINE TO SOAR THROUGH THE AIR."
    MessageList(53)="USE THE MISSILE TURRETS AGAINST EACH OTHER. HIDE BEHIND ONE AND RUN ONCE IT FIRES. DON'T GET TOO CLOSE!"
    MessageList(54)="TRY TO GET TO THE EXIT UP TOP."
    MessageList(55)="USE THE PLATFORMS AND GEL-O-VATORS TO GET TO THE SECURITY SHIELD SWITCH."
    MessageList(56)="DISABLE THE SECURITY SHIELD TO GET OUT THE EXIT."
    MessageList(57)="WATCH YOUR STEP."
    MessageList(58)="USE THE HELPING HAND TO RAISE AND LOWER THE WALL BLOCKS."
    MessageList(59)="GET THE DRONES INTO THE CENTER AREA TO UNLOCK THE EXIT."
    MessageList(60)="YOU MUST FLIP THE MAIN CONSOLE SWITCH ON THE HEAVILY GUARDED CENTER PILLAR."
    MessageList(61)="FLIP THE SWITCH THEN MAKE YOUR WAY TO THE EXIT."
    MessageList(62)="FIND A PATH WITH THE PLATFORMS."
    MessageList(63)="UH, THIS ONE LOOKS BROKEN."
    MessageList(64)="DO YOURSELF A FAVOR AND AVOID THE GUARDS."
    MessageList(65)="STEP ONTO THE BASE-PLATES UNDER THE TURRETS TO TAKE CONTROL OF THEM."
    MessageList(66)="USE YOUR FIRE BUTTON TO LAUNCH A BALL."
    MessageList(67)="USE THE DEFLECTORS TO GET BALLS INTO THE PROPER COLORED BINS."
    MessageList(68)="RAISE ALL FOUR BINS AND GET OUT OF HERE!"
    MessageList(69)="HIT THE 'E' KEY ON YOUR KEYBOARD TO ACTIVATE AND DEACTIVATE YOUR ATTRACTOR VEST."
    MessageList(70)="YOU CAN SLOWLY MOVE WHEN FLYING BY USING YOUR MOVEMENT KEYS."
    MessageList(71)="SHOOTING THE ATTRACTOR ORBS WITH YOUR HELPING HAND WILL TURN THEM ON AND OFF."
    MessageList(72)="FLY THROUGH THE FOUR CENTER RINGS TO DISABLE THE CLOAKING DEVICE."
    MessageList(73)="RIDE THESE ELEVATORS TO GET BACK DOWN TO THE EXIT."
    MessageList(74)="TRY TO GET THE COLORED BALLS THROUGH THE PIPES DOWN INTO THE PROPER COLORED BINS."
    MessageList(75)="FLIP THESE SWITCHES TO CHANGE THE DIRECTION BALLS WILL GO."
    MessageList(76)="CHECK THE PROGRESS TOWER TO SEE WHAT YOU STILL NEED TO GET."
    MessageList(77)="MOVE WALLS TO DEFLECT THE DRONE INTO THE CENTER OF THE MAZE."
    MessageList(78)="USE THIS BUTTON TO CALL A DRONE."
    MessageList(79)="USE A SHOT FROM THE HELPING HAND TO TURN ATTRACTOR BALLS OFF AND ON."
    MessageList(80)="FLIP THIS SWITCH TO RAISE THE BRIDGE- BUT DON'T RUN ACROSS UNTIL YOU'VE TAKEN OUT ALL THE MISSILE TURRETS!"
    MessageList(81)="USE THE PLATFORM NEAR THE ENTRANCE TO GET BACK UP."
    MessageList(82)="THE OUTSIDE TURRETS WILL SHOOT BALLS. DIRECT THEM WITH THE ATTRACTOR ORBS TO TAKE OUT THE INNER MISSILE TURRETS."
    MessageList(83)="BE CAREFUL, THERE ARE GUARDS EVERYWHERE."
    MessageList(84)="THERE IS A COMPUTER SOMEWHERE IN THIS CRAZY COMPLEX. TAKE IT OUT WITH YOUR HELPING HAND AND FIND THE WAY OUT."
    MessageList(85)="LOOK OUT FOR GUARDS AND TURRETS AROUND EVERY CORNER!"
    MessageList(86)="STEP UP TO THE SECURITY MONITOR TO GET A BIRD'S EYE VIEW."
    MessageList(87)="FIND A PATH TO THE EXIT BY RIDING THE PLATFORMS."
    MessageList(88)="AT LEAST YOU CAN'T GET STUCK OUT HERE."
    MessageList(89)="FIND A POSITION WHERE THE TURRETS WILL DESTROY EACH OTHER."
    MessageList(90)="YOU WON'T BE ABLE TO GET THEM ALL, BUT YOU CAN CLEAR A WIDE PATH."
    MessageList(91)="FIND THE EXIT. YOU'LL HAVE TO TIME THE JUMPS O AVOID GETTING SQUASHED."
    MessageList(92)="FOLLOW THE ARROWS AND JUMP THROUGH THE PORTAL TO GET BACK UP."
    MessageList(93)="TIME YOUR JUMP RIGHT. ONE FALSE MOVE AND THE GROUND WILL COME TO MEET YOU."
    MessageList(94)="LOOK OUT FOR BEEFED UP SECURITY IN THIS AREA."
    MessageList(95)="WATCH FOR FLYING MISSILES!"
    MessageList(96)="THRUSTER 3 NEEDS TO BE SHUT DOWN. FIND THE COMPUTER AND TAKE IT OUT!"
    MessageList(97)="CRAVEN IS IN HIS OFFICE UP TOP. YOU NEED TO GET HIM."
    MessageList(98)="PUSH THE FIRE BUTTON TO SEE THE AFFECTS OF THE ATTRACTOR ORB. THE BALL WILL BE ATTRACTED BY THE ATTRACTOR ORB."
    MessageList(99)="CLIMB THE STAIRS IN FRONT OF YOU TO GET TO THE FIRE BUTTON."
    MessageList(100)="DON'T FORGET TO FLIP THE SWITCH. WHEN YOU'RE DONE, JUMP DOWN TO THE NEXT RED CROSS AND PREPARE FOR FLIGHT."
    MessageList(101)="YOU'LL NEED TO FLIP THREE SWITCHES UP IN THE LOFTS TO OPEN THE EXIT."
    MessageList(102)="DON'T FORGET TO FLIP THE EXIT SWITCH."
    MessageList(103)="USE THE LEFT MOUSE BUTTON TO FIRE THE HELPING HAND."
    MessageList(104)="HIT F1 TO BRING UP OLD MESSAGES."
    MessageList(105)="USE THE HELPING HAND ON VERTICAL WALL TO FORM BRIDGE."
    MessageList(106)="GRAB THIS ATTRACTOR VEST. WITH IT YOU CAN LEARN TO FLY."
    MessageList(107)="ATTRACTOR ORBS TURN OFF WHEN YOUR BODY HITS THEM. USE YOUR HELPING HAND TO TURN IT BACK ON."
    MessageList(108)="YOU NEED TO FIND AND FLIP THREE SWITCHES TO OPEN THE EXIT."
    MessageList(109)="LOOKS LIKE YOU'LL NEED TO DO SOME REDECORATING. USE YOUR HELPING HAND ON THAT COMPUTER BLOCKING YOUR PATH."
    MessageList(110)="QUICK NOTE: TO QUICKSAVE, HIT THE F6 KEY ON YOUR KEYBOARD. TO QUICKLY RESTORE THE LAST QUICK-SAVED GAME, HIT F8."
    MessageList(111)="WATCH WHERE YOU'RE GOING. THIS IS A SECURE AREA. GUARDS RUN AMUCK."
    MessageList(112)="THERE'S A GUARD NOW. WITH HIS BACK TURNED, IT'S SAFE TO SNEAK BY, BUT WATCH WHERE YOU'RE GOING!"
    MessageList(113)="GET BACK ON TRACK. THE EXIT IS UP HIGH."
    MessageList(114)="WAY TO GO!"
    MessageList(115)="THIS ROOM IS FILLED WITH ROCKET TURRETS. AVOID THE ROCKETS AT ALL COSTS!"
    MessageList(116)="WATCH THAT RED CIRCLE ON THE FLOOR. ANYTHING THAT WALKS INTO WILL BE FIRED AT."
    MessageList(117)="THESE ARE HOMING ROCKETS, WHICH MEANS THEY WILL FOLLOW YOU."
    MessageList(118)="TRY TO GET A ROCKET TO TAKE OUT ITS OWN TURRET BY RUNNING AROUND IT."
    MessageList(119)="IT'S TRICKY, BUT YOU CAN DO IT!"
    MessageList(120)="REMEMBER THAT YOU CAN HIT F6 TO QUICKSAVE. F8 WILL RELOAD THE LAST QUICK-SAVED GAME."
    MessageList(121)="YOU NEED TO DISTRACT THE TURRET SO THE YELLOW DRONE CAN GET THROUGH."
    MessageList(122)="USE THE BLOCKING WALLS TO DIVERT DRONES INTO THE PROPER COLORED BINS."
    MessageList(123)="AVOID THE ROCKETS."
    MessageList(124)="USE YOUR HELPING HAND TO MOVE BLOCKING WALLS AND BRIGHT FLOOR PANELS."
    MessageList(125)="THAT'S THE SWITCH PLATFORM- THE ONE WITH CRAVEN'S MUG ON IT."
    MessageList(126)="WELL DONE!"
    MessageList(127)="USE THE MOUSE BUTTON TO FIRE BALLS FROM THE TURRETS."
    MessageList(128)="DEFLECT BALLS WITH THE METAL PLATES ABOVE EACH BIN."
    MessageList(129)="FLY THROUGH ALL THE RED HOOPS TO DEACTIVATE THE BASE CLOAKING SYSTEM."
    MessageList(130)="WITH THESE LIGHT ATTRACTOR ORBS, YOU CAN "
    MessageList(131)="TO OPEN THE EXIT, GET COLORED BALLS FROM THE TOP INTO THE PROPER COLORED BIN BY FLIPPING VALVE SWITCHES."
    MessageList(132)="THE YELLOW ARROWS SHOW THE DIRECTION THE VALVES ARE CURRENTLY ANGLED."
    MessageList(133)="MAKE YOUR WAY THROUGH THESE HALLS, FIND THE THRUSTER COMPUTER, DESTROY IT, THEN MAKE YOUR WAY TO THE EXIT."
    MessageList(134)="USE THESE LOOKOUT SITES TO REFERENCE YOUR LOCATION."
    MessageList(135)="THE RED ARROWS MARK THE LOCATION OF THE EXIT."
    MessageList(136)="AGAIN, FIND THE EXIT SWITCH AND THEN THE EXIT THROUGH THESE PORTALS."
    MessageList(137)="HOP ON THESE PLATFORMS TO CROSS TO THE EXIT."
    MessageList(138)="USE THE SECURITY CAMERA TO PLOT YOUR PATH TO THE EXIT."
    MessageList(139)="GET ROCKETS TO DESTROY TURRETS. LINE 'EM UP, KNOCK 'EM DOWN."
    MessageList(140)="HIT F6 TO QUICKSAVE. I'M NOT SAYING YOU NEED TO... F8 WILL RELOAD THE QUICK-SAVED GAME."
    MessageList(141)="NICE JOB!!!"
    MessageList(142)="FIND THE EXIT. HERE'S A HINT: IT'S UP."
    MessageList(143)="JUST LIKE BEFORE- LAUNCH BALLS INTO THE COLORED BINS."
    MessageList(144)="WHEN YOU'RE DONE, FOLLOW THE RAMP UP TO THE EXIT."
    MessageList(145)="MOVE BLOCKERS UP TO DIVERT DRONES INTO THE RIGHT COLORED BINS."
    MessageList(146)="FIND THE EXIT WITHOUT BEING CAPTURED. SIMPLE."
    MessageList(147)="DIVERT THIS DRONE INTO THE BIN ON THE FAR LEFT. IT WILL TURN RIGHT WHEN IT BUMPS INTO WALLS."
    MessageList(148)="FIRST, FIND THE COMPUTER THAT CONTROLS THRUSTER #2. DESTROY IT. NEXT, FIND THE EXIT AND MOVE ON. BUT, DON'T GET CAUGHT."
    MessageList(149)="USE THE HELPING HAND TO TURN ATTRACTOR ORBS ON AND OFF."
    MessageList(150)="USE THE ATTRACTOR ORBS TO ANGLE BALLS INTO THEIR PROPER COLORED BINS."
    MessageList(151)="DIVERT BALLS THROUGH THE PIPES, ROUTING THEM INTO THEIR PROPER COLORED BINS."
    MessageList(152)="GET THE YELLOW DRONES INTO THE YELLOW BIN SAFELY. WATCH OUT FOR ROCKETS."
    MessageList(153)="TRY TO GET ROCKETS TO DESTROY THE TURRETS. NO VICTIM, NO CRIME, RIGHT?"
    MessageList(154)="MAKE YOUR WAY TO THE EXIT USING THE PLATFORMS. OH, YEAH, AND WATCH FOR GUARDS AND MISSILES."
    MessageList(155)="ROUTE DRONES INTO THE RIGHT COLORED BINS. THESE BINS ARE ON TIMERS, GET THEM IN QUICKLY!"
    MessageList(156)="FIRST FIND THE SWITCHES TO TURN OFF THE TURRETS, THEN MAKE YOUR WAY TO THE EXIT."
    MessageList(157)="FIND A PATH TO THE EXIT BY USING THE TURRETS AGAINST EACH OTHER."
    MessageList(158)="BE CAREFUL OF HOMING ROCKETS."
    MessageList(159)="JUST FIND YOUR WAY TO THE EXIT. UH, OH... WE'VE GOT TROUBLE..."
    MessageList(160)="MAKE YOUR WAY UP TO THE EXIT."
    MessageList(161)="USE YOUR ATTRACTOR VEST TO FLY THROUGH THE HOOP. JUST LIKE A DOG AND PONY SHOW!"
    MessageList(162)="YOU'LL HAVE TO STAY ON THE MOVE TO AVOID BEEFED UP SECURITY. FIND THE EXIT PLATFORM TO UNLOCK THE SECURITY GATE."
    MessageList(163)="TAKE OUT THOSE PESKY TURRETS WITH THE ENERGY BALLS."
    MessageList(164)="I FOUND AN ESCAPE POD. CAPTURE CRAVEN AND I'LL PICK YOU UP AT THE TOP OF THIS DOME."
    MessageList(165)="USE THE FLOOR SPRING BOARDS TO JUMP UP TO THE HIGHER LEVEL. THEY'RE TRICKY, BUT YOU'LL GET IT."
    MessageList(166)="THIS MULTI-COLORED FIRE BUTTON WILL LAUNCH RANDOM COLORED-BALLS. YOU NEVER KNOW WHAT YOU'RE GONNA GET."
    MessageList(167)="EVERYONE WANTS TO BRING DOWN SPORE, BUT THEY ALSO WANT TO PROFIT FROM THE PLANS TO SOME OF SPORE'S MORE IMAGINATIVE PLANS. TRY TO COLLECT MORE PLANS THAN THE OTHER SCIENTIST!"
    MessageList(168)="LINE UP WITH THE GREEN CORRIDOR IN THE CEILING TO AVOID BEING CRUSHED!"
    MessageList(169)="QUICKLY! JUMP IN THE ESCAPE POD AND LET'S GET OUT OF HERE!"
    MainMenuType=Class'SPMainMenu'
}