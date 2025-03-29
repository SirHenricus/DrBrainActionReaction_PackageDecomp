//================================================================================
// SPPawnGenerator.
//================================================================================
class SPPawnGenerator expands SPTurret;

var() Class<SPPawn> PawnType;
var() name PawnOrders;
var() name PawnDirection;
var() float PawnGroundSpeed;

function FireProjectile ()
{
	local Vector Start;
	local SPPawn Pawn;

	Start=Location + vector(Rotation) * 10;
	Pawn=Spawn(PawnType,,,Start,Rotation);
	if ( Pawn != None )
	{
		Pawn.Orders=PawnOrders;
		Pawn.InitialDirection=PawnDirection;
		Pawn.LifeSpan=ProjectileLifeSpan;
		if ( PawnGroundSpeed != 0 )
		{
			Pawn.GroundSpeed=PawnGroundSpeed;
		}
	}
}

defaultproperties
{
    bCheckRange=True
}