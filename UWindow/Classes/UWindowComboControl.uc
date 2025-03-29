//================================================================================
// UWindowComboControl.
//================================================================================
class UWindowComboControl expands UWindowDialogControl;

var float EditBoxWidth;
var float EditAreaDrawX;
var float EditAreaDrawY;
var UWindowEditBox EditBox;
var UWindowComboButton Button;
var Class<UWindowComboList> ListClass;
var UWindowComboList List;
var bool bListVisible;
var bool bCanEdit;

function Created ()
{
	local Color C;

	Super.Created();
	EditBox=UWindowEditBox(CreateWindow(Class'UWindowEditBox',0.00,0.00,WinWidth - 12,WinHeight));
	EditBox.NotifyOwner=self;
	EditBoxWidth=WinWidth / 2;
	EditBox.bTransient=True;
	Button=UWindowComboButton(CreateWindow(Class'UWindowComboButton',WinWidth - 12,0.00,12.00,10.00));
	Button.Owner=self;
	List=UWindowComboList(Root.CreateWindow(ListClass,0.00,0.00,100.00,100.00));
	List.LookAndFeel=LookAndFeel;
	List.Owner=self;
	List.Setup();
	List.HideWindow();
	bListVisible=False;
	SetEditTextColor(LookAndFeel.EditBoxTextColor);
}

function Notify (byte E)
{
	Super.Notify(E);
	if ( E == 10 )
	{
		if (  !bListVisible )
		{
			if (  !bCanEdit )
			{
				DropDown();
				Root.CaptureMouse(List);
			}
		}
		else
		{
			CloseUp();
		}
	}
}

function int FindItemIndex (string V, optional bool bIgnoreCase)
{
	return List.FindItemIndex(V,bIgnoreCase);
}

function int FindItemIndex2 (string v2, optional bool bIgnoreCase)
{
	return List.FindItemIndex2(v2,bIgnoreCase);
}

function Close (optional bool bByParent)
{
	if ( bByParent && bListVisible )
	{
		CloseUp();
	}
	Super.Close(bByParent);
}

function SetNumericOnly (bool bNumericOnly)
{
	EditBox.bNumericOnly=bNumericOnly;
}

function SetFont (int NewFont)
{
	Super.SetFont(NewFont);
	EditBox.SetFont(NewFont);
}

function SetEditTextColor (Color NewColor)
{
	EditBox.SetTextColor(NewColor);
}

function SetEditable (bool bNewCanEdit)
{
	bCanEdit=bNewCanEdit;
	EditBox.SetEditable(bCanEdit);
}

function int GetSelectedIndex ()
{
	return List.FindItemIndex(GetValue());
}

function SetSelectedIndex (int Index)
{
	SetValue(List.GetItemValue(Index),List.GetItemValue2(Index));
}

function string GetValue ()
{
	return EditBox.GetValue();
}

function string GetValue2 ()
{
	return EditBox.GetValue2();
}

function SetValue (string NewValue, optional string NewValue2)
{
	EditBox.SetValue(NewValue,NewValue2);
}

function SetMaxLength (int MaxLength)
{
	EditBox.MaxLength=MaxLength;
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.Combo_Draw(self,C);
	Super.Paint(C,X,Y);
}

function AddItem (string S, optional string S2, optional int SortWeight)
{
	List.AddItem(S,S2,SortWeight);
}

function InsertItem (string S, optional string S2, optional int SortWeight)
{
	List.InsertItem(S,S2,SortWeight);
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	LookAndFeel.Combo_SetupSizes(self,C);
	List.bLeaveOnscreen=bListVisible && bLeaveOnscreen;
}

function CloseUp ()
{
	bListVisible=False;
	EditBox.SetEditable(bCanEdit);
	EditBox.SelectAll();
	List.HideWindow();
}

function DropDown ()
{
	bListVisible=True;
	EditBox.SetEditable(False);
	List.ShowWindow();
}

function Sort ()
{
	List.Sort();
}

function ClearValue ()
{
	EditBox.Clear();
}

function Clear ()
{
	List.Clear();
	EditBox.Clear();
}

function FocusOtherWindow (UWindowWindow W)
{
	Super.FocusOtherWindow(W);
	if ( bListVisible && (W.ParentWindow != self) && (W != List) && (W.ParentWindow != List) )
	{
		CloseUp();
	}
}

defaultproperties
{
    ListClass=Class'UWindowComboList'
    bNoKeyboard=True
}