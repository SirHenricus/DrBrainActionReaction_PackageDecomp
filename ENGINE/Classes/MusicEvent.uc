//================================================================================
// MusicEvent.
//================================================================================
class MusicEvent expands Triggers;

var() Music Song;
var() byte SongSection;
var() byte CdTrack;
var() EMusicTransition Transition;
var() bool bSilence;
var() bool bOnceOnly;
var() bool bAffectAllPlayers;

function BeginPlay ()
{
	if ( Song == None )
	{
		Song=Level.Song;
	}
	if ( bSilence )
	{
		SongSection=255;
		CdTrack=255;
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	local PlayerPawn P;
	local Pawn A;

	if ( bAffectAllPlayers )
	{
		A=Level.PawnList;
JL001D:
		if ( A != None )
		{
			if ( A.IsA('PlayerPawn') )
			{
				PlayerPawn(A).ClientSetMusic(Song,SongSection,CdTrack,Transition);
			}
			A=A.nextPawn;
			goto JL001D;
		}
	}
	else
	{
		P=PlayerPawn(EventInstigator);
		if ( P == None )
		{
			return;
		}
		P.ClientSetMusic(Song,SongSection,CdTrack,Transition);
	}
	if ( bOnceOnly )
	{
		SetCollision(False,False,False);
		Disable('Trigger');
	}
}

defaultproperties
{
    CdTrack=255
    Transition=MTRAN_Fade
    bAffectAllPlayers=True
}