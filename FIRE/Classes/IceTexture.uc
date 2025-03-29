//================================================================================
// IceTexture.
//================================================================================
class IceTexture expands FractalTexture
	native
	noexport
	safereplace;

var(IceLayer) Texture GlassTexture;
var(IceLayer) Texture SourceTexture;
var(IceLayer) PanningType PanningStyle;
var(IceLayer) TimingType TimeMethod;
var(IceLayer) byte HorizPanSpeed;
var(IceLayer) byte VertPanSpeed;
var(IceLayer) byte Frequency;
var(IceLayer) byte Amplitude;
var(IceLayer) bool MoveIce;
var float MasterCount;
var float UDisplace;
var float VDisplace;
var float UPosition;
var float VPosition;
var transient float TickAccu;
var transient int OldUDisplace;
var transient int OldVDisplace;
var transient Texture OldGlassTex;
var transient Texture OldSourceTex;
var transient int LocalSource;
var transient int ForceRefresh;
enum TimingType {
	TIME_FrameRateSync,
	TIME_RealTimeScroll
};

enum PanningType {
	SLIDE_Linear,
	SLIDE_Circular,
	SLIDE_Gestation,
	SLIDE_WavyX,
	SLIDE_WavyY
};