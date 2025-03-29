//================================================================================
// SPMPInstructionsMenu.
//================================================================================
class SPMPInstructionsMenu expands SPMenu;

var() localized string Instructions;
var string Map;

function bool ProcessSelection ()
{
	bExitAllMenus=True;
	PlayerOwner.ClientMessage(" ");
	PlayerOwner.bDelayedCommand=True;
	PlayerOwner.DelayedCommand="AutoSaveAndJoin " $ Map;
	return True;
}

function DrawMenu (Canvas C)
{
	if ( (C.ClipX != ClipX) || (C.ClipY != ClipY) )
	{
		if (  !Format(C,Font'SPLargeFont') )
		{
			if (  !Format(C,Font'SPMediumFont') )
			{
				if (  !Format(C,Font'SPSmallFont') )
				{
					Log("SPMenu::DrawMenu <ERROR> Couldn't format menu! <ERROR>");
					return;
				}
			}
		}
	}
	DrawBackGround(C);
	DrawHelpPanel(C);
	DrawInstructions(C);
}

function DrawInstructions (Canvas C)
{
	local float X;
	local float Y;
	local float W;
	local float H;

	W=C.ClipX * 0.60;
	H=C.ClipY * 0.40;
	X=(C.ClipX - W) / 2;
	Y=C.ClipY * 0.20;
	DrawTextBox(Instructions,X,Y,W,H,C);
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
	C.SetOrigin(X,Y);
	C.SetClip(W,H);
	C.bCenter=True;
	SetFontBrightness(C,True);
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
	C.bCenter=False;
}

defaultproperties
{
    Instructions="Collect as many briefcases as you can before time runs out. And watch out for the other players!"
    MenuLength=1
    HelpMessage(1)="Hit 'Enter' to join game"
}