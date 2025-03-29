//================================================================================
// SPSporeBase.
//================================================================================
class SPSporeBase expands SPActor;

var() float RotationAmount;

function BeginPlay ()
{
	Super.BeginPlay();
	SetTimer(0.50,True);
}

auto state Rotating
{
	function Tick (float DeltaTime)
	{
		local Rotator NewRot;
	
		NewRot=Rotation;
		NewRot.Yaw=Rotation.Yaw + DeltaTime * RotationAmount;
		SetRotation(NewRot);
	}
	
	function Timer ()
	{
		local Rotator bubblerot;
		local Vector newloc;
		local SPBubble bubble;
		local int i;
		local int j;
	
		RotateAboutAxis(bubblerot,vect(0.00,0.00,1.00),11300.00);
		newloc=vector((Rotation + bubblerot)) * 420;
		newloc.Z=newloc.Z - 16 * 14;
		i=0;
	JL005E:
		if ( i < 3 )
		{
			newloc.X=newloc.X + Rand(15);
			newloc.Y=newloc.Y + Rand(15);
			bubble=Spawn(Class'SPBubble',,,newloc);
			bubble.DrawScale=0.50;
			bubble.Texture=Texture'bubgroup1';
			bubble.LifeSpan=5.00;
			i++;
			goto JL005E;
		}
		RotateAboutAxis(bubblerot,vect(0.00,0.00,1.00),20500.00);
		newloc=vector((Rotation + bubblerot)) * 500;
		newloc.Z=newloc.Z - 16 * 14;
		i=0;
	JL015B:
		if ( i < 3 )
		{
			newloc.X=newloc.X + Rand(15);
			newloc.Y=newloc.Y + Rand(15);
			bubble=Spawn(Class'SPBubble',,,newloc);
			bubble.DrawScale=0.50;
			bubble.Texture=Texture'bubgroup2';
			bubble.LifeSpan=5.00;
			i++;
			goto JL015B;
		}
		RotateAboutAxis(bubblerot,vect(0.00,0.00,1.00),22000.00);
		newloc=vector((Rotation + bubblerot)) * 450;
		newloc.Z=newloc.Z - 16 * 14;
		i=0;
	JL0258:
		if ( i < 3 )
		{
			newloc.X=newloc.X + Rand(15);
			newloc.Y=newloc.Y + Rand(15);
			bubble=Spawn(Class'SPBubble',,,newloc);
			bubble.DrawScale=0.50;
			bubble.Texture=Texture'bubgroup3';
			bubble.LifeSpan=5.00;
			i++;
			goto JL0258;
		}
	}
	
Begin:
	LoopAnim('spin');
}

defaultproperties
{
    RotationAmount=30.00
    DrawType=DT_Sprite
    Mesh=LodMesh'Base'
}