//================================================================================
// SPGameEnding.
//================================================================================
class SPGameEnding expands SPGameIntro;

event AcceptInventory (Pawn PlayerPawn)
{
	local Inventory Inv;

	Inv=PlayerPawn.Inventory;
JL0014:
	if ( Inv != None )
	{
		Inv.Destroy();
		Inv=Inv.Inventory;
		goto JL0014;
	}
}

function SetUpFlyThrough ()
{
	local Actor A;
	local InterpolationPoint i;
	local SPSub S;

	if ( NewPlayer != None )
	{
		foreach AllActors(Class'InterpolationPoint',i,'Path')
		{
			if ( i.Position == 0 )
			{
				NewPlayer.Target=i;
				NewPlayer.SetPhysics(8);
				NewPlayer.PhysRate=1.00;
				NewPlayer.PhysAlpha=0.00;
				NewPlayer.bInterpolating=True;
			}
		}
		foreach AllActors(Class'SPSub',S)
		{
			foreach AllActors(Class'InterpolationPoint',i,S.Tag)
			{
				if ( i.Position == 0 )
				{
					S.SetCollision(False,False,False);
					S.Target=i;
					S.SetPhysics(8);
					S.PhysRate=1.00;
					S.PhysAlpha=0.00;
					S.bInterpolating=True;
				}
			}
		}
	}
}

defaultproperties
{
    HUDType=Class'SPEndHud'
}