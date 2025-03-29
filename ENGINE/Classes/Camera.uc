//================================================================================
// Camera.
//================================================================================
class Camera expands PlayerPawn
	native
	config(User);

defaultproperties
{
    Location=(X=-500.00,Y=-300.00,Z=300.00)
    Texture=Texture'S_Camera'
    CollisionRadius=16.00
    CollisionHeight=39.00
    LightBrightness=100
    LightRadius=16
}