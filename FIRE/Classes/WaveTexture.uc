//================================================================================
// WaveTexture.
//================================================================================
class WaveTexture expands WaterTexture
	native
	noexport
	safereplace;

var(WaterPaint) byte BumpMapLight;
var(WaterPaint) byte BumpMapAngle;
var(WaterPaint) byte PhongRange;
var(WaterPaint) byte PhongSize;