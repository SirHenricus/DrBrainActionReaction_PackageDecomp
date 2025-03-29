//================================================================================
// Texture.
//================================================================================
class Texture expands Bitmap
	native
	noexport
	safereplace;

enum ELODSet {
	LODSET_None,
	LODSET_World,
	LODSET_Skin
};

var() Texture BumpMap;
var() Texture DetailTexture;
var() Texture MacroTexture;
var() float Diffuse;
var() float Specular;
var() float Alpha;
var() float DrawScale;
var() float Friction;
var() float MipMult;
var() Sound FootstepSound;
var() Sound HitSound;
var bool bInvisible;
var(Surface) editconst bool bMasked;
var(Surface) bool bTransparent;
var bool bNotSolid;
var(Surface) bool bEnvironment;
var bool bSemisolid;
var(Surface) bool bModulate;
var(Surface) bool bFakeBackdrop;
var(Surface) bool bTwoSided;
var(Surface) bool bAutoUPan;
var(Surface) bool bAutoVPan;
var(Surface) bool bNoSmooth;
var(Surface) bool bBigWavy;
var(Surface) bool bSmallWavy;
var(Surface) bool bWaterWavy;
var bool bLowShadowDetail;
var bool bNoMerge;
var(Surface) bool bCloudWavy;
var bool bDirtyShadows;
var bool bHighLedge;
var bool bSpecialLit;
var bool bGouraud;
var(Surface) bool bUnlit;
var bool bHighShadowDetail;
var bool bPortal;
var const bool bMirrored;
var const bool bX2;
var const bool bX3;
var const bool bX4;
var const bool bX5;
var const bool bX6;
var const bool bX7;
var(Quality) private bool bHighColorQuality;
var(Quality) private bool bHighTextureQuality;
var private bool bRealtime;
var private bool bParametric;
var transient private bool bRealtimeChanged;
var(Quality) ELODSet LODSet;
var(Animation) Texture AnimNext;
var transient Texture AnimCurrent;
var(Animation) byte PrimeCount;
var transient byte PrimeCurrent;
var(Animation) float MinFrameRate;
var(Animation) float MaxFrameRate;
var transient float Accumulator;
var const native array<int> Mips;
var const native array<int> DecompMips;
var native private ETextureFormat DecompFormat;

defaultproperties
{
    Diffuse=1.00
    Specular=1.00
    DrawScale=1.00
    Friction=1.00
    MipMult=1.00
    LODSet=LODSET_World
}