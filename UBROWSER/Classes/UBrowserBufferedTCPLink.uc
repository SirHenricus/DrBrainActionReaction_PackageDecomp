//================================================================================
// UBrowserBufferedTCPLink.
//================================================================================
class UBrowserBufferedTCPLink expands TcpLink
	transient;

var byte InputBuffer[1024];
var byte OutputBuffer[1024];
var int InputBufferHead;
var int InputBufferTail;
var int OutputBufferHead;
var int OutputBufferTail;
var string OutputQueue;
var int OutputQueueLen;
var string InputQueue;
var int InputQueueLen;
var bool bEOF;
var string CRLF;
var string CR;
var string LF;
var bool bWaiting;
var float WaitTimeoutTime;
var string WaitingFor;
var int WaitForCountChars;
var string WaitResult;
var int WaitMatchData;

function ResetBuffer ()
{
	OutputQueueLen=0;
	InputQueueLen=0;
	InputBufferHead=0;
	InputBufferTail=0;
	OutputBufferHead=0;
	OutputBufferTail=0;
	bWaiting=False;
	CRLF=Chr(10) $ Chr(13);
	CR=Chr(13);
	LF=Chr(10);
	bEOF=False;
	LinkMode=1;
	ReceiveMode=0;
}

function WaitFor (string What, float TimeOut, int MatchData)
{
	bWaiting=True;
	WaitingFor=What;
	WaitForCountChars=0;
	WaitTimeoutTime=Level.TimeSeconds + TimeOut;
	WaitMatchData=MatchData;
	WaitResult="";
}

function WaitForCount (int Count, float TimeOut, int MatchData)
{
	bWaiting=True;
	WaitingFor="";
	WaitForCountChars=Count;
	WaitTimeoutTime=Level.TimeSeconds + TimeOut;
	WaitMatchData=MatchData;
	WaitResult="";
}

function GotMatch (int MatchData)
{
}

function GotMatchTimeout (int MatchData)
{
}

function string ParseDelimited (string Text, string Delimiter, int Count, optional bool bToEndOfLine)
{
	local string Result;
	local int Found;
	local int i;
	local string S;

	Result="";
	Found=1;
	i=0;
JL0016:
	if ( i < Len(Text) )
	{
		S=Mid(Text,i,1);
		if ( InStr(Delimiter,S) != -1 )
		{
			if ( Found == Count )
			{
				if ( bToEndOfLine )
				{
					return Result $ Mid(Text,i);
				}
				else
				{
					return Result;
				}
			}
			Found++;
		}
		else
		{
			if ( Found >= Count )
			{
				Result=Result $ S;
			}
		}
		i++;
		goto JL0016;
	}
	return Result;
}

function bool SendEOF ()
{
	local int NewTail;

	NewTail=OutputBufferTail;
	NewTail=(NewTail + 1) % 1024;
	if ( NewTail == OutputBufferHead )
	{
		Log(string(Name) $ " - Output buffer overrun");
		return False;
	}
	OutputBuffer[OutputBufferTail]=0;
	OutputBufferTail=NewTail;
	return True;
}

function int ReadChar ()
{
	local int C;

	if ( InputBufferHead == InputBufferTail )
	{
		return 0;
	}
	C=InputBuffer[InputBufferHead];
	InputBufferHead=(InputBufferHead + 1) % 1024;
	return C;
}

function int PeekChar ()
{
	if ( InputBufferHead == InputBufferTail )
	{
		return 0;
	}
	return InputBuffer[InputBufferHead];
}

function bool ReadBufferedLine (out string Text)
{
	local int NewHead;

	Text="";
	NewHead=InputBufferHead;
JL0013:
	if ( NewHead != InputBufferTail )
	{
		if ( InputBuffer[NewHead] == 13 )
		{
			NewHead=(NewHead + 1) % 1024;
			if ( NewHead != InputBufferTail )
			{
				if ( InputBuffer[NewHead] == 10 )
				{
					NewHead=(NewHead + 1) % 1024;
				}
			}
			InputBufferHead=NewHead;
			return True;
		}
		Text=Text $ Chr(InputBuffer[NewHead]);
		NewHead=(NewHead + 1) % 1024;
		goto JL0013;
	}
	return False;
}

