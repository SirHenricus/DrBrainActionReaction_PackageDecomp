//================================================================================
// Actor.
//================================================================================
class Actor expands Object
	native
	abstract;

enum EInputKey {
	IK_None,
	IK_LeftMouse,
	IK_RightMouse,
	IK_Cancel,
	IK_MiddleMouse,
	IK_Unknown05,
	IK_Unknown06,
	IK_Unknown07,
	IK_Backspace,
	IK_Tab,
	IK_Unknown0A,
	IK_Unknown0B,
	IK_Unknown0C,
	IK_Enter,
	IK_Unknown0E,
	IK_Unknown0F,
	IK_Shift,
	IK_Ctrl,
	IK_Alt,
	IK_Pause,
	IK_CapsLock,
	IK_Unknown15,
	IK_Unknown16,
	IK_Unknown17,
	IK_Unknown18,
	IK_Unknown19,
	IK_Unknown1A,
	IK_Escape,
	IK_Unknown1C,
	IK_Unknown1D,
	IK_Unknown1E,
	IK_Unknown1F,
	IK_Space,
	IK_PageUp,
	IK_PageDown,
	IK_End,
	IK_Home,
	IK_Left,
	IK_Up,
	IK_Right,
	IK_Down,
	IK_Select,
	IK_Print,
	IK_Execute,
	IK_PrintScrn,
	IK_Insert,
	IK_Delete,
	IK_Help,
	IK_0,
	IK_1,
	IK_2,
	IK_3,
	IK_4,
	IK_5,
	IK_6,
	IK_7,
	IK_8,
	IK_9,
	IK_Unknown3A,
	IK_Unknown3B,
	IK_Unknown3C,
	IK_Unknown3D,
	IK_Unknown3E,
	IK_Unknown3F,
	IK_Unknown40,
	IK_A,
	IK_B,
	IK_C,
	IK_D,
	IK_E,
	IK_F,
	IK_G,
	IK_H,
	IK_I,
	IK_J,
	IK_K,
	IK_L,
	IK_M,
	IK_N,
	IK_O,
	IK_P,
	IK_Q,
	IK_R,
	IK_S,
	IK_T,
	IK_U,
	IK_V,
	IK_W,
	IK_X,
	IK_Y,
	IK_Z,
	IK_Unknown5B,
	IK_Unknown5C,
	IK_Unknown5D,
	IK_Unknown5E,
	IK_Unknown5F,
	IK_NumPad0,
	IK_NumPad1,
	IK_NumPad2,
	IK_NumPad3,
	IK_NumPad4,
	IK_NumPad5,
	IK_NumPad6,
	IK_NumPad7,
	IK_NumPad8,
	IK_NumPad9,
	IK_GreyStar,
	IK_GreyPlus,
	IK_Separator,
	IK_GreyMinus,
	IK_NumPadPeriod,
	IK_GreySlash,
	IK_F1,
	IK_F2,
	IK_F3,
	IK_F4,
	IK_F5,
	IK_F6,
	IK_F7,
	IK_F8,
	IK_F9,
	IK_F10,
	IK_F11,
	IK_F12,
	IK_F13,
	IK_F14,
	IK_F15,
	IK_F16,
	IK_F17,
	IK_F18,
	IK_F19,
	IK_F20,
	IK_F21,
	IK_F22,
	IK_F23,
	IK_F24,
	IK_Unknown88,
	IK_Unknown89,
	IK_Unknown8A,
	IK_Unknown8B,
	IK_Unknown8C,
	IK_Unknown8D,
	IK_Unknown8E,
	IK_Unknown8F,
	IK_NumLock,
	IK_ScrollLock,
	IK_Unknown92,
	IK_Unknown93,
	IK_Unknown94,
	IK_Unknown95,
	IK_Unknown96,
	IK_Unknown97,
	IK_Unknown98,
	IK_Unknown99,
	IK_Unknown9A,
	IK_Unknown9B,
	IK_Unknown9C,
	IK_Unknown9D,
	IK_Unknown9E,
	IK_Unknown9F,
	IK_LShift,
	IK_RShift,
	IK_LControl,
	IK_RControl,
	IK_UnknownA4,
	IK_UnknownA5,
	IK_UnknownA6,
	IK_UnknownA7,
	IK_UnknownA8,
	IK_UnknownA9,
	IK_UnknownAA,
	IK_UnknownAB,
	IK_UnknownAC,
	IK_UnknownAD,
	IK_UnknownAE,
	IK_UnknownAF,
	IK_UnknownB0,
	IK_UnknownB1,
	IK_UnknownB2,
	IK_UnknownB3,
	IK_UnknownB4,
	IK_UnknownB5,
	IK_UnknownB6,
	IK_UnknownB7,
	IK_UnknownB8,
	IK_UnknownB9,
	IK_Semicolon,
	IK_Equals,
	IK_Comma,
	IK_Minus,
	IK_Period,
	IK_Slash,
	IK_Tilde,
	IK_UnknownC1,
	IK_UnknownC2,
	IK_UnknownC3,
	IK_UnknownC4,
	IK_UnknownC5,
	IK_UnknownC6,
	IK_UnknownC7,
	IK_Joy1,
	IK_Joy2,
	IK_Joy3,
	IK_Joy4,
	IK_Joy5,
	IK_Joy6,
	IK_Joy7,
	IK_Joy8,
	IK_Joy9,
	IK_Joy10,
	IK_Joy11,
	IK_Joy12,
	IK_Joy13,
	IK_Joy14,
	IK_Joy15,
	IK_Joy16,
	IK_UnknownD8,
	IK_UnknownD9,
	IK_UnknownDA,
	IK_LeftBracket,
	IK_Backslash,
	IK_RightBracket,
	IK_SingleQuote,
	IK_UnknownDF,
	IK_JoyX,
	IK_JoyY,
	IK_JoyZ,
	IK_JoyR,
	IK_MouseX,
	IK_MouseY,
	IK_MouseZ,
	IK_MouseW,
	IK_JoyU,
	IK_JoyV,
	IK_UnknownEA,
	IK_UnknownEB,
	IK_MouseWheelUp,
	IK_MouseWheelDown,
	IK_Unknown10E,
	UK_Unknown10F,
	IK_JoyPovUp,
	IK_JoyPovDown,
	IK_JoyPovLeft,
	IK_JoyPovRight,
	IK_UnknownF4,
	IK_UnknownF5,
	IK_Attn,
	IK_CrSel,
	IK_ExSel,
	IK_ErEof,
	IK_Play,
	IK_Zoom,
	IK_NoName,
	IK_PA1,
	IK_OEMClear
};

