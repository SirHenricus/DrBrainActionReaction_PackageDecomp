//================================================================================
// Spectator.
//================================================================================
class Spectator expands PlayerPawn
	config(User);

var bool bChaseCam;

function InitPlayerReplicationInfo ()
{
	Super.InitPlayerReplicationInfo();
	PlayerReplicationInfo.bIsSpectator=True;
}

event FootZoneChange (ZoneInfo newFootZone)
{
}

event HeadZoneChange (ZoneInfo newHeadZone)
{
}

exec function Walk ()
{
}

exec function ActivateItem ()
{
	bBehindView= !bBehindView;
	bChaseCam=bBehindView;
}

exec function BehindView (bool B)
{
	bBehindView=B;
	bChaseCam=bBehindView;
}

function ChangeTeam (int N)
{
	Level.Game.ChangeTeam(self,N);
}

exec function Taunt (name Sequence)
{
}

exec function CallForHelp ()
{
}

exec function ThrowWeapon ()
{
}

exec function Suicide ()
{
}

exec function Fly ()
{
	UnderWaterTime=-1.00;
	SetCollision(False,False,False);
	bCollideWorld=True;
	GotoState('CheatFlying');
	ClientReStart();
}

function ServerChangeSkin (coerce string SkinName, coerce string FaceName, byte TeamNum)
{
}

function ClientReStart ()
{
	Velocity=vect(0.00,0.00,0.00);
	Acceleration=vect(0.00,0.00,0.00);
	BaseEyeHeight=Default.BaseEyeHeight;
	EyeHeight=BaseEyeHeight;
	GotoState('CheatFlying');
}

function PlayerTimeout ()
{
	if ( Health > 0 )
	{
		Died(None,'dropped',Location);
	}
}

exec function Grab ()
{
}

exec function Say (string S)
{
	if (  !Level.Game.bMuteSpectators )
	{
		BroadcastMessage(PlayerReplicationInfo.PlayerName $ ":" $ S,True);
	}
}

exec function RestartLevel ()
{
}

function Possess ()
{
	bIsPlayer=True;
	DodgeClickTime=FMin(0.30,DodgeClickTime);
	EyeHeight=BaseEyeHeight;
	NetPriority=8.00;
	Weapon=None;
	Inventory=None;
	Fly();
}

function PostBeginPlay ()
{
	if ( Level.LevelEnterText != "" )
	{
		ClientMessage(Level.LevelEnterText);
	}
	bIsPlayer=True;
	FlashScale=vect(1.00,1.00,1.00);
	if ( Level.NetMode != 3 )
	{
		ScoringType=Level.Game.ScoreBoardType;
	}
}

exec function SwitchWeapon (byte F)
{
}

exec function NextItem ()
{
}

exec function PrevItem ()
{
}

exec function Fire (optional float F)
{
	ViewPlayerNum(-1);
	bBehindView=bChaseCam;
}

exec function AltFire (optional float F)
{
	bBehindView=False;
	ViewTarget=None;
	ClientMessage("Now viewing from own camera",'Event',True);
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
}

defaultproperties
{
    bChaseCam=True
    Visibility=0
    AttitudeToPlayer=ATTITUDE_Hate
    MenuName="Spectator"
    bHidden=True
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
}