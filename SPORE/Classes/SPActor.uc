//================================================================================
// SPActor.
//================================================================================
class SPActor expands Actor
	native
	abstract;

struct SkinAnimFrame
{
	var AnimCommand Command;
	var int Param;
	var float ParamF;
	var float FrameDelay;
};

enum AnimCommand {
	AC_ShowSkin,
	AC_CallBack,
	AC_Loop,
	AC_Stop
};

enum ESporeColor {
	SC_Red,
	SC_Green,
	SC_Blue,
	SC_LightBlue,
	SC_Yellow,
	SC_Purple,
	SC_Random
};

var() float Charge;
var() bool IsSourceCharge;
var() bool IgnoreGravityInChargeZone;
var() bool ApplyDrag;
var() float DragCoefficient;
var() float AxisRotationRate;
var() Vector RotationAxis;
var(SkinAnimation) Texture SkinTex[15];
var(SkinAnimation) float DefaultDelay;
var SkinAnimFrame AnimQ[20];
var byte CurFrame;
var byte NumFrames;
var float SavedDrawScale;

replication
{
	un?reliable if ( Role == 4 )
		Charge;
}

native final function bool SporeTest ();

native final function RotateAboutAxis (out Rotator R, Vector Axis, float Angle);

event Destroyed ()
{
	if ( IsSourceCharge && (SPChargeZoneInfo(Region.Zone) != None) )
	{
		Region.Zone.ActorLeaving(self);
	}
}

event PreBeginPlay ()
{
	if ( Level == None )
	{
		Log("SPActor::PreBeginPlay ----- ERROR ---- Level == None ----");
		return;
	}
	SavedDrawScale=DrawScale;
}

function SpeechDone (SPPawn Pawn, SPSpeechInfo Speech)
{
}

event Timer ()
{
	ProcessAnimQ();
}

function StartAnimQ ()
{
	if ( (CurFrame >= 0) && (CurFrame < 20) )
	{
		ProcessAnimQ();
	}
}

function ClearAnimQ ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 20 )
	{
		AnimQ[i].Command=3;
		AnimQ[i].Param=0;
		AnimQ[i].FrameDelay=0.00;
		i++;
		goto JL0007;
	}
	NumFrames=0;
	CurFrame=0;
}

function ProcessAnimQ ()
{
	local AnimCommand Command;
	local byte Param;
	local float Delay;
	local float ParamF;

	if ( CurFrame >= 20 )
	{
		return;
	}
	Command=AnimQ[CurFrame].Command;
	Param=AnimQ[CurFrame].Param;
	Delay=AnimQ[CurFrame].FrameDelay;
	ParamF=AnimQ[CurFrame].ParamF;
	if ( Command == 0 )
	{
		Skin=SkinTex[Param];
		CurFrame++;
		if ( CurFrame < 19 )
		{
			SetTimer(Delay,False);
		}
		if ( ParamF > 0 )
		{
			DrawScale=ParamF * SavedDrawScale;
		}
	}
	else
	{
		if ( Command == 2 )
		{
			CurFrame=Param;
			SetTimer(0.01,False);
		}
		else
		{
			if ( Command == 1 )
			{
				AnimCallBack(Param);
				CurFrame++;
				if ( CurFrame < 19 )
				{
					SetTimer(Delay,False);
				}
			}
			else
			{
			}
		}
	}
}

function AShowSkin (int i, optional float Delay, optional float Scale)
{
	if ( NumFrames < 20 )
	{
		AnimQ[NumFrames].Command=0;
		AnimQ[NumFrames].Param=i;
		if ( Delay == 0 )
		{
			Delay=DefaultDelay;
		}
		AnimQ[NumFrames].FrameDelay=Delay;
		AnimQ[NumFrames].ParamF=Scale;
		NumFrames++;
	}
}

function ACallBack (optional int Id, optional float Delay)
{
	if ( NumFrames < 20 )
	{
		AnimQ[NumFrames].Command=1;
		AnimQ[NumFrames].Param=Id;
		if ( Delay == 0 )
		{
			Delay=0.01;
		}
		AnimQ[NumFrames].FrameDelay=Delay;
		NumFrames++;
	}
}

function ALoop (optional int frame)
{
	if ( NumFrames < 20 )
	{
		AnimQ[NumFrames].Command=2;
		AnimQ[NumFrames].Param=frame;
		NumFrames++;
	}
}

function AStop ()
{
	if ( NumFrames < 20 )
	{
		AnimQ[NumFrames].Command=3;
		NumFrames++;
	}
}

function bool CreateSkinAnimation (byte startTex, byte endTex, float FrameDelay, bool bLoop)
{
	local int i;
	local int Length;

	if ( (startTex < 0) || (startTex >= 15) )
	{
		return False;
	}
	if ( startTex > endTex )
	{
		return False;
	}
	if ( FrameDelay == 0 )
	{
		return False;
	}
	ClearAnimQ();
	Length=endTex - startTex + 1;
	i=0;
JL0062:
	if ( i < Length )
	{
		AShowSkin(startTex + i,FrameDelay);
		i++;
		goto JL0062;
	}
	if ( bLoop )
	{
		ALoop();
	}
	return True;
}

function AnimCallBack (int Id)
{
}

defaultproperties
{
    DragCoefficient=0.00
    DefaultDelay=0.10
}