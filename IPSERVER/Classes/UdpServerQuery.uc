//================================================================================
// UdpServerQuery.
//================================================================================
class UdpServerQuery expands UdpLink
	transient;

var() name QueryName;
var int CurrentQueryNum;

function PreBeginPlay ()
{
	Tag=QueryName;
	if (  !BindPort(Level.Game.GetServerPort(),True) )
	{
		Log("UdpServerQuery: Port failed to bind.");
		return;
	}
}

function PostBeginPlay ()
{
	local UdpBeacon Beacon;

	foreach AllActors(Class'UdpBeacon',Beacon)
	{
		Beacon.UdpServerQueryPort=Port;
	}
	Super.PostBeginPlay();
}

event ReceivedText (IpAddr Addr, string Text)
{
	local string Query;
	local bool QueryRemaining;
	local int QueryNum;
	local int PacketNum;

	CurrentQueryNum++;
	if ( CurrentQueryNum > 100 )
	{
		CurrentQueryNum=1;
	}
	QueryNum=CurrentQueryNum;
	Query=Text;
	if ( Query == "" )
	{
		QueryRemaining=False;
	}
	else
	{
		QueryRemaining=True;
	}
JL004F:
	if ( QueryRemaining )
	{
		Query=ParseQuery(Addr,Query,QueryNum,PacketNum);
		if ( Query == "" )
		{
			QueryRemaining=False;
		}
		else
		{
			QueryRemaining=True;
		}
		goto JL004F;
	}
}

