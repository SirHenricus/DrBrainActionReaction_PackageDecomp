//================================================================================
// Bitmap.
//================================================================================
class Bitmap expands Object
	native
	noexport;

var const ETextureFormat Format;
var(Texture) Palette Palette;
var const byte UBits;
var const byte VBits;
var const int USize;
var const int VSize;
var(Texture) const int UClamp;
var(Texture) const int VClamp;
var const Color MipZero;
var const Color MaxColor;
var const int InternalTime[2];
enum ETextureFormat {
	TEXF_P8,
	TEXF_RGB32,
	TEXF_RGB64,
	TEXF_DXT1,
	TEXF_RGB24
};


defaultproperties
{
    MipZero=(R=64,G=128,B=64,A=0)
    MaxColor=(R=255,G=255,B=255,A=255)
}