enum EInputAction {
	IST_None,
	IST_Press,
	IST_Hold,
	IST_Release,
	IST_Axis
};

enum ETravelType {
	TRAVEL_Absolute,
	TRAVEL_Partial,
	TRAVEL_Relative
};

enum EDodgeDir {
	DODGE_None,
	DODGE_Left,
	DODGE_Right,
	DODGE_Forward,
	DODGE_Back,
	DODGE_Active,
	DODGE_Done
};

enum ELightEffect {
	LE_None,
	LE_TorchWaver,
	LE_FireWaver,
	LE_WateryShimmer,
	LE_Searchlight,
	LE_SlowWave,
	LE_FastWave,
	LE_CloudCast,
	LE_StaticSpot,
	LE_Shock,
	LE_Disco,
	LE_Warp,
	LE_Spotlight,
	LE_NonIncidence,
	LE_Shell,
	LE_OmniBumpMap,
	LE_Interference,
	LE_Cylinder,
	LE_Rotor,
	LE_Unused
};

enum ELightType {
	LT_None,
	LT_Steady,
	LT_Pulse,
	LT_Blink,
	LT_Flicker,
	LT_Strobe,
	LT_BackdropLight,
	LT_SubtlePulse,
	LT_TexturePaletteOnce,
	LT_TexturePaletteLoop
};

