//================================================================================
// SPAbstractGoon.
//================================================================================
class SPAbstractGoon expands SPPawn
	abstract;

function PlayRunning ()
{
	LoopAnim('run',0.70);
}

function PlayWalking ()
{
	LoopAnim('march',0.50);
}

function PlayIdleAnim ()
{
	if ( FRand() < 0.90 )
	{
		PlayAnim('chill1',0.10);
	}
	else
	{
		PlayAnim('chill2',0.30);
	}
}

function PlayLooking ()
{
	PlayAnim('look');
}

function PlayMeleeAttack ()
{
	if ( Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000 )
	{
		PlayAnim('chillgrab');
	}
	else
	{
		PlayAnim('rungrab');
	}
}

function PlayFalling ()
{
	LoopAnim('fall',0.70);
}

function PlayKO ()
{
	PlayAnim('ko',0.30);
}

function PlayStun ()
{
	PlayAnim('hit');
}

function PlayFootStep ()
{
}

defaultproperties
{
    Land=Sound'SPAbstractGoon.land04'
}