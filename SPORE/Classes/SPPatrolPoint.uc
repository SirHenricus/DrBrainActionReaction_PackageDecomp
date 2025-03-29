//================================================================================
// SPPatrolPoint.
//================================================================================
class SPPatrolPoint expands PatrolPoint;

var() bool bPushable;

function Bump (Actor Other)
{
	local float speed;
	local float oldZ;

	if ( bPushable )
	{
		oldZ=Velocity.Z;
		speed=VSize(Other.Velocity);
		Velocity=Other.Velocity * 2;
		Velocity.Z=500.00;
		SetPhysics(2);
		Instigator=Pawn(Other);
	}
}

defaultproperties
{
    bStatic=False
    bCollideWhenPlacing=False
    bStasis=True
    bDirectional=False
    CollisionRadius=10.00
    CollisionHeight=30.00
    Mass=10.00
}