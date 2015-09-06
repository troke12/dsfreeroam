//-----------------------IntrozeN---------------------
//-----------------------Gangzone---------------------
//-----------------------Creator----------------------
//-----------------------v1.0-------------------------

#include <a_samp>

#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define COLOR_GREENLIGHT 0x9ACD32AA
#define COLOR_DARKRED 0xC10B07FF

forward Createzone(playerid,color);

new Makingzone[MAX_PLAYERS];
new Float:ZMinX;
new Float:ZMaxX;
new Float:ZMinY;
new Float:ZMaxY;
new GangZone;
new Create;

public OnFilterScriptInit()
{
	print("\n----------------------------------");
	print("Gangzone Creator v1.0 by IntrozeN");
	print("----------------------------------\n");
	if(!fexist("/savedzones.txt")) fopen("/savedzones.txt", io_readwrite);
	return 1;
}

public OnFilterScriptExit()
{
	GangZoneHideForAll(GangZone);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(zone,4,cmdtext);
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 0)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
				if(Makingzone[playerid] == 1) return SendClientMessage(playerid,COLOR_DARKRED,".: Info: You're already making a zone. Cancel or Save the current one first :.");
	        	ShowPlayerDialog(playerid,1,2,"Color","Blue\nRed\nGreen\nPurple\nYellow\nGrey\nLightblue\nWhite\nBlack","Select","Cancel");
	        	Makingzone[playerid] = 1;
			}
			if(listitem == 1)
			{
			    if(Makingzone[playerid] == 0) return SendClientMessage(playerid,COLOR_DARKRED,".: Info: You're not making a zone. Create one first :.");
			    new string[128];
				KillTimer(Create);
				format(string,sizeof(string),"GangZoneCreate(%f,%f,%f,%f);\r\n",ZMinX,ZMinY,ZMaxX,ZMaxY);
				new File:save = fopen("/savedzones.txt", io_append);
				fwrite(save, string);
				fclose(save);
				SendClientMessage(playerid,COLOR_GREENLIGHT,".: Info: Zone created and saved in savedzones.txt :.");
				Makingzone[playerid] = 0;
			}
			if(listitem == 2)
			{
			    if(Makingzone[playerid] == 0) return SendClientMessage(playerid,COLOR_DARKRED,".: Info: You're not making a zone. Create one first :.");
				KillTimer(Create);
				GangZoneDestroy(GangZone);
				SendClientMessage(playerid,COLOR_GREENLIGHT,".: Info: Zone creation cancelled :.");
				Makingzone[playerid] = 0;
			}
		}
	}
	if(dialogid == 1)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0x0000FFAA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 1)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0xFF0000AA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 2)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0x00FF00AA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 3)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0xFF00FFAA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 4)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0xFFFF00AA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
			if(listitem == 5)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0x888888AA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 6)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0x00FFFFAA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 7)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0xFFFFFFAA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
            if(listitem == 8)
	        {
	            new Float:Z;
				new color;
				GetPlayerPos(playerid,ZMinX,ZMinY,Z);
				color = 0x000000AA;
				GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
				GangZoneShowForPlayer(playerid,GangZone,color);
				Create = SetTimerEx("Createzone",100,1,"ud",playerid,color);
			}
			SendClientMessage(playerid,COLOR_GREENLIGHT,".: Info: Zone is being created :.");
			SendClientMessage(playerid,COLOR_GREENLIGHT,".: Info: Check on the minimap while moving to create your zone perfectly then save the zone by typing /zone :.");
		}
		else if(!response)
		{
		    Makingzone[playerid] = 0;
		}
	}
	return 1;
}

public Createzone(playerid,color)
{
	GangZoneHideForPlayer(playerid,GangZone);
	GangZoneDestroy(GangZone);
	new Float:Z;
	GetPlayerPos(playerid,ZMaxX,ZMaxY,Z);
	GangZone = GangZoneCreate(ZMinX,ZMinY,ZMaxX,ZMaxY);
	GangZoneShowForPlayer(playerid,GangZone,color);
	return 1;
}

dcmd_zone(playerid,params[])
{
	#pragma unused params
	ShowPlayerDialog(playerid,0,2,"Gangzone Creator v1.0 by IntrozeN","Createzone\nSavezone\nCancelzone","Select","Cancel");
	return 1;
}