enum EMusicTransition {
	MTRAN_None,
	MTRAN_Instant,
	MTRAN_Segue,
	MTRAN_Fade,
	MTRAN_FastFade,
	MTRAN_SlowFade
};

enum ESoundSlot {
	SLOT_None,
	SLOT_Misc,
	SLOT_Pain,
	SLOT_Interact,
	SLOT_Ambient,
	SLOT_Talk,
	SLOT_Interface
};

enum ERenderStyle {
	STY_None,
	STY_Normal,
	STY_Masked,
	STY_Translucent,
	STY_Modulated
};

enum EDrawType {
	DT_None,
	DT_Sprite,
	DT_Mesh,
	DT_Brush,
	DT_RopeSprite,
	DT_VerticalSprite,
	DT_Terraform,
	DT_SpriteAnimOnce
};

struct PointRegion
{
	var ZoneInfo Zone;
	var int iLeaf;
	var byte ZoneNumber;
};

enum ENetRole {
	ROLE_None,
	ROLE_DumbProxy,
	ROLE_SimulatedProxy,
	ROLE_AutonomousProxy,
	ROLE_Authority
};

enum EPhysics {
	PHYS_None,
	PHYS_Walking,
	PHYS_Falling,
	PHYS_Swimming,
	PHYS_Flying,
	PHYS_Rotating,
	PHYS_Projectile,
	PHYS_Rolling,
	PHYS_Interpolating,
	PHYS_MovingBrush,
	PHYS_Spider,
	PHYS_Trailer
};

