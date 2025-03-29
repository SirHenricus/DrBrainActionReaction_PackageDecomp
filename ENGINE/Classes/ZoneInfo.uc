//================================================================================
// ZoneInfo.
//================================================================================
class ZoneInfo expands Info
	native;

var() name ZoneTag;
var() Vector ZoneGravity;
var() Vector ZoneVelocity;
var() float ZoneGroundFriction;
var() float ZoneFluidFriction;
var() float ZoneTerminalVelocity;
var() name ZonePlayerEvent;
var int ZonePlayerCount;
var int NumCarcasses;
var() int DamagePerSec;
var() name DamageType;
var() localized string DamageString;
var(LocationStrings) localized string ZoneName;
var(LocationStrings) localized string LocationStrings[4];
var() int MaxCarcasses;
var() Sound EntrySound;
var() Sound ExitSound;
var() Class<Actor> EntryActor;
var() Class<Actor> ExitActor;
var SkyZoneInfo SkyZone;
var() bool bWaterZone;
var() const bool bFogZone;
var() const bool bKillZone;
var() bool bNeutralZone;
var() bool bGravityZone;
var() bool bPainZone;
var() bool bDestructive;
var() bool bNoInventory;
var() bool bMoveProjectiles;
var(ZoneLight) byte AmbientBrightness;
var(ZoneLight) byte AmbientHue;
var(ZoneLight) byte AmbientSaturation;
var(ZoneLight) Color FogColor;
var(ZoneLight) float FogDistance;
var(ZoneLight) const Texture EnvironmentMap;
var(ZoneLight) float TexUPanSpeed;
var(ZoneLight) float TexVPanSpeed;
var(ZoneLight) Vector ViewFlash;
var(ZoneLight) Vector ViewFog;
var(Reverb) bool bReverbZone;
var(Reverb) bool bRaytraceReverb;
var(Reverb) float SpeedOfSound;
var(Reverb) byte MasterGain;
var(Reverb) int CutoffHz;
var(Reverb) byte Delay[6];
var(Reverb) byte Gain[6];
var(LensFlare) Texture LensFlare[12];
var(LensFlare) float LensFlareOffset[12];
var(LensFlare) float LensFlareScale[12];
var() byte MinLightCount;
var() byte MaxLightCount;
var() int MinLightingPolyCount;
var() int MaxLightingPolyCount;

replication
{
	un?reliable if ( Role == 4 )
		ZoneGravity,ZoneVelocity,ZoneGroundFriction,ZoneFluidFriction,ZoneTerminalVelocity,AmbientBrightness,AmbientHue,AmbientSaturation,FogColor,TexUPanSpeed,TexVPanSpeed,bReverbZone;
}

native(308) final iterator function ZoneActors (Class<Actor> BaseClass, out Actor Actor);

simulated function LinkToSkybox ()
{
	local SkyZoneInfo TempSkyZone;

	foreach AllActors(Class'SkyZoneInfo',TempSkyZone,'None')
	{
		SkyZone=TempSkyZone;
	}
	foreach AllActors(Class'SkyZoneInfo',TempSkyZone,'None')
	{
		if ( TempSkyZone.bHighDetail == Level.bHighDetailMode )
		{
			SkyZone=TempSkyZone;
		}
	}
}

simulated function PreBeginPlay ()
{
	Super.PreBeginPlay();
	LinkToSkybox();
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	if ( DamagePerSec != 0 )
	{
		bPainZone=True;
	}
}

event ActorEntered (Actor Other)
{
	local Actor A;
	local Vector AddVelocity;

	if ( bNoInventory && Other.IsA('Inventory') && (Other.Owner == None) )
	{
		Other.LifeSpan=1.50;
		return;
	}
	if ( (Pawn(Other) != None) && Pawn(Other).bIsPlayer )
	{
		if ( ( ++ZonePlayerCount == 1) && (ZonePlayerEvent != 'None') )
		{
			foreach AllActors(Class'Actor',A,ZonePlayerEvent)
			{
				A.Trigger(self,Pawn(Other));
			}
		}
	}
	if ( bMoveProjectiles && (ZoneVelocity != vect(0.00,0.00,0.00)) )
	{
		if ( Other.Physics == 6 )
		{
			AddVelocity=ZoneVelocity;
			AddVelocity.Z *= 0.50;
			Other.Velocity += ZoneVelocity;
		}
		else
		{
			if ( Other.IsA('Effects') && (Other.Physics == 0) )
			{
				Other.SetPhysics(6);
				AddVelocity=ZoneVelocity;
				AddVelocity.Z *= 0.50;
				Other.Velocity=AddVelocity;
			}
		}
	}
}

event ActorLeaving (Actor Other)
{
	local Actor A;

	if ( (Pawn(Other) != None) && Pawn(Other).bIsPlayer )
	{
		if ( ( --ZonePlayerCount == 0) && (ZonePlayerEvent != 'None') )
		{
			foreach AllActors(Class'Actor',A,ZonePlayerEvent)
			{
				A.UnTrigger(self,Pawn(Other));
			}
		}
	}
}

defaultproperties
{
    ZoneGravity=(X=0.00,Y=0.00,Z=-950.00)
    ZoneGroundFriction=4.00
    ZoneFluidFriction=1.20
    ZoneTerminalVelocity=2500.00
    MaxCarcasses=2
    bMoveProjectiles=True
    AmbientSaturation=255
    TexUPanSpeed=1.00
    TexVPanSpeed=1.00
    SpeedOfSound=8000.00
    MasterGain=100
    CutoffHz=6000
    Delay(0)=20
    Delay(1)=34
    Gain(0)=150
    Gain(1)=70
    MinLightCount=6
    MaxLightCount=6
    MinLightingPolyCount=1000
    MaxLightingPolyCount=5000
    bStatic=True
    bNoDelete=True
    Texture=Texture'S_ZoneInfo'
    bAlwaysRelevant=True
}