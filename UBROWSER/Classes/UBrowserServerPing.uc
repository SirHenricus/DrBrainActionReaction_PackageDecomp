//================================================================================
// UBrowserServerPing.
//================================================================================
class UBrowserServerPing expands UdpLink
	transient;

var UBrowserServerList Server;
var IpAddr ServerIPAddr;
var float ElapsedTime;
var float SentTime;
var name QueryState;
var bool bInitial;
var bool bJustThisServer;
var bool bNoSort;
var int PingAttempts;
var int AttemptNumber;
var int BindAttempts;
var localized string AdminEmailText;
var localized string AdminNameText;
var localized string ChangeLevelsText;
var localized string MultiplayerBotsText;
var localized string FragLimitText;
var localized string TimeLimitText;
var localized string GameModeText;
var localized string GameTypeText;
var localized string GameVersionText;
var localized string WorldLogText;
var localized string TrueString;
var localized string FalseString;
var config int MaxBindAttempts;
var config int BindRetryTime;

function ValidateServer ()
{
	if ( Server.ServerPing != self )
	{
		Log("ORPHANED: " $ string(self));
		Destroy();
	}
}

function StartQuery (name S, int InPingAttempts)
{
	QueryState=S;
	ValidateServer();
	ServerIPAddr.Port=Server.QueryPort;
	GotoState('Resolving');
	PingAttempts=InPingAttempts;
	AttemptNumber=1;
}

function Resolved (IpAddr Addr)
{
	ServerIPAddr.Addr=Addr.Addr;
	GotoState('Binding');
}

