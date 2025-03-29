//================================================================================
// SPButtonSwitch.
//================================================================================
class SPButtonSwitch expands SPActor;

var() Sound BumpSound;

event Bump (Actor Other)
{
	TriggerStuff(Other);
	PlayAnim('hit');
	PlaySound(BumpSound,3);
}

function TriggerStuff (Actor Other)
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

defaultproperties
{
    BumpSound=Sound'Switches.pushbutton'
    DrawType=DT_Sprite
    Mesh=LodMesh'buttonswitch'
    CollisionRadius=35.00
    CollisionHeight=40.00
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    bBlockPlayers=True
}