//================================================================================
// SPBubbleProjectile.
//================================================================================
class SPBubbleProjectile expands SPPushProjectile;

simulated function Timer ()
{
}

auto state Flying expands Flying
{
	simulated function Destroyed ()
	{
	}
	
}

defaultproperties
{
    DrawType=DT_Sprite
    Style=STY_Normal
    Texture=Texture'bubble'
    Mesh=None
    AmbientSound=None
    LightBrightness=27
    LightHue=153
}