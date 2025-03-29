//================================================================================
// SPExhaust.
//================================================================================
class SPExhaust expands SPActor;

var float DefaultDrawScale;
var() Texture spriteTextures[6];
var() int NumberOfRandomSpriteTextures;

simulated event BeginPlay ()
{
	DefaultDrawScale=DrawScale;
	LifeSpan=1.00 * FRand();
	DrawScale=DefaultDrawScale * FRand();
	if ( NumberOfRandomSpriteTextures > 0 )
	{
		Texture=spriteTextures[Rand(NumberOfRandomSpriteTextures)];
	}
}

simulated event Tick (float Time)
{
	DrawScale *= 0.90;
}

defaultproperties
{
    spriteTextures(0)=Texture'SporeSkin.Lips.Misc.Star02'
    spriteTextures(1)=Texture'SporeSkin.Lips.Misc.Star11'
    spriteTextures(2)=Texture'SporeSkin.Lips.Misc.Star12'
    spriteTextures(3)=Texture'SporeSkin.Lips.Misc.Star14'
    spriteTextures(4)=Texture'SporeSkin.Lips.Misc.Star15'
    NumberOfRandomSpriteTextures=5
    RemoteRole=0
    Texture=Texture'SporeSkin.Lips.Misc.Star02'
    DrawScale=0.40
}