var(Advanced) const bool bStatic;
var(Advanced) bool bHidden;
var(Advanced) const bool bNoDelete;
var bool bAnimFinished;
var bool bAnimLoop;
var bool bAnimNotify;
var bool bAnimByOwner;
var const bool bDeleteMe;
var const transient bool bAssimilated;
var const transient bool bTicked;
var transient bool bLightChanged;
var bool bDynamicLight;
var bool bTimerLoop;
var(Advanced) bool bCanTeleport;
var(Advanced) bool bIsSecretGoal;
var(Advanced) bool bIsKillGoal;
var(Advanced) bool bIsItemGoal;
var(Advanced) bool bCollideWhenPlacing;
var(Advanced) bool bTravel;
var(Advanced) bool bMovable;
var(Advanced) bool bHighDetail;
var(Advanced) bool bStasis;
var(Advanced) bool bForceStasis;
var const bool bIsPawn;
var(Advanced) const bool bNetTemporary;
var(Advanced) const bool bNetOptional;
var bool bReplicateInstigator;
var bool bTrailerSameRotation;
var(Movement) const EPhysics Physics;
var ENetRole Role;
var(Networking) ENetRole RemoteRole;
var const Actor Owner;
var(Object) name InitialState;
var(Object) name Group;
var float TimerRate;
var const float TimerCounter;
var(Advanced) float LifeSpan;
var(Display) name AnimSequence;
var(Display) float AnimFrame;
var(Display) float AnimRate;
var float TweenRate;
var const LevelInfo Level;
var const Level XLevel;
var(Events) name Tag;
var(Events) name Event;
var Actor Target;
var Pawn Instigator;
var Inventory Inventory;
var const Actor Base;
var const PointRegion Region;
var(Movement) name AttachTag;
var const byte StandingCount;
var const byte MiscNumber;
var const byte LatentByte;
var const int LatentInt;
var const float LatentFloat;
var const Actor LatentActor;
var const Actor Touching[4];
var const Actor Deleted;
var const transient int CollisionTag;
var const transient int LightingTag;
var const transient int NetTag;
var const transient int OtherTag;
var const transient int ExtraTag;
var const transient int SpecialTag;
var(Movement) const Vector Location;
var(Movement) const Rotator Rotation;
var const Vector OldLocation;
var const Vector ColLocation;
var(Movement) Vector Velocity;
var Vector Acceleration;
var(Advanced) bool bHiddenEd;
var(Advanced) bool bDirectional;
var const bool bSelected;
var const bool bMemorized;
var const bool bHighlighted;
var bool bEdLocked;
var(Advanced) bool bEdShouldSnap;
var transient bool bEdSnap;
var const transient bool bTempEditor;
var(Filter) bool bDifficulty0;
var(Filter) bool bDifficulty1;
var(Filter) bool bDifficulty2;
var(Filter) bool bDifficulty3;
var(Filter) bool bSinglePlayer;
var(Filter) bool bNet;
var(Filter) bool bNetSpecial;
var(Filter) float OddsOfAppearing;
var(Display) EDrawType DrawType;
var(Display) ERenderStyle Style;
var(Display) Texture Sprite;
var(Display) Texture Texture;
var(Display) Texture Skin;
var(Display) Mesh Mesh;
var const exportobject Model Brush;
var(Display) float DrawScale;
var Vector PrePivot;
var(Display) float ScaleGlow;
var(Display) byte AmbientGlow;
var(Display) byte Fatness;
var(Display) bool bUnlit;
var(Display) bool bNoSmooth;
var(Display) bool bParticles;
var(Display) bool bRandomFrame;
var(Display) bool bMeshEnviroMap;
var(Display) bool bMeshCurvy;
var(Display) float VisibilityRadius;
var(Display) float VisibilityHeight;
var(Display) bool bShadowCast;
var(Advanced) bool bOwnerNoSee;
var(Advanced) bool bOnlyOwnerSee;
var const bool bIsMover;
var(Advanced) bool bAlwaysRelevant;
var const bool bAlwaysTick;
var bool bHurtEntry;
var(Advanced) bool bGameRelevant;
var bool bCarriedItem;
var bool bForcePhysicsUpdate;
var(Display) Texture MultiSkins[8];
var(Sound) byte SoundRadius;
var(Sound) byte SoundVolume;
var(Sound) byte SoundPitch;
var(Sound) Sound AmbientSound;
var(Sound) float TransientSoundVolume;
var(Sound) float TransientSoundRadius;
var(Collision) const float CollisionRadius;
var(Collision) const float CollisionHeight;
var(Collision) const bool bCollideActors;
var(Collision) bool bCollideWorld;
var(Collision) bool bBlockActors;
var(Collision) bool bBlockPlayers;
var(Collision) bool bProjTarget;
var(Lighting) ELightType LightType;
var(Lighting) ELightEffect LightEffect;
var(LightColor) byte LightBrightness;
var(LightColor) byte LightHue;
var(LightColor) byte LightSaturation;
var(Lighting) byte LightRadius;
var(Lighting) byte LightPeriod;
var(Lighting) byte LightPhase;
var(Lighting) byte LightCone;
var(Lighting) byte VolumeBrightness;
var(Lighting) byte VolumeRadius;
var(Lighting) byte VolumeFog;
var(Lighting) bool bSpecialLit;
var(Lighting) bool bActorShadows;
var(Lighting) bool bCorona;
var(Lighting) bool bLensFlare;
var(Movement) bool bBounce;
var(Movement) bool bFixedRotationDir;
var(Movement) bool bRotateToDesired;
var bool bInterpolating;
var const bool bJustTeleported;
var EDodgeDir DodgeDir;
var(Movement) float Mass;
var(Movement) float Buoyancy;
var(Movement) Rotator RotationRate;
var(Movement) Rotator DesiredRotation;
var float PhysAlpha;
var float PhysRate;
var float AnimLast;
var float AnimMinRate;
var float OldAnimRate;
var Plane SimAnim;
var(Networking) float NetPriority;
var const bool bNetInitial;
var const bool bNetOwner;
var const bool bNetRelevant;
var const bool bNetSee;
var const bool bNetHear;
var const bool bNetFeel;
var const bool bSimulatedPawn;
var const bool bDemoRecording;
var(Display) Class<RenderIterator> RenderIteratorClass;
var transient RenderIterator RenderInterface;

