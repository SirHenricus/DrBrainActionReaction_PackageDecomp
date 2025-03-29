//================================================================================
// Decoration.
//================================================================================
class Decoration expands Actor
	native
	abstract;

var() Class<Actor> EffectWhenDestroyed;
var() bool bPushable;
var() bool bOnlyTriggerable;
var bool bSplash;
var bool bBobbing;
var bool bWasCarried;
var() Sound PushSound;
var const int numLandings;
var() Class<Inventory> contents;
var() Class<Inventory> content2;
var() Class<Inventory> content3;
var() Sound EndPushSound;
var bool bPushSoundPlaying;

simulated function FollowHolder (Actor Other);

function Landed (Vector HitNormall)
{
	if ( bWasCarried &&  !SetLocation(Location) )
	{
		if ( (Instigator != None) && (VSize(Instigator.Location - Location) < CollisionRadius + Instigator.CollisionRadius) )
		{
			SetLocation(Instigator.Location);
		}
		TakeDamage(1000,Instigator,Location,vect(0.00,0.00,1.00) * 900,'exploded');
	}
	bWasCarried=False;
	bBobbing=False;
}

singular function ZoneChange (ZoneInfo NewZone)
{
	local float splashSize;
	local Actor splash;

	if ( NewZone.bWaterZone )
	{
		if ( bSplash &&  !Region.Zone.bWaterZone && (Mass <= Buoyancy) && ((Abs(Velocity.Z) < 100) || (Mass == 0)) && (FRand() < 0.05) &&  !PlayerCanSeeMe() )
		{
			bSplash=False;
			SetPhysics(0);
		}
		else
		{
			if (  !Region.Zone.bWaterZone && (Velocity.Z < -200) )
			{
				splashSize=FClamp(0.00 * Mass * (250 - 0.50 * FMax(-600.00,Velocity.Z)),1.00,3.00);
				if ( NewZone.EntrySound != None )
				{
					PlaySound(NewZone.EntrySound,3,splashSize);
				}
				if ( NewZone.EntryActor != None )
				{
					splash=Spawn(NewZone.EntryActor);
					if ( splash != None )
					{
						splash.DrawScale=splashSize;
					}
				}
			}
		}
		bSplash=True;
	}
	else
	{
		if ( Region.Zone.bWaterZone && (Buoyancy > Mass) )
		{
			bBobbing=True;
			if ( Buoyancy > 1.10 * Mass )
			{
				Buoyancy=0.95 * Buoyancy;
			}
			else
			{
				if ( Buoyancy > 1.03 * Mass )
				{
					Buoyancy=0.99 * Buoyancy;
				}
			}
		}
	}
	if ( NewZone.bPainZone && (NewZone.DamagePerSec > 0) )
	{
		TakeDamage(100,None,Location,vect(0.00,0.00,0.00),NewZone.DamageType);
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	Instigator=EventInstigator;
	TakeDamage(1000,Instigator,Location,vect(0.00,0.00,1.00) * 900,'exploded');
}

singular function BaseChange ()
{
	local float decorMass;
	local float decorMass2;

	decorMass=FMax(1.00,Mass);
	bBobbing=False;
	if ( Velocity.Z < -500 )
	{
		TakeDamage(1 - Velocity.Z / 30,Instigator,Location,vect(0.00,0.00,0.00),'Crushed');
	}
	if ( (Base == None) && (bPushable || IsA('Carcass')) && (Physics == 0) )
	{
		SetPhysics(2);
	}
	else
	{
		if ( (Pawn(Base) != None) && (Pawn(Base).carriedDecoration != self) )
		{
			Base.TakeDamage((1 - Velocity.Z / 400) * decorMass / Base.Mass,Instigator,Location,0.50 * Velocity,'Crushed');
			Velocity.Z=100.00;
			if ( FRand() < 0.50 )
			{
				Velocity.X += 70;
			}
			else
			{
				Velocity.Y += 70;
			}
			SetPhysics(2);
		}
		else
		{
			if ( (Decoration(Base) != None) && (Velocity.Z < -500) )
			{
				decorMass2=FMax(Decoration(Base).Mass,1.00);
				Base.TakeDamage(1 - decorMass / decorMass2 * Velocity.Z / 30,Instigator,Location,0.20 * Velocity,'stomped');
				Velocity.Z=100.00;
				if ( FRand() < 0.50 )
				{
					Velocity.X += 70;
				}
				else
				{
					Velocity.Y += 70;
				}
				SetPhysics(2);
			}
			else
			{
				Instigator=None;
			}
		}
	}
}

function Destroyed ()
{
	local Actor dropped;
	local Actor A;
	local Class<Actor> tempClass;

	if ( (Pawn(Base) != None) && (Pawn(Base).carriedDecoration == self) )
	{
		Pawn(Base).DropDecoration();
	}
	if ( (contents != None) &&  !Level.bStartup )
	{
		tempClass=contents;
		if ( (content2 != None) && (FRand() < 0.30) )
		{
			tempClass=content2;
		}
		if ( (content3 != None) && (FRand() < 0.30) )
		{
			tempClass=content3;
		}
		dropped=Spawn(tempClass);
		dropped.RemoteRole=1;
		dropped.SetPhysics(2);
		dropped.bCollideWorld=True;
		if ( Inventory(dropped) != None )
		{
			Inventory(dropped).GotoState('Pickup','dropped');
		}
	}
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(self,None);
		}
	}
	Super.Destroyed();
}

