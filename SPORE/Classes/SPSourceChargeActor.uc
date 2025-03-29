//================================================================================
// SPSourceChargeActor.
//================================================================================
class SPSourceChargeActor expands SPActor
	native;

var() float ChargeValues[10];
var() int NumberOfChargeValues;
var int CurrentChargeValueIndex;
var SPSourceChargeNucleus Nucleus;

event PreBeginPlay ()
{
	Super.PreBeginPlay();
	if ( NumberOfChargeValues > 10 )
	{
		NumberOfChargeValues=10;
		Log("NumberOfChargeValues exceeds 10 for " $ "Self");
	}
	SetChargeAnim(Charge);
}

event BeginPlay ()
{
	local SPSourceChargeNucleus A;

	Super.BeginPlay();
	foreach AllActors(Class'SPSourceChargeNucleus',A,Event)
	{
		Nucleus=A;
	}
	if ( Nucleus != None )
	{
		Nucleus.SetLocation(Location);
		Nucleus.SetChargeAnim(Charge);
	}
}

function SetChargeValue (int newIndex)
{
	if ( newIndex < NumberOfChargeValues )
	{
		CurrentChargeValueIndex=newIndex;
		Charge=ChargeValues[CurrentChargeValueIndex];
		SetChargeAnim(Charge);
		if ( Nucleus != None )
		{
			Nucleus.SetChargeAnim(Charge);
		}
	}
	else
	{
		Log("NewIndex exceeds NumberOfChargeValues for " $ "Self");
	}
}

function SetChargeAnim (float q)
{
	local float oldChargeMag;

	oldChargeMag=Abs(Charge);
	if ( oldChargeMag < Abs(Charge) )
	{
		PlaySound(Sound'force_d',3);
	}
	else
	{
		PlaySound(Sound'force_u',3);
	}
	if ( Charge != 0 )
	{
		AmbientSound=Sound'field_a';
	}
	else
	{
		AmbientSound=None;
	}
	if ( q == 0 )
	{
		ClearAnimQ();
		DrawScale=SavedDrawScale;
		RotationRate.Yaw=0;
		Skin=None;
		return;
	}
	DefaultDelay=100.00 / Abs(q);
	RotationRate.Yaw=65535 * q / 4000;
	if ( q > 0 )
	{
		ClearAnimQ();
		AShowSkin(0,,1.00);
		AShowSkin(1,,0.80);
		AShowSkin(2,,0.60);
		AShowSkin(1,,0.40);
		AShowSkin(0,,0.20);
		AShowSkin(1,,0.40);
		AShowSkin(2,,0.60);
		AShowSkin(1,,0.80);
		ALoop();
		StartAnimQ();
	}
	else
	{
		ClearAnimQ();
		AShowSkin(3,,1.00);
		AShowSkin(4,,0.80);
		AShowSkin(5,,0.60);
		AShowSkin(4,,0.40);
		AShowSkin(3,,0.20);
		AShowSkin(4,,0.40);
		AShowSkin(5,,0.60);
		AShowSkin(4,,0.80);
		ALoop();
		StartAnimQ();
	}
}

defaultproperties
{
    Charge=1000.00
    IsSourceCharge=True
    SkinTex(0)=Texture'SporeSkin.Lips.Crystals.blue01'
    SkinTex(1)=Texture'SporeSkin.Lips.Crystals.blue02'
    SkinTex(2)=Texture'SporeSkin.Lips.Crystals.blue03'
    SkinTex(3)=Texture'SporeSkin.Lips.Crystals.orange01'
    SkinTex(4)=Texture'SporeSkin.Lips.Crystals.orange02'
    SkinTex(5)=Texture'SporeSkin.Lips.Crystals.orange03'
    Physics=PHYS_Walking
    DrawType=DT_Sprite
    Mesh=LodMesh'Crystal'
    DrawScale=0.50
    SoundRadius=128
    bFixedRotationDir=True
}