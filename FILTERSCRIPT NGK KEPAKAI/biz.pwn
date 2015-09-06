// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <zcmd>
#include <dini>
#include <streamer>
#if defined FILTERSCRIPT

//Max Custom
#define MAX_BIZ 101 // Ignore 0
// Business Settings
enum bizInfo
{
	bType,
	bStatus,
	bOwner[32],
	Float:bX,
	Float:bY,
	Float:bZ,
	bPickup,
	bMoney,
	bProducts,
	Text3D:bText,
	bSold,
	bLevel,
	bPrice,
	bAP
}
new BizInfo[MAX_BIZ][bizInfo];

stock LoadBiz()
{
    if(!fexist("biz.cfg")) fcreate("biz.cfg");
	new binfo[12][32];
	new string[256];
	new File:file = fopen("biz.cfg", io_read);
	if(file)
	{
	    new idx = 1;
		while(idx < MAX_BIZ)
		{
		    fread(file, string);
		    split(string, binfo, '|');
		    BizInfo[idx][bType] = strval(binfo[0]);
		    BizInfo[idx][bStatus] = strval(binfo[1]);
		    format(BizInfo[idx][bOwner], 32, "%s", binfo[2]);
		    BizInfo[idx][bX] = floatstr(binfo[3]);
		    BizInfo[idx][bY] = floatstr(binfo[4]);
		    BizInfo[idx][bZ] = floatstr(binfo[5]);
		    BizInfo[idx][bMoney] = strval(binfo[6]);
		    BizInfo[idx][bProducts] = strval(binfo[7]);
		    BizInfo[idx][bSold] = strval(binfo[8]);
		    BizInfo[idx][bLevel] = strval(binfo[9]);
		    BizInfo[idx][bPrice] = strval(binfo[10]);
		    BizInfo[idx][bAP] = strval(binfo[11]);
		    if(BizInfo[idx][bType]) // If Business is owned
		    {
		    	BizInfo[idx][bPickup] = CreateDynamicPickup(1272, 1, BizInfo[idx][bX], BizInfo[idx][bY], BizInfo[idx][bZ], 0);
		    	if(!strcmp("The State", BizInfo[idx][bOwner])) format(string, sizeof(string), "Owner: %s\nBusiness Type: %s\nStatus: For Sale\nPrice: $%d", BizInfo[idx][bOwner], RBT(idx), BizInfo[idx][bPrice]);
				else format(string, sizeof(string), "Business of %s\nBusiness type: %s\n%s", BizInfo[idx][bOwner], RBT(idx), RBS(idx));
		    	BizInfo[idx][bText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, BizInfo[idx][bX], BizInfo[idx][bY], BizInfo[idx][bZ]+0.3, 15);
			}
			idx++;
	    }
	}
	print("Businesses loaded successfully.");
	return 1;
}

stock SaveBiz()
{
    if(!fexist("biz.cfg")) fcreate("biz.cfg");
	new idx = 1, File:file;
	new string[256];
	while(idx < MAX_BIZ)
	{
	    format(string, sizeof(string), "%d|%d|%s|%f|%f|%f|%d|%d|%d|%d|%d|%d\r\n", BizInfo[idx][bType], BizInfo[idx][bStatus], BizInfo[idx][bOwner], BizInfo[idx][bX], BizInfo[idx][bY], BizInfo[idx][bZ], BizInfo[idx][bMoney], BizInfo[idx][bProducts], BizInfo[idx][bSold], BizInfo[idx][bLevel], BizInfo[idx][bPrice], BizInfo[idx][bAP]);
	    if(idx == 1)
	    {
	        file = fopen("biz.cfg", io_write);
	    }
	    else
	    {
	    	file = fopen("biz.cfg", io_append);
	    }
		fwrite(file, string);
		fclose(file);
		idx++;
	}
	print("Businesses saved successfully.");
}

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Biz System by Krisna                   ");
	print("--------------------------------------\n");
	LoadBiz();
	return 1;
}

public OnFilterScriptExit()
{
	SaveBiz();
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
