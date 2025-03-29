//================================================================================
// SPTurretFireButton.
//================================================================================
class SPTurretFireButton expands SPButtonSwitch;

event TriggerStuff (Actor Other)
{
	local SPTurret t;

	if ( Other.IsA('Pawn') || Other.IsA('Projectile') )
	{
		foreach AllActors(Class'SPTurret',t,Event)
		{
			t.ButtonFire();
		}
	}
}