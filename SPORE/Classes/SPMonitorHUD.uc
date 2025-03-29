//================================================================================
// SPMonitorHUD.
//================================================================================
class SPMonitorHUD expands SPHud
	config(User);

var() localized string CameraModeString;
var() localized string StaticString;
var() localized string TrackingString;
var() localized string RemoteControlString;
var() localized string HScanString;
var() localized string UnknownString;
var bool bIndicatorOn;

event BeginPlay ()
{
	SetTimer(1.00,True);
}

event Timer ()
{
	bIndicatorOn= !bIndicatorOn;
}

simulated function PostRender (Canvas Canvas)
{
	local PlayerPawn Player;
	local int X;
	local int Y;
	local int xSize;
	local int ySize;
	local float x2;
	local float y2;
	local SPCamera cam;
	local string cameraMode;
	local Texture tex1;
	local Texture tex2;
	local Texture tex3;
	local Texture tex4;

	HUDSetup(Canvas);
	Player=PlayerPawn(Owner);
	if ( Player != None )
	{
		if ( Player.bShowMenu )
		{
			if ( MainMenu == None )
			{
				CreateMenu();
			}
			if ( MainMenu != None )
			{
				MainMenu.DrawMenu(Canvas);
			}
			return;
		}
		Canvas.Style=2;
		X=0;
		Y=0;
		xSize=Canvas.ClipX - 2 * X;
		ySize=Canvas.ClipY - 2 * Y;
		x2=X + xSize / 2;
		y2=Y + ySize / 2;
		if ( (Canvas.ClipX > 512) && (Canvas.ClipY > 512) )
		{
			tex1=Texture'MonitorBack1';
			tex2=Texture'MonitorBack2';
			tex3=Texture'MonitorBack3';
			tex4=Texture'MonitorBack4';
		}
		else
		{
			if ( (Canvas.ClipX > 256) && (Canvas.ClipY > 256) )
			{
				tex1=Texture'MonitorBack1_128';
				tex2=Texture'MonitorBack2_128';
				tex3=Texture'MonitorBack3_128';
				tex4=Texture'MonitorBack4_128';
			}
			else
			{
				tex1=Texture'MonitorBack1_64';
				tex2=Texture'MonitorBack2_64';
				tex3=Texture'MonitorBack3_64';
				tex4=Texture'MonitorBack4_64';
			}
		}
		Canvas.SetPos(X,Y);
		Canvas.DrawRect(tex1,xSize / 2,ySize / 2);
		Canvas.SetPos(x2,Y);
		Canvas.DrawRect(tex2,xSize / 2,ySize / 2);
		Canvas.SetPos(X,y2);
		Canvas.DrawRect(tex3,xSize / 2,ySize / 2);
		Canvas.SetPos(x2,y2);
		Canvas.DrawRect(tex4,xSize / 2,ySize / 2);
		if ( bIndicatorOn )
		{
			Canvas.SetPos(Canvas.ClipX * 0.10,Canvas.ClipY * 0.85);
			Canvas.Font=Canvas.MedFont;
			if ( Player.IsA('SPPlayer') && (SPPlayer(Player).CameraInterface != None) )
			{
				cam=SPPlayer(Player).CameraInterface.CurCamera;
				if ( cam != None )
				{
					if ( cam.cameraMode == 0 )
					{
						cameraMode=StaticString;
					}
					else
					{
						if ( cam.cameraMode == 1 )
						{
							cameraMode=TrackingString;
						}
						else
						{
							if ( cam.cameraMode == 3 )
							{
								cameraMode=RemoteControlString;
							}
							else
							{
								if ( cam.cameraMode == 2 )
								{
									cameraMode=HScanString;
								}
								else
								{
									cameraMode=UnknownString;
								}
							}
						}
					}
				}
			}
			else
			{
				cameraMode=UnknownString;
			}
			Canvas.DrawText(CameraModeString $ cameraMode,False);
		}
	}
}

defaultproperties
{
    CameraModeString="Camera Mode: "
    StaticString="Static"
    TrackingString="Tracking"
    RemoteControlString="Remote Control"
    HScanString="Horizontal Scan"
    UnknownString="Unknown"
}