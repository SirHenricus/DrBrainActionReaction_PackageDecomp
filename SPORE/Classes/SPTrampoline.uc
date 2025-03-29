//================================================================================
// SPTrampoline.
//================================================================================
class SPTrampoline expands SPActor;

var() Class<Actor> LimitedToClass;
var Actor Pending;
var() float JumpZ;
var() bool bBrokenAfterFirstUse;

event HitWall (Vector HitNormal, Actor Wall)
{
	if ( (SPBall(Wall) == None) && (PlayerPawn(Wall) == None) && (SPPawn(Wall) == None) && (SPPushProjectile(Wall) == None) )
	{
		Velocity=vect(0.00,0.00,0.00);
	}
}

auto state Coiled
{
	function Timer ()
	{
		Pending.SetPhysics(2);
		Pending.Velocity.Z=JumpZ;
		Pending=None;
		PlaySound(Sound'tramp',3,1.00);
		if ( bBrokenAfterFirstUse )
		{
			PlayAnim('open2',0.50);
			Enable('AnimEnd');
		}
		else
		{
			PlayAnim('open1');
			Enable('AnimEnd');
		}
		GotoState('Uncoiled');
	}
	
	function AnimEnd ()
	{
		if (  !bBrokenAfterFirstUse )
		{
			TweenAnim('still',0.20);
			Disable('AnimEnd');
		}
	}
	
	function Bump (Actor Other)
	{
		if ( (Other.Physics == 2) && ((LimitedToClass == None) || (Other.Class == LimitedToClass)) )
		{
			Pending=Other;
			SetTimer(0.01,False);
		}
	}
	
Begin:
}

state Uncoiled
{
	function AnimEnd ()
	{
		if ( bBrokenAfterFirstUse )
		{
			GotoState('Broken');
		}
		else
		{
			PlayAnim('close1');
			Disable('AnimEnd');
			GotoState('Coiled');
		}
	}
	
	function Timer ()
	{
		Pending.SetPhysics(2);
		Pending.Velocity.Z=JumpZ;
		Pending=None;
		if ( bBrokenAfterFirstUse )
		{
			PlayAnim('open2',0.50);
			Enable('AnimEnd');
		}
		else
		{
			PlayAnim('open1');
			Enable('AnimEnd');
		}
		GotoState('Uncoiled');
	}
	
	function Bump (Actor Other)
	{
		if ( (Other.Physics == 2) && ((LimitedToClass == None) || (Other.Class == LimitedToClass)) )
		{
			if (  !bBrokenAfterFirstUse )
			{
				Pending=Other;
				SetTimer(0.01,False);
			}
		}
	}
	
Begin:
}

state Broken
{
}

defaultproperties
{
    JumpZ=500.00
    DrawType=DT_Sprite
    Mesh=LodMesh'trampo'
    DrawScale=2.00
    CollisionRadius=50.00
    CollisionHeight=7.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
    bProjTarget=True
}