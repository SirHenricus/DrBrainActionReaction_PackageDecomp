//================================================================================
// SPCornelius.
//================================================================================
class SPCornelius expands SPAbstractGoon;

function PlayLeftFootStep ()
{
	PlaySound(Sound'step2left',3,1.00);
}

function PlayRightFootStep ()
{
	PlaySound(Sound'step2right',3,1.00);
}

defaultproperties
{
    FaceList(0)=Texture'SporeSkin.Lips.Lips.cornyTalk1'
    FaceList(1)=Texture'SporeSkin.Lips.Lips.cornyTalk2'
    FaceList(2)=Texture'SporeSkin.Lips.Lips.cornyTalk3'
    FaceList(3)=Texture'SporeSkin.Lips.Lips.cornyTalk4'
    FaceList(4)=Texture'SporeSkin.Lips.Lips.cornyTalk5'
    FaceList(5)=Texture'SporeSkin.Lips.Lips.cornyTalk6'
    FaceList(6)=Texture'SporeSkin.Lips.Lips.cornyTalk7'
    FaceList(7)=Texture'SporeSkin.Lips.Lips.cornyTalk8'
    Land=Sound'SPPlayer.land02'
    DrawType=DT_Sprite
    Mesh=LodMesh'corny'
    DrawScale=1.10
    CollisionRadius=15.00
    CollisionHeight=31.00
}