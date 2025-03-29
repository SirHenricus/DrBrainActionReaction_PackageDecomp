//================================================================================
// SPStunProjectile.
//================================================================================
class SPStunProjectile expands SPPushProjectile;

auto state Flying expands Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local Vector Momentum;
		local int Damage;
	
		if ( bCanHitInstigator || (Other != Instigator) )
		{
			if ( PlayerPawn(Other) != None )
			{
				Damage=PlayerPawn(Other).Health;
			}
			else
			{
				Damage=0;
			}
			Other.TakeDamage(Damage,Instigator,HitLocation,vect(0.00,0.00,0.00),'stun');
			PlaySound(MiscSound,1,2.00);
			Destroy();
		}
	}
	
}

defaultproperties
{
    Exhaust=Class'SPStunExhaust'
    speed=500.00
    Mesh=LodMesh'StunMissle'
    AmbientSound=Sound'Projectile.woshmsle'
}