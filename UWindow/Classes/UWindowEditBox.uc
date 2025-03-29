//================================================================================
// UWindowEditBox.
//================================================================================
class UWindowEditBox expands UWindowDialogControl;

var string Value;
var string Value2;
var int CaretOffset;
var int MaxLength;
var float LastDrawTime;
var bool bShowCaret;
var float Offset;
var UWindowDialogControl NotifyOwner;
var bool bNumericOnly;
var bool bCanEdit;
var bool bAllSelected;
var bool bSelectOnFocus;
var bool bDelayedNotify;
var bool bChangePending;

function Created ()
{
	Super.Created();
	bCanEdit=True;
	MaxLength=255;
	CaretOffset=0;
	Offset=0.00;
	LastDrawTime=GetLevel().TimeSeconds;
}

function SetEditable (bool bEditable)
{
	bCanEdit=bEditable;
}

function SetValue (string NewValue, optional string NewValue2)
{
	Value=NewValue;
	Value2=NewValue2;
	if ( CaretOffset > Len(Value) )
	{
		CaretOffset=Len(Value);
	}
	Notify(1);
}

function Clear ()
{
	CaretOffset=0;
	Value="";
	Value2="";
	bAllSelected=False;
	if ( bDelayedNotify )
	{
		bChangePending=True;
	}
	else
	{
		Notify(1);
	}
}

function SelectAll ()
{
	if ( bCanEdit && (Value != "") )
	{
		CaretOffset=Len(Value);
		bAllSelected=True;
	}
}

function string GetValue ()
{
	return Value;
}

function string GetValue2 ()
{
	return Value2;
}

function Notify (byte E)
{
	if ( NotifyOwner != None )
	{
		NotifyOwner.Notify(E);
	}
	else
	{
		Super.Notify(E);
	}
}

function bool Insert (byte C)
{
	local string NewValue;

	NewValue=Left(Value,CaretOffset) $ Chr(C) $ Mid(Value,CaretOffset);
	if ( Len(NewValue) > MaxLength )
	{
		return False;
	}
	CaretOffset++;
	Value=NewValue;
	if ( bDelayedNotify )
	{
		bChangePending=True;
	}
	else
	{
		Notify(1);
	}
	return True;
}

function bool Backspace ()
{
	local string NewValue;

	if ( CaretOffset == 0 )
	{
		return False;
	}
	NewValue=Left(Value,CaretOffset - 1) $ Mid(Value,CaretOffset);
	CaretOffset--;
	Value=NewValue;
	if ( bDelayedNotify )
	{
		bChangePending=True;
	}
	else
	{
		Notify(1);
	}
	return True;
}

function bool Delete ()
{
	local string NewValue;

	if ( CaretOffset == Len(Value) )
	{
		return False;
	}
	NewValue=Left(Value,CaretOffset) $ Mid(Value,CaretOffset + 1);
	Value=NewValue;
	Notify(1);
	return True;
}

function bool MoveLeft ()
{
	if ( CaretOffset == 0 )
	{
		return False;
	}
	CaretOffset--;
	LastDrawTime=GetLevel().TimeSeconds;
	bShowCaret=True;
	return True;
}

function bool MoveRight ()
{
	if ( CaretOffset == Len(Value) )
	{
		return False;
	}
	CaretOffset++;
	LastDrawTime=GetLevel().TimeSeconds;
	bShowCaret=True;
	return True;
}

function bool MoveHome ()
{
	CaretOffset=0;
	LastDrawTime=GetLevel().TimeSeconds;
	bShowCaret=True;
	return True;
}

function bool MoveEnd ()
{
	CaretOffset=Len(Value);
	LastDrawTime=GetLevel().TimeSeconds;
	bShowCaret=True;
	return True;
}

function KeyType (int Key, float MouseX, float MouseY)
{
	if ( bCanEdit )
	{
		if ( bAllSelected )
		{
			Clear();
		}
		bAllSelected=False;
		if ( bNumericOnly )
		{
			if ( (Key >= 48) && (Key <= 57) )
			{
				Insert(Key);
			}
		}
		else
		{
			if ( (Key >= 32) && (Key < 128) )
			{
				Insert(Key);
			}
		}
	}
}

