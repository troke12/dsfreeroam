//Credits to Firecat and Tessar
#define FILTERSCRIPT

#include <a_samp>
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnGameModeInit()
{
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    SetPVarInt(playerid,"LastID",-1);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SetPVarInt(playerid,"LastID",-1);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(pm,2,cmdtext);
	dcmd(r,1,cmdtext);
	dcmd(nopm,4,cmdtext);
	return 0;
}
dcmd_nopm(playerid,params[])
{
	#pragma unused params
	if(GetPVarInt(playerid,"NoPM") == 1)
	{
	    SetPVarInt(playerid,"NoPM",0);
	    SendClientMessage(playerid,0xFFFF00FF,"Pm's on!");
 	}
 	else
 	{
 	    SetPVarInt(playerid,"NoPM",1);
	    SendClientMessage(playerid,0xFFFF00FF,"Pm's off!");
  	}
	return 1;
}
dcmd_pm(playerid,params[])
{
	new id,string[256],pName[MAX_PLAYER_NAME],pName2[MAX_PLAYER_NAME];
	id = strval(params);
	if(strlen(params) == 0) return SendClientMessage(playerid,0xF2A337FF,"USAGE: /pm [id][text]");
	if(GetPVarInt(id,"NoPM") == 1) return SendClientMessage(playerid,0xFF0000FF,"That player isnt recieving pm's");
	GetPlayerName(playerid,pName,sizeof(pName));
	GetPlayerName(id,pName2,sizeof(pName2));
	format(string,sizeof(string),"PM from %s: %s",pName,params);
	SendClientMessage(id,0xFFFF00FF,string);
	format(string,sizeof(string),"PM sent to %s: %s",pName2,params);
	SendClientMessage(playerid,0xF2A337FF,string);
	SetPVarInt(id,"LastID",playerid);
	return 1;
}

dcmd_r(playerid,params[])
{
	new string[256],pName[MAX_PLAYER_NAME],pName2[MAX_PLAYER_NAME];
	if(strlen(params) == 0) return SendClientMessage(playerid,0xF2A337FF,"USAGE: /r [text]");
	if(GetPVarInt(playerid,"LastID") == -1) return SendClientMessage(playerid,0xFF0000FF,"No recent messages!");
	if(GetPVarInt(GetPVarInt(playerid,"LastID"),"NoPM") == 1) return SendClientMessage(playerid,0xFF0000FF,"That player isnt recieving pm's");
	GetPlayerName(playerid,pName,sizeof(pName));
	GetPlayerName(GetPVarInt(playerid,"LastID"),pName2,sizeof(pName2));
	format(string,sizeof(string),"PM from %s: %s",pName,params);
	SendClientMessage(GetPVarInt(playerid,"LastID"),0xFFFF00FF,string);
	format(string,sizeof(string),"PM sent to %s: %s",pName2,params);
	SendClientMessage(playerid,0xF2A337FF,string);
	SetPVarInt(GetPVarInt(playerid,"LastID"),"LastID",playerid);
	return 1;
}
