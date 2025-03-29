//================================================================================
// SPFlyer.
//================================================================================
class SPFlyer expands SPActor;

var PlayerPawn Player;
var Vector Vel;
var Vector Accel;
var bool bInAir;
var() float ForwardSpeed;
var() int fuel;

event Touch (Actor Other)
{
	if ( PlayerPawn(Other) != None )
	{
		Player=PlayerPawn(Other);
	}
}

event Bump (Actor Other)
{
	Touch(Other);
}

event Tick (float DeltaTime)
{
	local Vector Loc;
	local Vector dMove;
	local Vector oldVel;
	local bool bMoved;

	if ( Player == None )
	{
		return;
	}
	if ( Player.Base == self )
	{
		GetInput();
	}
	Accel.Z=-0.30;
	oldVel=Vel;
	Vel.Z += Accel.Z;
	bMoved=MoveSmooth(Vel);
	if (  !bMoved )
	{
		Vel=vect(0.00,0.00,0.00);
	}
}

function GetInput ()
{
	if ( Player.bExtra0 != 0 )
	{
		LoopAnim('flame');
		MoveUp();
		if ( Player.bExtra1 != 0 )
		{
			AddFuel(10);
		}
	}
	else
	{
		LoopAnim('still');
	}
}

function MoveUp ()
{
	local Vector Loc;
	local Vector dMove;

	if ( fuel > 0 )
	{
		Vel.Z += 0.60;
		Vel.X=0.00;
		Vel.Y=0.00;
		dMove=vector(Player.ViewRotation) * ForwardSpeed;
		dMove.Z=0.00;
		Vel += dMove;
		fuel--;
	}
}

function AddFuel (int Amount)
{
	fuel += Amount;
}

defaultproperties
{
    ForwardSpeed=6.00
    fuel=10000
    Physics=PHYS_Walking
    DrawType=DT_Sprite
    Mesh=LodMesh'flystick'
    CollisionRadius=25.00
    CollisionHeight=16.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}