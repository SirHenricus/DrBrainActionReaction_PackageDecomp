//================================================================================
// WetTexture.
//================================================================================
class WetTexture expands WaterTexture
	native
	noexport
	safereplace;

var(WaterPaint) Texture SourceTexture;
var transient Texture OldSourceTex;
var transient int LocalSourceBitmap;