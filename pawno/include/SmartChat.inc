/*
			+-----------------------------------------------------------+
			|                         Smart Chat                        |
			|                       by varthshenon                      |
			|                        <<<<<<>>>>>>                       |
			|                            V3.3                           |
			|http://forum.sa-mp.com/showthread.php?t=269319             |
			|Stay tuned folks                                           |
			|Thanks to Y_Less for his foreach and y_ini                 |
			+-----------------------------------------------------------+
																					*/
#if defined _SmartChat
	#endinput
#endif
#define _SmartChat

#if defined MAX_INI_ENTRY_TEXT
	#undef MAX_INI_ENTRY_TEXT
	#define MAX_INI_ENTRY_TEXT 150
#endif

#define SWhite			0xFFFFFFFF
#define SChat1			0xC8C8C8C8
#define SChat2			0x95959595
#define SChat3			0x65656565
#define SChat4			0x33333333

#define CostumFormat(%0,%1,%2)	format((%0),sizeof(%0),(%1),%2)
#define CostumString(%0,%1)		format((%0),sizeof(%0),(%1))

new	bool:Splitted,
	bool:PlayerSeat[MAX_PLAYERS char],
	bool:PlayerAnim[MAX_PLAYERS char],
	bool:SLogged[MAX_PLAYERS char],
	antimer[MAX_PLAYERS];

forward SCAnimation(playerid);

#if !defined FILTERSCRIPT
public OnGameModeInit()
{
	print( "       +-----------------------------------------------------------+       " );
	print( "       |                         Smart Chat                        |       " );
	print( "       |                       by varthshenon                      |       " );
	print( "       |                        <<<<<<>>>>>>                       |       " );
	print( "       |                            V3.3                           |       " );
	print( "       |http://forum.sa-mp.com/showthread.php?t=269319             |       " );
	print( "       |Stay tuned folks                                           |       " );
	print( "       |Thanks to Y_Less for his foreach and y_ini                 |       " );
	print( "       +-----------------------------------------------------------+       " );
	return CallLocalFunction("SC_OnGameModeInit","");
}

public OnGameModeExit()
{
	print( "       +-----------------------------------------------------------+       " );
	print( "       |                    Smart Chat unloaded                    |       " );
	print( "       +-----------------------------------------------------------+       " );
	return CallLocalFunction("SC_OnGameModeExit","");
}
#else
public OnFilterScriptInit()
{
	foreach(Player,i)
	{
		PreloadAnimLib(i,"BOMBER");
		PreloadAnimLib(i,"RAPPING");
		PreloadAnimLib(i,"SHOP");
		PreloadAnimLib(i,"BEACH");
		PreloadAnimLib(i,"SMOKING");
		PreloadAnimLib(i,"FOOD");
		PreloadAnimLib(i,"ON_LOOKERS");
		PreloadAnimLib(i,"DEALER");
		PreloadAnimLib(i,"CRACK");
		PreloadAnimLib(i,"CARRY");
		PreloadAnimLib(i,"COP_AMBIENT");
		PreloadAnimLib(i,"PARK");
		PreloadAnimLib(i,"INT_HOUSE");
		PreloadAnimLib(i,"FOOD" );
		SLogged{i}++;
	}
	print( "       +-----------------------------------------------------------+       " );
	print( "       |                         Smart Chat                        |       " );
	print( "       |                       by varthshenon                      |       " );
	print( "       |                        <<<<<<>>>>>>                       |       " );
	print( "       |                            V3.3                           |       " );
	print( "       |http://forum.sa-mp.com/showthread.php?t=269319             |       " );
	print( "       |Stay tuned folks                                           |       " );
	print( "       |Thanks to Y_Less for his foreach and y_ini                 |       " );
	print( "       +-----------------------------------------------------------+       " );
	return CallLocalFunction("S@@OnFilterScriptInit","");
}

public OnFilterScriptExit()
{
	print( "       +-----------------------------------------------------------+       " );
	print( "       |                    Smart Chat unloaded                    |       " );
	print( "       +-----------------------------------------------------------+       " );
	return CallLocalFunction("SC_OnFilterScriptExit","");
}
#endif

public OnPlayerConnect(playerid)
{
	SLogged{playerid} = false;
	return CallLocalFunction("SC_OnPlayerConnect","d",playerid);
}

