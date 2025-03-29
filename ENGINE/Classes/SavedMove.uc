//================================================================================
// SavedMove.
//================================================================================
class SavedMove expands Info
	native;

var SavedMove NextMove;
var float TimeStamp;
var float Delta;
var bool bRun;
var bool bDuck;
var bool bPressedJump;
var EDodgeDir DodgeMove;
var bool bSent;

final function Clear ()
{
	TimeStamp=0.00;
	Delta=0.00;
	bSent=False;
	DodgeMove=0;
	Acceleration=vect(0.00,0.00,0.00);
}