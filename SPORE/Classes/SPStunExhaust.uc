//================================================================================
// SPStunExhaust.
//================================================================================
class SPStunExhaust expands SPExhaust;

simulated event PreBeginPlay ()
{
	Super.PreBeginPlay();
	if ( Level.bEnhancedContent )
	{
		Texture=FireTexture(DynamicLoadObject("SporeFX.Missle04",Class'FireTexture'));
	}
	else
	{
		Texture=Texture(DynamicLoadObject("SporeFX.Missle04",Class'Texture'));
	}
}

defaultproperties
{
    spriteTextures(0)=None
    spriteTextures(1)=None
    spriteTextures(2)=None
    spriteTextures(3)=None
    spriteTextures(4)=None
    NumberOfRandomSpriteTextures=0
    DrawScale=0.20
}