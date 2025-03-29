//================================================================================
// TimeDemoInterpolationPoint.
//================================================================================
class TimeDemoInterpolationPoint expands InterpolationPoint;

var TimeDemo t;

function InterpolateEnd (Actor Other)
{
	t.StartCycle();
	Super.InterpolateEnd(Other);
}