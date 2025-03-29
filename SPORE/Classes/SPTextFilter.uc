//================================================================================
// SPTextFilter.
//================================================================================
class SPTextFilter expands Actor
	native;

var bool bReady;

native final function Init ();

native final function bool PhraseAllowed (string phrase);

native final function CreateTextFilter (string allowed, string disallowed, string badwords);

native final function Destruct ();

event BeginPlay ()
{
	Init();
	SetDictionaries("allwords.txt","syscom","wintrans");
}

function SetDictionaries (string allowed, string disallowed, string badphrases)
{
	CreateTextFilter(allowed,disallowed,badphrases);
	bReady=True;
}

function bool TextAllowed (string Text)
{
	if ( bReady )
	{
		if ( PhraseAllowed(Text) )
		{
			return True;
		}
		else
		{
			return False;
		}
	}
	else
	{
		Log(string(self) $ "::TextAllowed <ERROR> Dictionaries haven't been set yet!!!");
		return False;
	}
}

event Destroyed ()
{
	Destruct();
}

defaultproperties
{
    bHidden=True
}