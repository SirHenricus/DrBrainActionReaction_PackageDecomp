//================================================================================
// SPGloveBit.
//================================================================================
class SPGloveBit expands SPActor;

defaultproperties
{
    Physics=PHYS_Walking
    RemoteRole=0
    LifeSpan=3.00
    DrawType=DT_Sprite
    Texture=None
    Mesh=LodMesh'SPPUSH'
    DrawScale=0.10
    CollisionRadius=1.00
    CollisionHeight=1.00
    LightType=LT_Steady
    LightBrightness=129
    LightSaturation=64
    LightRadius=5
    bBounce=True
}