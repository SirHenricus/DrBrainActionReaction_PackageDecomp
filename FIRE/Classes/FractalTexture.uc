//================================================================================
// FractalTexture.
//================================================================================
class FractalTexture expands Texture
	native
	noexport
	abstract
	safereplace;

var transient int UMask;
var transient int VMask;
var transient int LightOutput;
var transient int SoundOutput;
var transient int GlobalPhase;
var transient byte DrawPhase;
var transient byte AuxPhase;