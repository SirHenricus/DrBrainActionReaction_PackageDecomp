//================================================================================
// Carcass.
//================================================================================
class Carcass expands Decoration
	native;

var bool bPlayerCarcass;
var() byte flies;
var() byte rats;
var() bool bReducedHeight;
var bool bDecorative;
var bool bSlidingCarcass;
var int CumulativeDamage;
var PlayerReplicationInfo PlayerOwner;
var Pawn Bugs;

function CreateReplacement ()
{
	if ( Bugs != None )
	{
		Bugs.Destroy();
	}
}

function Destroyed ()
{
	local Actor A;

	if ( Bugs != None )
	{
		Bugs.Destroy();
	}
	Super.Destroyed();
}

function Initfor (Actor Other)
{
}

function ChunkUp (int Damage)
{
	Destroy();
}

static simulated function bool AllowChunk (int N, name A)
{
	return True;
}

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	if (  !bDecorative )
	{
		bBobbing=False;
		SetPhysics(2);
	}
	if ( (Physics == 0) && (Momentum.Z < 0) )
	{
		Momentum.Z *= -1;
	}
	Velocity += 3 * Momentum / (Mass + 200);
	if ( DamageType == 'shot' )
	{
		Damage *= 0.40;
	}
	CumulativeDamage += Damage;
	if ( ((Damage > 30) ||  !IsAnimating()) && (CumulativeDamage > 0.80 * Mass) || (Damage > 0.40 * Mass) || (Velocity.Z > 150) &&  !IsAnimating() )
	{
		ChunkUp(Damage);
	}
	if ( bDecorative )
	{
		Velocity=vect(0.00,0.00,0.00);
	}
}

auto state Dying
{
	ignores  TakeDamage;
	
Begin:
	Sleep(0.20);
	GotoState('Dead');
}

state Dead
{
	function Timer ()
	{
		local bool bSeen;
		local Pawn aPawn;
		local float dist;
	
		if ( Region.Zone.NumCarcasses <= Region.Zone.MaxCarcasses )
		{
			if (  !PlayerCanSeeMe() )
			{
				Destroy();
			}
			else
			{
				SetTimer(2.00,False);
			}
		}
		else
		{
			Destroy();
		}
	}
	
	function AddFliesAndRats ()
	{
	}
	
	function CheckZoneCarcasses ()
	{
	}
	
	function BeginState ()
	{
		if ( bDecorative )
		{
			LifeSpan=0.00;
		}
		else
		{
			SetTimer(18.00,False);
		}
	}
	
Begin:
	FinishAnim();
	Sleep(5.00);
	CheckZoneCarcasses();
	Sleep(7.00);
	if (  !bDecorative &&  !bHidden &&  !Region.Zone.bWaterZone &&  !Region.Zone.bPainZone )
	{
		AddFliesAndRats();
	}
}

defaultproperties
{
    bDecorative=True
    bStatic=False
    bStasis=False
    Physics=PHYS_Falling
    LifeSpan=180.00
    AnimSequence=Dead
    AnimFrame=0.90
    DrawType=DT_Sprite
    Texture=Texture'S_Corpse'
    CollisionRadius=18.00
    CollisionHeight=4.00
    bCollideActors=True
    bCollideWorld=True
    bProjTarget=True
    Mass=180.00
    Buoyancy=105.00
}