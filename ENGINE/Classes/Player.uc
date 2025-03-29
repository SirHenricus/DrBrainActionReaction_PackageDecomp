//================================================================================
// Player.
//================================================================================
class Player expands Object
	native
	noexport;

const IDC_WAIT=6;
const IDC_SIZEWE=5;
const IDC_SIZENWSE=4;
const IDC_SIZENS=3;
const IDC_SIZENESW=2;
const IDC_SIZEALL=1;
const IDC_ARROW=0;
var const native int vfOut;
var const native int vfExec;
var const transient PlayerPawn Actor;
var const transient Console Console;
var const transient bool bWindowsMouseAvailable;
var bool bShowWindowsMouse;
var const transient float WindowsMouseX;
var const transient float WindowsMouseY;
var byte SelectedCursor;