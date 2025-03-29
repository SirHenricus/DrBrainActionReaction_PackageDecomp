//================================================================================
// UWindowList.
//================================================================================
class UWindowList expands Object;

var UWindowList Next;
var UWindowList Last;
var UWindowList Prev;
var UWindowList Sentinel;

function bool Compare (UWindowList t, UWindowList B)
{
	return True;
}

function UWindowList InsertBefore (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=new (,C);
	InsertItemBefore(NewElement);
	return NewElement;
}

function InsertItemBefore (UWindowList NewElement)
{
	NewElement.Sentinel=Sentinel;
	NewElement.Prev=Prev;
	Prev.Next=NewElement;
	Prev=NewElement;
	NewElement.Next=self;
	if ( Sentinel.Next == self )
	{
		Sentinel.Next=NewElement;
	}
}

function InsertItemAfter (UWindowList NewElement, optional bool bCheckShowItem)
{
	local UWindowList N;

	N=Next;
	if ( bCheckShowItem )
	{
JL0014:
		if ( (N != None) &&  !N.ShowThisItem() )
		{
			N=N.Next;
			goto JL0014;
		}
	}
	if ( N != None )
	{
		N.InsertItemBefore(NewElement);
	}
	else
	{
		Sentinel.AppendItem(NewElement);
	}
}

function UWindowList Sort ()
{
	local UWindowList CurrentItem;
	local UWindowList S;
	local UWindowList Previous;
	local UWindowList Best;
	local UWindowList BestPrev;

	CurrentItem=self;
JL0007:
	if ( CurrentItem != None )
	{
		S=CurrentItem.Next;
		Best=CurrentItem.Next;
		Previous=CurrentItem;
		BestPrev=CurrentItem;
JL0050:
		if ( S != None )
		{
			if ( CurrentItem.Compare(S,Best) )
			{
				Best=S;
				BestPrev=Previous;
			}
			Previous=S;
			S=S.Next;
			goto JL0050;
		}
		if ( Best != CurrentItem.Next )
		{
			BestPrev.Next=Best.Next;
			if ( BestPrev.Next != None )
			{
				BestPrev.Next.Prev=BestPrev;
			}
			Best.Prev=CurrentItem;
			Best.Next=CurrentItem.Next;
			CurrentItem.Next.Prev=Best;
			CurrentItem.Next=Best;
			if ( Sentinel.Last == Best )
			{
				Sentinel.Last=BestPrev;
				if ( Sentinel.Last == None )
				{
					Sentinel.Last=Sentinel;
				}
			}
		}
		CurrentItem=CurrentItem.Next;
		goto JL0007;
	}
	return self;
}

function DestroyList ()
{
	local UWindowList L;
	local UWindowList Temp;

	L=Next;
JL000B:
	if ( L != None )
	{
		Temp=L.Next;
		L.DestroyListItem();
		L=Temp;
		goto JL000B;
	}
	DestroyListItem();
}

function DestroyListItem ()
{
	Next=None;
	Last=self;
	Sentinel=None;
	Prev=None;
}

function int Count ()
{
	local int C;
	local UWindowList i;

	i=Next;
JL000B:
	if ( i != None )
	{
		C++;
		i=i.Next;
		goto JL000B;
	}
	return C;
}

function Remove ()
{
	if ( Next != None )
	{
		Next.Prev=Prev;
	}
	if ( Prev != None )
	{
		Prev.Next=Next;
	}
	if ( Sentinel != None )
	{
		if ( Sentinel.Last == self )
		{
			Sentinel.Last=Prev;
		}
		Prev=None;
		Next=None;
		Sentinel=None;
	}
}

function UWindowList CopyExistingListItem (Class<UWindowList> ItemClass, UWindowList SourceItem)
{
	return Append(ItemClass);
}

function bool ShowThisItem ()
{
	return True;
}

function MoveItemSorted (UWindowList Item)
{
	local UWindowList L;

	L=Next;
JL000B:
	if ( L != None )
	{
		if ( Compare(Item,L) )
		{
			goto JL0043;
		}
		L=L.Next;
		goto JL000B;
	}
JL0043:
	if ( L != Item )
	{
		Item.Remove();
		if ( L == None )
		{
			AppendItem(Item);
		}
		else
		{
			L.InsertItemBefore(Item);
		}
	}
}

function SetupSentinel ()
{
	Last=self;
	Next=None;
	Prev=None;
	Sentinel=self;
}

function Validate ()
{
	local UWindowList i;
	local UWindowList Previous;
	local int Count;

	if ( Sentinel != self )
	{
		Log("Calling Sentinel.Validate() from " $ string(self));
		Sentinel.Validate();
		return;
	}
	Log("BEGIN Validate(): " $ string(Class));
	Count=0;
	Previous=self;
	i=Next;
JL007C:
	if ( i != None )
	{
		Log("Checking item: " $ string(Count));
		if ( i.Sentinel != self )
		{
			Log("   I.Sentinel reference is broken");
		}
		if ( i.Prev != Previous )
		{
			Log("   I.Prev reference is broken");
		}
		if ( (Last == i) && (i.Next != None) )
		{
			Log("   Item is Sentinel.Last but Item has valid Next");
		}
		if ( (i.Next == None) && (Last != i) )
		{
			Log("   Item is Item.Next is none, but Item is not Sentinel.Last");
		}
		Previous=i;
		Count++;
		i=i.Next;
		goto JL007C;
	}
	Log("END Validate(): " $ string(Class));
}

function UWindowList Append (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=new (,C);
	AppendItem(NewElement);
	return NewElement;
}

function AppendItem (UWindowList NewElement)
{
	NewElement.Next=None;
	Last.Next=NewElement;
	NewElement.Prev=Last;
	NewElement.Sentinel=self;
	Last=NewElement;
}

function UWindowList Insert (Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement=new (,C);
	InsertItem(NewElement);
	return NewElement;
}

function InsertItem (UWindowList NewElement)
{
	NewElement.Next=Next;
	if ( Next != None )
	{
		Next.Prev=NewElement;
	}
	Next=NewElement;
	NewElement.Prev=self;
	NewElement.Sentinel=self;
}

function UWindowList FindEntry (int Index)
{
	local UWindowList L;
	local int i;

	L=Next;
	i=0;
JL0012:
	if ( i < Index )
	{
		L=L.Next;
		if ( L == None )
		{
			return None;
		}
		i++;
		goto JL0012;
	}
	return L;
}

function Clear ()
{
	Next=None;
	Last=self;
}