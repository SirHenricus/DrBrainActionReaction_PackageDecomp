//================================================================================
// TcpLink.
//================================================================================
class TcpLink expands InternetLink
	native
	transient;

var ELinkState LinkState;
var IpAddr RemoteAddr;
enum ELinkState {
	STATE_Initialized,
	STATE_Ready,
	STATE_Listening,
	STATE_Connecting,
	STATE_Connected
};


native function bool BindPort (optional int Port, optional bool bUseNextAvailable);

native function bool Listen ();

native function bool Open (IpAddr Addr);

native function bool Close ();

native function bool IsConnected ();

native function int SendText (coerce string Str);

native function int SendBinary (int Count, byte B[255]);

native function int ReadText (out string Str);

native function int ReadBinary (int Count, out byte B[255]);

event Accepted ();

event Opened ();

event Closed ();

event ReceivedText (string Text);

event ReceivedLine (string Line);

event ReceivedBinary (int Count, byte B[255]);

defaultproperties
{
    bAlwaysTick=True
}