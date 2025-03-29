//================================================================================
// UBrowserOpenBar.
//================================================================================
class UBrowserOpenBar expands UWindowDialogClientWindow;

var UWindowComboControl OpenCombo;
var localized string OpenText;
var localized string OpenHelp;
var config string OpenHistory[10];

function Created ()
{
	local float EditWidth;
	local int i;
	local Color TC;

	Super.Created();
	EditWidth=WinWidth - 140;
	OpenCombo=UWindowComboControl(CreateControl(Class'UWindowComboControl',20.00,20.00,EditWidth,1.00));
	OpenCombo.SetText(OpenText);
	OpenCombo.SetHelpText(OpenHelp);
	OpenCombo.SetFont(0);
	OpenCombo.SetEditable(True);
	i=0;
JL008F:
	if ( i < 10 )
	{
		if ( OpenHistory[i] != "" )
		{
			OpenCombo.AddItem(OpenHistory[i]);
		}
		i++;
		goto JL008F;
	}
	TC.R=255;
	TC.G=255;
	TC.B=255;
	OpenCombo.SetTextColor(TC);
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float EditWidth;
	local float XL;
	local float YL;

	C.Font=Root.Fonts[OpenCombo.Font];
	TextSize(C,OpenCombo.Text,XL,YL);
	EditWidth=WinWidth - 140;
	OpenCombo.WinLeft=(WinWidth - EditWidth - 80) / 2;
	OpenCombo.WinTop=(WinHeight - OpenCombo.WinHeight) / 2;
	OpenCombo.SetSize(EditWidth,OpenCombo.WinHeight);
	OpenCombo.EditBoxWidth=OpenCombo.WinWidth - XL - 20;
}

function Notify (UWindowDialogControl C, byte E)
{
	Super.Notify(C,E);
	switch (E)
	{
		case 7:
		switch (C)
		{
			case OpenCombo:
			OpenURL();
			break;
			default:
		}
		default:
	}
}

function OpenURL ()
{
	local int i;
	local bool HistoryItem;
	local UWindowComboListItem Item;

	i=0;
JL0007:
	if ( i < 10 )
	{
		if ( OpenHistory[i] ~= OpenCombo.GetValue() )
		{
			HistoryItem=True;
		}
		i++;
		goto JL0007;
	}
	if (  !HistoryItem )
	{
		OpenCombo.InsertItem(OpenCombo.GetValue());
JL006D:
		if ( OpenCombo.List.Items.Count() > 10 )
		{
			OpenCombo.List.Items.Last.Remove();
			goto JL006D;
		}
		Item=UWindowComboListItem(OpenCombo.List.Items.Next);
		i=0;
JL00F4:
		if ( i < 10 )
		{
			if ( Item != None )
			{
				OpenHistory[i]=Item.Value;
				Item=UWindowComboListItem(Item.Next);
			}
			else
			{
				OpenHistory[i]="";
			}
			i++;
			goto JL00F4;
		}
	}
	SaveConfig();
	if ( Left(OpenCombo.GetValue(),7) ~= "http://" )
	{
		GetPlayerOwner().ConsoleCommand("start " $ OpenCombo.GetValue());
	}
	else
	{
		if ( Left(OpenCombo.GetValue(),9) ~= "unreal://" )
		{
			GetPlayerOwner().ClientTravel(OpenCombo.GetValue(),0,False);
		}
		else
		{
			GetPlayerOwner().ClientTravel("unreal://" $ OpenCombo.GetValue(),0,False);
		}
	}
	GetParent(Class'UWindowFramedWindow').Close();
	Root.Console.CloseUWindow();
	OpenCombo.ClearValue();
}

function Paint (Canvas C, float X, float Y)
{
	DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'BlackTexture');
}

defaultproperties
{
    OpenText="Open:"
    OpenHelp="Enter a standard URL, or select one from the URL history.  Press Enter to activate."
}