//================================================================================
// HUD.
//================================================================================
class HUD expands Actor
	native
	abstract
	config(User);

var globalconfig int HudMode;
var globalconfig int Crosshair;
var() Class<Menu> MainMenuType;
var() string HUDConfigWindowType;
var Menu MainMenu;

simulated event PreRender (Canvas Canvas);

simulated event PostRender (Canvas Canvas);

simulated function InputNumber (byte F);

simulated function ChangeHud (int D);

simulated function ChangeCrosshair (int D);

simulated function DrawCrossHair (Canvas Canvas, int StartX, int StartY);

simulated function Message (PlayerReplicationInfo PRI, coerce string Msg, name N);

simulated function PlayReceivedMessage (string S, string PName, ZoneInfo PZone)
{
	PlayerPawn(Owner).ClientMessage(S);
	if ( PlayerPawn(Owner).bMessageBeep )
	{
		PlayerPawn(Owner).PlayBeepSound();
	}
}

simulated function bool DisplayMessages (Canvas Canvas)
{
	return False;
}

defaultproperties
{
    HUDConfigWindowType="UMenu.UMenuHUDConfigCW"
    bHidden=True
    RemoteRole=ROLE_DumbProxy
}