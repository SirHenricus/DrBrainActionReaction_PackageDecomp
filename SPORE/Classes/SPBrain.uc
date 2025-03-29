//================================================================================
// SPBrain.
//================================================================================
class SPBrain expands SPPawn;

event BeginPlay ()
{
	Super.BeginPlay();
	SetTimer(Rand(3) + 1,False);
	GotoState('TotallyIgnoringPlayer');
}

event Timer ()
{
	if ( Rand(5) == 1 )
	{
		PlayAnim('thumbs',0.30);
	}
	else
	{
		PlayAnim('Typing',0.30);
	}
	SetTimer(Rand(3) + 1,False);
}

function PlayRunning ()
{
	LoopAnim('run');
}

function PlayIdleAnim ()
{
	if ( Rand(5) == 1 )
	{
		PlayAnim('thumbs',0.30);
	}
	else
	{
		PlayAnim('Typing',0.30);
	}
}

state TotallyIgnoringPlayer expands TotallyIgnoringPlayer
{
	ignores  TakeDamage, KilledBy;
	
Begin:
}

defaultproperties
{
    FaceList(0)=Texture'SporeSkin.Lips.Lips.BrainTalk1'
    FaceList(1)=Texture'SporeSkin.Lips.Lips.BrainTalk2'
    FaceList(2)=Texture'SporeSkin.Lips.Lips.BrainTalk3'
    FaceList(3)=Texture'SporeSkin.Lips.Lips.BrainTalk4'
    FaceList(4)=Texture'SporeSkin.Lips.Lips.BrainTalk5'
    FaceList(5)=Texture'SporeSkin.Lips.Lips.BrainTalk6'
    FaceList(6)=Texture'SporeSkin.Lips.Lips.BrainTalk7'
    FaceList(7)=Texture'SporeSkin.Lips.Lips.BrainTalk8'
    DrawType=DT_Sprite
    Mesh=LodMesh'brain'
    DrawScale=1.60
    CollisionRadius=18.00
    CollisionHeight=48.00
}