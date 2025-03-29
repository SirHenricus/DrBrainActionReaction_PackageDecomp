//================================================================================
// SPGloveTrail.
//================================================================================
class SPGloveTrail expands SPActor;

event BeginPlay ()
{
	Super.BeginPlay();
	LoopAnim('flicker');
}

event Timer ()
{
	DrawScale *= 0.90;
}

defaultproperties
{
    DrawType=DT_Sprite
    Texture=Texture'Star'
    Mesh=LodMesh'Tail'
    DrawScale=0.20
    ScaleGlow=5.00
    bUnlit=True
    bParticles=True
}