function bool GetNextValue (string In, out string Out, out string Result)
{
	local int i;
	local bool bFoundStart;

	Result="";
	bFoundStart=False;
	i=0;
JL0017:
	if ( i < Len(In) )
	{
		if ( bFoundStart )
		{
			if ( Mid(In,i,1) == "\" )
			{
				Out=Right(In,Len(In) - i);
				return True;
			}
			else
			{
				Result=Result $ Mid(In,i,1);
			}
		}
		else
		{
			if ( Mid(In,i,1) == "\" )
			{
				bFoundStart=True;
			}
		}
		i++;
		goto JL0017;
	}
	return False;
}

function string LocalizeBoolValue (string Value)
{
	if ( Value ~= "True" )
	{
		return TrueString;
	}
	if ( Value ~= "False" )
	{
		return TrueString;
	}
	return Value;
}

function AddRule (string Rule, string Value)
{
	local UBrowserRulesList RulesList;

	ValidateServer();
	RulesList=UBrowserRulesList(Server.RulesList.Next);
JL0028:
	if ( RulesList != None )
	{
		if ( RulesList.Rule == Rule )
		{
			return;
		}
		RulesList=UBrowserRulesList(RulesList.Next);
		goto JL0028;
	}
	RulesList=UBrowserRulesList(Server.RulesList.Append(Class'UBrowserRulesList'));
	RulesList.Rule=Rule;
	RulesList.Value=Value;
}

state Binding
{
Begin:
	if (  !BindPort(2000,True) )
	{
		Log("UBrowserServerPing: Port failed to bind.  Attempt " $ string(BindAttempts));
		BindAttempts++;
		ValidateServer();
		if ( BindAttempts == MaxBindAttempts )
		{
			Server.PingDone(bInitial,bJustThisServer,False,bNoSort);
		}
		else
		{
			GotoState('BindFailed');
		}
	}
	else
	{
		GotoState(QueryState);
	}
}

state BindFailed
{
	event Timer ()
	{
		GotoState('Binding');
	}
	
Begin:
	SetTimer(BindRetryTime,False);
}

state GetStatus
{
	event ReceivedText (IpAddr Addr, string Text)
	{
		local string Value;
		local string In;
		local string Out;
		local byte Id;
		local bool bOK;
		local UBrowserPlayerList PlayerEntry;
	
		ValidateServer();
		In=Text;
	JL0011:
		bOK=GetNextValue(In,Out,Value);
		In=Out;
		if ( Left(Value,7) == "player_" )
		{
			Id=int(Right(Value,Len(Value) - 7));
			PlayerEntry=Server.PlayerList.FindID(Id);
			if ( PlayerEntry == None )
			{
				PlayerEntry=UBrowserPlayerList(Server.PlayerList.Append(Class'UBrowserPlayerList'));
			}
			PlayerEntry.PlayerID=Id;
			bOK=GetNextValue(In,Out,Value);
			In=Out;
			PlayerEntry.PlayerName=Value;
		}
		else
		{
			if ( Left(Value,6) == "frags_" )
			{
				Id=int(Right(Value,Len(Value) - 6));
				bOK=GetNextValue(In,Out,Value);
				In=Out;
				PlayerEntry=Server.PlayerList.FindID(Id);
				PlayerEntry.PlayerFrags=int(Value);
			}
			else
			{
				if ( Left(Value,5) == "ping_" )
				{
					Id=int(Right(Value,Len(Value) - 5));
					bOK=GetNextValue(In,Out,Value);
					In=Out;
					PlayerEntry=Server.PlayerList.FindID(Id);
					PlayerEntry.PlayerPing=int(Right(Value,Len(Value) - 1));
				}
				else
				{
					if ( Left(Value,5) == "team_" )
					{
						Id=int(Right(Value,Len(Value) - 5));
						bOK=GetNextValue(In,Out,Value);
						In=Out;
						PlayerEntry=Server.PlayerList.FindID(Id);
						PlayerEntry.PlayerTeam=Value;
					}
					else
					{
						if ( Left(Value,5) == "skin_" )
						{
							Id=int(Right(Value,Len(Value) - 5));
							bOK=GetNextValue(In,Out,Value);
							In=Out;
							PlayerEntry=Server.PlayerList.FindID(Id);
							PlayerEntry.PlayerSkin=GetItemName(Value);
						}
						else
						{
							if ( Left(Value,5) == "mesh_" )
							{
								Id=int(Right(Value,Len(Value) - 5));
								bOK=GetNextValue(In,Out,Value);
								In=Out;
								PlayerEntry=Server.PlayerList.FindID(Id);
								PlayerEntry.PlayerMesh=GetItemName(Value);
							}
							else
							{
								if ( Value == "final" )
								{
									Server.StatusDone(True);
									return;
								}
								else
								{
									if ( Value ~= "gamever" )
									{
										bOK=GetNextValue(In,Out,Value);
										AddRule(GameVersionText,Value);
									}
									else
									{
										if ( Value ~= "gametype" )
										{
											bOK=GetNextValue(In,Out,Value);
											AddRule(GameTypeText,Value);
										}
										else
										{
											if ( Value ~= "gamemode" )
											{
												bOK=GetNextValue(In,Out,Value);
												AddRule(GameModeText,Value);
											}
											else
											{
												if ( Value ~= "timelimit" )
												{
													bOK=GetNextValue(In,Out,Value);
													AddRule(TimeLimitText,Value);
												}
												else
												{
													if ( Value ~= "fraglimit" )
													{
														bOK=GetNextValue(In,Out,Value);
														AddRule(FragLimitText,Value);
													}
													else
													{
														if ( Value ~= "MultiplayerBots" )
														{
															bOK=GetNextValue(In,Out,Value);
															AddRule(MultiplayerBotsText,LocalizeBoolValue(Value));
														}
														else
														{
															if ( Value ~= "ChangeLevels" )
															{
																bOK=GetNextValue(In,Out,Value);
																AddRule(ChangeLevelsText,LocalizeBoolValue(Value));
															}
															else
															{
																if ( Value ~= "AdminName" )
																{
																	bOK=GetNextValue(In,Out,Value);
																	AddRule(AdminNameText,Value);
																}
																else
																{
																	if ( Value ~= "AdminEMail" )
																	{
																		bOK=GetNextValue(In,Out,Value);
																		AddRule(AdminEmailText,Value);
																	}
																	else
																	{
																		if ( Value ~= "WorldLog" )
																		{
																			bOK=GetNextValue(In,Out,Value);
																			AddRule(WorldLogText,LocalizeBoolValue(Value));
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		if (!  !bOK ) goto JL0011;
	}
	
	event Timer ()
	{
		if ( AttemptNumber < PingAttempts )
		{
			Log("Timed out getting player replies.  Attempt " $ string(AttemptNumber));
			AttemptNumber++;
			GotoState(QueryState);
		}
		else
		{
			Server.StatusDone(False);
			Log("Timed out getting player replies.  Giving Up");
		}
	}
	
Begin:
	ValidateServer();
	if ( Server.PlayerList != None )
	{
		Server.PlayerList.DestroyList();
	}
	Server.PlayerList=new (None,Class'UBrowserPlayerList');
	Server.PlayerList.SetupSentinel();
	if ( Server.RulesList != None )
	{
		Server.RulesList.DestroyList();
	}
	Server.RulesList=new (None,Class'UBrowserRulesList');
	Server.RulesList.SetupSentinel();
	SendText(ServerIPAddr,"\status\");
	SentTime=ElapsedTime;
	SetTimer(10.00 + Rand(200) / 100,False);
}

state GetInfo
{
	event ReceivedText (IpAddr Addr, string Text)
	{
		local string Temp;
		local int i;
		local int L;
	
		Disable('Tick');
		ValidateServer();
		Server.Ping=1000.00 * (ElapsedTime - SentTime);
		Server.HostName=Server.IP;
		Server.GamePort=0;
		Server.MapName="";
		Server.GameType="";
		Server.GameMode="";
		Server.NumPlayers=0;
		Server.MaxPlayers=0;
		Server.GameVer=0;
		Server.MinGameVer=0;
		L=Len(Text);
		i=InStr(Text,"\hostname\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 10);
			Server.HostName=Left(Temp,InStr(Temp,"\"));
		}
		i=InStr(Text,"\hostport\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 10);
			Server.GamePort=int(Left(Temp,InStr(Temp,"\")));
		}
		i=InStr(Text,"\mapname\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 9);
			Server.MapName=Left(Temp,InStr(Temp,"\"));
		}
		i=InStr(Text,"\gametype\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 10);
			Server.GameType=Left(Temp,InStr(Temp,"\"));
		}
		i=InStr(Text,"\numplayers\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 12);
			Server.NumPlayers=int(Left(Temp,InStr(Temp,"\")));
		}
		i=InStr(Text,"\maxplayers\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 12);
			Server.MaxPlayers=int(Left(Temp,InStr(Temp,"\")));
		}
		i=InStr(Text,"\gamemode\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 10);
			Server.GameMode=Left(Temp,InStr(Temp,"\"));
		}
		i=InStr(Text,"\gamever\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 9);
			Server.GameVer=int(Left(Temp,InStr(Temp,"\")));
		}
		i=InStr(Text,"\mingamever\");
		if ( i >= 0 )
		{
			Temp=Right(Text,L - i - 12);
			Server.MinGameVer=int(Left(Temp,InStr(Temp,"\")));
		}
		Server.PingDone(bInitial,bJustThisServer,True,bNoSort);
	}
	
	event Tick (float DeltaTime)
	{
		ElapsedTime=ElapsedTime + DeltaTime;
	}
	
	event Timer ()
	{
		ValidateServer();
		if ( AttemptNumber < PingAttempts )
		{
			Log("Ping Timeout from " $ Server.IP $ ".  Attempt " $ string(AttemptNumber));
			AttemptNumber++;
			GotoState(QueryState);
		}
		else
		{
			Log("Ping Timeout from " $ Server.IP $ " Giving Up");
			Server.Ping=9999.00;
			Server.GamePort=0;
			Server.MapName="";
			Server.GameType="";
			Server.GameMode="";
			Server.NumPlayers=0;
			Server.MaxPlayers=0;
			Disable('Tick');
			Server.PingDone(bInitial,bJustThisServer,False,bNoSort);
		}
	}
	
Begin:
	ElapsedTime=0.00;
	Enable('Tick');
	SendText(ServerIPAddr,"\info\");
	SentTime=ElapsedTime;
	SetTimer(10.00 + Rand(200) / 100,False);
}

state Resolving
{
Begin:
	Resolve(Server.IP);
}

defaultproperties
{
    AdminEmailText="Admin Email"
    AdminNameText="Admin Name"
    ChangeLevelsText="Change Levels"
    MultiplayerBotsText="Bots in Multiplayer"
    FragLimitText="Frag Limit"
    TimeLimitText="Time Limit"
    GameModeText="Game Mode"
    GameTypeText="Game Type"
    GameVersionText="Game Version"
    WorldLogText="ngStats World Stat-Logging"
    TrueString="Enabled"
    FalseString="Disabled"
    MaxBindAttempts=5
    BindRetryTime=10
}