//================================================================================
// SPStars.
//================================================================================
class SPStars expands SPActor;

event BeginPlay ()
{
	LoopAnim('Stars',0.30);
}

defaultproperties
{
    DrawType=DT_Sprite
    Texture=Texture'SporeSkin.Lips.Misc.Star12'
    Mesh=LodMesh'Stars'
    DrawScale=0.40
    ScaleGlow=5.00
    bUnlit=True
    bParticles=True
}