//================================================================================
// Canvas.
//================================================================================
class Canvas expands Object
	native
	noexport;

var Font Font;
var float SpaceX;
var float SpaceY;
var float OrgX;
var float OrgY;
var float ClipX;
var float ClipY;
var float CurX;
var float CurY;
var float Z;
var byte Style;
var float CurYL;
var Color DrawColor;
var bool bCenter;
var bool bNoSmooth;
var const int SizeX;
var const int SizeY;
var Font SmallFont;
var Font MedFont;
var Font BigFont;
var Font LargeFont;
var const Viewport Viewport;
var const int FramePtr;
var const int RenderPtr;

native(464) final function StrLen (coerce string String, out float XL, out float YL);

native(465) final function DrawText (coerce string Text, optional bool CR);

native(466) final function DrawTile (Texture Tex, float XL, float YL, float U, float V, float UL, float VL);

native(467) final function DrawActor (Actor A, bool WireFrame, optional bool ClearZ);

native(468) final function DrawTileClipped (Texture Tex, float XL, float YL, float U, float V, float UL, float VL);

native(469) final function DrawTextClipped (coerce string Text, optional bool bCheckHotKey);

native(470) final function TextSize (coerce string String, out float XL, out float YL);

native(471) final function DrawClippedActor (Actor A, bool WireFrame, int X, int Y, int XB, int YB, optional bool ClearZ);

native(480) final function DrawPortal (int X, int Y, int Width, int Height, Actor CamActor, Vector CamLocation, Rotator CamRotation, optional int FOV, optional bool ClearZ);

event Reset ()
{
	Font=Default.Font;
	SpaceX=Default.SpaceX;
	SpaceY=Default.SpaceY;
	OrgX=Default.OrgX;
	OrgY=Default.OrgY;
	CurX=Default.CurX;
	CurY=Default.CurY;
	Style=Default.Style;
	DrawColor=Default.DrawColor;
	CurYL=Default.CurYL;
	bCenter=False;
	bNoSmooth=False;
	Z=1.00;
}

final function SetPos (float X, float Y)
{
	CurX=X;
	CurY=Y;
}

final function SetOrigin (float X, float Y)
{
	OrgX=X;
	OrgY=Y;
}

final function SetClip (float X, float Y)
{
	ClipX=X;
	ClipY=Y;
}

final function DrawPattern (Texture Tex, float XL, float YL, float Scale)
{
	DrawTile(Tex,XL,YL,(CurX - OrgX) * Scale,(CurY - OrgY) * Scale,XL * Scale,YL * Scale);
}

final function DrawIcon (Texture Tex, float Scale)
{
	if ( Tex != None )
	{
		DrawTile(Tex,Tex.USize * Scale,Tex.VSize * Scale,0.00,0.00,Tex.USize,Tex.VSize);
	}
}

final function DrawRect (Texture Tex, float RectX, float RectY)
{
	DrawTile(Tex,RectX,RectY,0.00,0.00,Tex.USize,Tex.VSize);
}

defaultproperties
{
    Z=1.00
    Style=STY_Normal
    DrawColor=(R=127,G=127,B=127,A=0)
    SmallFont=Font'SmallFont'
    MedFont=Font'MedFont'
    BigFont=Font'BigFont'
    LargeFont=Font'LargeFont'
}