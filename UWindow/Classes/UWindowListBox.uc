//================================================================================
// UWindowListBox.
//================================================================================
class UWindowListBox expands UWindowListControl;

var float ItemHeight;
var UWindowVScrollbar VertSB;
var UWindowListBoxItem SelectedItem;
var bool bCanDrag;
var bool bCanDragExternal;
var bool bDragging;
var float DragY;

function Created ()
{
	Super.Created();
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - 12,0.00,12.00,WinHeight));
}

function BeforePaint (Canvas C, float MouseX, float MouseY)
{
	VertSB.SetRange(0.00,Items.Count(),WinHeight / ItemHeight);
}

function Sort ()
{
	Items.Sort();
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	CurItem=Items.Next;
	i=0;
JL001B:
	if ( (CurItem != None) && (i < VertSB.pos) )
	{
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL001B;
	}
	Y=0.00;
JL007C:
	if ( (Y < WinHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			DrawItem(C,CurItem,0.00,Y,WinWidth - 12,ItemHeight);
			Y=Y + ItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL007C;
	}
}

function Resized ()
{
	Super.Resized();
	VertSB.WinLeft=WinWidth - 12;
	VertSB.WinTop=0.00;
	VertSB.SetSize(12.00,WinHeight);
}

function UWindowListBoxItem GetItemAt (float MouseX, float MouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	if ( (MouseX < 0) || (MouseX > WinWidth) )
	{
		return None;
	}
	CurItem=Items.Next;
	i=0;
JL003A:
	if ( (CurItem != None) && (i < VertSB.pos) )
	{
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL003A;
	}
	Y=0.00;
JL009B:
	if ( (Y < WinHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			if ( (MouseY >= Y) && (MouseY <= Y + ItemHeight) )
			{
				return UWindowListBoxItem(CurItem);
			}
			Y=Y + ItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL009B;
	}
	return None;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	if ( (NewSelected != None) && (SelectedItem != NewSelected) )
	{
		if ( SelectedItem != None )
		{
			SelectedItem.bSelected=False;
		}
		SelectedItem=NewSelected;
		if ( SelectedItem != None )
		{
			SelectedItem.bSelected=True;
		}
		Notify(2);
	}
}

function SetSelected (float X, float Y)
{
	local UWindowListBoxItem NewSelected;

	NewSelected=GetItemAt(X,Y);
	SetSelectedItem(NewSelected);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	SetSelected(X,Y);
	if ( bCanDrag || bCanDragExternal )
	{
		bDragging=True;
		Root.CaptureMouse();
		DragY=Y;
	}
}

function MouseMove (float X, float Y)
{
	local UWindowListBoxItem OverItem;

	Super.MouseMove(X,Y);
	if ( bDragging && bMouseDown )
	{
		OverItem=GetItemAt(X,Y);
		if ( bCanDrag && (OverItem != SelectedItem) && (OverItem != None) )
		{
			SelectedItem.Remove();
			if ( Y < DragY )
			{
				OverItem.InsertItemBefore(SelectedItem);
			}
			else
			{
				OverItem.InsertItemAfter(SelectedItem,True);
			}
			Notify(1);
			DragY=Y;
		}
		else
		{
			if ( bCanDragExternal && (CheckExternalDrag(X,Y) != None) )
			{
				bDragging=False;
			}
		}
	}
	else
	{
		bDragging=False;
	}
}

function bool ExternalDragOver (UWindowDialogControl ExternalControl, float X, float Y)
{
	local UWindowListBox B;
	local UWindowListBoxItem OverItem;

	B=UWindowListBox(ExternalControl);
	if ( (B != None) && (B.SelectedItem != None) )
	{
		OverItem=GetItemAt(X,Y);
		B.SelectedItem.Remove();
		if ( OverItem != None )
		{
			OverItem.InsertItemBefore(B.SelectedItem);
		}
		else
		{
			Items.AppendItem(B.SelectedItem);
		}
		SetSelectedItem(B.SelectedItem);
		B.SelectedItem=None;
		B.Notify(1);
		Notify(1);
		if ( bCanDrag || bCanDragExternal )
		{
			Root.CancelCapture();
			bDragging=True;
			bMouseDown=True;
			Root.CaptureMouse(self);
			DragY=Y;
		}
		return True;
	}
	return False;
}

defaultproperties
{
    ItemHeight=10.00
}