function KeyDown (int Key, float X, float Y)
{
	local PlayerPawn P;

	P=GetPlayerOwner();
	switch (Key)
	{
		case P.27:
		break;
		case P.13:
		if ( bCanEdit )
		{
			Notify(7);
		}
		break;
		case P.39:
		if ( bCanEdit )
		{
			MoveRight();
		}
		bAllSelected=False;
		break;
		case P.37:
		if ( bCanEdit )
		{
			MoveLeft();
		}
		bAllSelected=False;
		break;
		case P.36:
		if ( bCanEdit )
		{
			MoveHome();
		}
		bAllSelected=False;
		break;
		case P.35:
		if ( bCanEdit )
		{
			MoveEnd();
		}
		bAllSelected=False;
		break;
		case P.8:
		if ( bCanEdit )
		{
			if ( bAllSelected )
			{
				Clear();
			}
			else
			{
				Backspace();
			}
		}
		bAllSelected=False;
		break;
		case P.46:
		if ( bCanEdit )
		{
			if ( bAllSelected )
			{
				Clear();
			}
			else
			{
				Delete();
			}
		}
		bAllSelected=False;
		break;
		default:
		if ( NotifyOwner != None )
		{
			NotifyOwner.KeyDown(Key,X,Y);
		}
		else
		{
			Super.KeyDown(Key,X,Y);
		}
		break;
	}
}

function Click (float X, float Y)
{
	Notify(2);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	Notify(10);
}

function Paint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float TextY;

	C.Font=Root.Fonts[Font];
	TextSize(C,"A",W,H);
	TextY=(WinHeight - H) / 2;
	TextSize(C,Left(Value,CaretOffset),W,H);
	C.DrawColor.R=255;
	C.DrawColor.G=255;
	C.DrawColor.B=255;
	if ( W + Offset < 0 )
	{
		Offset= -W;
	}
	if ( W + Offset > WinWidth - 2 )
	{
		Offset=WinWidth - 2 - W;
		if ( Offset > 0 )
		{
			Offset=0.00;
		}
	}
	C.DrawColor=TextColor;
	if ( bAllSelected )
	{
		DrawStretchedTexture(C,Offset + 1,TextY,W,H,Texture'WhiteTexture');
		C.DrawColor.R=255 ^ C.DrawColor.R;
		C.DrawColor.G=255 ^ C.DrawColor.G;
		C.DrawColor.B=255 ^ C.DrawColor.B;
	}
	ClipText(C,Offset + 1,TextY,Value);
	if (  !bHasKeyboardFocus ||  !bCanEdit )
	{
		bShowCaret=False;
	}
	else
	{
		if ( (GetLevel().TimeSeconds > LastDrawTime + 0.30) || (GetLevel().TimeSeconds < LastDrawTime) )
		{
			LastDrawTime=GetLevel().TimeSeconds;
			bShowCaret= !bShowCaret;
		}
	}
	if ( bShowCaret )
	{
		ClipText(C,Offset + W - 1,TextY,"|");
	}
}

function Close (optional bool bByParent)
{
	if ( bChangePending )
	{
		bChangePending=False;
		Notify(1);
	}
	Super.Close(bByParent);
}

function FocusOtherWindow (UWindowWindow W)
{
	if ( bChangePending )
	{
		bChangePending=False;
		Notify(1);
	}
	if ( NotifyOwner != None )
	{
		NotifyOwner.FocusOtherWindow(W);
	}
	else
	{
		Super.FocusOtherWindow(W);
	}
}

function KeyFocusEnter ()
{
	if ( bSelectOnFocus &&  !bHasKeyboardFocus )
	{
		SelectAll();
	}
	Super.KeyFocusEnter();
}

function DoubleClick (float X, float Y)
{
	Super.DoubleClick(X,Y);
	SelectAll();
}

function KeyFocusExit ()
{
	bAllSelected=False;
	Super.KeyFocusExit();
}