replication
{
	reliable if ( Role < 4 )
		BroadcastMessage;
	reliable if ( bDemoRecording )
		DemoPlaySound;
	un?reliable if ( Role == 4 )
		bHidden,bOnlyOwnerSee;
	un?reliable if ( (DrawType == 2) && (RemoteRole == 2) )
		bAnimNotify;
	un?reliable if ( (RemoteRole == 2) && bNetInitial &&  !bSimulatedPawn )
		Physics,Acceleration,bBounce;
	un?reliable if ( Role == 4 )
		Role,RemoteRole,Owner;
	un?reliable if ( (DrawType == 2) && (RemoteRole <= 2) )
		AnimSequence;
	un?reliable if ( bReplicateInstigator && (Role == 4) && (RemoteRole >= 2) )
		Instigator;
	un?reliable if ( (Role == 4) && bNetOwner )
		Inventory,bNetOwner;
	un?reliable if ( (Role == 4) && (RemoteRole == 2) )
		Base;
	un?reliable if ( (Role == 4) &&  !bCarriedItem && (bNetInitial || bSimulatedPawn || (RemoteRole < 2)) )
		Location;
	un?reliable if ( (Role == 4) &&  !bCarriedItem && ((DrawType == 2) || (DrawType == 3)) && (bNetInitial || bSimulatedPawn || (RemoteRole < 2)) )
		Rotation;
	un?reliable if ( (RemoteRole == 2) && (bNetInitial || bSimulatedPawn) || bIsMover )
		Velocity;
	un?reliable if ( Role == 4 )
		DrawType,Style,Texture,DrawScale,PrePivot,ScaleGlow,AmbientGlow,Fatness,bUnlit,bNoSmooth,bShadowCast,bActorShadows;
	un?reliable if ( (Role == 4) && (DrawType == 1) &&  !bHidden && ( !bOnlyOwnerSee || bNetOwner) )
		Sprite;
	un?reliable if ( (Role == 4) && (DrawType == 2) )
		Skin,Mesh,bMeshEnviroMap,bMeshCurvy,MultiSkins;
	un?reliable if ( (Role == 4) && (DrawType == 3) )
		Brush;
	un?reliable if ( (Role == 4) && (AmbientSound != None) )
		SoundRadius,SoundVolume,SoundPitch;
	un?reliable if ( Role == 4 )
		AmbientSound;
	un?reliable if ( (Role == 4) && (bCollideActors || bCollideWorld) )
		CollisionRadius,CollisionHeight;
	un?reliable if ( Role == 4 )
		bCollideActors;
	un?reliable if ( Role == 4 )
		bCollideWorld;
	un?reliable if ( (Role == 4) && bCollideActors )
		bBlockActors,bBlockPlayers;
	un?reliable if ( Role == 4 )
		LightType;
	un?reliable if ( (Role == 4) && (LightType != 0) )
		LightEffect,LightBrightness,LightHue,LightSaturation,LightRadius,LightPeriod,LightPhase,LightCone,VolumeBrightness,VolumeRadius,bSpecialLit;
	un?reliable if ( (RemoteRole == 2) && (Physics == 5) && bNetInitial )
		bFixedRotationDir,bRotateToDesired,RotationRate,DesiredRotation;
	un?reliable if ( (DrawType == 2) && (RemoteRole < 3) )
		AnimMinRate,SimAnim;
}

native function string ConsoleCommand (string Command);

native(233) final function Error (coerce string S);

native(256) final latent function Sleep (float Seconds);

native(262) final function SetCollision (optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers);

