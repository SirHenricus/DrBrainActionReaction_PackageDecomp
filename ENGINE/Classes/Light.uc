//================================================================================
// Light.
//================================================================================
class Light expands Actor
	native;

defaultproperties
{
    bStatic=True
    bHidden=True
    bNoDelete=True
    bMovable=False
    Texture=Texture'S_Light'
    CollisionRadius=24.00
    CollisionHeight=24.00
    LightType=LT_Steady
    LightBrightness=64
    LightSaturation=255
    LightRadius=64
    LightPeriod=32
    LightCone=128
    VolumeBrightness=64
}