simulated function skinnedFrag (Class<Fragment> FragType, Texture FragSkin, Vector Momentum, float DSize, int NumFrags)
{
	local int i;
	local Actor A;
	local Actor Toucher;
	local Fragment S;

	if ( bOnlyTriggerable )
	{
		return;
	}
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(Toucher,Pawn(Toucher));
		}
	}
	if ( Region.Zone.bDestructive )
	{
		Destroy();
		return;
	}
	i=0;
JL0072:
	if ( i < NumFrags )
	{
		S=Spawn(FragType,Owner);
		S.CalcVelocity(Momentum / 100,0.00);
		S.Skin=FragSkin;
		S.DrawScale=DSize * 0.50 + 0.70 * DSize * FRand();
		i++;
		goto JL0072;
	}
	Destroy();
}

simulated function Frag (Class<Fragment> FragType, Vector Momentum, float DSize, int NumFrags)
{
	local int i;
	local Actor A;
	local Actor Toucher;
	local Fragment S;

	if ( bOnlyTriggerable )
	{
		return;
	}
	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(Toucher,Pawn(Toucher));
		}
	}
	if ( Region.Zone.bDestructive )
	{
		Destroy();
		return;
	}
	i=0;
JL0072:
	if ( i < NumFrags )
	{
		S=Spawn(FragType,Owner);
		S.CalcVelocity(Momentum,0.00);
		S.DrawScale=DSize * 0.50 + 0.70 * DSize * FRand();
		i++;
		goto JL0072;
	}
	Destroy();
}

function Timer ()
{
	PlaySound(EndPushSound,1,0.00);
	bPushSoundPlaying=False;
}

function Bump (Actor Other)
{
	local float speed;
	local float oldZ;

	if ( bPushable && (Pawn(Other) != None) && (Other.Mass > 40) )
	{
		bBobbing=False;
		oldZ=Velocity.Z;
		speed=VSize(Other.Velocity);
		Velocity=Other.Velocity * FMin(120.00,20.00 + speed) / speed;
		if ( Physics == 0 )
		{
			Velocity.Z=25.00;
			if (  !bPushSoundPlaying )
			{
				PlaySound(PushSound,1,0.25);
			}
			bPushSoundPlaying=True;
		}
		else
		{
			Velocity.Z=oldZ;
		}
		SetPhysics(2);
		SetTimer(0.30,False);
		Instigator=Pawn(Other);
	}
}

defaultproperties
{
    bStatic=True
    bStasis=True
    Texture=None
    Mass=0.00
}