//================================================================================
// SPConsole.
//================================================================================
class SPConsole expands Console
	transient;

var config string NextLevel;

event PostRender (Canvas C)
{
	local string BigMessage;
	local Font LargeFont;
	local float XL;
	local float YL;
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
	if ( bTimeDemo && (TimeDemo != None) )
	{
		TimeDemo.PostRender(C);
	}
	LargeFont=Font'SPLargeFont';
	if ( Viewport.Actor.bShowMenu )
	{
		BigMessage="";
	}
	else
	{
		if ( NextLevel ~= "The End" )
		{
			BigMessage="";
		}
		else
		{
			if ( Viewport.Actor.Level.LevelAction == 1 )
			{
				DrawLoadingBackGround(C);
				BigMessage=LoadingMessage;
			}
			else
			{
				if ( Viewport.Actor.Level.LevelAction == 2 )
				{
					DrawLoadingBackGround(C);
					BigMessage=SavingMessage;
				}
				else
				{
					if ( Viewport.Actor.Level.LevelAction == 3 )
					{
						DrawLoadingBackGround(C);
						BigMessage=ConnectingMessage;
					}
					else
					{
						if ( Viewport.Actor.Level.Pauser != "" )
						{
							DrawLoadingBackGround(C);
							BigMessage=PausedMessage;
						}
					}
				}
			}
		}
	}
	if ( BigMessage != "" )
	{
		DrawMessage(BigMessage,C);
	}
	if ( ConsoleLines > 0 )
	{
		C.SetOrigin(0.00,ConsoleLines - FrameY * 0.60);
		C.SetPos(0.00,0.00);
		C.DrawTile(ConBackground,FrameX,FrameY * 0.60,C.CurX,C.CurY - FrameY * 0.60,FrameX,FrameY * 0.60);
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

function DrawMessage (string Message, Canvas C)
{
	local float X;
	local float Y;
	local float W;
	local float H;

	W=0.70 * C.ClipX;
	H=0.20 * C.ClipY;
	X=(C.ClipX - W) / 2;
	Y=0.20 * C.ClipY;
	DrawTextBox(Message,X,Y,W,H,C);
	Y=0.50 * C.ClipY;
	DrawTextBox(NextLevel,X,Y,W,H,C);
}

function DrawLoadingBackGround (Canvas Canvas)
{
	local int X;
	local int Y;
	local int xSize;
	local int ySize;
	local float x2;
	local float y2;

	X=0.01 * Canvas.ClipX;
	Y=0.01 * Canvas.ClipY;
	xSize=Canvas.ClipX - 2 * X;
	ySize=Canvas.ClipY - 2 * Y;
	X += BorderPixels;
	Y += BorderLines;
	x2=X + xSize / 2;
	y2=Y + ySize / 2;
	Canvas.SetPos(X,Y);
	Canvas.DrawRect(Texture'LargeBack1',xSize / 2,ySize / 2);
	Canvas.SetPos(x2,Y);
	Canvas.DrawRect(Texture'LargeBack2',xSize / 2,ySize / 2);
	Canvas.SetPos(X,y2);
	Canvas.DrawRect(Texture'LargeBack3',xSize / 2,ySize / 2);
	Canvas.SetPos(x2,y2);
	Canvas.DrawRect(Texture'LargeBack4',xSize / 2,ySize / 2);
}

function DrawTextBox (string Text, float X, float Y, float W, float H, Canvas C)
{
	local float xSize;
	local float ySize;
	local int saveOrgX;
	local int saveOrgY;
	local int saveClipX;
	local int saveClipY;

	saveOrgX=C.OrgX;
	saveOrgY=C.OrgY;
	saveClipX=C.ClipX;
	saveClipY=C.ClipY;
	X += BorderPixels;
	Y += BorderLines;
	C.SetOrigin(X,Y);
	C.SetClip(W,H);
	C.bCenter=True;
	C.Font=Font'SPLargeFont';
	C.StrLen(Text,xSize,ySize);
	if ( (xSize > W) || (ySize > H) )
	{
		C.Font=Font'SPMediumFont';
		C.StrLen(Text,xSize,ySize);
		if ( (xSize > W) || (ySize > H) )
		{
			C.Font=Font'SPSmallFont';
		}
	}
	C.SetPos(0.00,0.00);
	C.DrawText(Text,False);
	C.SetOrigin(saveOrgX,saveOrgY);
	C.SetClip(saveClipX,saveClipY);
}

simulated function DrawConsoleView (Canvas C)
{
	local int Y;
	local int i;
	local int Line;
	local float XL;
	local float YL;

	if ( C.ClipX >= 800 )
	{
		C.Font=Font'SPLargeFont';
	}
	else
	{
		if ( C.ClipX >= 512 )
		{
			C.Font=Font'SPMediumFont';
		}
		else
		{
			C.Font=Font'SPSmallFont';
		}
	}
	Y=ConsoleLines - 1;
	MsgText[(TopLine + 1 + 64) % 64]="(>" @ TypedStr;
	i=Scrollback;
JL00B2:
	if ( i < NumLines + 1 )
	{
		Line=(TopLine + 64 * 2 - i - 1) % 64;
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
			goto JL024D;
		}
		C.SetPos(4.00,Y);
		if ( (MsgType[Line] == 'Say') || (MsgType[Line] == 'TeamSay') )
		{
			C.DrawText(MsgPlayer[Line].PlayerName $ ":" @ MsgText[Line],False);
		}
		else
		{
			C.DrawText(MsgText[Line],False);
		}
		i++;
		goto JL00B2;
	}
JL024D:
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
	local int Y;

	if ( C.ClipX >= 800 )
	{
		C.Font=Font'SPLargeFont';
	}
	else
	{
		if ( C.ClipX >= 512 )
		{
			C.Font=Font'SPMediumFont';
		}
		else
		{
			C.Font=Font'SPSmallFont';
		}
	}
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
			C.StrLen(TypingPrompt,XL,YL);
			C.SetPos(2.00,FrameY - ConsoleLines - YL - 1);
			C.DrawText(TypingPrompt,False);
		}
	}
	if ( (TextLines > 0) && ( !Viewport.Actor.bShowMenu || Viewport.Actor.bShowScores) )
	{
		j=TopLine;
		i=0;
JL01C3:
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
			goto JL01C3;
		}
		j=0;
		Y=2;
		i=0;
JL0285:
		if ( i < 4 )
		{
			if ( ShortMessages[3 - i] != "" )
			{
				C.SetPos(4.00,Y);
				C.StrLen(ShortMessages[3 - i],XL,YL);
				C.DrawText(ShortMessages[3 - i],False);
				Y += YL + 2;
				if ( YL == 18.00 )
				{
					ExtraSpace++;
				}
				j++;
			}
			i++;
			goto JL0285;
		}
	}
}