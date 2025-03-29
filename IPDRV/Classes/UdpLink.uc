//================================================================================
// UdpLink.
//================================================================================
class UdpLink expands InternetLink
	native
	transient;

var() const int BroadcastAddr;

native function bool BindPort (optional int Port, optional bool bUseNextAvailable);

native function bool SendText (IpAddr Addr, coerce string Str);

native function bool SendBinary (IpAddr Addr, int Count, byte B[255]);

native function int ReadText (out IpAddr Addr, out string Str);

native function int ReadBinary (out IpAddr Addr, int Count, out byte B[255]);

native function string Validate (string ValidationString);

event ReceivedText (IpAddr Addr, string Text);

event ReceivedLine (IpAddr Addr, string Line);

event ReceivedBinary (IpAddr Addr, int Count, byte B[255]);

defaultproperties
{
    BroadcastAddr=-1
    bAlwaysTick=True
}