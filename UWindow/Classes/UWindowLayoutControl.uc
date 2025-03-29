//================================================================================
// UWindowLayoutControl.
//================================================================================
class UWindowLayoutControl expands Object;

struct RowData
{
	var LayoutCell Y[50];
};

struct LayoutCell
{
	var UWindowDialogControl C;
	var UWindowLayoutControl L;
	var int HAlign;
	var int VAlign;
};

var UWindowWindow OwnerWindow;
var float WinTop;
var float WinLeft;
var float WinWidth;
var float WinHeight;
var int Rows;
var int Cols;
var bool bEqualSizedRows;
var bool bEqualSizedCols;
var bool bFixedWidth;
var bool bFixedHeight;
var float ColWidths[50];
var float RowHeights[50];
var RowData X[50];

function SetSize (float X, float Y)
{
	WinWidth=X;
	WinHeight=Y;
	DoLayout();
}

function int SetDimensions (int NewCols, int NewRows)
{
	Cols=NewCols;
	Rows=NewRows;
}

function float CalcColWidth (int Col)
{
	local float MaxWidth;
	local float W;
	local float H;
	local int R;
	local int C;

	MaxWidth=0.00;
	if ( Col == -1 )
	{
		C=0;
JL0021:
		if ( C < Cols )
		{
			W=CalcColWidth(C);
			if ( W > MaxWidth )
			{
				MaxWidth=W;
			}
			C++;
			goto JL0021;
		}
	}
	else
	{
		R=0;
JL006F:
		if ( R < Rows )
		{
			if ( X[Col].Y[R].C != None )
			{
				if ( X[Col].Y[R].C.MinWidth > MaxWidth )
				{
					MaxWidth=X[Col].Y[R].C.MinWidth;
				}
			}
			else
			{
				if ( X[Col].Y[R].L != None )
				{
					X[Col].Y[R].L.CalcSize(W,H);
					if ( W > MaxWidth )
					{
						MaxWidth=W;
					}
				}
			}
			R++;
			goto JL006F;
		}
	}
}

function float CalcRowHeight (int Row)
{
	local float MaxHeight;
	local float W;
	local float H;
	local int R;
	local int C;

	MaxHeight=0.00;
	if ( Row == -1 )
	{
		R=0;
JL0021:
		if ( R < Rows )
		{
			H=CalcRowHeight(R);
			if ( H > MaxHeight )
			{
				MaxHeight=H;
			}
			R++;
			goto JL0021;
		}
	}
	else
	{
		C=0;
JL006F:
		if ( C < Cols )
		{
			if ( X[C].Y[Row].C != None )
			{
				if ( X[C].Y[Row].C.MinHeight > MaxHeight )
				{
					MaxHeight=X[C].Y[Row].C.MinHeight;
				}
			}
			else
			{
				if ( X[C].Y[Row].L != None )
				{
					X[C].Y[Row].L.CalcSize(W,H);
					if ( H > MaxHeight )
					{
						MaxHeight=H;
					}
				}
			}
			C++;
			goto JL006F;
		}
	}
}

function DoLayout ()
{
	local float X;
	local float Y;
	local int R;
	local int C;

	CalcSize(X,Y);
	WinWidth=X;
	WinHeight=Y;
}

function CalcSize (out float Width, out float Height)
{
	local int R;
	local int C;

	if ( bFixedWidth )
	{
		Width=WinWidth;
	}
	else
	{
		if ( bEqualSizedCols )
		{
			WinWidth=Cols * CalcColWidth(-1);
		}
		else
		{
			WinWidth=0.00;
			C=0;
JL004E:
			if ( C < Cols )
			{
				WinWidth += CalcColWidth(C);
				C++;
				goto JL004E;
			}
		}
	}
	if ( bFixedHeight )
	{
		Height=WinHeight;
	}
	else
	{
		if ( bEqualSizedCols )
		{
			WinHeight=Rows * CalcRowHeight(-1);
		}
		else
		{
			Height=0.00;
			R=0;
JL00C7:
			if ( R < Rows )
			{
				WinHeight += CalcRowHeight(R);
				R++;
				goto JL00C7;
			}
		}
	}
}