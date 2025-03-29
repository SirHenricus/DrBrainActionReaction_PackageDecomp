//================================================================================
// SPSourceChargeSilencer.
//================================================================================
class SPSourceChargeSilencer expands SPActor;

function Trigger (Actor Other, Pawn Instigator)
{
	local SPSourceChargeActor Charge;

	foreach AllActors(Class'SPSourceChargeActor',Charge)
	{
		Charge.AmbientSound=None;
	}
}