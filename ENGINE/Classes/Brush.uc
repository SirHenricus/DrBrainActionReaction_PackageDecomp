//================================================================================
// Brush.
//================================================================================
class Brush expands Actor
	native;

var() ECsgOper CsgOper;
var const Object UnusedLightMesh;
var Vector PostPivot;
var() Scale MainScale;
var() Scale PostScale;
var Scale TempScale;
var() Color BrushColor;
var() int PolyFlags;
var() bool bColored;
enum ECsgOper {
	CSG_Active,
	CSG_Add,
	CSG_Subtract,
	CSG_Intersect,
	CSG_Deintersect
};


defaultproperties
{
    MainScale=(X=1.00, Y=1.00, Z=1.00, SheerRate=0.00, SheerAxis=SHEER_None)
    PostScale=(X=1.00, Y=1.00, Z=1.00, SheerRate=0.00, SheerAxis=SHEER_None)
    TempScale=(X=1.00, Y=1.00, Z=1.00, SheerRate=0.00, SheerAxis=SHEER_None)
    bStatic=True
    bNoDelete=True
    bEdShouldSnap=True
    DrawType=DT_Sprite
    bFixedRotationDir=True
}