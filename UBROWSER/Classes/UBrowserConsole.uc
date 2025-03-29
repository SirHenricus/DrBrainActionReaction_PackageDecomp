//================================================================================
// UBrowserConsole.
//================================================================================
class UBrowserConsole expands WindowConsole
	transient;

event bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
{
	return Super(Console).KeyEvent(Key,Action,Delta);
}

exec function ShowUBrowser ()
{
	LaunchUWindow();
}