native(283) final function bool SetCollisionSize (float NewRadius, float NewHeight);

native(266) final function bool Move (Vector Delta);

native(267) final function bool SetLocation (Vector NewLocation);

native(299) final function bool SetRotation (Rotator NewRotation);

native(3969) final function bool MoveSmooth (Vector Delta);

native(3971) final function AutonomousPhysics (float DeltaSeconds);

native(298) final function SetBase (Actor NewBase);

native(272) final function SetOwner (Actor NewOwner);

native(259) final function PlayAnim (name Sequence, optional float Rate, optional float TweenTime);

native(260) final function LoopAnim (name Sequence, optional float Rate, optional float TweenTime, optional float MinRate);

native(294) final function TweenAnim (name Sequence, float Time);

native(282) final function bool IsAnimating ();

native(293) final function name GetAnimGroup (name Sequence);

native(261) final latent function FinishAnim ();

native(263) final function bool HasAnim (name Sequence);

event AnimEnd ();

native(301) final latent function FinishInterpolation ();

native(3970) final function SetPhysics (EPhysics newPhysics);

event Spawned ();

event Destroyed ();

event Expired ();

event GainedChild (Actor Other);

event LostChild (Actor Other);

event Tick (float DeltaTime);

event Trigger (Actor Other, Pawn EventInstigator);

event UnTrigger (Actor Other, Pawn EventInstigator);

event BeginEvent ();

event EndEvent ();

event Timer ();

event HitWall (Vector HitNormal, Actor HitWall);

event Falling ();

event Landed (Vector HitNormal);

event ZoneChange (ZoneInfo NewZone);

event Touch (Actor Other);

event UnTouch (Actor Other);

event Bump (Actor Other);

event BaseChange ();

event Attach (Actor Other);

event Detach (Actor Other);

event KillCredit (Actor Other);

event Actor SpecialHandling (Pawn Other);

event bool EncroachingOn (Actor Other);

event EncroachedBy (Actor Other);

event InterpolateEnd (Actor Other);

event EndedRotation ();

event FellOutOfWorld ()
{
	SetPhysics(0);
	Destroy();
}

event KilledBy (Pawn EventInstigator);

event TakeDamage (int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, name DamageType);

native(277) final function Actor Trace (out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent);

native(278) final function Actor Spawn (Class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation);

native(279) final function bool Destroy ();

native(280) final function SetTimer (float NewTimerRate, bool bLoop);

native(264) final function PlaySound (Sound Sound, optional ESoundSlot Slot, optional float Volume, optional bool bNoOverride, optional float Radius, optional float Pitch);

native simulated event DemoPlaySound (Sound Sound, optional ESoundSlot Slot, optional float Volume, optional bool bNoOverride, optional float Radius, optional float Pitch);

native(512) final function MakeNoise (float Loudness);

native(532) final function bool PlayerCanSeeMe ();

event bool PreTeleport (Teleporter InTeleporter);

event PostTeleport (Teleporter OutTeleporter);

event BeginPlay ();

native(539) final function string GetMapName (string NameEnding, string MapName, int Dir);

native(545) final function GetNextSkin (string Prefix, string CurrentSkin, int Dir, out string SkinName, out string SkinDesc);

native(547) final function string GetURLMap ();

native final function string GetNextInt (string ClassName, int Num);

native final function GetNextIntDesc (string ClassName, int Num, out string Entry, out string Description);

native(304) final iterator function AllActors (Class<Actor> BaseClass, out Actor Actor, optional name MatchTag);

native(305) final iterator function ChildActors (Class<Actor> BaseClass, out Actor Actor);

native(306) final iterator function BasedActors (Class<Actor> BaseClass, out Actor Actor);

native(307) final iterator function TouchingActors (Class<Actor> BaseClass, out Actor Actor);

native(309) final iterator function TraceActors (Class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, Vector End, optional Vector Start, optional Vector Extent);

