//================================================================================
// Engine.
//================================================================================
class Engine expands Subsystem
	native
	noexport
	transient;

var(Drivers) config Class<RenderDevice> GameRenderDevice;
var(Drivers) config Class<AudioSubsystem> AudioDevice;
var(Drivers) config Class<Console> Console;
var(Drivers) config Class<NetDriver> NetworkDevice;
var(Drivers) config Class<Language> Language;
var Primitive Cylinder;
var const Client Client;
var const RenderBase Render;
var const AudioSubsystem Audio;
var int TickCycles;
var int GameCycles;
var int ClientCycles;
var(Settings) config int CacheSizeMegs;
var(Settings) config bool UseSound;

defaultproperties
{
    CacheSizeMegs=2
    UseSound=True
}