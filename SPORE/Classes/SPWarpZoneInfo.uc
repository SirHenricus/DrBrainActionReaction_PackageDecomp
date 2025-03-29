//================================================================================
// SPWarpZoneInfo.
//================================================================================
class SPWarpZoneInfo expands WarpZoneInfo;

event ActorLeaving (Actor Other)
{
	Super.ActorLeaving(Other);
	Other.PlaySound(Sound'Warp',0);
}