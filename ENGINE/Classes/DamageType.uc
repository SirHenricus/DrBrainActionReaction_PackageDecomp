//================================================================================
// DamageType.
//================================================================================
class DamageType expands Actor
	abstract;

var() localized string Name;
var() localized string AltName;
var() float ViewFlash;
var() Vector ViewFog;
var() Class<Effects> DamageEffect;

static function string DeathMessage ()
{
	if ( FRand() < 0.50 )
	{
		return Default.Name;
	}
	else
	{
		return Default.AltName;
	}
}

defaultproperties
{
    AltName="killed"
}