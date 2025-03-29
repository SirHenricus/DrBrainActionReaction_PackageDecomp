//================================================================================
// InternetLink.
//================================================================================
class InternetLink expands InternetInfo
	native
	transient;

enum EReceiveMode {
	RMODE_Manual,
	RMODE_Event
};

var ELinkMode LinkMode;
var const int Socket;
var const int Port;
var const int RemoteSocket;
var const native private int PrivateResolveInfo;
var const int DataPending;
var EReceiveMode ReceiveMode;
enum ELinkMode {
	MODE_Text,
	MODE_Line,
	MODE_Binary
};

struct IpAddr
{
	var int Addr;
	var int Port;
};


native function bool IsDataPending ();

native function bool ParseURL (coerce string URL, out string Addr, out int Port, out string LevelName, out string EntryName);

native function Resolve (coerce string Domain);

native function int GetLastError ();

native function string IpAddrToString (IpAddr Arg);

event Resolved (IpAddr Addr);

event ResolveFailed ();