function bool SendBufferedData (string Text)
{
	local int intLength;
	local int i;
	local int NewTail;

	intLength=Len(Text);
	i=0;
JL0014:
	if ( i < intLength )
	{
		NewTail=OutputBufferTail;
		NewTail=(NewTail + 1) % 1024;
		if ( NewTail == OutputBufferHead )
		{
			Log(string(Name) $ " - Output buffer overrun");
			return False;
		}
		OutputBuffer[OutputBufferTail]=Asc(Mid(Text,i,1));
		OutputBufferTail=NewTail;
		i++;
		goto JL0014;
	}
	return True;
}

function DoBufferQueueIO ()
{
	local int i;
	local int NewTail;
	local int NewHead;
	local int BytesSent;
	local byte ch;

JL0000:
	if ( bWaiting )
	{
		if ( Level.TimeSeconds > WaitTimeoutTime )
		{
			bWaiting=False;
			GotMatchTimeout(WaitMatchData);
		}
		ch=ReadChar();
JL0041:
		if ( (ch != 0) && bWaiting )
		{
			WaitResult=WaitResult $ Chr(ch);
			if ( WaitForCountChars > 0 )
			{
				if ( Len(WaitResult) == WaitForCountChars )
				{
					bWaiting=False;
					GotMatch(WaitMatchData);
				}
				else
				{
					goto JL00F7;
					if ( (InStr(WaitResult,WaitingFor) != -1) || (WaitingFor == CR) && (InStr(WaitResult,LF) != -1) )
					{
						bWaiting=False;
						GotMatch(WaitMatchData);
					}
					else
					{
JL00F7:
						ch=ReadChar();
						goto JL0041;
					}
				}
			}
		}
		if ( ch == 0 )
		{
			goto JL0119;
		}
		goto JL0000;
	}
JL0119:
	if ( IsConnected() )
	{
		OutputQueueLen=0;
		OutputQueue="";
		NewHead=OutputBufferHead;
JL013C:
		if ( (OutputQueueLen < 255) && (NewHead != OutputBufferTail) )
		{
			if ( OutputBuffer[NewHead] != 0 )
			{
				OutputQueue=OutputQueue $ Chr(OutputBuffer[NewHead]);
				OutputQueueLen++;
			}
			else
			{
				bEOF=True;
			}
			NewHead=(NewHead + 1) % 1024;
			goto JL013C;
		}
		if ( OutputQueueLen > 0 )
		{
			BytesSent=SendText(OutputQueue $ "");
			OutputBufferHead=NewHead;
		}
	}
JL01DE:
	if ( IsDataPending() && IsConnected() || (InputQueueLen > 0) )
	{
		if ( InputQueueLen == 0 )
		{
			if ( ReadText(InputQueue) > 0 )
			{
				InputQueueLen=Len(InputQueue);
			}
		}
		if ( InputQueueLen > 0 )
		{
			i=0;
JL023A:
			if ( i < Len(InputQueue) )
			{
				NewTail=InputBufferTail;
				NewTail=(NewTail + 1) % 1024;
				if ( NewTail == InputBufferHead )
				{
					InputQueueLen=InputQueueLen - i;
					InputQueue=Mid(InputQueue,i,InputQueueLen);
					return;
				}
				InputBuffer[InputBufferTail]=Asc(Mid(InputQueue,i,1));
				InputBufferTail=NewTail;
				i++;
				goto JL023A;
			}
			InputQueueLen=0;
		}
		else
		{
			goto JL02E9;
		}
		goto JL01DE;
	}
JL02E9:
}