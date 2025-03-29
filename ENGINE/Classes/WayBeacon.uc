//================================================================================
// WayBeacon.
//================================================================================
class WayBeacon expands Keypoint;

function PostBeginPlay ()
{
	local Class<Actor> NewClass;

	Super.PostBeginPlay();
	NewClass=Class<Actor>(DynamicLoadObject("Unreali.Lamp4",Class'Class'));
	if ( NewClass != None )
	{
		Mesh=NewClass.Default.Mesh;
	}
}

function Touch (Actor Other)
{
	if ( Other == Owner )
	{
		if ( Owner.IsA('PlayerPawn') )
		{
			PlayerPawn(Owner).ShowPath();
		}
		Destroy();
	}
}

defaultproperties
{
    bStatic=False
    bHidden=False
    RemoteRole=0
    LifeSpan=6.00
    DrawType=DT_Sprite
    DrawScale=0.50
    AmbientGlow=40
    bOnlyOwnerSee=True
    bCollideActors=True
    LightType=LT_Steady
    LightBrightness=125
    LightSaturation=125
}