//================================================================================
// EditorEngine.
//================================================================================
class EditorEngine expands Engine
	native
	noexport
	transient;

var const int NotifyVtbl;
var const Level Level;
var const Model TempModel;
var const Texture CurrentTexture;
var const Class CurrentClass;
var const TransBuffer Trans;
var const TextBuffer Results;
var const int Pad[8];
var const Texture MenuUp;
var const Texture MenuDn;
var const Texture CollOn;
var const Texture CollOff;
var const Texture PlyrOn;
var const Texture PlyrOff;
var const Texture LiteOn;
var const Texture LiteOff;
var const Texture Bad;
var const Texture Bkgnd;
var const Texture BkgndHi;
var const bool bBootstrapping;
var const config int AutoSaveIndex;
var const int AutoSaveCount;
var const int Mode;
var const int ClickFlags;
var const float MovementSpeed;
var const Package PackageContext;
var const Vector AddLocation;
var const Plane AddPlane;
var const array<Object> Tools;
var const Class BrowseClass;
var const int ConstraintsVtbl;
var(Grid) config bool GridEnabled;
var(Grid) config bool SnapVertices;
var(Grid) config float SnapDistance;
var(Grid) config Vector GridSize;
var(RotationGrid) config bool RotGridEnabled;
var(RotationGrid) config Rotator RotGridSize;
var(Advanced) config float FovAngleDegrees;
var(Advanced) config bool GodMode;
var(Advanced) config bool AutoSave;
var(Advanced) config byte AutosaveTimeMinutes;
var(Advanced) config string GameCommandLine;
var(Advanced) config array<string> EditPackages;
var(Colors) config Color C_WorldBox;
var(Colors) config Color C_GroundPlane;
var(Colors) config Color C_GroundHighlight;
var(Colors) config Color C_BrushWire;
var(Colors) config Color C_Pivot;
var(Colors) config Color C_Select;
var(Colors) config Color C_Current;
var(Colors) config Color C_AddWire;
var(Colors) config Color C_SubtractWire;
var(Colors) config Color C_GreyWire;
var(Colors) config Color C_BrushVertex;
var(Colors) config Color C_BrushSnap;
var(Colors) config Color C_Invalid;
var(Colors) config Color C_ActorWire;
var(Colors) config Color C_ActorHiWire;
var(Colors) config Color C_Black;
var(Colors) config Color C_White;
var(Colors) config Color C_Mask;
var(Colors) config Color C_SemiSolidWire;
var(Colors) config Color C_NonSolidWire;
var(Colors) config Color C_WireBackground;
var(Colors) config Color C_WireGridAxis;
var(Colors) config Color C_ActorArrow;
var(Colors) config Color C_ScaleBox;
var(Colors) config Color C_ScaleBoxHi;
var(Colors) config Color C_ZoneWire;
var(Colors) config Color C_Mover;
var(Colors) config Color C_OrthoBackground;

defaultproperties
{
    MenuUp=Texture'B_MenuUp'
    MenuDn=Texture'B_MenuDn'
    CollOn=Texture'B_CollOn'
    CollOff=Texture'B_CollOf'
    PlyrOn=Texture'B_PlyrOn'
    PlyrOff=Texture'B_PlyrOf'
    LiteOn=Texture'B_LiteOn'
    Bad=Texture'Bad'
    Bkgnd=Texture'Bkgnd'
    BkgndHi=Texture'BkgndHi'
    GridSize=(X=16.00,Y=16.00,Z=16.00)
}