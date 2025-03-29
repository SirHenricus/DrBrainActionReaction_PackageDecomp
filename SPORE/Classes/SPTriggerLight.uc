//================================================================================
// SPTriggerLight.
//================================================================================
class SPTriggerLight expands Light;

var() bool bStartOn;
var() bool bToggle;
var byte savedBrightness;
var bool bLightIsOn;

event BeginPlay ()
{
	savedBrightness=LightBrightness;
	if (  !bStartOn )
	{
		LightBrightness=0;
	}
}

event Trigger (Actor Other, Pawn EventInstigator)
{
	if ( bToggle )
	{
		bLightIsOn= !bLightIsOn;
	}
	else
	{
		bLightIsOn=True;
	}
	if ( bLightIsOn )
	{
		LightBrightness=savedBrightness;
	}
	else
	{
		LightBrightness=0;
	}
}