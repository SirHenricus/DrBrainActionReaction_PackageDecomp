//================================================================================
// UWindowHSliderControl.
//================================================================================
class UWindowHSliderControl expands UWindowDialogControl;

var float MinValue;
var float MaxValue;
var float Value;
var int Step;
var float SliderWidth;
var float SliderDrawX;
var float SliderDrawY;
var float TrackStart;
var float TrackWidth;
var bool bSliding;
var bool bNoSlidingNotify;

function Created ()
{
	Super.Created();
	SliderWidth=WinWidth / 2;
	TrackWidth=4.00;
}

function SetRange (float Min, float Max, int NewStep)
{
	MinValue=Min;
	MaxValue=Max;
	Step=NewStep;
	Value=CheckValue(Value);
}

function float GetValue ()
{
	return Value;
}

function SetValue (float NewValue, optional bool bNoNotify)
{
	local float OldValue;

	OldValue=Value;
	Value=CheckValue(NewValue);
	if ( (Value != OldValue) &&  !bNoNotify )
	{
		Notify(1);
	}
}

function float CheckValue (float test)
{
	local float TempF;
	local float NewValue;

	NewValue=test;
	if ( Step != 0 )
	{
		TempF=NewValue / Step;
		NewValue=(TempF + 0.50) * Step;
	}
	if ( NewValue < MinValue )
	{
		NewValue=MinValue;
	}
	if ( NewValue > MaxValue )
	{
		NewValue=MaxValue;
	}
	return NewValue;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	Super.BeforePaint(C,X,Y);
	TextSize(C,Text,W,H);
	WinHeight=H + 1;
	switch (Align)
	{
		case 0:
		SliderDrawX=WinWidth - SliderWidth;
		TextX=0.00;
		break;
		case 1:
		SliderDrawX=0.00;
		TextX=WinWidth - W;
		break;
		case 2:
		SliderDrawX=(WinWidth - SliderWidth) / 2;
		TextX=(WinWidth - W) / 2;
		break;
		default:
	}
	SliderDrawY=(WinHeight - 2) / 2;
	TextY=(WinHeight - H) / 2;
	TrackStart=SliderDrawX + (SliderWidth - TrackWidth) * (Value - MinValue) / (MaxValue - MinValue);
}

function Paint (Canvas C, float X, float Y)
{
	local Texture t;
	local Region R;

	t=GetLookAndFeelTexture();
	if ( Text != "" )
	{
		C.DrawColor=TextColor;
		ClipText(C,TextX,TextY,Text);
		C.DrawColor.R=255;
		C.DrawColor.G=255;
		C.DrawColor.B=255;
	}
	R=LookAndFeel.HLine;
	DrawStretchedTextureSegment(C,SliderDrawX,SliderDrawY,SliderWidth,R.H,R.X,R.Y,R.W,R.H,t);
	DrawUpBevel(C,TrackStart,SliderDrawY - 4,TrackWidth,10.00,t);
}

function LMouseUp (float X, float Y)
{
	Super.LMouseUp(X,Y);
	if ( bNoSlidingNotify )
	{
		Notify(1);
	}
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( (X >= TrackStart) && (X <= TrackStart + TrackWidth) )
	{
		bSliding=True;
		Root.CaptureMouse();
	}
	if ( (X < TrackStart) && (X > SliderDrawX) )
	{
		if ( Step != 0 )
		{
			SetValue(Value - Step);
		}
		else
		{
			SetValue(Value - 1);
		}
	}
	if ( (X > TrackStart + TrackWidth) && (X < SliderDrawX + SliderWidth) )
	{
		if ( Step != 0 )
		{
			SetValue(Value + Step);
		}
		else
		{
			SetValue(Value + 1);
		}
	}
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	if ( bSliding && bMouseDown )
	{
		SetValue((X - SliderDrawX) / (SliderWidth - TrackWidth) * (MaxValue - MinValue) + MinValue,bNoSlidingNotify);
	}
	else
	{
		bSliding=False;
	}
}

function KeyDown (int Key, float X, float Y)
{
	local PlayerPawn P;

	P=GetPlayerOwner();
	switch (Key)
	{
		case P.37:
		if ( Step != 0 )
		{
			SetValue(Value - Step);
		}
		else
		{
			SetValue(Value - 1);
		}
		break;
		case P.39:
		if ( Step != 0 )
		{
			SetValue(Value + Step);
		}
		else
		{
			SetValue(Value + 1);
		}
		break;
		case P.36:
		SetValue(MinValue);
		break;
		case P.35:
		SetValue(MaxValue);
		break;
		default:
		Super.KeyDown(Key,X,Y);
		break;
	}
}