public OnPlayerSpawn(playerid)
{
	if(!SLogged{playerid})
	{
		PreloadAnimLib(playerid,"BOMBER");
		PreloadAnimLib(playerid,"RAPPING");
		PreloadAnimLib(playerid,"SHOP");
		PreloadAnimLib(playerid,"BEACH");
		PreloadAnimLib(playerid,"SMOKING");
		PreloadAnimLib(playerid,"FOOD");
		PreloadAnimLib(playerid,"ON_LOOKERS");
		PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD" );
		PreloadAnimLib(playerid,"PED" );
		SLogged{playerid}++;
	}
	return CallLocalFunction("SC_OnPlayerSpawn","d",playerid);
}

public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
	if(PlayerAnim{playerid}) KillTimer(antimer[playerid]),SCStopAnim(playerid);
	return CallLocalFunction("SC_OnPlayerEnterVehicle","ddd",playerid,vehicleid,ispassenger);
}

public OnPlayerExitVehicle(playerid,vehicleid)
{
	if(PlayerAnim{playerid}) KillTimer(antimer[playerid]),SCStopAnim(playerid);
	return CallLocalFunction("SC_OnPlayerExitVehicle","dd",playerid,vehicleid);
}

public SCAnimation(playerid)
{
	if(PlayerSeat{playerid}) return ApplyAnimation(playerid,"PED","SEAT_IDLE",4,0,0,0,1,0,1);
	else SCStopAnim(playerid);
	return 1;
}

stock SCGeneral(playerid,stringtext[],Float:range1,Float:range2,Float:range3,Float:range4,Float:range5,color1,color2,color3,color4,color5)
{
	new strings[65],strings1[65];
	if(strlen(stringtext) > 64)
	{
		strmid(strings,stringtext,64,128);
		strdel(stringtext,64,128);
		format(stringtext,66,"%s-",stringtext);
		format(strings,66,"-%s",strings);
		Splitted = true;
	}
	else Splitted = false;
	if(range1 == 0)
	{
		if(Splitted)
		{
			SendClientMessageToAll(color1,strings);
			SendClientMessageToAll(color1,strings1);
		}
		else SendClientMessageToAll(color1,stringtext);
		return 1;
	}
	new Float:SCX,Float:SCY,Float:SCZ;
	GetPlayerPos(playerid,SCX,SCY,SCZ);
	foreach(Player,i)
	{
		if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(i)) continue;
		SCX = GetPlayerDistanceFromPoint(i,SCX,SCY,SCZ);
		if(SCX <= range1)
		{
			SendClientMessage(playerid,color1,stringtext);
			if(Splitted) SendClientMessage(playerid,color1,strings);
			continue;
		}
		if(range2 == 0) continue;
		if(SCX <= range2)
		{
			SendClientMessage(playerid,color2,stringtext);
			if(Splitted) SendClientMessage(playerid,color2,strings);
			continue;
		}
		if(range3 == 0) continue;
		if(SCX <= range3)
		{
			SendClientMessage(playerid,color3,stringtext);
			if(Splitted) SendClientMessage(playerid,color3,strings);
			continue;
		}
		if(range4 == 0) continue;
		if(SCX <= range4)
		{
			SendClientMessage(playerid,color4,stringtext);
			if(Splitted) SendClientMessage(playerid,color4,strings);
			continue;
		}
		if(range5 == 0) continue;
		if(SCX <= range5)
		{
			SendClientMessage(playerid,color5,stringtext);
			if(Splitted) SendClientMessage(playerid,color5,strings);
			continue;
		}
	}
	return 1;
}

stock SCMessage(playerid,toplayerid,stringtext[],color)
{
	if(strlen(stringtext) > 64)
	{
		new strings[65];
		strmid(strings,stringtext,64,128);
		strdel(stringtext,64,128);
		format(stringtext,66,"%s-",stringtext);
		format(strings,66,"-%s",strings);
		SendClientMessage(playerid,color,stringtext);
		SendClientMessage(playerid,color,strings);
		SendClientMessage(toplayerid,color,stringtext);
		SendClientMessage(toplayerid,color,strings);
		return 1;
	}
	SendClientMessage(playerid,color,stringtext);
	SendClientMessage(toplayerid,color,stringtext);
	return 1;
}

