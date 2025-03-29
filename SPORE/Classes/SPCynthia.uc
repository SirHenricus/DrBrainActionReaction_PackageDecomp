//================================================================================
// SPCynthia.
//================================================================================
class SPCynthia expands SPAbstractGoon;

function PlayFootStep ()
{
	PlaySound(Sound'step2left',3,1.00);
}

defaultproperties
{
    FaceList(0)=Texture'SporeSkin.Lips.Lips.CFOTALK1'
    FaceList(1)=Texture'SporeSkin.Lips.Lips.CFOTALK2'
    FaceList(2)=Texture'SporeSkin.Lips.Lips.CFOTALK3'
    FaceList(3)=Texture'SporeSkin.Lips.Lips.CFOTALK4'
    FaceList(4)=Texture'SporeSkin.Lips.Lips.CFOTALK5'
    FaceList(5)=Texture'SporeSkin.Lips.Lips.CFOTALK6'
    FaceList(6)=Texture'SporeSkin.Lips.Lips.CFOTALK7'
    FaceList(7)=Texture'SporeSkin.Lips.Lips.CFOTALK8'
    Land=Sound'SPPlayer.land02'
    DrawType=DT_Sprite
    Mesh=LodMesh'cyn'
    DrawScale=2.00
    CollisionHeight=55.00
}