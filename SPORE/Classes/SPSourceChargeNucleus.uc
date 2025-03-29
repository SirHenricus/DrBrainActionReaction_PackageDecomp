//================================================================================
// SPSourceChargeNucleus.
//================================================================================
class SPSourceChargeNucleus expands SPActor;

var Texture PositiveTexture;
var Texture NegativeTexture;
var Texture NeutralTexture;

event PreBeginPlay ()
{
	Super.PreBeginPlay();
	PositiveTexture=FireTexture(DynamicLoadObject("SporeFX.source102",Class'FireTexture'));
	NegativeTexture=FireTexture(DynamicLoadObject("SporeFX.source101",Class'FireTexture'));
	NeutralTexture=FireTexture(DynamicLoadObject("SporeFX.neutral2",Class'FireTexture'));
	SetChargeAnim(Charge);
}

function SetChargeAnim (float q)
{
	if ( q == 0 )
	{
		Texture=NeutralTexture;
		DrawScale=1.50 * SavedDrawScale;
		return;
	}
	if ( q > 0 )
	{
		Texture=PositiveTexture;
		DrawScale=SavedDrawScale;
	}
	else
	{
		Texture=NegativeTexture;
		DrawScale=SavedDrawScale;
	}
}

defaultproperties
{
    Style=STY_Normal
    Texture=FireTexture'SporeFX.Charges.Charges.neutral2'
    bUnlit=True
}