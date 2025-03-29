//================================================================================
// TimeDemo.
//================================================================================
class TimeDemo expands Info
	native;

var int FileAr;
var float TimePassed;
var float TimeDilation;
var float StartTime;
var float LastSecTime;
var float LastCycleTime;
var float LastFrameTime;
var float SquareSum;
var int FrameNum;
var int FrameLastSecond;
var int FrameLastCycle;
var int CycleCount;
var int QuitAfterCycles;
var string CycleMessage;
var string CycleResult;
var bool bSaveToFile;
var bool bFirstFrame;
var float LastSec;
var float MinFPS;
var float MaxFPS;
var InterpolationPoint OldPoint;
var TimeDemoInterpolationPoint NewPoint;
var Console Console;

native final function OpenFile ();

native final function WriteToFile (string Text);

native final function CloseFile ();

function DoSetup (Console C, optional bool bSave, optional int QuitAfter)
{
	local InterpolationPoint i;

	Console=C;
	bSaveToFile=bSave;
	QuitAfterCycles=QuitAfter;
	bFirstFrame=True;
	OldPoint=None;
	foreach Console.Viewport.Actor.AllActors(Class'InterpolationPoint',i,'Path')
	{
		if ( i.Position == 0 )
		{
			OldPoint=i;
		}
		else
		{
		}
	}
	if ( OldPoint != None )
	{
		Log("*************************");
		Console.Viewport.Actor.StartWalk();
		Console.Viewport.Actor.SetLocation(OldPoint.Location);
		OldPoint.Tag='OldPath';
		NewPoint=Console.Viewport.Actor.Spawn(Class'TimeDemoInterpolationPoint',OldPoint.Owner);
		NewPoint.SetLocation(OldPoint.Location);
		NewPoint.SetRotation(OldPoint.Rotation);
		NewPoint.Position=0;
		NewPoint.RateModifier=OldPoint.RateModifier;
		NewPoint.bEndOfPath=OldPoint.bEndOfPath;
		NewPoint.Tag='Path';
		NewPoint.Next=OldPoint.Next;
		NewPoint.Prev=OldPoint.Prev;
		NewPoint.Prev.Next=NewPoint;
		NewPoint.Next.Prev=NewPoint;
		NewPoint.t=self;
	}
}

function DoShutdown ()
{
	local float Avg;

	if ( OldPoint != None )
	{
		NewPoint.Destroy();
		OldPoint.Tag='Path';
		OldPoint.Prev.Next=OldPoint;
		OldPoint.Next.Prev=OldPoint;
		OldPoint=None;
	}
	Avg=FrameNum / (TimePassed - StartTime) / TimeDilation;
	Console.Viewport.Actor.ClientMessage(string(FrameNum) $ " frames rendered in " $ string((TimePassed - StartTime) / TimeDilation) $ " seconds. " $ string(Avg) $ " FPS average.");
	Console.TimeDemo=None;
	Destroy();
}

function PostRender (Canvas C)
{
	local float Avg;
	local float RMS;

	TimeDilation=Console.Viewport.Actor.Level.TimeDilation;
	if ( bFirstFrame )
	{
		StartTime=TimePassed;
		LastSecTime=TimePassed;
		LastFrameTime=TimePassed;
		FrameNum=0;
		FrameLastSecond=0;
		FrameLastCycle=0;
		CycleCount=0;
		LastSec=0.00;
		LastCycleTime=0.00;
		CycleMessage="";
		CycleResult="";
		SquareSum=0.00;
		MinFPS=0.00;
		MaxFPS=0.00;
		bFirstFrame=False;
		return;
	}
	FrameNum++;
	FrameLastSecond++;
	FrameLastCycle++;
	SquareSum=SquareSum + (LastFrameTime - TimePassed) * (LastFrameTime - TimePassed);
	RMS=1.00 / Sqrt(SquareSum / FrameNum);
	LastFrameTime=TimePassed;
	Avg=FrameNum / (TimePassed - StartTime) / TimeDilation;
	if ( (TimePassed - LastSecTime) / TimeDilation > 1 )
	{
		LastSec=FrameLastSecond / (TimePassed - LastSecTime) / TimeDilation;
		FrameLastSecond=0;
		LastSecTime=TimePassed;
	}
	if ( (LastSec < MinFPS) || (MinFPS == 0) )
	{
		MinFPS=LastSec;
	}
	if ( LastSec > MaxFPS )
	{
		MaxFPS=LastSec;
	}
	if ( Console.Viewport.Actor.bShowMenu )
	{
		return;
	}
	if ( C.ClipX >= 400 )
	{
		C.Font=C.MedFont;
	}
	else
	{
		C.Font=C.SmallFont;
	}
	C.SetPos(0.00,48.00);
	C.DrawText("Average:");
	C.SetPos(200.00,48.00);
	C.DrawText(string(Avg) $ " FPS.");
	C.SetPos(0.00,72.00);
	C.DrawText("RMS:");
	C.SetPos(200.00,72.00);
	C.DrawText(string(RMS) $ " FPS.");
	C.SetPos(0.00,96.00);
	C.DrawText("Last Second:");
	C.SetPos(200.00,96.00);
	C.DrawText(string(LastSec) $ " FPS.");
	C.SetPos(0.00,120.00);
	C.DrawText("Lowest:");
	C.SetPos(200.00,120.00);
	C.DrawText(string(MinFPS) $ " FPS.");
	C.SetPos(0.00,144.00);
	C.DrawText("Highest:");
	C.SetPos(200.00,144.00);
	C.DrawText(string(MaxFPS) $ " FPS.");
	C.SetPos(0.00,168.00);
	C.DrawText(CycleMessage);
	C.SetPos(200.00,168.00);
	C.DrawText(CycleResult);
}

function TickTimeDemo (float Delta)
{
	TimePassed=TimePassed + Delta;
}

function StartCycle ()
{
	local string Temp;

	if ( LastCycleTime == 0 )
	{
		CycleMessage="Cycle #1:";
		CycleResult="Timing...";
	}
	else
	{
		CycleMessage="Cycle #" $ string(CycleCount) $ ":";
		CycleResult=string(FrameLastCycle / (TimePassed - LastCycleTime) / TimeDilation) $ " FPS (" $ string(FrameLastCycle) $ " frames, " $ string((TimePassed - LastCycleTime) / TimeDilation) $ " seconds)";
		Log("Cycle #" $ string(CycleCount) $ ": " $ string(FrameLastCycle / (TimePassed - LastCycleTime) / TimeDilation) $ " FPS (" $ string(FrameLastCycle) $ " frames, " $ string((TimePassed - LastCycleTime) / TimeDilation) $ " seconds)");
		if ( bSaveToFile )
		{
			OpenFile();
			Temp=string(100 * FrameLastCycle / (TimePassed - LastCycleTime) / TimeDilation);
			WriteToFile(Left(Temp,Len(Temp) - 2) $ "." $ Right(Temp,2) $ " Unreal " $ Console.Viewport.Actor.Level.EngineVersion);
			Temp=string(100 * MinFPS);
			WriteToFile(Left(Temp,Len(Temp) - 2) $ "." $ Right(Temp,2) $ " Min");
			Temp=string(100 * MaxFPS);
			WriteToFile(Left(Temp,Len(Temp) - 2) $ "." $ Right(Temp,2) $ " Max");
			CloseFile();
		}
		if ( CycleCount == QuitAfterCycles )
		{
			Console.Viewport.Actor.ConsoleCommand("exit");
		}
	}
	LastCycleTime=TimePassed;
	FrameLastCycle=0;
	CycleCount++;
}