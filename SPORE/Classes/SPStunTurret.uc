//================================================================================
// SPStunTurret.
//================================================================================
class SPStunTurret expands SPTurret;

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, name DamageType)
{
	if ( DamageType == 'stun' )
	{
		Destroy();
		PlaySound(Sound'turretwosh',3);
	}
}

defaultproperties
{
    projType=Class'SPStunProjectile'
}