//================================================================================
// EAXZone.
//================================================================================
class EAXZone expands ZoneInfo
	native;

var(EAX) const EAmbients Ambients;
var(EAX) bool UseAmbients;
var(EAX) bool UseSpecial;
var(EAX) float EnvironmentSize;
var(EAX) float EnvironmentDiffusion;
var(EAX) int Room;
var(EAX) int RoomHF;
var(EAX) float DecayTime;
var(EAX) int DecayHFRatio;
var(EAX) int Reflections;
var(EAX) float ReflectionsDelay;
var(EAX) int Reverb;
var(EAX) float ReverbDelay;
var(EAX) float RoomRolloffFactor;
var(EAX) float AirAbsorptionHF;
enum EAmbients {
	ENVIRONMENT_GENERIC,
	ENVIRONMENT_PADDEDCELL,
	ENVIRONMENT_ROOM,
	ENVIRONMENT_BATHROOM,
	ENVIRONMENT_LIVINGROOM,
	ENVIRONMENT_STONEROOM,
	ENVIRONMENT_AUDITORIUM,
	ENVIRONMENT_CONCERTHALL,
	ENVIRONMENT_CAVE,
	ENVIRONMENT_ARENA,
	ENVIRONMENT_HANGAR,
	ENVIRONMENT_CARPETEDHALLWAY,
	ENVIRONMENT_HALLWAY,
	ENVIRONMENT_STONECORRIDOR,
	ENVIRONMENT_ALLEY,
	ENVIRONMENT_FOREST,
	ENVIRONMENT_CITY,
	ENVIRONMENT_MOUNTAINS,
	ENVIRONMENT_QUARRY,
	ENVIRONMENT_PLAIN,
	ENVIRONMENT_PARKINGLOT,
	ENVIRONMENT_SEWERPIPE,
	ENVIRONMENT_UNDERWATER,
	ENVIRONMENT_DRUGGED,
	ENVIRONMENT_DIZZY,
	ENVIRONMENT_PSYCHOTIC
};


defaultproperties
{
    EnvironmentSize=7.50
    EnvironmentDiffusion=1.00
    DecayTime=0.10
    Reflections=-10000
    Reverb=-10000
    AirAbsorptionHF=-5.00
}