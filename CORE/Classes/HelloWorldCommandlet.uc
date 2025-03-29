//================================================================================
// HelloWorldCommandlet.
//================================================================================
class HelloWorldCommandlet expands Commandlet
	transient;

var int intparm;
var string strparm;

function int Main (string Parms)
{
	Log("Hello, world!");
	if ( Parms != "" )
	{
		Log("Command line parameters=" $ Parms);
	}
	if ( intparm != 0 )
	{
		Log("You specified intparm=" $ string(intparm));
	}
	if ( strparm != "" )
	{
		Log("You specified strparm=" $ strparm);
	}
}

defaultproperties
{
    HelpCmd="HelloWorld"
    HelpOneLiner="Sample"
    HelpUsage="HelloWorld"
    HelpParm(0)="IntParm"
    HelpParm(1)="StrParm"
    HelpDesc(0)="An integer parameter"
    HelpDesc(1)="A string parameter"
}