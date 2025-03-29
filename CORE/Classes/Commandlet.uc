//================================================================================
// Commandlet.
//================================================================================
class Commandlet expands Object
	native
	noexport
	abstract
	transient;

var localized string HelpCmd;
var localized string HelpOneLiner;
var localized string HelpUsage;
var localized string HelpWebLink;
var localized string HelpParm[16];
var localized string HelpDesc[16];
var bool LogToStdout;
var bool IsServer;
var bool IsClient;
var bool IsEditor;
var bool LazyLoad;
var bool ShowErrorCount;
var bool ShowBanner;

native event int Main (string Parms);

defaultproperties
{
    LogToStdout=True
    IsServer=True
    IsClient=True
    IsEditor=True
    LazyLoad=True
    ShowBanner=True
}