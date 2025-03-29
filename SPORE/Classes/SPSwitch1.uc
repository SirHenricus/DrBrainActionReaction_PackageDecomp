//================================================================================
// SPSwitch1.
//================================================================================
class SPSwitch1 expands SPActor;

enum EControlType {
	CT_Doors,
	CT_Movers,
	CT_Actors
};

var() ESporeColor Color;
var() bool bIgnoreColor;
var() EControlType ControlType;
var() name DoorNames[10];
var() int NumberOfDoors;
var float SwitchTime;
var() float ReSwitchDelay;
var() bool bOnceOnly;
var() bool bStartOn;
var bool isOn;
var Texture RedLightSkin;
var Texture GreenLightSkin;

event PreBeginPlay ()
{
	local string texNum;

	if ( bIgnoreColor )
	{
		texNum="07";
	}
	else
	{
		if ( Color == 2 )
		{
			texNum="01";
		}
		else
		{
			if ( Color == 3 )
			{
				texNum="02";
			}
			else
			{
				if ( Color == 1 )
				{
					texNum="03";
				}
				else
				{
					if ( Color == 5 )
					{
						texNum="04";
					}
					else
					{
						if ( Color == 0 )
						{
							texNum="05";
						}
						else
						{
							if ( Color == 4 )
							{
								texNum="06";
							}
						}
					}
				}
			}
		}
	}
	RedLightSkin=Texture(DynamicLoadObject("SporeSkin.TBarr" $ texNum,Class'Texture'));
	GreenLightSkin=Texture(DynamicLoadObject("SporeSkin.TBarg" $ texNum,Class'Texture'));
}

event PostBeginPlay ()
{
	if (  !bStartOn )
	{
		isOn=False;
		PlayAnim('Down');
		Skin=RedLightSkin;
	}
	else
	{
		isOn=True;
		PlayAnim('up');
		Skin=GreenLightSkin;
	}
	Super.PostBeginPlay();
}

event Bump (Actor Other)
{
	if (  !Other.IsA('SPPlayer') &&  !Other.IsA('SPPushProjectile') )
	{
		return;
	}
	if ( ReSwitchDelay > 0 )
	{
		if ( Level.TimeSeconds < SwitchTime )
		{
			SwitchTime=0.00;
		}
		if ( Level.TimeSeconds - SwitchTime < ReSwitchDelay )
		{
			return;
		}
		SwitchTime=Level.TimeSeconds;
	}
	if ( isOn )
	{
		GotoState('TurningOff');
	}
	else
	{
		GotoState('TurningOn');
	}
	ActivateStuff();
}

function ActivateStuff ()
{
	if ( ControlType == 0 )
	{
		ActivateDoors();
	}
	else
	{
		if ( ControlType == 1 )
		{
			ActivateMovers();
		}
		else
		{
			if ( ControlType == 2 )
			{
				ActivateActors();
			}
		}
	}
	PlaySound(Sound'Switch',3);
}

function ActivateActors ()
{
	local Actor A;

	if ( Event != 'None' )
	{
		foreach AllActors(Class'Actor',A,Event)
		{
			A.Trigger(self,Instigator);
		}
	}
}

function ActivateDoors ()
{
	local SPDoorIris door;
	local int i;

	i=0;
JL0007:
	if ( i < NumberOfDoors )
	{
		foreach AllActors(Class'SPDoorIris',door,DoorNames[i])
		{
			door.Activate();
		}
		i++;
		goto JL0007;
	}
}

function ActivateMovers ()
{
	local Actor A;
	local int i;

	i=0;
JL0007:
	if ( i < NumberOfDoors )
	{
		foreach AllActors(Class'Actor',A,DoorNames[i])
		{
			A.Trigger(self,Instigator);
		}
		i++;
		goto JL0007;
	}
}

function Trigger (Actor Other, Pawn Instigator)
{
	GotoState('Inactive');
}

state TurningOff
{
	function Trigger (Actor Other, Pawn Instigator)
	{
		isOn=True;
		Skin=RedLightSkin;
		GotoState('Inactive');
	}
	
Begin:
	isOn=False;
	PlayAnim('Down');
	FinishAnim();
	Skin=RedLightSkin;
	if (  !bOnceOnly )
	{
		GotoState('None');
	}
	else
	{
		GotoState('Inactive');
	}
}

state TurningOn
{
	function Trigger (Actor Other, Pawn Instigator)
	{
		isOn=True;
		Skin=GreenLightSkin;
		GotoState('Inactive');
	}
	
Begin:
	isOn=True;
	PlayAnim('up');
	FinishAnim();
	Skin=GreenLightSkin;
	if (  !bOnceOnly )
	{
		GotoState('None');
	}
	else
	{
		GotoState('Inactive');
	}
}

state Inactive
{
	function Trigger (Actor Other, Pawn Instigator)
	{
		GotoState('None');
	}
	
}

defaultproperties
{
    ControlType=CT_Movers
    ReSwitchDelay=0.25
    DrawType=DT_Sprite
    Mesh=LodMesh'switch1'
    CollisionRadius=25.00
    CollisionHeight=50.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}