stock SCBubble(playerid,stringtext[],bool:selftext,color,range,time)
{
	SetPlayerChatBubble(playerid,stringtext,color,range,time);
	if(selftext)
	{
		if(strlen(stringtext) > 64)
		{
			new strings1[65];
			strmid(strings1,stringtext,64,128);
			strdel(stringtext,64,128);
			format(stringtext,66,"%s-",stringtext);
			format(strings1,66,"-%s",strings1);
			SendClientMessage(playerid,color,stringtext);
			SendClientMessage(playerid,color,strings1);
		}
		else SendClientMessage(playerid,color,stringtext);
	}
	return 1;
}

stock SCAnim(playerid,stringtext[],length)
{
	KillTimer(antimer[playerid]);
	PlayerAnim{playerid} = true;
	if(PlayerSeat{playerid})
	{
		ApplyAnimation(playerid,"MISC","SEAT_TALK_02",4,1,0,0,1,strlen(stringtext) * 50,1);
		antimer[playerid] = SetTimerEx("SCAnimation",strlen(stringtext) * length,0,"d",playerid);
	}
	else if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerVehicleSeat(playerid) == 0) ApplyAnimation(playerid,"CAR_CHAT","CAR_SC3_FL",4,1,0,0,0,strlen(stringtext) * length,1);
		if(GetPlayerVehicleSeat(playerid) == 1) ApplyAnimation(playerid,"CAR_CHAT","CAR_SC3_FR",4,1,0,0,0,strlen(stringtext) * length,1);
		if(GetPlayerVehicleSeat(playerid) == 2) ApplyAnimation(playerid,"CAR_CHAT","CAR_SC1_BL",4,1,0,0,0,strlen(stringtext) * length,1);
		if(GetPlayerVehicleSeat(playerid) == 3) ApplyAnimation(playerid,"CAR_CHAT","CAR_SC3_BR",4,1,0,0,0,strlen(stringtext) * length,1);
	}
	else if(!IsPlayerInAnyVehicle(playerid) && !PlayerSeat{playerid})
	{
		ApplyAnimation(playerid,"PED","IDLE_CHAT",4,1,0,0,1,1);
		antimer[playerid] = SetTimerEx("SCAnimation",strlen(stringtext) * length,0,"d",playerid);
	}
	return 1;
}

stock SUName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	for(new i;i<strlen(pname);i++)
	{
		if(pname[i] == '_') pname[i] = ' ';
	}
	return pname;
}

stock SCStopAnim(playerid)
{
	PlayerAnim{playerid} = false;
	ApplyAnimation(playerid,"CARRY","crry_prtial",4,0,0,0,0,1);
	return 1;
}

stock SLog(stringtext1[],stringtext2[],name[])
{
	#if defined MAX_INI_ENTRY_TEXT
	new INI:log = INI_Open(name);
	INI_WriteString(log,stringtext1,stringtext2);
	INI_Close(log);
	#else
	new	File:log = fopen(name,io_append);
	format(stringtext1,150,"%s = %s\n",stringtext1,stringtext2);
	fwrite(log,stringtext1);
	fclose(log);
	#endif
	return 1;
}

stock STimeDate()
{
	new int,ints,intses,int1,int2,string[32];
	gettime(int,ints);
	getdate(intses,int1,int2);
	CostumFormat(string,"%d/%d/%d || %d:%d",intses,int1,int2,int,ints);
	return string;
}

stock PreloadAnimLib(playerid,animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0,0,0,0,0,1);
	return 1;
}

#if !defined FILTERSCRIPT
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit SC_OnGameModeInit
forward OnGameModeInit();

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit SC_OnGameModeExit
forward OnGameModeExit();
#else
#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit SC_OnFilterScriptInit
forward OnFilterScriptInit();

#if defined _ALS_OnFilterScriptExit
	#undef OnFilterScriptExit
#else
	#define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit SC_OnFilterScriptExit
forward OnFilterScriptExit();
#endif

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect SC_OnPlayerConnect
forward OnPlayerConnect(playerid);

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn SC_OnPlayerSpawn
forward OnPlayerSpawn(playerid);

#if defined _ALS_OnPlayerEnterVehicle
	#undef OnPlayerEnterVehicle
#else
	#define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle SC_OnPlayerEnterVehicle
forward OnPlayerEnterVehicle(playerid,vehicleid,ispassenger);

#if defined _ALS_OnPlayerExitVehicle
	#undef OnPlayerExitVehicle
#else
	#define _ALS_OnPlayerExitVehicle
#endif
#define OnPlayerExitVehicle SC_OnPlayerExitVehicle
forward OnPlayerExitVehicle(playerid,vehicleid);