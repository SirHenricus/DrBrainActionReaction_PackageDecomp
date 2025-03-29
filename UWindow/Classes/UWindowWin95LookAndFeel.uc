//================================================================================
// UWindowWin95LookAndFeel.
//================================================================================
class UWindowWin95LookAndFeel expands UWindowLookAndFeel;

const BRSIZEBORDER= 15;
const SIZEBORDER= 3;
var() Region SBUpUp;
var() Region SBUpDown;
var() Region SBUpDisabled;
var() Region SBDownUp;
var() Region SBDownDown;
var() Region SBDownDisabled;
var() Region SBLeftUp;
var() Region SBLeftDown;
var() Region SBLeftDisabled;
var() Region SBRightUp;
var() Region SBRightDown;
var() Region SBRightDisabled;
var() Region SBBackground;
var() Region FrameSBL;
var() Region FrameSB;
var() Region FrameSBR;
var() Region CloseBoxUp;
var() Region CloseBoxDown;
var() int CloseBoxOffsetX;
var() int CloseBoxOffsetY;

function FW_DrawWindowFrame (UWindowFramedWindow W, Canvas C)
{
	local Texture t;
	local Region R;
	local Region Temp;

	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	t=W.GetLookAndFeelTexture();
	R=FrameTL;
	W.DrawStretchedTextureSegment(C,0.00,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameT;
	W.DrawStretchedTextureSegment(C,FrameTL.W,0.00,W.WinWidth - FrameTL.W - FrameTR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=FrameTR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,0.00,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		Temp=FrameSBL;
	}
	else
	{
		Temp=FrameBL;
	}
	R=FrameL;
	W.DrawStretchedTextureSegment(C,0.00,FrameTL.H,R.W,W.WinHeight - FrameTL.H - Temp.H,R.X,R.Y,R.W,R.H,t);
	R=FrameR;
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,FrameTL.H,R.W,W.WinHeight - FrameTL.H - Temp.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		R=FrameSBL;
	}
	else
	{
		R=FrameBL;
	}
	W.DrawStretchedTextureSegment(C,0.00,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	if ( W.bStatusBar )
	{
		R=FrameSB;
		W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - FrameSBL.W - FrameSBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	}
	else
	{
		R=FrameB;
		W.DrawStretchedTextureSegment(C,FrameBL.W,W.WinHeight - R.H,W.WinWidth - FrameBL.W - FrameBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	}
	if ( W.bStatusBar )
	{
		R=FrameSBR;
	}
	else
	{
		R=FrameBR;
	}
	W.DrawStretchedTextureSegment(C,W.WinWidth - R.W,W.WinHeight - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	C.Font=W.Root.Fonts[W.0];
	if ( W.ParentWindow.ActiveWindow == W )
	{
		C.DrawColor=FrameActiveTitleColor;
	}
	else
	{
		C.DrawColor=FrameInactiveTitleColor;
	}
	W.ClipTextWidth(C,FrameTitleX,FrameTitleY,W.WindowTitle,W.WinWidth - 22);
	if ( W.bStatusBar )
	{
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
		W.ClipTextWidth(C,6.00,W.WinHeight - 13,W.StatusBarText,W.WinWidth - 22);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function FW_SetupFrameButtons (UWindowFramedWindow W, Canvas C)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.CloseBox.WinLeft=W.WinWidth - CloseBoxOffsetX - CloseBoxUp.W;
	W.CloseBox.WinTop=CloseBoxOffsetY;
	W.CloseBox.SetSize(CloseBoxUp.W,CloseBoxUp.H);
	W.CloseBox.bUseRegion=True;
	W.CloseBox.UpTexture=t;
	W.CloseBox.DownTexture=t;
	W.CloseBox.OverTexture=t;
	W.CloseBox.DisabledTexture=t;
	W.CloseBox.UpRegion=CloseBoxUp;
	W.CloseBox.DownRegion=CloseBoxDown;
	W.CloseBox.OverRegion=CloseBoxUp;
	W.CloseBox.DisabledRegion=CloseBoxUp;
}

function Region FW_GetClientArea (UWindowFramedWindow W)
{
	local Region R;

	R.X=FrameL.W;
	R.Y=FrameT.H;
	R.W=W.WinWidth - FrameL.W + FrameR.W;
	if ( W.bStatusBar )
	{
		R.H=W.WinHeight - FrameT.H + FrameSB.H;
	}
	else
	{
		R.H=W.WinHeight - FrameT.H + FrameB.H;
	}
	return R;
}

function FrameHitTest FW_HitTest (UWindowFramedWindow W, float X, float Y)
{
	if ( (X >= 3) && (X <= W.WinWidth - 3) && (Y >= 3) && (Y <= 14) )
	{
		return 8;
	}
	if ( (X < 15) && (Y < 3) || (X < 3) && (Y < 15) )
	{
		return 0;
	}
	if ( (X > W.WinWidth - 3) && (Y < 15) || (X > W.WinWidth - 15) && (Y < 3) )
	{
		return 2;
	}
	if ( (X < 15) && (Y > W.WinHeight - 3) || (X < 3) && (Y > W.WinHeight - 15) )
	{
		return 5;
	}
	if ( (X > W.WinWidth - 15) && (Y > W.WinHeight - 15) )
	{
		return 7;
	}
	if ( Y < 3 )
	{
		return 1;
	}
	if ( Y > W.WinHeight - 3 )
	{
		return 6;
	}
	if ( X < 3 )
	{
		return 3;
	}
	if ( X > W.WinWidth - 3 )
	{
		return 4;
	}
	return 10;
}

function DrawClientArea (UWindowClientWindow W, Canvas C)
{
	W.DrawStretchedTexture(C,0.00,0.00,W.WinWidth,W.WinHeight,Texture'BlackTexture');
}

function Combo_SetupSizes (UWindowComboControl W, Canvas C)
{
	local float tW;
	local float tH;

	C.Font=W.Root.Fonts[W.Font];
	W.TextSize(C,W.Text,tW,tH);
	W.WinHeight=12.00 + MiscBevelT[2].H + MiscBevelB[2].H;
	switch (W.Align)
	{
		case 0:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=0.00;
		break;
		case 1:
		W.EditAreaDrawX=0.00;
		W.TextX=W.WinWidth - tW;
		break;
		case 2:
		W.EditAreaDrawX=(W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX=(W.WinWidth - tW) / 2;
		break;
		default:
	}
	W.EditAreaDrawY=(W.WinHeight - 2) / 2;
	W.TextY=(W.WinHeight - tH) / 2;
	W.EditBox.WinLeft=W.EditAreaDrawX + MiscBevelL[2].W;
	W.EditBox.WinTop=MiscBevelT[2].H;
	W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W;
	W.EditBox.WinHeight=W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
	W.Button.WinLeft=W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W;
	W.Button.WinTop=W.EditBox.WinTop;
	W.Button.WinWidth=ComboBtnUp.W;
	W.Button.WinHeight=W.EditBox.WinHeight;
}

function Combo_Draw (UWindowComboControl W, Canvas C)
{
	W.DrawMiscBevel(C,W.EditAreaDrawX,0.00,W.EditBoxWidth,W.WinHeight,Misc,2);
	if ( W.Text != "" )
	{
		C.DrawColor=W.TextColor;
		W.ClipText(C,W.TextX,W.TextY,W.Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function Checkbox_SetupSizes (UWindowCheckbox W, Canvas C)
{
	local float tW;
	local float tH;

	W.TextSize(C,W.Text,tW,tH);
	W.WinHeight=Max(tH + 1,16);
	switch (W.Align)
	{
		case 0:
		W.ImageX=W.WinWidth - 16;
		W.TextX=0.00;
		break;
		case 1:
		W.ImageX=0.00;
		W.TextX=W.WinWidth - tW;
		break;
		case 2:
		W.ImageX=(W.WinWidth - 16) / 2;
		W.TextX=(W.WinWidth - tW) / 2;
		break;
		default:
	}
	W.ImageY=(W.WinHeight - 16) / 2;
	W.TextY=(W.WinHeight - tH) / 2;
	if ( W.bChecked )
	{
		W.UpTexture=Texture'ChkChecked';
		W.DownTexture=Texture'ChkChecked';
		W.OverTexture=Texture'ChkChecked';
		W.DisabledTexture=Texture'ChkCheckedDisabled';
	}
	else
	{
		W.UpTexture=Texture'ChkUnchecked';
		W.DownTexture=Texture'ChkUnchecked';
		W.OverTexture=Texture'ChkUnchecked';
		W.DisabledTexture=Texture'ChkUncheckedDisabled';
	}
}

function Combo_GetButtonBitmaps (UWindowComboButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=ComboBtnUp;
	W.DownRegion=ComboBtnDown;
	W.OverRegion=ComboBtnUp;
	W.DisabledRegion=ComboBtnDisabled;
}

function Editbox_SetupSizes (UWindowEditControl W, Canvas C)
{
	local float tW;
	local float tH;
	local int B;

	B=EditBoxBevel;
	C.Font=W.Root.Fonts[W.Font];
	W.TextSize(C,W.Text,tW,tH);
	W.WinHeight=12.00 + MiscBevelT[B].H + MiscBevelB[B].H;
	switch (W.Align)
	{
		case 0:
		W.EditAreaDrawX=W.WinWidth - W.EditBoxWidth;
		W.TextX=0.00;
		break;
		case 1:
		W.EditAreaDrawX=0.00;
		W.TextX=W.WinWidth - tW;
		break;
		case 2:
		W.EditAreaDrawX=(W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX=(W.WinWidth - tW) / 2;
		break;
		default:
	}
	W.EditAreaDrawY=(W.WinHeight - 2) / 2;
	W.TextY=(W.WinHeight - tH) / 2;
	W.EditBox.WinLeft=W.EditAreaDrawX + MiscBevelL[B].W;
	W.EditBox.WinTop=MiscBevelT[B].H;
	W.EditBox.WinWidth=W.EditBoxWidth - MiscBevelL[B].W - MiscBevelR[B].W;
	W.EditBox.WinHeight=W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H;
}

function Editbox_Draw (UWindowEditControl W, Canvas C)
{
	W.DrawMiscBevel(C,W.EditAreaDrawX,0.00,W.EditBoxWidth,W.WinHeight,Misc,EditBoxBevel);
	if ( W.Text != "" )
	{
		C.DrawColor=W.TextColor;
		W.ClipText(C,W.TextX,W.TextY,W.Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
}

function Tab_DrawTab (UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text)
{
	local Region R;
	local Texture t;

	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	t=Tab.GetLookAndFeelTexture();
	if ( bActiveTab )
	{
		R=TabSelectedL;
		Tab.DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabSelectedM;
		Tab.DrawStretchedTextureSegment(C,X + TabSelectedL.W,Y,W - TabSelectedL.W - TabSelectedR.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabSelectedR;
		Tab.DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		C.Font=Tab.Root.Fonts[Tab.0];
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
		Tab.ClipText(C,X + Size_TabSpacing / 2,3.00,Text,True);
	}
	else
	{
		R=TabUnselectedL;
		Tab.DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabUnselectedM;
		Tab.DrawStretchedTextureSegment(C,X + TabUnselectedL.W,Y,W - TabUnselectedL.W - TabUnselectedR.W,R.H,R.X,R.Y,R.W,R.H,t);
		R=TabUnselectedR;
		Tab.DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
		C.Font=Tab.Root.Fonts[Tab.0];
		C.DrawColor.R=0;
		C.DrawColor.G=0;
		C.DrawColor.B=0;
		Tab.ClipText(C,X + Size_TabSpacing / 2,4.00,Text,True);
	}
}

function SB_SetupUpButton (UWindowSBUpButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBUpUp;
	W.DownRegion=SBUpDown;
	W.OverRegion=SBUpUp;
	W.DisabledRegion=SBUpDisabled;
}

function SB_SetupDownButton (UWindowSBDownButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBDownUp;
	W.DownRegion=SBDownDown;
	W.OverRegion=SBDownUp;
	W.DisabledRegion=SBDownDisabled;
}

function SB_SetupLeftButton (UWindowSBLeftButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBLeftUp;
	W.DownRegion=SBLeftDown;
	W.OverRegion=SBLeftUp;
	W.DisabledRegion=SBLeftDisabled;
}

function SB_SetupRightButton (UWindowSBRightButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBRightUp;
	W.DownRegion=SBRightDown;
	W.OverRegion=SBRightUp;
	W.DisabledRegion=SBRightDisabled;
}

function SB_VDraw (UWindowVScrollbar W, Canvas C)
{
	local Region R;
	local Texture t;

	t=W.GetLookAndFeelTexture();
	R=SBBackground;
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,W.WinHeight,R.X,R.Y,R.W,R.H,t);
	if (  !W.bDisabled )
	{
		W.DrawUpBevel(C,0.00,W.ThumbStart,Size_ScrollbarWidth,W.ThumbHeight,t);
	}
}

function SB_HDraw (UWindowHScrollbar W, Canvas C)
{
	local Region R;
	local Texture t;

	t=W.GetLookAndFeelTexture();
	R=SBBackground;
	W.DrawStretchedTextureSegment(C,0.00,0.00,W.WinWidth,W.WinHeight,R.X,R.Y,R.W,R.H,t);
	if (  !W.bDisabled )
	{
		W.DrawUpBevel(C,W.ThumbStart,0.00,W.ThumbWidth,Size_ScrollbarWidth,t);
	}
}

function Tab_SetupLeftButton (UWindowTabControlLeftButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.WinWidth=Size_ScrollbarButtonHeight;
	W.WinHeight=Size_ScrollbarWidth;
	W.WinTop=Size_TabAreaHeight - W.WinHeight;
	W.WinLeft=W.ParentWindow.WinWidth - 2 * W.WinWidth;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBLeftUp;
	W.DownRegion=SBLeftDown;
	W.OverRegion=SBLeftUp;
	W.DisabledRegion=SBLeftDisabled;
}

function Tab_SetupRightButton (UWindowTabControlRightButton W)
{
	local Texture t;

	t=W.GetLookAndFeelTexture();
	W.WinWidth=Size_ScrollbarButtonHeight;
	W.WinHeight=Size_ScrollbarWidth;
	W.WinTop=Size_TabAreaHeight - W.WinHeight;
	W.WinLeft=W.ParentWindow.WinWidth - W.WinWidth;
	W.bUseRegion=True;
	W.UpTexture=t;
	W.DownTexture=t;
	W.OverTexture=t;
	W.DisabledTexture=t;
	W.UpRegion=SBRightUp;
	W.DownRegion=SBRightDown;
	W.OverRegion=SBRightUp;
	W.DisabledRegion=SBRightDisabled;
}

function Tab_SetTabPageSize (UWindowPageControl W, UWindowPageWindow P)
{
	P.WinLeft=2.00;
	P.WinTop=W.TabArea.WinHeight - TabSelectedM.H - TabUnselectedM.H + 3;
	P.SetSize(W.WinWidth - 4,W.WinHeight - W.TabArea.WinHeight - TabSelectedM.H - TabUnselectedM.H - 6);
}

function Tab_DrawTabPageArea (UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel(C,0.00,Size_TabAreaHeight,W.WinWidth,W.WinHeight - Size_TabAreaHeight,W.GetLookAndFeelTexture());
}

function Tab_GetTabSize (UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H)
{
	local float tW;
	local float tH;

	C.Font=Tab.Root.Fonts[Tab.0];
	Tab.TextSize(C,Text,tW,tH);
	W=tW + Size_TabSpacing;
	H=tH;
}

function Menu_DrawMenuBar (UWindowMenuBar W, Canvas C)
{
}

defaultproperties
{
    SBUpUp=(X=20, Y=16, W=12, H=10)
    SBUpDown=(X=32, Y=16, W=12, H=10)
    SBUpDisabled=(X=44, Y=16, W=12, H=10)
    SBDownUp=(X=20, Y=26, W=12, H=10)
    SBDownDown=(X=32, Y=26, W=12, H=10)
    SBDownDisabled=(X=44, Y=26, W=12, H=10)
    SBLeftUp=(X=20, Y=48, W=10, H=12)
    SBLeftDown=(X=30, Y=48, W=10, H=12)
    SBLeftDisabled=(X=40, Y=48, W=10, H=12)
    SBRightUp=(X=20, Y=36, W=10, H=12)
    SBRightDown=(X=30, Y=36, W=10, H=12)
    SBRightDisabled=(X=40, Y=36, W=10, H=12)
    SBBackground=(X=4, Y=79, W=1, H=1)
    FrameSBL=(X=0, Y=112, W=2, H=16)
    FrameSB=(X=32, Y=112, W=1, H=16)
    FrameSBR=(X=112, Y=112, W=16, H=16)
    CloseBoxUp=(X=4, Y=32, W=11, H=11)
    CloseBoxDown=(X=4, Y=43, W=11, H=11)
    CloseBoxOffsetX=3
    CloseBoxOffsetY=5
    Active=Texture'Icons.ActiveFrame'
    Inactive=Texture'Icons.InactiveFrame'
    ActiveS=Texture'Icons.ActiveFrameS'
    InactiveS=Texture'Icons.InactiveFrameS'
    Misc=Texture'Icons.Misc'
    FrameTL=(X=0, Y=0, W=2, H=16)
    FrameT=(X=32, Y=0, W=1, H=16)
    FrameTR=(X=126, Y=0, W=2, H=16)
    FrameL=(X=0, Y=32, W=2, H=1)
    FrameR=(X=126, Y=32, W=2, H=1)
    FrameBL=(X=0, Y=125, W=2, H=3)
    FrameB=(X=32, Y=125, W=1, H=3)
    FrameBR=(X=126, Y=125, W=2, H=3)
    FrameActiveTitleColor=(R=255,G=255,B=255,A=0)
    FrameInactiveTitleColor=(R=255,G=255,B=255,A=0)
    FrameTitleX=6
    FrameTitleY=4
    BevelUpTL=(X=4, Y=16, W=2, H=2)
    BevelUpT=(X=10, Y=16, W=1, H=2)
    BevelUpTR=(X=18, Y=16, W=2, H=2)
    BevelUpL=(X=4, Y=20, W=2, H=1)
    BevelUpR=(X=18, Y=20, W=2, H=1)
    BevelUpBL=(X=4, Y=30, W=2, H=2)
    BevelUpB=(X=10, Y=30, W=1, H=2)
    BevelUpBR=(X=18, Y=30, W=2, H=2)
    BevelUpArea=(X=8, Y=20, W=1, H=1)
    MiscBevelTL(0)=(X=0, Y=17, W=3, H=3)
    MiscBevelTL(1)=(X=0, Y=0, W=3, H=3)
    MiscBevelTL(2)=(X=0, Y=33, W=2, H=2)
    MiscBevelT(0)=(X=3, Y=17, W=116, H=3)
    MiscBevelT(1)=(X=3, Y=0, W=116, H=3)
    MiscBevelT(2)=(X=2, Y=33, W=1, H=2)
    MiscBevelTR(0)=(X=119, Y=17, W=3, H=3)
    MiscBevelTR(1)=(X=119, Y=0, W=3, H=3)
    MiscBevelTR(2)=(X=11, Y=33, W=2, H=2)
    MiscBevelL(0)=(X=0, Y=20, W=3, H=10)
    MiscBevelL(1)=(X=0, Y=3, W=3, H=10)
    MiscBevelL(2)=(X=0, Y=36, W=2, H=1)
    MiscBevelR(0)=(X=119, Y=20, W=3, H=10)
    MiscBevelR(1)=(X=119, Y=3, W=3, H=10)
    MiscBevelR(2)=(X=11, Y=36, W=2, H=1)
    MiscBevelBL(0)=(X=0, Y=30, W=3, H=3)
    MiscBevelBL(1)=(X=0, Y=14, W=3, H=3)
    MiscBevelBL(2)=(X=0, Y=44, W=2, H=2)
    MiscBevelB(0)=(X=3, Y=30, W=116, H=3)
    MiscBevelB(1)=(X=3, Y=14, W=116, H=3)
    MiscBevelB(2)=(X=2, Y=44, W=1, H=2)
    MiscBevelBR(0)=(X=119, Y=30, W=3, H=3)
    MiscBevelBR(1)=(X=119, Y=14, W=3, H=3)
    MiscBevelBR(2)=(X=11, Y=44, W=2, H=2)
    MiscBevelArea(0)=(X=3, Y=20, W=116, H=10)
    MiscBevelArea(1)=(X=3, Y=3, W=116, H=10)
    MiscBevelArea(2)=(X=2, Y=35, W=9, H=9)
    ComboBtnUp=(X=20, Y=60, W=12, H=12)
    ComboBtnDown=(X=32, Y=60, W=12, H=12)
    ComboBtnDisabled=(X=44, Y=60, W=12, H=12)
    ColumnHeadingHeight=13
    HLine=(X=5, Y=78, W=1, H=2)
    EditBoxBevel=2
    TabSelectedL=(X=4, Y=80, W=3, H=17)
    TabSelectedM=(X=7, Y=80, W=1, H=17)
    TabSelectedR=(X=55, Y=80, W=2, H=17)
    TabUnselectedL=(X=57, Y=80, W=3, H=15)
    TabUnselectedM=(X=60, Y=80, W=1, H=15)
    TabUnselectedR=(X=109, Y=80, W=2, H=15)
    TabBackground=(X=4, Y=79, W=1, H=1)
    Size_ScrollbarWidth=12.00
    Size_ScrollbarButtonHeight=10.00
    Size_MinScrollbarHeight=6.00
    Size_TabAreaHeight=15.00
    Size_TabAreaOverhangHeight=2.00
    Size_TabSpacing=20.00
    Size_TabXOffset=1.00
}