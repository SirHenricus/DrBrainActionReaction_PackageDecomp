//================================================================================
// SPTriggeredSub.
//================================================================================
class SPTriggeredSub expands SPSub;

function Trigger (Actor Other, Pawn EventInstigator)
{
	local InterpolationPoint i;

	foreach AllActors(Class'InterpolationPoint',i,self.Tag)
	{
		if ( i.Position == 0 )
		{
			self.SetCollision(False,False,False);
			self.Target=i;
			self.SetPhysics(8);
			self.PhysRate=1.00;
			self.PhysAlpha=0.00;
			self.bInterpolating=True;
		}
	}
}