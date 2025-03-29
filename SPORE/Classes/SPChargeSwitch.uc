//================================================================================
// SPChargeSwitch.
//================================================================================
class SPChargeSwitch expands SPActor;

var float SwitchTime;
var() float ReSwitchDelay;
var() int NumberOfStates;
var() int CurrentStateNumber;
var Texture SwitchTexture[10];

event PreBeginPlay ()
{
	if ( NumberOfStates > 10 )
	{
		NumberOfStates=10;
		Log("NumberOfStates exceeds 10 for " $ "Self");
	}
	SwitchTexture[0]=Texture'switch0';
	SwitchTexture[1]=Texture'switch1';
	SwitchTexture[2]=Texture'switch2';
	SwitchTexture[3]=Texture'switch3';
	SwitchTexture[4]=Texture'switch4';
	SwitchTexture[5]=Texture'switch5';
	SwitchTexture[6]=Texture'switch6';
	SwitchTexture[7]=Texture'switch7';
	SwitchTexture[8]=Texture'switch8';
	SwitchTexture[9]=Texture'switch9';
	Super.PreBeginPlay();
}

event Touch (Actor Other)
{
	local SPSourceChargeActor A;

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
	if ( CurrentStateNumber + 1 >= NumberOfStates )
	{
		CurrentStateNumber=0;
	}
	else
	{
		CurrentStateNumber++;
	}
	Texture=SwitchTexture[CurrentStateNumber];
	foreach AllActors(Class'SPSourceChargeActor',A,Event)
	{
		A.SetChargeValue(CurrentStateNumber);
	}
}

defaultproperties
{
    ReSwitchDelay=0.25
    Texture=Texture'switch0'
    CollisionRadius=40.00
    CollisionHeight=80.00
    bCollideActors=True
}