function bool ParseNextQuery (string Query, out string QueryType, out string QueryValue, out string QueryRest, out string FinalPacket)
{
	local string TempQuery;
	local int ClosingSlash;

	if ( Query == "" )
	{
		return False;
	}
	if ( Left(Query,1) == "\" )
	{
		ClosingSlash=InStr(Right(Query,Len(Query) - 1),"\");
		if ( ClosingSlash == 0 )
		{
			return False;
		}
		TempQuery=Query;
		QueryType=Right(Query,Len(Query) - 1);
		QueryType=Left(QueryType,ClosingSlash);
		QueryRest=Right(Query,Len(Query) - Len(QueryType) + 2);
		if ( (QueryRest == "") || (Len(QueryRest) == 1) )
		{
			FinalPacket="final";
			return True;
		}
		else
		{
			if ( Left(QueryRest,1) == "\" )
			{
				return True;
			}
		}
		ClosingSlash=InStr(QueryRest,"\");
		if ( ClosingSlash >= 0 )
		{
			QueryValue=Left(QueryRest,ClosingSlash);
		}
		else
		{
			QueryValue=QueryRest;
		}
		QueryRest=Right(Query,Len(Query) - Len(QueryType) + Len(QueryValue) + 3);
		if ( QueryRest == "" )
		{
			FinalPacket="final";
			return True;
		}
		else
		{
			return True;
		}
	}
	else
	{
		return False;
	}
}

function string ParseQuery (IpAddr Addr, coerce string Query, int QueryNum, out int PacketNum)
{
	local string QueryType;
	local string QueryValue;
	local string QueryRest;
	local string ValidationString;
	local bool Result;
	local string FinalPacket;

	Result=ParseNextQuery(Query,QueryType,QueryValue,QueryRest,FinalPacket);
	if (  !Result )
	{
		return "";
	}
	if ( QueryType == "basic" )
	{
		Result=SendQueryPacket(Addr,GetBasic(),QueryNum, ++PacketNum,FinalPacket);
	}
	else
	{
		if ( QueryType == "info" )
		{
			Result=SendQueryPacket(Addr,GetInfo(),QueryNum, ++PacketNum,FinalPacket);
		}
		else
		{
			if ( QueryType == "rules" )
			{
				Result=SendQueryPacket(Addr,GetRules(),QueryNum, ++PacketNum,FinalPacket);
			}
			else
			{
				if ( QueryType == "players" )
				{
					if ( Level.Game.NumPlayers > 0 )
					{
						Result=SendPlayers(Addr,QueryNum,PacketNum,FinalPacket);
					}
					else
					{
						Result=SendQueryPacket(Addr,"",QueryNum,PacketNum,FinalPacket);
					}
				}
				else
				{
					if ( QueryType == "status" )
					{
						Result=SendQueryPacket(Addr,GetBasic(),QueryNum, ++PacketNum,"");
						Result=SendQueryPacket(Addr,GetInfo(),QueryNum, ++PacketNum,"");
						if ( Level.Game.NumPlayers == 0 )
						{
							Result=SendQueryPacket(Addr,GetRules(),QueryNum, ++PacketNum,FinalPacket);
						}
						else
						{
							Result=SendQueryPacket(Addr,GetRules(),QueryNum, ++PacketNum,"");
							Result=SendPlayers(Addr,QueryNum,PacketNum,FinalPacket);
						}
					}
					else
					{
						if ( QueryType == "echo" )
						{
							Result=SendQueryPacket(Addr,"\echo\" $ QueryValue,QueryNum, ++PacketNum,FinalPacket);
						}
						else
						{
							if ( QueryType == "secure" )
							{
								ValidationString="\validate\" $ Validate(QueryValue);
								Result=SendQueryPacket(Addr,ValidationString,QueryNum, ++PacketNum,FinalPacket);
							}
							else
							{
								if ( QueryType == "level_property" )
								{
									Result=SendQueryPacket(Addr,GetLevelProperty(QueryValue),QueryNum, ++PacketNum,FinalPacket);
								}
								else
								{
									if ( QueryType == "game_property" )
									{
										Result=SendQueryPacket(Addr,GetGameProperty(QueryValue),QueryNum, ++PacketNum,FinalPacket);
									}
									else
									{
										if ( QueryType == "player_property" )
										{
											Result=SendQueryPacket(Addr,GetPlayerProperty(QueryValue),QueryNum, ++PacketNum,FinalPacket);
										}
										else
										{
											Log("UdpServerQuery: Unknown query: " $ QueryType);
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
	if (  !Result )
	{
		Log("UdpServerQuery: Error responding to query.");
	}
	return QueryRest;
}

function bool SendQueryPacket (IpAddr Addr, coerce string SendString, int QueryNum, int PacketNum, string FinalPacket)
{
	local bool Result;

	if ( FinalPacket == "final" )
	{
		SendString=SendString $ "\final\";
	}
	SendString=SendString $ "\queryid\" $ string(QueryNum) $ "." $ string(PacketNum);
	Result=SendText(Addr,SendString);
	return Result;
}

function string GetBasic ()
{
	local string ResultSet;

	ResultSet="\gamename\unreal";
	ResultSet=ResultSet $ "\gamever\" $ Level.EngineVersion;
	ResultSet=ResultSet $ "\mingamever\" $ Level.MinNetVersion;
	ResultSet=ResultSet $ "\location\" $ string(Level.Game.GameReplicationInfo.Region);
	return ResultSet;
}

function string GetInfo ()
{
	local string ResultSet;

	ResultSet="\hostname\" $ Level.Game.GameReplicationInfo.ServerName;
	ResultSet=ResultSet $ "\shortname\" $ Level.Game.GameReplicationInfo.ShortName;
	ResultSet=ResultSet $ "\hostport\" $ string(Level.Game.GetServerPort());
	ResultSet=ResultSet $ "\mapname\" $ Level.Title;
	ResultSet=ResultSet $ "\gametype\" $ Level.Game.GameName;
	ResultSet=ResultSet $ "\numplayers\" $ string(Level.Game.NumPlayers);
	ResultSet=ResultSet $ "\maxplayers\" $ string(Level.Game.MaxPlayers);
	ResultSet=ResultSet $ "\gamemode\openplaying";
	ResultSet=ResultSet $ "\gamever\" $ Level.EngineVersion;
	ResultSet=ResultSet $ "\mingamever\" $ Level.MinNetVersion;
	return ResultSet;
}

function string GetRules ()
{
	local string ResultSet;

	ResultSet=Level.Game.GetRules();
	if ( Level.Game.GameReplicationInfo.AdminName != "" )
	{
		ResultSet=ResultSet $ "\AdminName\" $ Level.Game.GameReplicationInfo.AdminName;
	}
	if ( Level.Game.GameReplicationInfo.AdminEmail != "" )
	{
		ResultSet=ResultSet $ "\AdminEMail\" $ Level.Game.GameReplicationInfo.AdminEmail;
	}
	return ResultSet;
}

function string GetPlayer (PlayerPawn P, int PlayerNum)
{
	local string ResultSet;

	ResultSet="\player_" $ string(PlayerNum) $ "\" $ P.PlayerReplicationInfo.PlayerName;
	ResultSet=ResultSet $ "\frags_" $ string(PlayerNum) $ "\" $ string(P.PlayerReplicationInfo.Score);
	ResultSet=ResultSet $ "\ping_" $ string(PlayerNum) $ "\" $ P.ConsoleCommand("GETPING");
	ResultSet=ResultSet $ "\team_" $ string(PlayerNum) $ "\" $ string(P.PlayerReplicationInfo.Team);
	ResultSet=ResultSet $ "\skin_" $ string(PlayerNum) $ "\" $ GetItemName(string(P.Skin));
	ResultSet=ResultSet $ "\mesh_" $ string(PlayerNum) $ "\" $ GetItemName(string(P.Mesh));
	return ResultSet;
}

function bool SendPlayers (IpAddr Addr, int QueryNum, out int PacketNum, string FinalPacket)
{
	local Pawn P;
	local int i;
	local bool Result;
	local bool SendResult;

	Result=False;
	P=Level.PawnList;
JL001C:
	if ( i < Level.Game.NumPlayers )
	{
		if ( P.IsA('PlayerPawn') )
		{
			if ( (i == Level.Game.NumPlayers - 1) && (FinalPacket == "final") )
			{
				SendResult=SendQueryPacket(Addr,GetPlayer(PlayerPawn(P),i),QueryNum, ++PacketNum,"final");
			}
			else
			{
				SendResult=SendQueryPacket(Addr,GetPlayer(PlayerPawn(P),i),QueryNum, ++PacketNum,"");
			}
			Result=SendResult || Result;
			i++;
		}
		P=P.nextPawn;
		goto JL001C;
	}
	return Result;
}

function string GetLevelProperty (string Prop)
{
	local string ResultSet;

	ResultSet="\" $ Prop $ "\" $ Level.GetPropertyText(Prop);
	return ResultSet;
}

function string GetGameProperty (string Prop)
{
	local string ResultSet;

	ResultSet="\" $ Prop $ "\" $ Level.Game.GetPropertyText(Prop);
	return ResultSet;
}

function string GetPlayerProperty (string Prop)
{
	local string ResultSet;
	local int i;
	local PlayerPawn P;

	foreach AllActors(Class'PlayerPawn',P)
	{
		i++;
		ResultSet=ResultSet $ "\" $ Prop $ "_" $ string(i) $ "\" $ P.GetPropertyText(Prop);
	}
	return ResultSet;
}

defaultproperties
{
    QueryName=MasterUplink
}