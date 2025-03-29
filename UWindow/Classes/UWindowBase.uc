//================================================================================
// UWindowBase.
//================================================================================
class UWindowBase expands Object;

enum FrameHitTest {
	HT_NW,
	HT_N,
	HT_NE,
	HT_W,
	HT_E,
	HT_SW,
	HT_S,
	HT_SE,
	HT_TitleBar,
	HT_DragHandle,
	HT_None
};

enum TextAlign {
	TA_Left,
	TA_Right,
	TA_Center
};

struct TexRegion
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
	var() Texture t;
};

struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};


function Region NewRegion (float X, float Y, float W, float H)
{
	local Region R;

	R.X=X;
	R.Y=Y;
	R.W=W;
	R.H=H;
	return R;
}

function TexRegion NewTexRegion (float X, float Y, float W, float H, Texture t)
{
	local TexRegion R;

	R.X=X;
	R.Y=Y;
	R.W=W;
	R.H=H;
	R.t=t;
	return R;
}

function Region GetRegion (TexRegion t)
{
	local Region R;

	R.X=t.X;
	R.Y=t.Y;
	R.W=t.W;
	R.H=t.H;
	return R;
}