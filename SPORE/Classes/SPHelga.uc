//================================================================================
// SPHelga.
//================================================================================
class SPHelga expands SPAbstractGoon;

function PlayFootStep ()
{
	PlaySound(Sound'step5',3,1.00);
}

defaultproperties
{
    FaceList(0)=Texture'SporeSkin.Lips.Lips.helgaTalk1'
    FaceList(1)=Texture'SporeSkin.Lips.Lips.helgaTalk2'
    FaceList(2)=Texture'SporeSkin.Lips.Lips.helgaTalk3'
    FaceList(3)=Texture'SporeSkin.Lips.Lips.helgaTalk4'
    FaceList(4)=Texture'SporeSkin.Lips.Lips.helgaTalk5'
    FaceList(5)=Texture'SporeSkin.Lips.Lips.helgaTalk6'
    FaceList(6)=Texture'SporeSkin.Lips.Lips.helgaTalk7'
    FaceList(7)=Texture'SporeSkin.Lips.Lips.helgaTalk8'
    Land=Sound'SPAbstractGoon.land05'
    DrawType=DT_Sprite
    Mesh=LodMesh'helga'
    DrawScale=2.00
    CollisionRadius=40.00
    CollisionHeight=53.00
}