native(310) final iterator function RadiusActors (Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc);

native(311) final iterator function VisibleActors (Class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc);

native(312) final iterator function VisibleCollidingActors (Class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc, optional bool bIgnoreHidden);

event RenderOverlays (Canvas Canvas);

event PreBeginPlay ()
{
	if (  !bGameRelevant && (Level.NetMode != 3) &&  !Level.Game.IsRelevant(self) )
	{
		Destroy();
	}
}

event BroadcastMessage (coerce string Msg, optional bool bBeep, optional name Type)
{
	local Pawn P;

	if ( Type == 'None' )
	{
		Type='Event';
	}
	if ( Level.Game.AllowsBroadcast(self,Len(Msg)) )
	{
		P=Level.PawnList;
JL0051:
		if ( P != None )
		{
			if ( P.bIsPlayer )
			{
				P.ClientMessage(Msg,Type,bBeep);
			}
			P=P.nextPawn;
			goto JL0051;
		}
	}
}

event PostBeginPlay ();

simulated event SetInitialState ()
{
	if ( InitialState != 'None' )
	{
		GotoState(InitialState);
	}
	else
	{
		GotoState('Auto');
	}
}

final function HurtRadius (float DamageAmount, float DamageRadius, name DamageName, float Momentum, Vector HitLocation)
{
	local Actor Victims;
	local float damageScale;
	local float dist;
	local Vector Dir;

	if ( bHurtEntry )
	{
		return;
	}
	bHurtEntry=True;
	foreach VisibleCollidingActors(Class'Actor',Victims,DamageRadius,HitLocation)
	{
		if ( Victims != self )
		{
			Dir=Victims.Location - HitLocation;
			dist=FMax(1.00,VSize(Dir));
			Dir=Dir / dist;
			damageScale=1.00 - FMax(0.00,(dist - Victims.CollisionRadius) / DamageRadius);
			Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.50 * (Victims.CollisionHeight + Victims.CollisionRadius) * Dir,damageScale * Momentum * Dir,DamageName);
		}
	}
	bHurtEntry=False;
}

event TravelPreAccept ();

event TravelPostAccept ();

event RenderTexture (ScriptedTexture Tex);

function BecomeViewTarget ();

function string GetItemName (string FullName)
{
	local int pos;

	pos=InStr(FullName,".");
JL0010:
	if ( pos != -1 )
	{
		FullName=Right(FullName,Len(FullName) - pos - 1);
		pos=InStr(FullName,".");
		goto JL0010;
	}
	return FullName;
}

function string GetHumanName ()
{
	return GetItemName(string(Class));
}

function SetDisplayProperties (ERenderStyle NewStyle, Texture NewTexture, bool bLighting, bool bEnviroMap)
{
	Style=NewStyle;
	Texture=NewTexture;
	bUnlit=bLighting;
	bMeshEnviroMap=bEnviroMap;
}

function SetDefaultDisplayProperties ()
{
	Style=Default.Style;
	Texture=Default.Texture;
	bUnlit=Default.bUnlit;
	bMeshEnviroMap=Default.bMeshEnviroMap;
}

defaultproperties
{
    bMovable=True
    Role=ROLE_Authority
    RemoteRole=ROLE_DumbProxy
    bDifficulty0=True
    bDifficulty1=True
    bDifficulty2=True
    bDifficulty3=True
    bSinglePlayer=True
    bNet=True
    bNetSpecial=True
    OddsOfAppearing=1.00
    DrawType=DT_Sprite
    Style=STY_Normal
    Texture=Texture'S_Actor'
    DrawScale=1.00
    ScaleGlow=1.00
    Fatness=128
    SoundRadius=32
    SoundVolume=128
    SoundPitch=64
    TransientSoundVolume=1.00
    CollisionRadius=22.00
    CollisionHeight=22.00
    bJustTeleported=True
    Mass=100.00
    NetPriority=1.00
}